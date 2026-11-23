import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/store.dart';
import '../services/notifications.dart';
import '../state/app_state.dart';
import 'l10n.dart';
import 'theme.dart';
import 'widgets/language_menu.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.settings;
    final theme = Theme.of(context);
    final l = context.l;
    final notifOn = s.notificationsEnabled;

    Widget header(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(t, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          header(l.aboutHer),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l.name),
            subtitle: Text(s.herName.isEmpty ? l.notSet : s.herName),
            onTap: () async {
              final c = TextEditingController(text: s.herName);
              final v = await showDialog<String>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l.herName),
                  content: TextField(controller: c, autofocus: true, textCapitalization: TextCapitalization.words),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
                    FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: Text(l.save)),
                  ],
                ),
              );
              if (v != null) state.updateSettings((s) => s.herName = v.trim());
            },
          ),
          ListTile(
            leading: const Icon(Icons.water_drop_outlined),
            title: Text(l.typicalPeriodLength),
            subtitle: Text(
              state.learnedPeriodLength
                  ? l.learnedPeriodLength(state.periodLength)
                  : l.defaultPeriodLength(s.defaultPeriodLength),
            ),
          ),
          if (!state.learnedPeriodLength)
            Slider(
              min: 2,
              max: 10,
              divisions: 8,
              value: s.defaultPeriodLength.toDouble(),
              label: l.nDays(s.defaultPeriodLength),
              onChanged: (v) => state.updateSettings((s) => s.defaultPeriodLength = v.round()),
            ),
          header(l.notifications),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(l.notifications),
            subtitle: Text(l.notifDiscreet),
            value: notifOn,
            onChanged: (v) async {
              await state.updateSettings((s) => s.notificationsEnabled = v);
              if (v && context.mounted) await context.read<NotificationService>().requestPermission();
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.water_drop_outlined),
            title: Text(l.notifPeriodSoon),
            subtitle: Text(l.notifPeriodSoonSub(s.periodSoonLeadDays)),
            value: s.notifyPeriodSoon,
            onChanged: notifOn ? (v) => state.updateSettings((s) => s.notifyPeriodSoon = v) : null,
          ),
          if (notifOn && s.notifyPeriodSoon)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(l.leadDays),
                  Expanded(
                    child: Slider(
                      min: 1,
                      max: 7,
                      divisions: 6,
                      value: s.periodSoonLeadDays.toDouble(),
                      label: '${s.periodSoonLeadDays}',
                      onChanged: (v) => state.updateSettings((s) => s.periodSoonLeadDays = v.round()),
                    ),
                  ),
                ],
              ),
            ),
          SwitchListTile(
            secondary: const Icon(Icons.cloud_outlined),
            title: Text(l.notifPms),
            value: s.notifyPms,
            onChanged: notifOn ? (v) => state.updateSettings((s) => s.notifyPms = v) : null,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.lightbulb_outline),
            title: Text(l.notifDaily),
            value: s.notifyDailyTip,
            onChanged: notifOn ? (v) => state.updateSettings((s) => s.notifyDailyTip = v) : null,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.auto_awesome_outlined),
            title: Text(l.notifFertile),
            subtitle: Text(l.notifFertileSub),
            value: s.notifyFertile,
            onChanged: notifOn ? (v) => state.updateSettings((s) => s.notifyFertile = v) : null,
          ),
          ListTile(
            enabled: notifOn,
            leading: const Icon(Icons.schedule),
            title: Text(l.notifTime),
            trailing: Text(TimeOfDay(hour: s.notifyHour, minute: s.notifyMinute).format(context)),
            onTap: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: s.notifyHour, minute: s.notifyMinute),
              );
              if (t != null) {
                state.updateSettings((s) {
                  s.notifyHour = t.hour;
                  s.notifyMinute = t.minute;
                });
              }
            },
          ),
          header(l.appearance),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.language),
            trailing: DropdownButton<String>(
              value: s.language,
              underline: const SizedBox.shrink(),
              onChanged: (v) => state.updateSettings((s) => s.language = v ?? 'system'),
              items: [
                for (final code in ['system', ...AppState.supportedLanguages])
                  DropdownMenuItem(value: code, child: Text(languageLabel(l, code))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'system', label: Text(l.themeSystem)),
                ButtonSegment(value: 'light', label: Text(l.themeLight)),
                ButtonSegment(value: 'dark', label: Text(l.themeDark)),
              ],
              selected: {s.themeMode},
              onSelectionChanged: (v) => state.updateSettings((s) => s.themeMode = v.first),
            ),
          ),
          header(l.dataHeader),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(l.exportBackup),
            subtitle: Text(l.exportSub),
            onTap: () => _export(context, state),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: Text(l.importBackup),
            subtitle: Text(l.importSub),
            onTap: () => _import(context, state),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: theme.colorScheme.error),
            title: Text(l.deleteAll, style: TextStyle(color: theme.colorScheme.error)),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l.deleteConfirmTitle),
                  content: Text(l.deleteConfirmBody),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
                    FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.delete)),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                await state.wipe();
                if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
              }
            },
          ),
          header(l.about),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(l.aboutBody(kAppName))),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context, AppState state) async {
    final subject = context.l.backupSubject(kAppName);
    final dir = await getTemporaryDirectory();
    final now = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    final f = File('${dir.path}/tempo-backup-${now.year}-${two(now.month)}-${two(now.day)}.json');
    await f.writeAsString(state.exportJson());
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(f.path, mimeType: 'application/json')],
        subject: subject,
      ),
    );
  }

  Future<void> _import(BuildContext context, AppState state) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l;
    try {
      final files = await FilePicker.pickFiles(type: FileType.any);
      if (files.isEmpty) return;
      final data = Store.decode(await files.first.xFile.readAsString());
      await state.importData(data);
      messenger.showSnackBar(SnackBar(content: Text(l.imported(data.periods.length, data.notes.length))));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(l.invalidBackup(kAppName))));
    }
  }
}
