import 'package:flutter_test/flutter_test.dart';
import 'package:rizzlang/features/chat/providers/streak_provider.dart';

void main() {
  group('StreakData.checkMilestone — マイルストーン判定テスト', () {
    test('streak=7 → milestone=7（1週間達成）', () {
      expect(StreakData.checkMilestone(7), equals(7));
    });

    test('streak=30 → milestone=30（1ヶ月達成）', () {
      expect(StreakData.checkMilestone(30), equals(30));
    });

    test('streak=100 → milestone=100（100日達成）', () {
      expect(StreakData.checkMilestone(100), equals(100));
    });

    test('streak=5 → milestone=null（マイルストーンなし）', () {
      expect(StreakData.checkMilestone(5), isNull);
    });

    test('streak=31 → milestone=null（達成日以外はnull）', () {
      expect(StreakData.checkMilestone(31), isNull);
    });

    test('streak=0 → milestone=null', () {
      expect(StreakData.checkMilestone(0), isNull);
    });

    test('streak=1 → milestone=null', () {
      expect(StreakData.checkMilestone(1), isNull);
    });

    test('streak=99 → milestone=null（100日直前はnull）', () {
      expect(StreakData.checkMilestone(99), isNull);
    });
  });

  group('StreakData — データモデルテスト', () {
    test('デフォルト値が正しく設定される', () {
      const data = StreakData();
      expect(data.streak, equals(0));
      expect(data.todayXp, equals(0));
      expect(data.weeklyVocab, equals(0));
      expect(data.newMilestone, isNull);
    });

    test('xpProgress は 0.0〜1.0 の範囲にクランプされる', () {
      const full = StreakData(todayXp: 30);
      expect(full.xpProgress, equals(1.0));

      const over = StreakData(todayXp: 60);
      expect(over.xpProgress, equals(1.0));

      const half = StreakData(todayXp: 15);
      expect(half.xpProgress, closeTo(0.5, 0.001));
    });
  });
}
