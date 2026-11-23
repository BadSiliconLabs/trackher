import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../engine/phases.dart';
import '../engine/tips_engine.dart';
import '../state/app_state.dart';
import 'l10n.dart';
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
    final l = context.l;
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
                    avatar: Icon(p.icon, size: 18),
                    label: Text(p == current ? l.phaseNow(l.phase(p)) : l.phase(p)),
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
                  label: Text(l.all),
                  selected: _cat == null,
                  onSelected: (_) => setState(() => _cat = null),
                ),
              ),
              for (final c in TipCategory.values)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    avatar: Icon(c.icon, size: 18),
                    label: Text(l.category(c)),
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
              '${l.blurb(phase)}\n${l.tipsDisclaimer}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
            ),
          ),
        if (tips.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: Text(l.noTips)),
          ),
        for (final t in tips)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TipCard(tip: t),
          ),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _showHidden = !_showHidden),
            child: Text(_showHidden ? l.backToTips : l.showHidden),
          ),
        ),
      ],
    );
  }
}
