import 'package:intl/intl.dart' show DateFormat;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../engine/day.dart';
import '../engine/phases.dart';
import '../state/app_state.dart';
import 'calendar_page.dart' show showDaySheet;
import 'guide_page.dart';
import 'l10n.dart';
import 'theme.dart';
import 'widgets/tip_card.dart';

class HomePage extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  const HomePage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final f = state.forecast;
    if (f == null) return _Empty(state: state);

    final phase = f.likelyPhase;
    final notes = state.notesFor(phase);
    final l = context.l;
    final events = f.upcomingEvents();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        if (f.lastStartAssumed) ...[
          _Banner(
            icon: Icons.history,
            text: l.bannerStale,
            action: l.bannerLog,
            onAction: () => logStartOnOtherDay(context, state),
          ),
          const SizedBox(height: 12),
        ],
        if (f.stats.suspiciousGaps.isNotEmpty) ...[
          _Banner(
            icon: Icons.warning_amber_rounded,
            text: l.bannerSuspicious,
            action: l.bannerReview,
            onAction: () => onNavigate(1),
          ),
          const SizedBox(height: 12),
        ],
        _PhaseCard(forecast: f),
        const SizedBox(height: 12),
        _QuickActions(state: state),
        const SizedBox(height: 20),
        _NextDays(forecast: f),
        if (events.isNotEmpty) ...[
          const SizedBox(height: 20),
          _SectionTitle(l.comingUp),
          _ComingUp(events: events, today: f.todayDay),
        ],
        if (notes.isNotEmpty) ...[
          const SizedBox(height: 20),
          _SectionTitle(
            l.remember,
            trailing: TextButton(onPressed: () => onNavigate(4), child: Text(l.allNotes)),
          ),
          for (final n in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: ListTile(leading: const Icon(Icons.push_pin_outlined), title: Text(n.text)),
              ),
            ),
        ],
        const SizedBox(height: 20),
        _SectionTitle(
          l.todaysTip,
          trailing: TextButton(onPressed: () => onNavigate(3), child: Text(l.moreTips)),
        ),
        _RotatingTip(state: state),
      ],
    );
  }
}

/// Logs a period start, with an Undo snackbar.
Future<void> logStart(BuildContext context, AppState state, DateTime day) async {
  final messenger = ScaffoldMessenger.of(context);
  final l = context.l;
  final alreadyLogged = state.isLoggedStart(day);
  await state.addPeriodStart(day);
  if (alreadyLogged) return;
  final isToday = dayNumber(day) == state.todayDay;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(isToday ? l.loggedSnack(l.her(state.settings)) : l.loggedStartOn(DateFormat.MMMMd().format(day))),
        action: SnackBarAction(
          label: l.undo,
          onPressed: () {
            final e = state.data.periods.where((p) => dayNumber(p.start) == dayNumber(day));
            if (e.isNotEmpty) state.removePeriod(e.first);
          },
        ),
      ),
    );
}

/// Asks for a past date and logs it as a period start.
Future<void> logStartOnOtherDay(BuildContext context, AppState state) async {
  final today = state.today;
  final picked = await showDatePicker(
    context: context,
    initialDate: today.subtract(const Duration(days: 1)),
    firstDate: DateTime(today.year - 3),
    lastDate: today,
    helpText: context.l.whenDidItStart,
  );
  if (picked != null && context.mounted) await logStart(context, state, picked);
}

class _PhaseCard extends StatelessWidget {
  final Forecast forecast;
  const _PhaseCard({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final f = forecast;
    final phase = f.likelyPhase;
    final likely = f.likelyPhaseProb < 0.7;
    final (lo, hi) = f.next.interval(0.8);
    final until = f.daysUntilNext;
    final theme = Theme.of(context);
    final fmt = DateFormat.MMMd();
    final l = context.l;

    String headline;
    if (f.pAlreadyStarted > 0.5 && phase != Phase.period) {
      headline = l.anyDayNow;
    } else if (until > 0) {
      headline = l.nextIn(until);
    } else if (until == 0) {
      headline = l.startsToday;
    } else {
      headline = l.probablyStarted;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [phase.color, Color.lerp(phase.color, Colors.black, 0.25)!],
        ),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l.dayOfCycle(f.cycleDay, f.currentCycleLength),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white70),
                ),
                const Spacer(),
                Icon(phase.icon, color: Colors.white, size: 28),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              likely ? l.likelyPhase(l.phase(phase)) : l.phase(phase),
              style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _CycleProgress(forecast: f),
            const SizedBox(height: 12),
            Text(l.blurb(phase), style: const TextStyle(color: Colors.white, height: 1.35)),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.white, padding: EdgeInsets.zero),
                icon: const Icon(Icons.menu_book_outlined, size: 18),
                label: Text(l.aboutPhase),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => GuidePage(focus: phase))),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  const Icon(Icons.water_drop_outlined, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(headline, style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(
                          l.mostLikelyRange(
                            fmt.format(f.next.modeDate),
                            fmt.format(fromDayNumber(lo)),
                            fmt.format(fromDayNumber(hi)),
                          ),
                          style: const TextStyle(fontSize: 12.5, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Segmented bar of the current cycle (coloured by phase) with a marker for today.
class _CycleProgress extends StatelessWidget {
  final Forecast forecast;
  const _CycleProgress({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final f = forecast;
    final len = f.currentCycleLength;
    final segments = <(Phase, int)>[];
    for (var c = 0; c < len; c++) {
      final p = phaseForCycleDay(c, len, f.periodLength);
      if (segments.isNotEmpty && segments.last.$1 == p) {
        segments[segments.length - 1] = (p, segments.last.$2 + 1);
      } else {
        segments.add((p, 1));
      }
    }
    return LayoutBuilder(
      builder: (context, c) {
        final x = c.maxWidth * f.cycleProgress;
        return SizedBox(
          height: 16,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: [
                    for (final (p, n) in segments)
                      Expanded(
                        flex: n,
                        child: Container(
                          height: 8,
                          margin: const EdgeInsets.only(right: 1),
                          color: Color.lerp(p.color, Colors.white, 0.45),
                        ),
                      ),
                  ],
                ),
              ),
              Positioned(
                left: (x - 8).clamp(0, c.maxWidth - 16),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: f.likelyPhase.color, width: 3),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickActions extends StatelessWidget {
  final AppState state;
  const _QuickActions({required this.state});

  @override
  Widget build(BuildContext context) {
    final today = state.today;
    final loggedToday = state.isLoggedStart(today);
    final p = state.periodOn(today);
    final canEnd = p != null && p.end == null && !loggedToday;
    final l = context.l;
    const pad = EdgeInsets.symmetric(vertical: 14, horizontal: 12);
    return Row(
      children: [
        if (canEnd)
          Expanded(
            child: FilledButton.tonalIcon(
              style: FilledButton.styleFrom(padding: pad),
              icon: const Icon(Icons.flag_outlined),
              label: Text(l.periodEnded),
              onPressed: () => state.setPeriodEnd(p, today),
            ),
          )
        else
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: pad,
                backgroundColor: loggedToday ? Theme.of(context).colorScheme.surfaceContainerHighest : null,
                foregroundColor: loggedToday ? Theme.of(context).colorScheme.onSurface : null,
              ),
              icon: Icon(loggedToday ? Icons.check : Icons.water_drop),
              label: Text(loggedToday ? l.loggedToday : l.periodStartedToday),
              onPressed: loggedToday
                  ? () => state.removePeriod(state.data.periods.firstWhere((e) => dayNumber(e.start) == state.todayDay))
                  : () => logStart(context, state, today),
            ),
          ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(padding: pad),
          icon: const Icon(Icons.edit_calendar_outlined, size: 20),
          label: Text(l.otherDay),
          onPressed: () => logStartOnOtherDay(context, state),
        ),
      ],
    );
  }
}

class _NextDays extends StatelessWidget {
  final Forecast forecast;
  const _NextDays({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final f = forecast;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(context.l.nextTwoWeeks),
        SizedBox(
          height: 74,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 14,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              final day = f.todayDay + i;
              final ph = f.phaseOn(day);
              final pp = f.periodProbability(day);
              final d = fromDayNumber(day);
              return Material(
                color: ph.color.withValues(alpha: ph == Phase.period ? 0.25 + 0.6 * pp : 0.22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: i == 0 ? BorderSide(color: theme.colorScheme.onSurface, width: 1.5) : BorderSide.none,
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => showDaySheet(context, d),
                  child: SizedBox(
                    width: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat.E().format(d).substring(0, 2), style: theme.textTheme.labelSmall),
                        Text('${d.day}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        Icon(ph.icon, size: 14, color: ph.color),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ComingUp extends StatelessWidget {
  final List<CycleEvent> events;
  final int today;
  const _ComingUp({required this.events, required this.today});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final theme = Theme.of(context);
    final fmt = DateFormat.MMMEd();
    return Card(
      child: Column(
        children: [
          for (final (i, e) in events.indexed) ...[
            if (i > 0) Divider(height: 1, indent: 64, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: e.kind.phase.color.withValues(alpha: 0.18),
                child: Icon(e.kind.phase.icon, color: e.kind.phase.color, size: 20),
              ),
              title: Text(l.event(e.kind), style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                e.spread > 0 ? '${fmt.format(fromDayNumber(e.day))} (±${e.spread})' : fmt.format(fromDayNumber(e.day)),
              ),
              trailing: Text(
                l.relativeDay(e.day - today),
                style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RotatingTip extends StatefulWidget {
  final AppState state;
  const _RotatingTip({required this.state});

  @override
  State<_RotatingTip> createState() => _RotatingTipState();
}

class _RotatingTipState extends State<_RotatingTip> {
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    final tips = widget.state.tipsForDay(widget.state.todayDay);
    if (tips.isEmpty) return const SizedBox.shrink();
    final tip = tips[_offset % tips.length];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: TipCard(key: ValueKey(tip.id), tip: tip),
        ),
        if (tips.length > 1)
          TextButton.icon(
            icon: const Icon(Icons.shuffle, size: 18),
            label: Text(context.l.anotherTip),
            onPressed: () => setState(() => _offset++),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const _SectionTitle(this.text, {this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6, left: 4),
    child: Row(
      children: [
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        ?trailing,
      ],
    ),
  );
}

class _Banner extends StatelessWidget {
  final IconData icon;
  final String text;
  final String action;
  final VoidCallback onAction;
  const _Banner({required this.icon, required this.text, required this.action, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
      decoration: BoxDecoration(color: cs.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
          TextButton(onPressed: onAction, child: Text(action)),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final AppState state;
  const _Empty({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_note_outlined, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(l.emptyTitle, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(l.emptyBody, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Icons.water_drop),
              label: Text(l.periodStartedToday),
              onPressed: () => logStart(context, state, state.today),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.edit_calendar_outlined),
              label: Text(l.otherDay),
              onPressed: () => logStartOnOtherDay(context, state),
            ),
          ],
        ),
      ),
    );
  }
}
