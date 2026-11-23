import 'package:material_ui/material_ui.dart';

import '../../engine/phases.dart';
import 'guide_en.dart';
import 'guide_es.dart';
import 'guide_it.dart';

class GuideContent {
  final String intro;
  final String cycleNote;
  final List<PhaseGuide> phases;
  final List<GeneralGuide> general;
  const GuideContent({required this.intro, required this.cycleNote, required this.phases, required this.general});
}

GuideContent guideFor(String lang) => switch (lang) {
  'it' => guideIt,
  'es' => guideEs,
  _ => guideEn,
};

class PhaseGuide {
  final Phase phase;
  final String when;
  final String body;
  final String feel;
  final List<String> help;
  final List<String> avoid;
  const PhaseGuide({
    required this.phase,
    required this.when,
    required this.body,
    required this.feel,
    required this.help,
    required this.avoid,
  });
}

class GeneralGuide {
  final IconData icon;
  final String title;
  final String body;
  const GeneralGuide(this.icon, this.title, this.body);
}
