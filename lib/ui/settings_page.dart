import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/store.dart';
import '../services/notifications.dart';
import '../state/app_state.dart';
import 'theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.settings;
    final theme = Theme.of(context);
    final notifOn = s.notificationsEnabled;

    Widget header(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(t, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          header('About her'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Name'),
            subtitle: Text(s.herName.isEmpty ? 'Not set' : s.herName),
            onTap: () async {
              final c = TextEditingController(text: s.herName);
              final v = await showDialog<String>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Her name'),
                  content: TextField(controller: c, autofocus: true, textCapitalization: TextCapitalization.words),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('Save')),
                  ],
                ),
              );
              if (v != null) state.updateSettings((s) => s.herName = v.trim());
            },
          ),
          ListTile(
            leading: const Icon(Icons.water_drop_outlined),
            title: const Text('Typical period length'),
            subtitle: Text(
              state.learnedPeriodLength
                  ? 'Learned: ${state.periodLength} days (from logged end dates)'
                  : '${s.defaultPeriodLength} days. Log end dates to learn it automatically',
            ),
          ),
          if (!state.learnedPeriodLength)
            Slider(
              min: 2,
              max: 10,
              divisions: 8,
              value: s.defaultPeriodLength.toDouble(),
              label: '${s.defaultPeriodLength} days',
              onChanged: (v) => state.updateSettings((s) => s.defaultPeriodLength = v.round()),
            ),
          header('Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Lock-screen text stays discreet'),
            value: notifOn,
            onChanged: (v) async {
              await state.updateSettings((s) => s.notificationsEnabled = v);
              if (v && context.mounted) await context.read<NotificationService>().requestPermission();
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.water_drop_outlined),
            title: const Text('Period coming soon'),
            subtitle: Text(
              '${s.periodSoonLeadDays} day${s.periodSoonLeadDays == 1 ? '' : 's'} before the most likely start',
            ),
            value: s.notifyPeriodSoon,
            onChanged: notifOn ? (v) => state.updateSettings((s) => s.notifyPeriodSoon = v) : null,
          ),
          if (notifOn && s.notifyPeriodSoon)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Lead days'),
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
            title: const Text('PMS window starting'),
            value: s.notifyPms,
            onChanged: notifOn ? (v) => state.updateSettings((s) => s.notifyPms = v) : null,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.lightbulb_outline),
            title: const Text('Daily tip'),
            value: s.notifyDailyTip,
            onChanged: notifOn ? (v) => state.updateSettings((s) => s.notifyDailyTip = v) : null,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.auto_awesome_outlined),
            title: const Text('Fertile window'),
            subtitle: const Text('Informational only, not contraception'),
            value: s.notifyFertile,
            onChanged: notifOn ? (v) => state.updateSettings((s) => s.notifyFertile = v) : null,
          ),
          ListTile(
            enabled: notifOn,
            leading: const Icon(Icons.schedule),
            title: const Text('Notification time'),
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
          header('Appearance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'system', label: Text('System')),
                ButtonSegment(value: 'light', label: Text('Light')),
                ButtonSegment(value: 'dark', label: Text('Dark')),
              ],
              selected: {s.themeMode},
              onSelectionChanged: (v) => state.updateSettings((s) => s.themeMode = v.first),
            ),
          ),
          header('Your data (stored only on this phone)'),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Export backup'),
            subtitle: const Text('Save or send a JSON file'),
            onTap: () => _export(context, state),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Import backup'),
            subtitle: const Text('Replaces current data'),
            onTap: () => _import(context, state),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: theme.colorScheme.error),
            title: Text('Delete all data', style: TextStyle(color: theme.colorScheme.error)),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete everything?'),
                  content: const Text(
                    'All dates, notes, logs and settings will be erased from this phone. This can\'t be undone.',
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                await state.wipe();
                if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
              }
            },
          ),
          header('About'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$kAppName estimates cycles statistically from the dates you enter. It is not medical advice and must not be '
              'used as contraception. Every person is different, so talk with her. If her cycles are often shorter than 21 '
              'or longer than 35 days, or very painful, suggest seeing a doctor.',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context, AppState state) async {
    final dir = await getTemporaryDirectory();
    final now = DateTime.now();
    final f = File(
      '${dir.path}/tempo-backup-${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.json',
    );
    await f.writeAsString(state.exportJson());
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(f.path, mimeType: 'application/json')],
        subject: '$kAppName backup',
      ),
    );
  }

  Future<void> _import(BuildContext context, AppState state) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final files = await FilePicker.pickFiles(type: FileType.any);
      if (files.isEmpty) return;
      final data = Store.decode(await files.first.xFile.readAsString());
      await state.importData(data);
      messenger.showSnackBar(
        SnackBar(content: Text('Imported ${data.periods.length} periods and ${data.notes.length} notes')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text("That file isn't a valid $kAppName backup")));
    }
  }
}
