import 'package:intl/intl.dart' show DateFormat;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../engine/day.dart';
import '../engine/phases.dart';
import '../model/models.dart';
import '../state/app_state.dart';
import 'theme.dart';
import 'widgets/month_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final f = state.forecast;
    final theme = Theme.of(context);
    final periods = state.periodsSorted;

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      children: [
        MonthCalendar(
          onTap: (d) => showDaySheet(context, d),
          cellBuilder: (context, d, inMonth) => _DayCell(day: d, inMonth: inMonth, state: state, forecast: f),
        ),
        const SizedBox(height: 8),
        const _Legend(),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Tap a day to log or edit a period, mood or symptoms.',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Logged periods (${periods.length})',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 6),
        if (periods.isEmpty)
          const Padding(padding: EdgeInsets.all(8), child: Text('None yet. Tap the day her last period started.')),
        for (var i = 0; i < periods.length; i++)
          _PeriodTile(
            entry: periods[i],
            gap: i + 1 < periods.length ? daysBetween(periods[i + 1].start, periods[i].start) : null,
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool inMonth;
  final AppState state;
  final Forecast? forecast;
  const _DayCell({required this.day, required this.inMonth, required this.state, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final n = dayNumber(day);
    final today = state.todayDay;
    final logged = state.periodOn(day) != null;
    final isStart = state.isLoggedStart(day);
    final f = forecast;
    double predicted = 0;
    Phase? phase;
    if (f != null && n >= today) {
      predicted = f.periodProbability(n);
      phase = f.phaseOn(n);
    }
    final hasLog = state.logFor(day) != null;

    Color? fill;
    Color text = inMonth ? theme.colorScheme.onSurface : theme.colorScheme.outlineVariant;
    if (logged) {
      fill = Phase.period.color.withValues(alpha: isStart ? 1 : 0.75);
      text = Colors.white;
    } else if (predicted > 0.03) {
      fill = Phase.period.color.withValues(alpha: (0.12 + 0.6 * predicted).clamp(0, 0.72));
    } else if (phase == Phase.fertile || phase == Phase.ovulation || phase == Phase.pms) {
      fill = phase!.color.withValues(alpha: phase == Phase.ovulation ? 0.35 : 0.16);
    }
    if (!inMonth && fill != null) fill = fill.withValues(alpha: fill.a * 0.4);

    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fill,
          border: n == today ? Border.all(color: theme.colorScheme.onSurface, width: 2) : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(color: text, fontWeight: logged || n == today ? FontWeight.w700 : FontWeight.w500),
            ),
            if (hasLog)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: logged ? Colors.white : theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    Widget item(Color c, String t) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(t, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 6,
      children: [
        item(Phase.period.color, 'Logged'),
        item(Phase.period.color.withValues(alpha: 0.4), 'Predicted (shade = probability)'),
        item(Phase.fertile.color.withValues(alpha: 0.4), 'Fertile'),
        item(Phase.ovulation.color.withValues(alpha: 0.6), 'Ovulation'),
        item(Phase.pms.color.withValues(alpha: 0.4), 'PMS'),
      ],
    );
  }
}

class _PeriodTile extends StatelessWidget {
  final PeriodEntry entry;
  final int? gap;
  const _PeriodTile({required this.entry, this.gap});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat.yMMMd();
    final sub = [
      if (entry.length != null) '${entry.length} days' else 'end not logged',
      if (gap != null) '$gap days after previous',
    ].join(' · ');
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: CircleAvatar(
        backgroundColor: Phase.period.color,
        child: const Icon(Icons.water_drop, color: Colors.white, size: 18),
      ),
      title: Text(fmt.format(entry.start)),
      subtitle: Text(sub),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showDaySheet(context, entry.start),
    );
  }
}

Future<void> showDaySheet(BuildContext context, DateTime day) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => ChangeNotifierProvider.value(
    value: context.read<AppState>(),
    child: _DaySheet(day: dateOnly(day)),
  ),
);

class _DaySheet extends StatelessWidget {
  final DateTime day;
  const _DaySheet({required this.day});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final theme = Theme.of(context);
    final n = dayNumber(day);
    final future = n > state.todayDay;
    final isStart = state.isLoggedStart(day);
    final within = state.periodOn(day);
    final f = state.forecast;
    final log = state.logFor(day) ?? DayLog(date: day);
    final name = state.settings.name;

    String? info;
    if (f != null) {
      final ph = f.phaseOn(n);
      final pp = f.periodProbability(n);
      info = '${ph.emoji} ${ph.label}';
      if (n >= state.todayDay && pp > 0.02 && within == null) info += ' · ${(pp * 100).round()}% chance of period';
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 16 + MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMEEEEd().format(day),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (info != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(info)),
              const SizedBox(height: 16),
              if (future)
                Text('This day is in the future. You can log it once it happens.', style: theme.textTheme.bodySmall)
              else ...[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Period started this day'),
                  subtitle: Text('First day of bleeding for $name'),
                  value: isStart,
                  onChanged: (v) => v
                      ? state.addPeriodStart(day)
                      : state.removePeriod(state.data.periods.firstWhere((e) => dayNumber(e.start) == n)),
                ),
                if (within != null && !isStart)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Period ended this day'),
                    subtitle: const Text('Optional. Helps learn her period length'),
                    value: within.end != null && dayNumber(within.end!) == n,
                    onChanged: (v) => state.setPeriodEnd(within, v ? day : null),
                  ),
                if (isStart && within != null && within.end != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Ended ${DateFormat.MMMd().format(within.end!)} (${within.length} days)',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                const Divider(height: 24),
                Text(
                  'How was she? (optional)',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final m in kMoods)
                      ChoiceChip(
                        label: Text(m, style: const TextStyle(fontSize: 20)),
                        selected: log.mood == m,
                        onSelected: (sel) => state.setLog(
                          DayLog(date: day, mood: sel ? m : null, symptoms: log.symptoms, note: log.note),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final s in kSymptoms)
                      FilterChip(
                        label: Text(s),
                        selected: log.symptoms.contains(s),
                        onSelected: (sel) {
                          final set = {...log.symptoms};
                          sel ? set.add(s) : set.remove(s);
                          state.setLog(DayLog(date: day, mood: log.mood, symptoms: set, note: log.note));
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                _NoteField(day: day, initial: log.note),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteField extends StatefulWidget {
  final DateTime day;
  final String initial;
  const _NoteField({required this.day, required this.initial});

  @override
  State<_NoteField> createState() => _NoteFieldState();
}

class _NoteFieldState extends State<_NoteField> {
  late final _c = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _save();
    _c.dispose();
    super.dispose();
  }

  void _save() {
    final state = context.read<AppState>();
    final log = state.logFor(widget.day) ?? DayLog(date: widget.day);
    if (log.note == _c.text) return;
    state.setLog(DayLog(date: widget.day, mood: log.mood, symptoms: log.symptoms, note: _c.text));
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _c,
    maxLines: 2,
    decoration: const InputDecoration(labelText: 'Note', border: OutlineInputBorder()),
    onSubmitted: (_) => _save(),
    onTapOutside: (_) => _save(),
  );
}
