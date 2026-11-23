import 'package:intl/intl.dart' show DateFormat;
import 'package:material_ui/material_ui.dart';

import '../../engine/day.dart';
import '../l10n.dart';

typedef DayCellBuilder = Widget Function(BuildContext context, DateTime day, bool inMonth);

/// A swipeable month calendar with a custom cell builder.
class MonthCalendar extends StatefulWidget {
  final DayCellBuilder cellBuilder;
  final ValueChanged<DateTime>? onTap;
  final DateTime? initialMonth;
  final DateTime? lastMonth;

  const MonthCalendar({super.key, required this.cellBuilder, this.onTap, this.initialMonth, this.lastMonth});

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  static const _origin = 1200; // page index of the initial month
  late final DateTime _base;
  late final PageController _ctrl;
  int _page = _origin;

  @override
  void initState() {
    super.initState();
    final m = widget.initialMonth ?? DateTime.now();
    _base = DateTime(m.year, m.month);
    _ctrl = PageController(initialPage: _origin);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  DateTime _monthFor(int page) => DateTime(_base.year, _base.month + page - _origin);

  int? get _maxPage {
    final l = widget.lastMonth;
    if (l == null) return null;
    return _origin + (l.year - _base.year) * 12 + (l.month - _base.month);
  }

  @override
  Widget build(BuildContext context) {
    final month = _monthFor(_page);
    final theme = Theme.of(context);
    final max = _maxPage;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _ctrl.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _capitalize(DateFormat.yMMMM().format(month)),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (_page != _origin)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: context.l.navToday,
                      icon: const Icon(Icons.today_outlined, size: 20),
                      onPressed: () => _ctrl.animateToPage(
                        _origin,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
              icon: const Icon(Icons.chevron_right),
              onPressed: max != null && _page >= max
                  ? null
                  : () => _ctrl.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
            ),
          ],
        ),
        _WeekdayHeader(),
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, c) {
            final cell = c.maxWidth / 7;
            return SizedBox(
              height: cell * 6,
              child: PageView.builder(
                controller: _ctrl,
                itemCount: max == null ? null : max + 1,
                onPageChanged: (p) => setState(() => _page = p),
                itemBuilder: (context, p) =>
                    _MonthGrid(month: _monthFor(p), cellSize: cell, builder: widget.cellBuilder, onTap: widget.onTap),
              ),
            );
          },
        ),
      ],
    );
  }
}

int _firstDayIndex(BuildContext context) => MaterialLocalizations.of(context).firstDayOfWeekIndex; // 0 = Sunday

class _WeekdayHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = MaterialLocalizations.of(context);
    final first = _firstDayIndex(context);
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.outline);
    return Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Text(loc.narrowWeekdays[(first + i) % 7], textAlign: TextAlign.center, style: style),
          ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final double cellSize;
  final DayCellBuilder builder;
  final ValueChanged<DateTime>? onTap;

  const _MonthGrid({required this.month, required this.cellSize, required this.builder, this.onTap});

  @override
  Widget build(BuildContext context) {
    final first = _firstDayIndex(context);
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final weekday = firstOfMonth.weekday % 7; // 0 = Sunday
    final lead = (weekday - first + 7) % 7;
    final startN = dayNumber(firstOfMonth) - lead;
    return Column(
      children: [
        for (var r = 0; r < 6; r++)
          SizedBox(
            height: cellSize,
            child: Row(
              children: [
                for (var c = 0; c < 7; c++)
                  Builder(
                    builder: (context) {
                      final day = fromDayNumber(startN + r * 7 + c);
                      final inMonth = day.month == month.month;
                      return SizedBox(
                        width: cellSize,
                        height: cellSize,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onTap == null ? null : () => onTap!(day),
                          child: builder(context, day, inMonth),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
