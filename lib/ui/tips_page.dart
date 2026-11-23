import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../engine/phases.dart';
import '../engine/tips_engine.dart';
import '../state/app_state.dart';
import 'theme.dart';
import 'widgets/tip_card.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  Phase? _phase; // null = current phase
  TipCategory? _cat;
  bool _showHidden = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final current = state.forecast?.likelyPhase ?? Phase.follicular;
    final phase = _phase ?? current;
    final theme = Theme.of(context);
    final fb = state.data.tipFeedback;
    var tips = _showHidden
        ? state.tips.tips.where((t) => (fb[t.id] ?? 0) < 0).toList()
        : state.tips.forPhase(phase, feedback: fb);
    if (_cat != null) tips = tips.where((t) => t.category == _cat).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final p in Phase.values.where((p) => p != Phase.ovulation))
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    avatar: Text(p.emoji),
                    label: Text(p == current ? '${p.label} (now)' : p.label),
                    selected: !_showHidden && p == phase,
                    onSelected: (_) => setState(() {
                      _showHidden = false;
                      _phase = p;
                    }),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: const Text('All'),
                  selected: _cat == null,
                  onSelected: (_) => setState(() => _cat = null),
                ),
              ),
              for (final c in TipCategory.values)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text('${c.emoji} ${c.label}'),
                    selected: _cat == c,
                    onSelected: (s) => setState(() => _cat = s ? c : null),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (!_showHidden)
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
            child: Text(
              '${phase.blurb}\nThese are ideas, not rules. What she tells you always wins.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
            ),
          ),
        if (tips.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No tips here.')),
          ),
        for (final t in tips)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TipCard(tip: t),
          ),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _showHidden = !_showHidden),
            child: Text(_showHidden ? 'Back to tips' : 'Show hidden tips'),
          ),
        ),
      ],
    );
  }
}
