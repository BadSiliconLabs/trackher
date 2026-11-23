import 'package:material_ui/material_ui.dart';

import '../engine/phases.dart';
import '../engine/tips_engine.dart';

/// Muted slate-teal: discreet, nothing that screams "period tracker".
const kSeed = Color(0xFF4E6E7E);
const kAppName = 'Tempo';

ThemeData buildTheme(Brightness b) {
  final scheme = ColorScheme.fromSeed(
    seedColor: kSeed,
    brightness: b,
    dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
  );
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

extension PhaseStyle on Phase {
  Color get color => switch (this) {
    Phase.period => const Color(0xFF8A6F8E), // muted mauve
    Phase.follicular => const Color(0xFF5E9183), // sage
    Phase.fertile => const Color(0xFF6E8CB0), // dusty blue
    Phase.ovulation => const Color(0xFF52709A), // deeper blue
    Phase.luteal => const Color(0xFFB0965F), // sand
    Phase.pms => const Color(0xFFA97D66), // clay
  };

  IconData get icon => switch (this) {
    Phase.period => Icons.water_drop_outlined,
    Phase.follicular => Icons.eco_outlined,
    Phase.fertile => Icons.auto_awesome_outlined,
    Phase.ovulation => Icons.wb_sunny_outlined,
    Phase.luteal => Icons.nightlight_outlined,
    Phase.pms => Icons.cloud_outlined,
  };
}

extension TipCategoryStyle on TipCategory {
  IconData get icon => switch (this) {
    TipCategory.food => Icons.restaurant_outlined,
    TipCategory.comfort => Icons.weekend_outlined,
    TipCategory.affection => Icons.favorite_border,
    TipCategory.space => Icons.spa_outlined,
    TipCategory.plans => Icons.event_outlined,
    TipCategory.words => Icons.chat_bubble_outline,
    TipCategory.practical => Icons.build_outlined,
  };
}

extension CycleEventStyle on CycleEventKind {
  /// The phase whose colour and icon represent this event.
  Phase get phase => switch (this) {
    CycleEventKind.pms => Phase.pms,
    CycleEventKind.period => Phase.period,
    CycleEventKind.fertile => Phase.fertile,
    CycleEventKind.ovulation => Phase.ovulation,
  };
}

/// Mood keys stored in day logs → icons.
const kMoodIcons = <String, IconData>{
  'happy': Icons.sentiment_satisfied_alt_outlined,
  'neutral': Icons.sentiment_neutral_outlined,
  'sad': Icons.sentiment_dissatisfied_outlined,
  'irritable': Icons.sentiment_very_dissatisfied_outlined,
  'tired': Icons.bedtime_outlined,
};

const kPad = EdgeInsets.symmetric(horizontal: 16);
