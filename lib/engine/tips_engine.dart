import 'dart:convert';

import 'phases.dart';

enum TipCategory { food, comfort, affection, space, plans, words, practical }

extension TipCategoryInfo on TipCategory {
  String get label => switch (this) {
    TipCategory.food => 'Food',
    TipCategory.comfort => 'Comfort',
    TipCategory.affection => 'Affection',
    TipCategory.space => 'Space',
    TipCategory.plans => 'Plans',
    TipCategory.words => 'Words',
    TipCategory.practical => 'Practical',
  };
}

class Tip {
  final String id;
  final Set<Phase> phases; // empty = any phase
  final TipCategory category;
  final String title;
  final String text;

  const Tip({required this.id, required this.phases, required this.category, required this.title, required this.text});

  bool appliesTo(Phase p) {
    if (phases.isEmpty) return true;
    if (phases.contains(p)) return true;
    // Ovulation day also counts as fertile window and vice versa.
    if (p == Phase.ovulation && phases.contains(Phase.fertile)) return true;
    if (p == Phase.fertile && phases.contains(Phase.ovulation)) return true;
    // PMS is a sub-phase of luteal.
    if (p == Phase.pms && phases.contains(Phase.luteal)) return true;
    return false;
  }

  factory Tip.fromJson(Map<String, dynamic> j) => Tip(
    id: j['id'],
    phases: {
      for (final p in (j['phases'] as List))
        if (p != 'any') Phase.values.byName(p),
    },
    category: TipCategory.values.byName(j['category']),
    title: j['title'],
    text: j['text'],
  );
}

class TipsEngine {
  final List<Tip> tips;

  TipsEngine(this.tips);

  factory TipsEngine.fromJsonString(String s) => TipsEngine([for (final t in jsonDecode(s) as List) Tip.fromJson(t)]);

  List<Tip> forPhase(Phase p, {Map<String, int> feedback = const {}}) {
    final list = tips.where((t) => t.appliesTo(p) && (feedback[t.id] ?? 0) >= 0).toList();
    // Phase-specific before generic; liked first.
    list.sort((a, b) {
      final la = feedback[a.id] ?? 0, lb = feedback[b.id] ?? 0;
      if (la != lb) return lb.compareTo(la);
      return (a.phases.isEmpty ? 1 : 0).compareTo(b.phases.isEmpty ? 1 : 0);
    });
    return list;
  }

  /// Deterministic tip of the day for [dayNumber] in [phase].
  /// Disliked tips are excluded, liked tips are 3x as likely,
  /// phase-specific tips 2x as likely as generic ones.
  Tip? dailyTip(int dayNumber, Phase phase, {Map<String, int> feedback = const {}}) {
    final pool = <Tip>[];
    for (final t in tips) {
      if (!t.appliesTo(phase)) continue;
      final f = feedback[t.id] ?? 0;
      if (f < 0) continue;
      var weight = t.phases.isEmpty ? 1 : 2;
      if (f > 0) weight *= 3;
      for (var i = 0; i < weight; i++) {
        pool.add(t);
      }
    }
    if (pool.isEmpty) return null;
    return pool[_hash(dayNumber) % pool.length];
  }

  static int _hash(int x) {
    var h = x * 0x9E3779B1;
    h = (h ^ (h >> 15)) & 0x7fffffff;
    h = (h * 0x85EBCA6B) & 0x7fffffff;
    return (h ^ (h >> 13)) & 0x7fffffff;
  }
}
