/// Cycle phases and the full forecast: next start, current phase, calendar.
library;

import 'dart:math' as math;

import 'day.dart';
import 'predictor.dart';

enum Phase { period, follicular, fertile, ovulation, luteal, pms }

enum CycleEventKind { pms, period, fertile, ovulation }

/// A predicted upcoming moment in the cycle.
class CycleEvent {
  final CycleEventKind kind;
  final int day;

  /// Half-width of the 80% range, in days (0 when not meaningful).
  final int spread;
  const CycleEvent(this.kind, this.day, this.spread);
}

/// Phase for a cycle day [c] (0-based) of a cycle of length [len].
Phase phaseForCycleDay(int c, int len, int periodLength) {
  if (c < periodLength) return Phase.period;
  final ov = len - 14;
  if (c >= len - 6) return Phase.pms;
  if (c == ov) return Phase.ovulation;
  if (c >= ov - 5 && c <= ov + 1) return Phase.fertile;
  if (c > ov + 1) return Phase.luteal;
  return Phase.follicular;
}

/// Everything the UI needs, computed from the logged starts.
class Forecast {
  final int todayDay;
  final int anchorDay; // last logged start
  final int periodLength;
  final CyclePosterior posterior;

  /// Predictive distributions for upcoming starts (n = nextN, nextN+1, ...).
  final List<StartForecast> upcoming;

  /// Most recent start (logged or assumed when the log has gaps).
  final int lastStartDay;
  final bool lastStartAssumed;

  /// Probability that the "next" period has already started by today.
  final double pAlreadyStarted;

  /// Phase probabilities for today.
  final Map<Phase, double> todayPhase;

  Forecast._({
    required this.todayDay,
    required this.anchorDay,
    required this.periodLength,
    required this.posterior,
    required this.upcoming,
    required this.lastStartDay,
    required this.lastStartAssumed,
    required this.pAlreadyStarted,
    required this.todayPhase,
  });

  StartForecast get next => upcoming.first;
  CycleStats get stats => posterior.stats;

  /// 1-based day of the current cycle.
  int get cycleDay => todayDay - lastStartDay + 1;

  int get daysUntilNext => next.mode - todayDay;

  Phase get likelyPhase => todayPhase.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

  double get likelyPhaseProb => todayPhase[likelyPhase] ?? 0;

  /// True when today is past most of the predicted window.
  bool get isLate => pAlreadyStarted > 0.9;

  /// P(she is on her period on [day]) for calendar shading, using
  /// the marginal over all upcoming starts.
  double periodProbability(int day) {
    if (day >= lastStartDay && day < lastStartDay + periodLength && day < next.firstDay) {
      return 1;
    }
    var p = 0.0;
    for (final f in upcoming) {
      p += f.cdf(day) - f.cdf(day - periodLength);
    }
    return p.clamp(0, 1).toDouble();
  }

  /// Deterministic most-likely phase for any future/past day, using the
  /// chain of predicted modes (good enough for calendar tinting).
  Phase phaseOn(int day) {
    if (day == todayDay) return likelyPhase;
    final starts = [lastStartDay, ...upcoming.map((f) => f.mode)];
    final avg = posterior.stats.muMean.round();
    for (var i = starts.length - 1; i >= 0; i--) {
      if (day >= starts[i]) {
        final len = i + 1 < starts.length ? starts[i + 1] - starts[i] : avg;
        return phaseForCycleDay(day - starts[i], len, periodLength);
      }
    }
    // Before the last start: just use average cycle backward.
    final c = ((day - lastStartDay) % avg + avg) % avg;
    return phaseForCycleDay(c, avg, periodLength);
  }

  /// Next predicted events from today, soonest first.
  List<CycleEvent> upcomingEvents({int horizonDays = 60, int max = 4}) {
    final out = <CycleEvent>[];
    for (final f in upcoming) {
      final (lo, hi) = f.interval(0.8);
      final spread = ((hi - lo) / 2).ceil();
      out
        ..add(CycleEvent(CycleEventKind.fertile, f.mode - 19, spread))
        ..add(CycleEvent(CycleEventKind.ovulation, f.mode - 14, spread))
        ..add(CycleEvent(CycleEventKind.pms, f.mode - 6, spread))
        ..add(CycleEvent(CycleEventKind.period, f.mode, spread));
    }
    final list = out.where((e) => e.day >= todayDay && e.day - todayDay <= horizonDays).toList()
      ..sort((a, b) => a.day.compareTo(b.day));
    return list.take(max).toList();
  }

  /// Progress through the current cycle in [0, 1] (expected length = last start → next mode).
  double get cycleProgress {
    final len = next.mode - lastStartDay;
    if (len <= 0) return 1;
    return ((todayDay - lastStartDay) / len).clamp(0.0, 1.0);
  }

  /// Expected length of the current cycle in days.
  int get currentCycleLength => (next.mode - lastStartDay).clamp(1, 120);

  static Forecast? compute(
    List<DateTime> starts, {
    required DateTime today,
    int periodLength = 5,
    int horizonCycles = 6,
    ModelConfig config = const ModelConfig(),
  }) {
    if (starts.isEmpty) return null;
    final todayN = dayNumber(today);
    final days = starts.map(dayNumber).where((d) => d <= todayN).toSet().toList()..sort();
    if (days.isEmpty) return null;
    final anchor = days.last;
    final post = CyclePosterior.fit(days.map(fromDayNumber), today: today, config: config);

    // Find the first n whose window hasn't fully passed.
    var n = 1;
    StartForecast f = post.predict(anchor, n);
    while (f.quantile(0.975) < todayN && n < 60) {
      n++;
      f = post.predict(anchor, n);
    }
    final upcoming = <StartForecast>[f];
    for (var k = 1; k < horizonCycles; k++) {
      upcoming.add(post.predict(anchor, n + k));
    }

    final lastStart = n == 1 ? anchor : post.predict(anchor, n - 1).mode;
    final pStarted = f.cdf(todayN);

    // Phase probabilities for today, averaged over the next-start pmf.
    final phase = {for (final p in Phase.values) p: 0.0};
    final avgLen = post.stats.muMean.round();
    for (var i = 0; i < f.pmf.length; i++) {
      final p = f.pmf[i];
      if (p < 1e-6) continue;
      final s = f.firstDay + i;
      Phase ph;
      if (todayN < s) {
        final len = math.max(s - lastStart, periodLength + 1);
        ph = phaseForCycleDay(todayN - lastStart, len, periodLength);
      } else {
        ph = phaseForCycleDay(todayN - s, avgLen, periodLength);
      }
      phase[ph] = phase[ph]! + p;
    }

    return Forecast._(
      todayDay: todayN,
      anchorDay: anchor,
      periodLength: periodLength,
      posterior: post,
      upcoming: upcoming,
      lastStartDay: lastStart,
      lastStartAssumed: n > 1,
      pAlreadyStarted: pStarted,
      todayPhase: phase,
    );
  }
}
