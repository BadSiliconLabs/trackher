import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:trackher/engine/day.dart';
import 'package:trackher/engine/phases.dart';
import 'package:trackher/engine/predictor.dart';

double _gauss(math.Random r) {
  final u1 = 1 - r.nextDouble(), u2 = r.nextDouble();
  return math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
}

List<int> _simulate(math.Random r, int startDay, double mu, double sigma, int count) {
  final out = <int>[startDay];
  var d = startDay.toDouble();
  for (var i = 1; i < count; i++) {
    d += mu + sigma * _gauss(r);
    out.add(d.round());
  }
  return out;
}

void main() {
  final today = DateTime(2026, 11, 23);

  test('single date falls back to prior and still forecasts', () {
    final f = Forecast.compute([DateTime(2026, 11, 10)], today: today)!;
    expect(f.stats.gapsUsed, 0);
    expect(f.stats.muMean, closeTo(28.5, 0.6));
    final (lo, hi) = f.next.interval(0.8);
    expect(f.next.mode, inInclusiveRange(dayNumber(DateTime(2026, 12, 6)), dayNumber(DateTime(2026, 12, 10))));
    expect(hi - lo, greaterThan(4));
  });

  test('sparse non-consecutive dates: this month, last month, 5 months ago', () {
    // True cycle 31 days.
    final starts = [DateTime(2026, 6, 18), DateTime(2026, 10, 20), DateTime(2026, 11, 20)];
    // Gap Jun18->Oct20 = 124 = 4*31; Oct20->Nov20 = 31.
    final f = Forecast.compute(starts, today: today)!;
    expect(f.stats.gapsUsed, 2);
    expect(f.stats.multiCycleGaps, 1);
    expect(f.stats.muMean, closeTo(31, 1.0));
    expect(f.next.mode, closeTo(dayNumber(DateTime(2026, 12, 21)), 1));
    expect(f.lastStartAssumed, isFalse);
    expect(f.cycleDay, 4);
  });

  test('variance of forecast grows with horizon', () {
    final starts = [DateTime(2026, 8, 25), DateTime(2026, 9, 22), DateTime(2026, 10, 21), DateTime(2026, 11, 19)];
    final f = Forecast.compute(starts, today: today)!;
    for (var i = 1; i < f.upcoming.length; i++) {
      expect(f.upcoming[i].sd, greaterThan(f.upcoming[i - 1].sd));
    }
  });

  test('stale log projects forward to a future cycle', () {
    final starts = [DateTime(2026, 1, 5), DateTime(2026, 2, 2), DateTime(2026, 3, 2)];
    final f = Forecast.compute(starts, today: today)!;
    expect(f.lastStartAssumed, isTrue);
    expect(f.next.quantile(0.975), greaterThanOrEqualTo(dayNumber(today)));
    expect(f.cycleDay, inInclusiveRange(1, 45));
  });

  test('duplicate / spotting entries are flagged, not used', () {
    final starts = [DateTime(2026, 10, 1), DateTime(2026, 10, 5), DateTime(2026, 10, 29)];
    final p = CyclePosterior.fit(starts, today: today);
    expect(p.stats.suspiciousGaps, [4]);
  });

  test('calibration: 80% intervals cover ~80% of held-out starts', () {
    final r = math.Random(42);
    var hits = 0, total = 0;
    for (var trial = 0; trial < 150; trial++) {
      final mu = 24 + r.nextDouble() * 10;
      final sigma = 1 + r.nextDouble() * 4;
      final seq = _simulate(r, 20000, mu, sigma, 14);
      // Keep a random sparse subset of the first 12 (at least 2), predict #13.
      final known = <int>[seq[11]];
      for (var i = 0; i < 11; i++) {
        if (r.nextDouble() < 0.5) known.add(seq[i]);
      }
      final post = CyclePosterior.fit(known.map(fromDayNumber), today: fromDayNumber(seq[11]));
      final f = post.predict(seq[11], 1);
      final (lo, hi) = f.interval(0.8);
      if (seq[12] >= lo && seq[12] <= hi) hits++;
      total++;
    }
    final cov = hits / total;
    expect(cov, inInclusiveRange(0.7, 0.92));
  });

  test('phase for cycle day', () {
    expect(phaseForCycleDay(0, 28, 5), Phase.period);
    expect(phaseForCycleDay(7, 28, 5), Phase.follicular);
    expect(phaseForCycleDay(14, 28, 5), Phase.ovulation);
    expect(phaseForCycleDay(12, 28, 5), Phase.fertile);
    expect(phaseForCycleDay(18, 28, 5), Phase.luteal);
    expect(phaseForCycleDay(24, 28, 5), Phase.pms);
  });
}
