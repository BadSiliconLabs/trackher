// Renders every main screen to PNG (goldens) so the UI can be reviewed
// without a device:  flutter test test/screens_test.dart --update-goldens
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:trackher/data/store.dart';
import 'package:trackher/engine/phases.dart';
import 'package:trackher/engine/tips_engine.dart';
import 'package:trackher/model/models.dart';
import 'package:trackher/services/notifications.dart';
import 'package:trackher/state/app_state.dart';
import 'package:trackher/ui/app.dart';

Future<void> _loadFonts() async {
  final base = '${Platform.environment['HOME']}/flutter/bin/cache/artifacts/material_fonts';
  Future<void> load(String family, List<String> files) async {
    final l = FontLoader(family);
    for (final f in files) {
      final p = File('$base/$f');
      if (p.existsSync()) l.addFont(Future.value(ByteData.sublistView(p.readAsBytesSync())));
    }
    await l.load();
  }

  await load('Roboto', ['Roboto-Regular.ttf', 'Roboto-Medium.ttf', 'Roboto-Bold.ttf', 'Roboto-Black.ttf']);
  await load('MaterialIcons', ['MaterialIcons-Regular.otf']);
}

void main() {
  final tips = TipsEngine.fromJsonString(File('assets/tips.json').readAsStringSync());

  Future<AppState> makeState(bool onboarded) async {
    final dir = await Directory.systemTemp.createTemp('trackher');
    final s = AppState(
      store: Store(dir: () async => dir),
      tips: tips,
      clock: () => DateTime(2026, 11, 23),
    );
    await s.load();
    if (onboarded) {
      await s.completeOnboarding('Anna', [DateTime(2026, 6, 18), DateTime(2026, 10, 20), DateTime(2026, 11, 19)]);
      await s.upsertNote(HerNote(id: 'a', text: 'Craves salty chips, not sweets', phases: {Phase.pms, Phase.luteal}));
      await s.upsertNote(HerNote(id: 'b', text: 'Favourite flowers: peonies'));
    }
    return s;
  }

  Widget wrap(AppState s) => MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: s),
      Provider.value(value: NotificationService()),
    ],
    child: const TrackHerApp(),
  );

  setUpAll(_loadFonts);

  for (final (i, name) in ['today', 'calendar', 'forecast', 'tips', 'notes'].indexed) {
    testWidgets('screen $name', (t) async {
      t.view.physicalSize = const Size(1080, 2340);
      t.view.devicePixelRatio = 2.75;
      final s = await t.runAsync(() => makeState(true));
      await t.pumpWidget(wrap(s!));
      await t.pumpAndSettle();
      if (i > 0) {
        await t.tap(find.byType(NavigationDestination).at(i));
        await t.pumpAndSettle();
      }
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/$name.png'));
    });
  }

  testWidgets('screen onboarding', (t) async {
    t.view.physicalSize = const Size(1080, 2340);
    t.view.devicePixelRatio = 2.75;
    final s = await t.runAsync(() => makeState(false));
    await t.pumpWidget(wrap(s!));
    await t.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/onboarding.png'));
  });
}
