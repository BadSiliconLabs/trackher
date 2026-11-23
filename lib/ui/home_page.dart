import 'package:intl/intl.dart' show DateFormat;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../engine/day.dart';
import '../engine/phases.dart';
import '../state/app_state.dart';
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
    final tip = state.tipForDay(state.todayDay);
    final l = context.l;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        if (f.lastStartAssumed) ...[
          _Banner(icon: Icons.history, text: l.bannerStale, action: l.bannerLog, onAction: () => onNavigate(1)),
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
        const SizedBox(height: 16),
        _NextDays(forecast: f),
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
        if (tip != null) ...[
          const SizedBox(height: 20),
          _SectionTitle(
            l.todaysTip,
            trailing: TextButton(onPressed: () => onNavigate(3), child: Text(l.moreTips)),
          ),
          TipCard(tip: tip),
        ],
      ],
    );
  }
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
      padding: const EdgeInsets.all(20),
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
                  l.cycleDay(f.cycleDay),
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
            const SizedBox(height: 8),
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
            const SizedBox(height: 16),
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
    final name = l.her(state.settings);
    return Row(
      children: [
        if (!canEnd)
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: loggedToday ? Theme.of(context).colorScheme.surfaceContainerHighest : null,
                foregroundColor: loggedToday ? Theme.of(context).colorScheme.onSurface : null,
              ),
              icon: Icon(loggedToday ? Icons.check : Icons.water_drop),
              label: Text(loggedToday ? l.loggedToday : l.periodStartedToday),
              onPressed: loggedToday
                  ? () => state.removePeriod(state.data.periods.firstWhere((e) => dayNumber(e.start) == state.todayDay))
                  : () async {
                      await state.addPeriodStart(today);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.loggedSnack(name))));
                      }
                    },
            ),
          ),
        if (canEnd)
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              icon: const Icon(Icons.flag_outlined),
              label: Text(l.periodEnded),
              onPressed: () => state.setPeriodEnd(p, today),
            ),
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
              return Container(
                width: 48,
                decoration: BoxDecoration(
                  color: ph.color.withValues(alpha: ph == Phase.period ? 0.25 + 0.6 * pp : 0.22),
                  borderRadius: BorderRadius.circular(14),
                  border: i == 0 ? Border.all(color: theme.colorScheme.onSurface, width: 1.5) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat.E().format(d).substring(0, 2), style: theme.textTheme.labelSmall),
                    Text('${d.day}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    Icon(ph.icon, size: 14, color: ph.color),
                  ],
                ),
              );
            },
          ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_note_outlined, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(context.l.emptyTitle, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(context.l.emptyBody, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Icons.water_drop),
              label: Text(context.l.periodStartedToday),
              onPressed: () => state.addPeriodStart(state.today),
            ),
          ],
        ),
      ),
    );
  }
}
