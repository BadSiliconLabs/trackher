import '../engine/day.dart';
import '../engine/phases.dart';

String _d(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
DateTime _p(String s) => dateOnly(DateTime.parse(s));

class PeriodEntry {
  final DateTime start;
  final DateTime? end; // inclusive, optional

  PeriodEntry(DateTime start, {DateTime? end}) : start = dateOnly(start), end = end == null ? null : dateOnly(end);

  int? get length => end == null ? null : daysBetween(start, end!) + 1;

  PeriodEntry copyWith({DateTime? end, bool clearEnd = false}) =>
      PeriodEntry(start, end: clearEnd ? null : (end ?? this.end));

  Map<String, dynamic> toJson() => {'start': _d(start), if (end != null) 'end': _d(end!)};
  factory PeriodEntry.fromJson(Map<String, dynamic> j) =>
      PeriodEntry(_p(j['start']), end: j['end'] == null ? null : _p(j['end']));
}

/// A personal note about her, optionally tied to phases (empty = always).
class HerNote {
  final String id;
  final String text;
  final Set<Phase> phases;

  HerNote({required this.id, required this.text, Set<Phase>? phases}) : phases = phases ?? {};

  bool appliesTo(Phase p) => phases.isEmpty || phases.contains(p);

  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'phases': phases.map((p) => p.name).toList()};
  factory HerNote.fromJson(Map<String, dynamic> j) => HerNote(
    id: j['id'],
    text: j['text'],
    phases: {for (final n in (j['phases'] as List? ?? [])) Phase.values.byName(n)},
  );
}

const kSymptoms = ['cramps', 'headache', 'fatigue', 'bloating', 'acne', 'cravings', 'back pain', 'tender breasts'];
const kMoods = ['happy', 'neutral', 'sad', 'irritable', 'tired'];
const _legacyMoods = {'😊': 'happy', '😐': 'neutral', '😢': 'sad', '😠': 'irritable', '😴': 'tired'};

class DayLog {
  final DateTime date;
  final String? mood;
  final Set<String> symptoms;
  final String note;

  DayLog({required DateTime date, this.mood, Set<String>? symptoms, this.note = ''})
    : date = dateOnly(date),
      symptoms = symptoms ?? {};

  bool get isEmpty => mood == null && symptoms.isEmpty && note.trim().isEmpty;

  Map<String, dynamic> toJson() => {
    'date': _d(date),
    if (mood != null) 'mood': mood,
    'symptoms': symptoms.toList(),
    'note': note,
  };
  factory DayLog.fromJson(Map<String, dynamic> j) => DayLog(
    date: _p(j['date']),
    mood: _legacyMoods[j['mood']] ?? j['mood'],
    symptoms: {...(j['symptoms'] as List? ?? []).cast<String>()},
    note: j['note'] ?? '',
  );
}

class Settings {
  String herName;
  int defaultPeriodLength;
  bool notificationsEnabled;
  bool notifyPeriodSoon;
  int periodSoonLeadDays;
  bool notifyPms;
  bool notifyDailyTip;
  bool notifyFertile;
  int notifyHour;
  int notifyMinute;
  String themeMode; // system | light | dark
  String language; // system | en | it | es
  bool onboarded;

  Settings({
    this.herName = '',
    this.defaultPeriodLength = 5,
    this.notificationsEnabled = true,
    this.notifyPeriodSoon = true,
    this.periodSoonLeadDays = 2,
    this.notifyPms = true,
    this.notifyDailyTip = true,
    this.notifyFertile = false,
    this.notifyHour = 9,
    this.notifyMinute = 0,
    this.themeMode = 'system',
    this.language = 'system',
    this.onboarded = false,
  });

  Map<String, dynamic> toJson() => {
    'herName': herName,
    'defaultPeriodLength': defaultPeriodLength,
    'notificationsEnabled': notificationsEnabled,
    'notifyPeriodSoon': notifyPeriodSoon,
    'periodSoonLeadDays': periodSoonLeadDays,
    'notifyPms': notifyPms,
    'notifyDailyTip': notifyDailyTip,
    'notifyFertile': notifyFertile,
    'notifyHour': notifyHour,
    'notifyMinute': notifyMinute,
    'themeMode': themeMode,
    'language': language,
    'onboarded': onboarded,
  };

  factory Settings.fromJson(Map<String, dynamic> j) {
    final d = Settings();
    return Settings(
      herName: j['herName'] ?? d.herName,
      defaultPeriodLength: j['defaultPeriodLength'] ?? d.defaultPeriodLength,
      notificationsEnabled: j['notificationsEnabled'] ?? d.notificationsEnabled,
      notifyPeriodSoon: j['notifyPeriodSoon'] ?? d.notifyPeriodSoon,
      periodSoonLeadDays: j['periodSoonLeadDays'] ?? d.periodSoonLeadDays,
      notifyPms: j['notifyPms'] ?? d.notifyPms,
      notifyDailyTip: j['notifyDailyTip'] ?? d.notifyDailyTip,
      notifyFertile: j['notifyFertile'] ?? d.notifyFertile,
      notifyHour: j['notifyHour'] ?? d.notifyHour,
      notifyMinute: j['notifyMinute'] ?? d.notifyMinute,
      themeMode: j['themeMode'] ?? d.themeMode,
      language: j['language'] ?? d.language,
      onboarded: j['onboarded'] ?? d.onboarded,
    );
  }
}

class AppData {
  static const schemaVersion = 1;

  List<PeriodEntry> periods;
  List<HerNote> notes;
  Map<int, DayLog> logs; // keyed by day number
  Map<String, int> tipFeedback; // tip id -> +1 / -1
  Settings settings;

  AppData({
    List<PeriodEntry>? periods,
    List<HerNote>? notes,
    Map<int, DayLog>? logs,
    Map<String, int>? tipFeedback,
    Settings? settings,
  }) : periods = periods ?? [],
       notes = notes ?? [],
       logs = logs ?? {},
       tipFeedback = tipFeedback ?? {},
       settings = settings ?? Settings();

  Map<String, dynamic> toJson() => {
    'schema': schemaVersion,
    'periods': periods.map((p) => p.toJson()).toList(),
    'notes': notes.map((n) => n.toJson()).toList(),
    'logs': logs.values.where((l) => !l.isEmpty).map((l) => l.toJson()).toList(),
    'tipFeedback': tipFeedback,
    'settings': settings.toJson(),
  };

  factory AppData.fromJson(Map<String, dynamic> j) {
    final logs = <int, DayLog>{};
    for (final l in (j['logs'] as List? ?? [])) {
      final log = DayLog.fromJson(l);
      logs[dayNumber(log.date)] = log;
    }
    return AppData(
      periods: [for (final p in (j['periods'] as List? ?? [])) PeriodEntry.fromJson(p)],
      notes: [for (final n in (j['notes'] as List? ?? [])) HerNote.fromJson(n)],
      logs: logs,
      tipFeedback: Map<String, int>.from(j['tipFeedback'] ?? {}),
      settings: Settings.fromJson(j['settings'] ?? {}),
    );
  }
}
