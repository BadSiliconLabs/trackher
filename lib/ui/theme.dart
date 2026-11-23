import 'package:material_ui/material_ui.dart';

import '../engine/phases.dart';

const kSeed = Color(0xFFB4436C);

ThemeData buildTheme(Brightness b) {
  final scheme = ColorScheme.fromSeed(seedColor: kSeed, brightness: b);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  );
}

extension PhaseColors on Phase {
  Color get color => switch (this) {
    Phase.period => const Color(0xFFE0446A),
    Phase.follicular => const Color(0xFF2FA58C),
    Phase.fertile => const Color(0xFF8E7CF0),
    Phase.ovulation => const Color(0xFF6A4FE0),
    Phase.luteal => const Color(0xFFE0A030),
    Phase.pms => const Color(0xFFEF7B3A),
  };

  String get emoji => switch (this) {
    Phase.period => '🩸',
    Phase.follicular => '🌱',
    Phase.fertile => '✨',
    Phase.ovulation => '🌕',
    Phase.luteal => '🍂',
    Phase.pms => '🌧️',
  };
}

const kPad = EdgeInsets.symmetric(horizontal: 16);
