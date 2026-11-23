import 'dart:math' as math;

import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../engine/day.dart';
import '../engine/phases.dart';
import '../engine/predictor.dart';
import '../state/app_state.dart';
import 'l10n.dart';
import 'theme.dart';

String _d1(double v) => NumberFormat('0.0').format(v);

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  int _sel = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final f = state.forecast;
    final theme = Theme.of(context);
    final l = context.l;
    if (f == null) {
      return Center(
        child: Padding(padding: const EdgeInsets.all(32), child: Text(context.l.needOneDate)),
      );
    }
    final sel = math.min(_sel, f.upcoming.length - 1);
    final s = f.stats;
    final fmt = DateFormat.MMMd();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.nextStartProbability, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < f.upcoming.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(DateFormat.MMM().format(f.upcoming[i].modeDate)),
                            selected: i == sel,
                            onSelected: (_) => setState(() => _sel = i),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _BellPainter(
                      forecast: f.upcoming[sel],
                      today: f.todayDay,
                      color: Phase.period.color,
                      axis: theme.colorScheme.outline,
                      textStyle: theme.textTheme.labelSmall!,
                      todayLabel: l.chartToday,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _IntervalText(fc: f.upcoming[sel]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                for (final up in f.upcoming)
                  Builder(
                    builder: (context) {
                      final (lo, hi) = up.interval(0.8);
                      final (lo95, hi95) = up.interval(0.95);
                      return ListTile(
                        dense: true,
                        leading: Icon(Phase.period.icon, color: Phase.period.color),
                        title: Text(
                          DateFormat.yMMMEd().format(up.modeDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          l.rangeLine(
                            fmt.format(fromDayNumber(lo)),
                            fmt.format(fromDayNumber(hi)),
                            fmt.format(fromDayNumber(lo95)),
                            fmt.format(fromDayNumber(hi95)),
                          ),
                        ),
                        trailing: Text('±${_d1(up.sd)}'),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.modelLearned, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _Stat(l.avgCycle, l.daysValue(_d1(s.muMean)), l.uncertainty(_d1(s.muSd))),
                _Stat(l.variation, l.plusMinusDays(_d1(s.sigmaMean)), l.regularity(s.regularity)),
                _Stat(
                  l.periodLength,
                  l.nDays(state.periodLength),
                  state.learnedPeriodLength ? l.learnedFromEnds : l.defaultFromSettings,
                ),
                _Stat(
                  l.dataUsed,
                  l.intervals(s.gapsUsed),
                  s.multiCycleGaps > 0 ? l.multiCycle(s.multiCycleGaps) : l.fromStarts(state.data.periods.length),
                ),
                if (s.gapsUsed < 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      s.gapsUsed == 0 ? l.oneDateHint : l.moreDatesHint,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: Card(
            child: ExpansionTile(
              title: Text(l.howItWorks),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [Text(l.howItWorksBody)],
            ),
          ),
        ),
      ],
    );
  }
}

class _IntervalText extends StatelessWidget {
  final StartForecast fc;
  const _IntervalText({required this.fc});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat.MMMEd();
    final (lo, hi) = fc.interval(0.8);
    return Text(
      context.l.forecastSummary(
        fmt.format(fc.modeDate),
        (fc.prob(fc.mode) * 100).round(),
        fmt.format(fromDayNumber(lo)),
        fmt.format(fromDayNumber(hi)),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value, sub;
  const _Stat(this.label, this.value, this.sub);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                Text(sub, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
              ],
            ),
          ),
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _BellPainter extends CustomPainter {
  final StartForecast forecast;
  final int today;
  final Color color, axis;
  final TextStyle textStyle;
  final String todayLabel;

  _BellPainter({
    required this.todayLabel,
    required this.forecast,
    required this.today,
    required this.color,
    required this.axis,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final f = forecast;
    final lo = f.quantile(0.005), hi = f.quantile(0.995);
    final from = lo - 2, to = hi + 2;
    final n = to - from + 1;
    const bottomPad = 22.0, topPad = 18.0;
    final h = size.height - bottomPad - topPad;
    final bw = size.width / n;
    var maxP = 0.0;
    for (var d = from; d <= to; d++) {
      maxP = math.max(maxP, f.prob(d));
    }
    final (i80lo, i80hi) = f.interval(0.8);

    for (var i = 0; i < n; i++) {
      final d = from + i;
      final p = f.prob(d);
      final bh = maxP == 0 ? 0.0 : h * p / maxP;
      final inBand = d >= i80lo && d <= i80hi;
      final paint = Paint()
        ..color = color.withValues(
          alpha: d == f.mode
              ? 1
              : inBand
              ? 0.7
              : 0.28,
        );
      final r = RRect.fromRectAndCorners(
        Rect.fromLTWH(i * bw + bw * 0.12, topPad + h - bh, bw * 0.76, bh),
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
      );
      canvas.drawRRect(r, paint);
    }

    // Axis
    final ap = Paint()
      ..color = axis.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, topPad + h), Offset(size.width, topPad + h), ap);

    // Labels: every ~5 days
    final step = math.max(1, (n / 6).ceil());
    final fmt = DateFormat.MMMd();
    for (var i = 0; i < n; i += step) {
      _text(canvas, fmt.format(fromDayNumber(from + i)), Offset(i * bw + bw / 2, topPad + h + 4), center: true);
    }
    // Mode label
    final mi = f.mode - from;
    _text(canvas, '${(f.prob(f.mode) * 100).round()}%', Offset(mi * bw + bw / 2, topPad - 1), center: true, bold: true);

    // Today marker
    if (today >= from && today <= to) {
      final x = (today - from) * bw + bw / 2;
      final tp = Paint()
        ..color = axis
        ..strokeWidth = 1.5;
      for (var y = topPad; y < topPad + h; y += 6) {
        canvas.drawLine(Offset(x, y), Offset(x, y + 3), tp);
      }
      _text(canvas, todayLabel, Offset(x + 3, topPad + 2), center: false);
    }
  }

  void _text(Canvas c, String s, Offset at, {bool center = false, bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: textStyle.copyWith(fontWeight: bold ? FontWeight.w700 : null),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = center ? at.dx - tp.width / 2 : at.dx;
    final dy = bold ? at.dy - tp.height : at.dy;
    tp.paint(c, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant _BellPainter old) =>
      old.forecast != forecast || old.today != today || old.color != color;
}
