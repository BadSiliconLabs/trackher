import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../engine/phases.dart';
import '../model/models.dart';
import '../state/app_state.dart';
import 'theme.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final theme = Theme.of(context);
    final notes = state.data.notes;
    final current = state.forecast?.likelyPhase;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
          child: Text(
            "Things she told you or you learned: what helps, what doesn't, favourite comfort food. "
            'Tag a note with phases and it shows up on the Today screen at the right time.',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
          ),
        ),
        if (notes.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Examples', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text(
                    '• Period: doesn\'t want to be touched on day 1, but loves a heat pad\n'
                    '• PMS: craves salty chips, NOT sweets\n'
                    '• Always: favourite flowers are peonies\n'
                    '• Follicular: loves hiking dates',
                  ),
                ],
              ),
            ),
          ),
        for (final n in notes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              color: current != null && n.phases.contains(current) ? theme.colorScheme.tertiaryContainer : null,
              child: ListTile(
                title: Text(n.text),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      if (n.phases.isEmpty) const _Mini('Always', null),
                      for (final p in n.phases) _Mini('${p.emoji} ${p.label}', p.color),
                    ],
                  ),
                ),
                onTap: () => editNote(context, n),
              ),
            ),
          ),
      ],
    );
  }
}

class _Mini extends StatelessWidget {
  final String t;
  final Color? c;
  const _Mini(this.t, this.c);

  @override
  Widget build(BuildContext context) {
    final color = c ?? Theme.of(context).colorScheme.outline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(
        t,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class AddNoteFab extends StatelessWidget {
  const AddNoteFab({super.key});

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
    onPressed: () => editNote(context, null),
    icon: const Icon(Icons.add),
    label: const Text('Add note'),
  );
}

Future<void> editNote(BuildContext context, HerNote? existing) async {
  final state = context.read<AppState>();
  final text = TextEditingController(text: existing?.text ?? '');
  final phases = {...?existing?.phases};
  final selectable = Phase.values.where((p) => p != Phase.ovulation);
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              existing == null ? 'New note' : 'Edit note',
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: text,
              autofocus: existing == null,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g. Wants space on day 1'),
            ),
            const SizedBox(height: 12),
            const Text('Show during (none = always)'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final p in selectable)
                  FilterChip(
                    avatar: Text(p.emoji),
                    label: Text(p.label),
                    selected: phases.contains(p),
                    onSelected: (s) => setS(() => s ? phases.add(p) : phases.remove(p)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (existing != null)
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                    onPressed: () {
                      state.deleteNote(existing.id);
                      Navigator.pop(ctx);
                    },
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    if (text.text.trim().isEmpty) return;
                    // Fertile also covers ovulation day.
                    final ph = {...phases, if (phases.contains(Phase.fertile)) Phase.ovulation};
                    state.upsertNote(
                      HerNote(
                        id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
                        text: text.text.trim(),
                        phases: ph,
                      ),
                    );
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
