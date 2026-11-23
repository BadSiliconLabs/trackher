import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../l10n.dart';

/// Native names, shown untranslated so anyone can find their language.
const kLanguageNames = {'en': 'English', 'it': 'Italiano', 'es': 'Español'};

String languageLabel(L l, String code) => code == 'system' ? l.languageSystem : kLanguageNames[code] ?? code;

/// Compact language switcher (globe + current language).
class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return PopupMenuButton<String>(
      tooltip: context.l.language,
      initialValue: state.settings.language,
      onSelected: (v) => state.updateSettings((s) => s.language = v),
      itemBuilder: (context) => [
        for (final code in ['system', ...AppState.supportedLanguages])
          PopupMenuItem(value: code, child: Text(languageLabel(context.l, code))),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [const Icon(Icons.language, size: 20), const SizedBox(width: 6), Text(kLanguageNames[state.lang]!)],
        ),
      ),
    );
  }
}
