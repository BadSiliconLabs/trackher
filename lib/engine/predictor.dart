/// Bayesian cycle-length estimation from sparse, possibly non-consecutive
/// period start dates. See docs/DESIGN.md §4.
library;

import 'dart:math' as math;

import 'day.dart';

/// Tunable model constants.
class ModelConfig {
  final double muMin, muMax, muStep;
  final double sigmaMin, sigmaMax, sigmaStep;
  final double priorMuMean, priorMuSd;
  final double priorSigmaMedian, priorSigmaLogSd;
  final int maxGapDays;
  final int minGapDays;
  final double halfLifeDays;

  const ModelConfig({
    this.muMin = 20,
    this.muMax = 45,
    this.muStep = 0.1,
    this.sigmaMin = 0.75,
    this.sigmaMax = 10,
    this.sigmaStep = 0.25,
    this.priorMuMean = 28.5,
    this.priorMuSd = 3.5,
    this.priorSigmaMedian = 2.5,
    this.priorSigmaLogSd = 0.5,
    this.maxGapDays = 365,
    this.minGapDays = 15,
    this.halfLifeDays = 365,
  });
}

enum Regularity { unknown, veryRegular, regular, somewhatIrregular, irregular }

/// Summary of what the model learned about her cycle.
class CycleStats {
  final double muMean;
  final double muSd;
  final double sigmaMean;
  final int gapsUsed;
  final int multiCycleGaps;
  final List<int> suspiciousGaps; // gaps < minGapDays (likely duplicates)

  const CycleStats({
    required this.muMean,
    required this.muSd,
    required this.sigmaMean,
    required this.gapsUsed,
    required this.multiCycleGaps,
    required this.suspiciousGaps,
  });

  Regularity get regularity {
    if (gapsUsed == 0) return Regularity.unknown;
    if (sigmaMean < 2) return Regularity.veryRegular;
    if (sigmaMean < 4) return Regularity.regular;
    if (sigmaMean < 7) return Regularity.somewhatIrregular;
    return Regularity.irregular;
  }
}

/// Probability mass over calendar days for one predicted period start.
class StartForecast {
  /// Index of the cycle after the anchor (1 = the cycle right after the anchor).
  final int n;

  /// Day number of pmf[0].
  final int firstDay;
  final List<double> pmf;

  StartForecast(this.n, this.firstDay, this.pmf);

  int get lastDay => firstDay + pmf.length - 1;

  double prob(int day) {
    final i = day - firstDay;
    return (i < 0 || i >= pmf.length) ? 0 : pmf[i];
  }

  /// P(start <= day).
  double cdf(int day) {
    final i = day - firstDay;
    if (i < 0) return 0;
    if (i >= pmf.length) return 1;
    var s = 0.0;
    for (var k = 0; k <= i; k++) {
      s += pmf[k];
    }
    return s;
  }

  int get mode {
    var best = 0;
    for (var i = 1; i < pmf.length; i++) {
      if (pmf[i] > pmf[best]) best = i;
    }
    return firstDay + best;
  }

  double get mean {
    var m = 0.0;
    for (var i = 0; i < pmf.length; i++) {
      m += (firstDay + i) * pmf[i];
    }
    return m;
  }

  double get sd {
    final m = mean;
    var v = 0.0;
    for (var i = 0; i < pmf.length; i++) {
      final d = firstDay + i - m;
      v += d * d * pmf[i];
    }
    return math.sqrt(v);
  }

  /// Smallest day whose cumulative probability reaches [q].
  int quantile(double q) {
    var s = 0.0;
    for (var i = 0; i < pmf.length; i++) {
      s += pmf[i];
      if (s >= q) return firstDay + i;
    }
    return lastDay;
  }

  DateTime get modeDate => fromDayNumber(mode);
  (int, int) interval(double level) => (quantile((1 - level) / 2), quantile(1 - (1 - level) / 2));
}

/// Posterior over (mu, sigma) on a grid.
class CyclePosterior {
  final List<double> mu;
  final List<double> sigma;
  final List<double> weight; // normalised, pruned (all > 0)
  final CycleStats stats;

  CyclePosterior._(this.mu, this.sigma, this.weight, this.stats);

  /// Builds the posterior from period start dates (any order, duplicates ok).
  /// [today] is used for recency weighting.
  factory CyclePosterior.fit(
    Iterable<DateTime> starts, {
    required DateTime today,
    ModelConfig config = const ModelConfig(),
  }) {
    final c = config;
    final days = starts.map(dayNumber).toSet().toList()..sort();
    final todayN = dayNumber(today);

    final gaps = <int>[];
    final gapWeights = <double>[];
    final suspicious = <int>[];
    for (var i = 1; i < days.length; i++) {
      final g = days[i] - days[i - 1];
      if (g < c.minGapDays) {
        suspicious.add(g);
        continue;
      }
      if (g > c.maxGapDays) continue;
      gaps.add(g);
      final age = (todayN - days[i]).clamp(0, 100000);
      gapWeights.add(math.pow(0.5, age / c.halfLifeDays).toDouble());
    }

    final muN = ((c.muMax - c.muMin) / c.muStep).round() + 1;
    final sgN = ((c.sigmaMax - c.sigmaMin) / c.sigmaStep).round() + 1;
    final total = muN * sgN;
    final logp = List<double>.filled(total, 0);
    final muArr = List<double>.filled(total, 0);
    final sgArr = List<double>.filled(total, 0);

    // Precompute per gap the k range.
    final kMax = [for (final g in gaps) math.min(24, (g / 18).ceil())];

    var idx = 0;
    var maxLog = double.negativeInfinity;
    for (var i = 0; i < muN; i++) {
      final mu = c.muMin + i * c.muStep;
      final zMu = (mu - c.priorMuMean) / c.priorMuSd;
      final lpMu = -0.5 * zMu * zMu;
      for (var j = 0; j < sgN; j++) {
        final sg = c.sigmaMin + j * c.sigmaStep;
        final zs = (math.log(sg) - math.log(c.priorSigmaMedian)) / c.priorSigmaLogSd;
        // log-normal density includes the 1/sigma Jacobian
        var lp = lpMu - 0.5 * zs * zs - math.log(sg);
        for (var g = 0; g < gaps.length; g++) {
          lp += gapWeights[g] * _logGapLik(gaps[g].toDouble(), mu, sg, kMax[g]);
        }
        muArr[idx] = mu;
        sgArr[idx] = sg;
        logp[idx] = lp;
        if (lp > maxLog) maxLog = lp;
        idx++;
      }
    }

    // Normalise and prune negligible points.
    final mu = <double>[], sigma = <double>[], w = <double>[];
    var sum = 0.0;
    for (var k = 0; k < total; k++) {
      final v = math.exp(logp[k] - maxLog);
      if (v < 1e-7) continue;
      mu.add(muArr[k]);
      sigma.add(sgArr[k]);
      w.add(v);
      sum += v;
    }
    var muMean = 0.0, sgMean = 0.0;
    for (var k = 0; k < w.length; k++) {
      w[k] /= sum;
      muMean += w[k] * mu[k];
      sgMean += w[k] * sigma[k];
    }
    var muVar = 0.0;
    for (var k = 0; k < w.length; k++) {
      final d = mu[k] - muMean;
      muVar += w[k] * d * d;
    }

    // How many gaps most plausibly span more than one cycle?
    var multi = 0;
    for (final g in gaps) {
      if ((g / muMean).round() > 1) multi++;
    }

    return CyclePosterior._(
      mu,
      sigma,
      w,
      CycleStats(
        muMean: muMean,
        muSd: math.sqrt(muVar),
        sigmaMean: sgMean,
        gapsUsed: gaps.length,
        multiCycleGaps: multi,
        suspiciousGaps: suspicious,
      ),
    );
  }

  static double _logGapLik(double g, double mu, double sg, int kMax) {
    // log sum_k (1/kMax) N(g; k mu, k sg^2), computed with log-sum-exp.
    var best = double.negativeInfinity;
    final terms = List<double>.filled(kMax, 0);
    for (var k = 1; k <= kMax; k++) {
      final var_ = k * sg * sg;
      final d = g - k * mu;
      final t = -0.5 * d * d / var_ - 0.5 * math.log(2 * math.pi * var_);
      terms[k - 1] = t;
      if (t > best) best = t;
    }
    if (best == double.negativeInfinity) return -1e9;
    var s = 0.0;
    for (final t in terms) {
      s += math.exp(t - best);
    }
    return best + math.log(s / kMax);
  }

  /// Predictive distribution of the n-th start after [anchorDay].
  StartForecast predict(int anchorDay, int n) {
    final sn = math.sqrt(n.toDouble());
    // Determine support from the posterior extremes.
    var lo = double.infinity, hi = double.negativeInfinity;
    for (var k = 0; k < w.length; k++) {
      final m = n * mu[k];
      final s = sn * sigma[k];
      lo = math.min(lo, m - 5 * s);
      hi = math.max(hi, m + 5 * s);
    }
    final first = lo.floor();
    final last = hi.ceil();
    final len = last - first + 1;
    final pmf = List<double>.filled(len, 0);
    for (var k = 0; k < w.length; k++) {
      final m = n * mu[k];
      final s = sn * sigma[k];
      var prev = _phi((first - 0.5 - m) / s);
      for (var i = 0; i < len; i++) {
        final cur = _phi((first + i + 0.5 - m) / s);
        pmf[i] += w[k] * (cur - prev);
        prev = cur;
      }
    }
    var tot = 0.0;
    for (final p in pmf) {
      tot += p;
    }
    for (var i = 0; i < len; i++) {
      pmf[i] /= tot;
    }
    return StartForecast(n, anchorDay + first, pmf);
  }

  List<double> get w => weight;
}

double _phi(double x) => 0.5 * (1 + _erf(x / math.sqrt2));

/// Abramowitz & Stegun 7.1.26 (|error| < 1.5e-7).
double _erf(double x) {
  final sign = x < 0 ? -1.0 : 1.0;
  x = x.abs();
  const a1 = 0.254829592, a2 = -0.284496736, a3 = 1.421413741;
  const a4 = -1.453152027, a5 = 1.061405429, p = 0.3275911;
  final t = 1 / (1 + p * x);
  final y = 1 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x * x);
  return sign * y;
}
