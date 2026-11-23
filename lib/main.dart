import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'data/store.dart';
import 'engine/tips_engine.dart';
import 'services/notifications.dart';
import 'state/app_state.dart';
import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tips = {
    for (final lang in AppState.supportedLanguages)
      lang: TipsEngine.fromJsonString(await rootBundle.loadString('assets/tips/$lang.json')),
  };
  final notifications = NotificationService();
  try {
    await notifications.init();
  } catch (_) {
    // Notifications are optional; the app works without them.
  }
  final state = AppState(store: Store(), tipsByLang: tips, reschedule: notifications.reschedule);
  await state.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: state),
        Provider.value(value: notifications),
      ],
      child: const TrackHerApp(),
    ),
  );
}
