import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/store.dart';
import '../engine/day.dart';
import '../engine/phases.dart';
import '../engine/tips_engine.dart';
import '../model/models.dart';

typedef Rescheduler = Future<void> Function(AppState state);

class AppState extends ChangeNotifier {
  final Store store;

  /// Tip libraries keyed by language code (en, it, es).
  final Map<String, TipsEngine> tipsByLang;
  final List<String> Function() _systemLanguages;
  final Rescheduler? reschedule;
  final DateTime Function() _clock;

  AppData data = AppData();
  Forecast? forecast;
  bool loaded = false;
  Timer? _rescheduleDebounce;

  AppState({
    required this.store,
    required this.tipsByLang,
    this.reschedule,
    DateTime Function()? clock,
    List<String> Function()? systemLanguages,
  }) : _clock = clock ?? DateTime.now,
       _systemLanguages = systemLanguages ?? _platformLanguages;

  static const supportedLanguages = ['en', 'it', 'es'];

  static List<String> _platformLanguages() => [for (final l in PlatformDispatcher.instance.locales) l.languageCode];

  /// Active language: explicit setting, else the first supported phone language, else English.
  String get lang {
    final set = settings.language;
    if (supportedLanguages.contains(set)) return set;
    for (final l in _systemLanguages()) {
      if (supportedLanguages.contains(l)) return l;
    }
    return 'en';
  }

  TipsEngine get tips => tipsByLang[lang] ?? tipsByLang['en'] ?? tipsByLang.values.first;

  DateTime get today => dateOnly(_clock());
  int get todayDay => dayNumber(today);
  Settings get settings => data.settings;

  List<PeriodEntry> get periodsSorted => [...data.periods]..sort((a, b) => b.start.compareTo(a.start));

  /// Learned from logged end dates, otherwise the setting.
  int get periodLength {
    final lens = data.periods.map((p) => p.length).whereType<int>().where((l) => l >= 1 && l <= 12).toList();
    if (lens.isEmpty) return settings.defaultPeriodLength;
    return (lens.reduce((a, b) => a + b) / lens.length).round().clamp(2, 10);
  }

  bool get learnedPeriodLength => data.periods.any((p) => p.end != null);

  Future<void> load() async {
    data = await store.load();
    loaded = true;
    _recompute();
    notifyListeners();
    _scheduleNotifications();
  }

  /// Call when the app resumes (date may have changed).
  void refresh() {
    _recompute();
    notifyListeners();
    _scheduleNotifications();
  }

  void _recompute() {
    forecast = Forecast.compute(data.periods.map((p) => p.start).toList(), today: today, periodLength: periodLength);
  }

  Future<void> _commit() async {
    _recompute();
    notifyListeners();
    await store.save(data);
    _scheduleNotifications();
  }

  void _scheduleNotifications() {
    final r = reschedule;
    if (r == null) return;
    _rescheduleDebounce?.cancel();
    _rescheduleDebounce = Timer(const Duration(milliseconds: 400), () => r(this));
  }

  // ---- Periods ----
  PeriodEntry? periodOn(DateTime day) {
    final d = dayNumber(day);
    for (final p in data.periods) {
      final s = dayNumber(p.start);
      final e = p.end != null ? dayNumber(p.end!) : s + periodLength - 1;
      if (d >= s && d <= e) return p;
    }
    return null;
  }

  bool isLoggedStart(DateTime day) => data.periods.any((p) => dayNumber(p.start) == dayNumber(day));

  Future<void> addPeriodStart(DateTime start) async {
    if (isLoggedStart(start)) return;
    data.periods.add(PeriodEntry(start));
    await _commit();
  }

  Future<void> setPeriodStarts(Iterable<DateTime> starts) async {
    final existing = {for (final p in data.periods) dayNumber(p.start): p};
    data.periods = [for (final s in starts) existing[dayNumber(s)] ?? PeriodEntry(s)];
    await _commit();
  }

  Future<void> removePeriod(PeriodEntry p) async {
    data.periods.removeWhere((e) => dayNumber(e.start) == dayNumber(p.start));
    await _commit();
  }

  Future<void> setPeriodEnd(PeriodEntry p, DateTime? end) async {
    final i = data.periods.indexWhere((e) => dayNumber(e.start) == dayNumber(p.start));
    if (i < 0) return;
    data.periods[i] = end == null ? p.copyWith(clearEnd: true) : p.copyWith(end: end);
    await _commit();
  }

  // ---- Notes ----
  Future<void> upsertNote(HerNote n) async {
    final i = data.notes.indexWhere((e) => e.id == n.id);
    if (i >= 0) {
      data.notes[i] = n;
    } else {
      data.notes.add(n);
    }
    await _commit();
  }

  Future<void> deleteNote(String id) async {
    data.notes.removeWhere((n) => n.id == id);
    await _commit();
  }

  List<HerNote> notesFor(Phase p) => data.notes.where((n) => n.appliesTo(p)).toList();

  // ---- Day logs ----
  DayLog? logFor(DateTime d) => data.logs[dayNumber(d)];

  Future<void> setLog(DayLog log) async {
    final k = dayNumber(log.date);
    if (log.isEmpty) {
      data.logs.remove(k);
    } else {
      data.logs[k] = log;
    }
    await _commit();
  }

  // ---- Tips ----
  int tipFeedback(String id) => data.tipFeedback[id] ?? 0;

  Future<void> setTipFeedback(String id, int v) async {
    if (v == 0) {
      data.tipFeedback.remove(id);
    } else {
      data.tipFeedback[id] = v;
    }
    await _commit();
  }

  Tip? tipForDay(int day) {
    final f = forecast;
    final phase = f == null ? Phase.follicular : f.phaseOn(day);
    return tips.dailyTip(day, phase, feedback: data.tipFeedback);
  }

  // ---- Settings / data ----
  Future<void> updateSettings(void Function(Settings s) change) async {
    change(data.settings);
    await _commit();
  }

  Future<void> completeOnboarding(String name, Iterable<DateTime> starts) async {
    data.settings.herName = name.trim();
    data.settings.onboarded = true;
    data.periods = [for (final s in starts) PeriodEntry(s)];
    await _commit();
  }

  Future<void> importData(AppData imported) async {
    imported.settings.onboarded = true;
    data = imported;
    await _commit();
  }

  Future<void> wipe() async {
    await store.wipe();
    data = AppData();
    _recompute();
    notifyListeners();
    _scheduleNotifications();
  }

  String exportJson() => Store.encode(data);

  @override
  void dispose() {
    _rescheduleDebounce?.cancel();
    super.dispose();
  }
}
