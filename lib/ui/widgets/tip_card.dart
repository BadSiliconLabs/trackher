import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../engine/phases.dart';
import '../../engine/tips_engine.dart';
import '../../state/app_state.dart';
import '../theme.dart';

class TipCard extends StatelessWidget {
  final Tip tip;
  const TipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final fb = state.tipFeedback(tip.id);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(tip.category.icon, size: 22, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(tip.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(tip.text, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    children: [
                      _Tag(tip.category.label, theme.colorScheme.primary),
                      if (tip.phases.isEmpty)
                        _Tag('Any time', theme.colorScheme.outline)
                      else
                        for (final p in tip.phases) _Tag(p.label, p.color),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Helpful',
                  icon: Icon(fb > 0 ? Icons.thumb_up : Icons.thumb_up_outlined, size: 20),
                  color: fb > 0 ? theme.colorScheme.primary : null,
                  onPressed: () => state.setTipFeedback(tip.id, fb > 0 ? 0 : 1),
                ),
                IconButton(
                  tooltip: 'Not for us (hide)',
                  icon: Icon(fb < 0 ? Icons.thumb_down : Icons.thumb_down_outlined, size: 20),
                  onPressed: () {
                    state.setTipFeedback(tip.id, fb < 0 ? 0 : -1);
                    if (fb >= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Tip hidden'),
                          action: SnackBarAction(label: 'Undo', onPressed: () => state.setTipFeedback(tip.id, 0)),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 4),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
    child: Text(
      text,
      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
    ),
  );
}
