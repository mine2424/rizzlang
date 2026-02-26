import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/providers/auth_provider.dart';

// ────────────────────────────────────────────────
// Streak データ
// ────────────────────────────────────────────────
class StreakData {
  final int streak;
  final int todayXp;        // 今日のターン数 × 10 (仮XP)
  final int weeklyVocab;    // 今週の語彙獲得数
  final int? newMilestone;  // 今日初めて達成したマイルストーン (7/30/100)

  const StreakData({
    this.streak = 0,
    this.todayXp = 0,
    this.weeklyVocab = 0,
    this.newMilestone,
  });

  /// XPバーの進捗 (0.0-1.0)
  double get xpProgress {
    const maxXp = 30; // 30XP (3ターン × 10) で満タン
    return (todayXp / maxXp).clamp(0.0, 1.0);
  }

  /// マイルストーン閾値チェック
  static int? checkMilestone(int streak) {
    if (streak == 7) return 7;
    if (streak == 30) return 30;
    if (streak == 100) return 100;
    return null;
  }
}

// ────────────────────────────────────────────────
// Provider
// ────────────────────────────────────────────────
final streakDataProvider = FutureProvider<StreakData>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return const StreakData();

  final today = DateTime.now().toIso8601String().split('T')[0];

  // users テーブルから streak 取得
  final userData = await supabase
      .from('users')
      .select('streak')
      .eq('id', uid)
      .single();

  final streak = (userData['streak'] as int?) ?? 0;

  // 今日のターン数（usage_logs）
  final usageData = await supabase
      .from('usage_logs')
      .select('turns_used')
      .eq('user_id', uid)
      .eq('date', today)
      .maybeSingle();

  final turnsToday = (usageData?['turns_used'] as int?) ?? 0;

  // 今週の語彙獲得数
  final weekStart = DateTime.now()
      .subtract(Duration(days: DateTime.now().weekday - 1))
      .toIso8601String()
      .split('T')[0];

  final vocabData = await supabase
      .from('vocabulary')
      .select('id')
      .eq('user_id', uid)
      .gte('learned_at', weekStart);

  final weeklyVocab = (vocabData as List).length;

  return StreakData(
    streak: streak,
    todayXp: turnsToday * 10,
    weeklyVocab: weeklyVocab,
    newMilestone: StreakData.checkMilestone(streak),
  );
});
