import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../engine/phases.dart';
import '../model/models.dart';
import '../state/app_state.dart';
import 'l10n.dart';
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
            context.l.notesIntro,
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
                  Text(context.l.examples, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(context.l.examplesBody),
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
                      if (n.phases.isEmpty) _Mini(context.l.always, null),
                      for (final p in n.phases) _Mini(context.l.phase(p), p.color, icon: p.icon),
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
  final IconData? icon;
  const _Mini(this.t, this.c, {this.icon});

  @override
  Widget build(BuildContext context) {
    final color = c ?? Theme.of(context).colorScheme.outline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: color), const SizedBox(width: 4)],
          Text(
            t,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
          ),
        ],
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
    label: Text(context.l.addNote),
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
              existing == null ? ctx.l.newNote : ctx.l.editNote,
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: text,
              autofocus: existing == null,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(border: const OutlineInputBorder(), hintText: ctx.l.noteHint),
            ),
            const SizedBox(height: 12),
            Text(ctx.l.showDuring),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final p in selectable)
                  FilterChip(
                    avatar: Icon(p.icon, size: 18),
                    label: Text(ctx.l.phase(p)),
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
                    label: Text(ctx.l.delete),
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
                  child: Text(ctx.l.save),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
