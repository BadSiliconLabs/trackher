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
  final tips = TipsEngine.fromJsonString(await rootBundle.loadString('assets/tips.json'));
  final notifications = NotificationService();
  try {
    await notifications.init();
  } catch (_) {
    // Notifications are optional; the app works without them.
  }
  final state = AppState(store: Store(), tips: tips, reschedule: notifications.reschedule);
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
