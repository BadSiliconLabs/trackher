import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackher/data/store.dart';
import 'package:trackher/engine/day.dart';
import 'package:trackher/engine/phases.dart';
import 'package:trackher/engine/tips_engine.dart';
import 'package:trackher/model/models.dart';
import 'package:trackher/state/app_state.dart';

TipsEngine loadTips() => TipsEngine.fromJsonString(File('assets/tips.json').readAsStringSync());

void main() {
  test('tips asset parses and covers every phase', () {
    final t = loadTips();
    expect(t.tips.length, greaterThanOrEqualTo(55));
    expect(t.tips.map((e) => e.id).toSet().length, t.tips.length, reason: 'ids unique');
    for (final p in Phase.values) {
      expect(t.forPhase(p).where((x) => x.phases.isNotEmpty), isNotEmpty, reason: p.name);
    }
  });

  test('daily tip is deterministic and respects dislikes', () {
    final t = loadTips();
    final a = t.dailyTip(20000, Phase.pms)!;
    expect(t.dailyTip(20000, Phase.pms)!.id, a.id);
    final b = t.dailyTip(20000, Phase.pms, feedback: {a.id: -1})!;
    expect(b.id, isNot(a.id));
  });

  test('store round-trips all data', () async {
    final dir = await Directory.systemTemp.createTemp('trackher');
    final store = Store(dir: () async => dir);
    final d = AppData(
      periods: [PeriodEntry(DateTime(2026, 10, 3), end: DateTime(2026, 10, 7))],
      notes: [
        HerNote(id: '1', text: 'loves ramen', phases: {Phase.pms}),
      ],
      logs: {
        dayNumber(DateTime(2026, 10, 4)): DayLog(date: DateTime(2026, 10, 4), mood: '😴', symptoms: {'cramps'}),
      },
      tipFeedback: {'pms-hugs': 1},
      settings: Settings(herName: 'Anna', notifyFertile: true, onboarded: true),
    );
    await store.save(d);
    final r = await store.load();
    expect(r.periods.single.length, 5);
    expect(r.notes.single.phases, {Phase.pms});
    expect(r.logs.values.single.symptoms, {'cramps'});
    expect(r.tipFeedback['pms-hugs'], 1);
    expect(r.settings.herName, 'Anna');
    expect(r.settings.notifyFertile, isTrue);
    expect(() => Store.decode('{"foo":1}'), throwsFormatException);
    await dir.delete(recursive: true);
  });

  test('app state learns period length and updates forecast', () async {
    final dir = await Directory.systemTemp.createTemp('trackher');
    final s = AppState(
      store: Store(dir: () async => dir),
      tips: loadTips(),
      clock: () => DateTime(2026, 11, 23),
    );
    await s.load();
    expect(s.forecast, isNull);
    await s.completeOnboarding('Anna', [DateTime(2026, 9, 24), DateTime(2026, 10, 23)]);
    expect(s.forecast, isNotNull);
    expect(s.periodLength, 5);
    await s.setPeriodEnd(s.data.periods.first, DateTime(2026, 9, 27));
    expect(s.periodLength, 4);
    final before = s.forecast!.next.mode;
    await s.addPeriodStart(DateTime(2026, 11, 20));
    expect(s.forecast!.next.mode, isNot(before));
    expect(s.tipForDay(s.todayDay), isNotNull);
    await dir.delete(recursive: true);
  });
}
