/// Cycle phases and the full forecast: next start, current phase, calendar.
library;

import 'dart:math' as math;

import 'day.dart';
import 'predictor.dart';

enum Phase { period, follicular, fertile, ovulation, luteal, pms }

extension PhaseInfo on Phase {
  String get label => switch (this) {
    Phase.period => 'Period',
    Phase.follicular => 'Follicular',
    Phase.fertile => 'Fertile window',
    Phase.ovulation => 'Ovulation',
    Phase.luteal => 'Luteal',
    Phase.pms => 'PMS',
  };

  String get blurb => switch (this) {
    Phase.period => 'Her period. Energy can be low and cramps are common. Comfort, warmth and patience help most.',
    Phase.follicular => 'Hormones are rising and energy and mood often improve. A good time for plans and adventures.',
    Phase.fertile => 'Around ovulation. Often the time of highest energy, confidence and libido.',
    Phase.ovulation => 'Estimated ovulation day. Some people feel a twinge or mild pain on one side.',
    Phase.luteal => 'Progesterone rises. She may be more tired or want more calm and coziness.',
    Phase.pms =>
      'The days before her period. Mood swings, cravings, bloating and irritability are common. Be extra kind.',
  };
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
