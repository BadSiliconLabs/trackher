import 'package:material_ui/material_ui.dart';

import '../engine/phases.dart';
import '../engine/predictor.dart';
import '../engine/tips_engine.dart';
import '../l10n/app_localizations.dart';
import '../model/models.dart';

export '../l10n/app_localizations.dart';

/// Delegates for the app strings plus Material/Cupertino/Widgets localizations
/// (from material_ui, which pairs with this Material library).
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  L.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

extension LX on L {
  String phase(Phase p) => switch (p) {
    Phase.period => phasePeriod,
    Phase.follicular => phaseFollicular,
    Phase.fertile => phaseFertile,
    Phase.ovulation => phaseOvulation,
    Phase.luteal => phaseLuteal,
    Phase.pms => phasePms,
  };

  String blurb(Phase p) => switch (p) {
    Phase.period => blurbPeriod,
    Phase.follicular => blurbFollicular,
    Phase.fertile => blurbFertile,
    Phase.ovulation => blurbOvulation,
    Phase.luteal => blurbLuteal,
    Phase.pms => blurbPms,
  };

  String category(TipCategory c) => switch (c) {
    TipCategory.food => catFood,
    TipCategory.comfort => catComfort,
    TipCategory.affection => catAffection,
    TipCategory.space => catSpace,
    TipCategory.plans => catPlans,
    TipCategory.words => catWords,
    TipCategory.practical => catPractical,
  };

  String mood(String key) => switch (key) {
    'happy' => moodHappy,
    'neutral' => moodNeutral,
    'sad' => moodSad,
    'irritable' => moodIrritable,
    'tired' => moodTired,
    _ => key,
  };

  String symptom(String key) => switch (key) {
    'cramps' => symCramps,
    'headache' => symHeadache,
    'fatigue' => symFatigue,
    'bloating' => symBloating,
    'acne' => symAcne,
    'cravings' => symCravings,
    'back pain' => symBackPain,
    'tender breasts' => symTenderBreasts,
    _ => key,
  };

  String regularity(Regularity r) => switch (r) {
    Regularity.unknown => regUnknown,
    Regularity.veryRegular => regVeryRegular,
    Regularity.regular => regRegular,
    Regularity.somewhatIrregular => regSomewhatIrregular,
    Regularity.irregular => regIrregular,
  };

  String event(CycleEventKind k) => switch (k) {
    CycleEventKind.pms => evPms,
    CycleEventKind.period => evPeriod,
    CycleEventKind.fertile => evFertile,
    CycleEventKind.ovulation => evOvulation,
  };

  /// "today", "tomorrow", "in 3 days".
  String relativeDay(int days) => days <= 0
      ? relToday
      : days == 1
      ? relTomorrow
      : relInDays(days);

  /// Her name, or a localized "her"/"She" when not set.
  String her(Settings s) => s.herName.trim().isEmpty ? herDefault : s.herName.trim();
  String herCap(Settings s) => s.herName.trim().isEmpty ? herDefaultCap : s.herName.trim();
}

extension LContext on BuildContext {
  L get l => L.of(this);
}
