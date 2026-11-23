import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../engine/phases.dart';
import '../state/app_state.dart';
import 'guide/guide_content.dart';
import 'l10n.dart';
import 'theme.dart';

/// Plain-language guide to the cycle and each phase.
class GuidePage extends StatelessWidget {
  /// Phase to open expanded (e.g. the current one).
  final Phase? focus;
  const GuidePage({super.key, this.focus});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l;
    final g = guideFor(context.select<AppState, String>((s) => s.lang));
    return Scaffold(
      appBar: AppBar(title: Text(l.guide)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          _Intro(text: g.intro),
          const SizedBox(height: 16),
          _CycleBar(note: g.cycleNote),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(l.guidePhases, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          for (final pg in g.phases)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PhaseSection(guide: pg, expanded: pg.phase == focus),
            ),
          const SizedBox(height: 10),
          for (final s in g.general)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _InfoSection(icon: s.icon, title: s.title, body: s.body),
            ),
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  final String text;
  const _Intro({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: cs.onPrimaryContainer, height: 1.4)),
    );
  }
}

/// A proportional bar of a typical 28-day cycle.
class _CycleBar extends StatelessWidget {
  final String note;
  const _CycleBar({required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Days 1-28 by phase, using the same rules as the forecast.
    final days = [for (var c = 0; c < 28; c++) phaseForCycleDay(c, 28, 5)];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l.typicalCycle, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  for (final p in days)
                    Expanded(
                      child: Container(height: 22, margin: const EdgeInsets.only(right: 1), color: p.color),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final d in [1, 7, 14, 21, 28].map(context.l.dayN))
                  Text(d, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                for (final p in Phase.values)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(p.icon, size: 16, color: p.color),
                      const SizedBox(width: 4),
                      Text(context.l.phase(p), style: theme.textTheme.labelMedium),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(note, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
          ],
        ),
      ),
    );
  }
}

class _PhaseSection extends StatelessWidget {
  final PhaseGuide guide;
  final bool expanded;
  const _PhaseSection({required this.guide, required this.expanded});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = guide.phase;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: expanded,
          leading: CircleAvatar(
            backgroundColor: p.color.withValues(alpha: 0.18),
            child: Icon(p.icon, color: p.color),
          ),
          title: Text(context.l.phase(p), style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(guide.when),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Block(icon: Icons.science_outlined, title: context.l.gWhat, body: guide.body),
            _Block(icon: Icons.person_outline, title: context.l.gFeel, body: guide.feel),
            _Block(icon: Icons.volunteer_activism_outlined, title: context.l.gHelp, bullets: guide.help),
            _Block(icon: Icons.do_not_disturb_on_outlined, title: context.l.gAvoid, bullets: guide.avoid),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  final List<String> bullets;
  const _Block({required this.icon, required this.title, this.body, this.bullets = const []});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          if (body != null) Text(body!, style: const TextStyle(height: 1.4)),
          for (final b in bullets)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7, right: 8, left: 2),
                    child: Icon(Icons.circle, size: 5, color: theme.colorScheme.outline),
                  ),
                  Expanded(child: Text(b, style: const TextStyle(height: 1.4))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _InfoSection({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(body, style: const TextStyle(height: 1.4))],
        ),
      ),
    );
  }
}
