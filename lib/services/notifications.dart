import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../engine/day.dart';
import '../state/app_state.dart';

/// Schedules all local notifications ahead of time; rescheduled whenever
/// data or settings change (see DESIGN.md §6).
class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _horizonDays = 45;
  static const _channel = AndroidNotificationDetails(
    'tempo_reminders',
    'Reminders',
    channelDescription: 'Cycle heads-ups and daily tips',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
    visibility: NotificationVisibility.private,
    icon: 'ic_notification',
  );

  Future<void> init() async {
    try {
      tzdata.initializeTimeZones();
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Fall back to UTC; times may be off by the offset but still fire.
    }
    await _plugin.initialize(
      settings: const InitializationSettings(android: AndroidInitializationSettings('ic_notification')),
    );
    _ready = true;
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? true;
  }

  Future<void> reschedule(AppState state) async {
    if (!_ready) return;
    await _plugin.cancelAll();
    final s = state.settings;
    final f = state.forecast;
    if (!s.notificationsEnabled || !s.onboarded) return;

    final now = tz.TZDateTime.now(tz.local);
    var id = 1;
    Future<void> at(int day, String title, String body) async {
      final d = fromDayNumber(day);
      final when = tz.TZDateTime(tz.local, d.year, d.month, d.day, s.notifyHour, s.notifyMinute);
      if (!when.isAfter(now)) return;
      if (when.difference(now).inDays > _horizonDays + 1) return;
      await _plugin.zonedSchedule(
        id: id++,
        scheduledDate: when,
        notificationDetails: const NotificationDetails(android: _channel),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
      );
    }

    final today = state.todayDay;

    if (f != null) {
      for (final up in f.upcoming) {
        if (up.mode - today > _horizonDays) break;
        final (lo, hi) = up.interval(0.8);
        final range = ((hi - lo) / 2).ceil();
        if (s.notifyPeriodSoon) {
          final lead = s.periodSoonLeadDays;
          await at(
            up.mode - lead,
            'Tempo',
            'Heads-up for about $lead day${lead == 1 ? '' : 's'} from now (±$range). Open the app for details.',
          );
        }
        if (s.notifyPms) {
          await at(
            up.mode - 6,
            'Tempo',
            'A sensitive week likely starts now. Extra patience and kindness go a long way.',
          );
        }
        if (s.notifyFertile) {
          await at(up.mode - 19, 'Tempo', 'A new window starts around now. Open for details.');
        }
      }
    }

    if (s.notifyDailyTip) {
      for (var d = today; d <= today + 30; d++) {
        final tip = state.tipForDay(d);
        if (tip == null) continue;
        await at(d, 'Tip: ${tip.title}', tip.text);
      }
    }
  }
}
