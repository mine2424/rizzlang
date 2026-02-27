import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/vocabulary_model.dart';
import '../../../core/providers/auth_provider.dart';

// ────────────────────────────────────────────────
// フィルターEnum
// ────────────────────────────────────────────────
enum VocabFilter { all, today, dueReview }

// ────────────────────────────────────────────────
// 語彙一覧 Provider
// ────────────────────────────────────────────────
final vocabFilterProvider = StateProvider<VocabFilter>((ref) => VocabFilter.all);

final vocabularyProvider = FutureProvider<List<VocabularyModel>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final filter = ref.watch(vocabFilterProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return [];

  var query = supabase
      .from('vocabulary')
      .select()
      .eq('user_id', uid)
      .eq('language', 'ko')
      .order('learned_at', ascending: false);

  final data = await query;

  final all = (data as List)
      .map((e) => VocabularyModel.fromJson(e as Map<String, dynamic>))
      .toList();

  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  return switch (filter) {
    VocabFilter.all => all,
    VocabFilter.today =>
      all.where((v) => v.learnedAt.isAfter(todayStart)).toList(),
    VocabFilter.dueReview =>
      all.where((v) => v.nextReview.isBefore(now)).toList(),
  };
});

/// 今日の習得数
final todayVocabCountProvider = FutureProvider<int>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return 0;

  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day).toIso8601String();

  final data = await supabase
      .from('vocabulary')
      .select('id')
      .eq('user_id', uid)
      .gte('learned_at', todayStart);

  return (data as List).length;
});

/// 復習期限が来ている語彙数
final dueReviewCountProvider = FutureProvider<int>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return 0;

  final data = await supabase
      .from('vocabulary')
      .select('id')
      .eq('user_id', uid)
      .lte('next_review', DateTime.now().toIso8601String());

  return (data as List).length;
});

// ────────────────────────────────────────────────
// SRS復習 State（フリップカード用）
// ────────────────────────────────────────────────
class ReviewState {
  final List<VocabularyModel> queue;
  final int currentIndex;
  final bool isFlipped;
  final bool isCompleted;

  const ReviewState({
    required this.queue,
    this.currentIndex = 0,
    this.isFlipped = false,
    this.isCompleted = false,
  });

  VocabularyModel? get current =>
      queue.isEmpty || currentIndex >= queue.length ? null : queue[currentIndex];

  int get remaining => queue.length - currentIndex;

  ReviewState copyWith({
    List<VocabularyModel>? queue,
    int? currentIndex,
    bool? isFlipped,
    bool? isCompleted,
  }) =>
      ReviewState(
        queue: queue ?? this.queue,
        currentIndex: currentIndex ?? this.currentIndex,
        isFlipped: isFlipped ?? this.isFlipped,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class ReviewNotifier extends StateNotifier<ReviewState> {
  final SupabaseClient _supabase;

  ReviewNotifier(this._supabase, List<VocabularyModel> queue)
      : super(ReviewState(queue: queue));

  void flip() => state = state.copyWith(isFlipped: !state.isFlipped);

  /// SM-2 アルゴリズムで次回復習日を計算して DB 更新
  Future<void> answer(int quality) async {
    // quality: 0-5 (0=全く覚えてない, 5=完璧)
    final vocab = state.current;
    if (vocab == null) return;

    // SM-2: easeFactor 更新
    final newEF = (vocab.easeFactor +
            (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)))
        .clamp(1.3, 2.5);

    // nextReview 計算
    final DateTime nextReview;
    if (quality < 3) {
      // 不正解 → 翌日にリセット
      nextReview = DateTime.now().add(const Duration(days: 1));
    } else if (vocab.reviewCount == 0) {
      nextReview = DateTime.now().add(const Duration(days: 1));
    } else if (vocab.reviewCount == 1) {
      nextReview = DateTime.now().add(const Duration(days: 3));
    } else {
      final intervalDays =
          ((vocab.reviewCount == 2 ? 7 : 7 * vocab.easeFactor) * newEF / 2.5)
              .round();
      nextReview = DateTime.now().add(Duration(days: intervalDays));
    }

    // DB 更新
    await _supabase.from('vocabulary').update({
      'review_count': vocab.reviewCount + 1,
      'ease_factor': newEF,
      'next_review': nextReview.toIso8601String(),
    }).eq('id', vocab.id);

    // 次のカードへ
    final nextIndex = state.currentIndex + 1;
    state = state.copyWith(
      currentIndex: nextIndex,
      isFlipped: false,
      isCompleted: nextIndex >= state.queue.length,
    );
  }
}

final reviewNotifierProvider =
    StateNotifierProvider.family<ReviewNotifier, ReviewState, List<VocabularyModel>>(
  (ref, queue) => ReviewNotifier(ref.watch(supabaseClientProvider), queue),
);

// ────────────────────────────────────────────────
// 今日の復習 Provider（弱点フォーカス復習）
// ────────────────────────────────────────────────
final todayReviewProvider = FutureProvider<List<VocabularyModel>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return [];

  final data = await supabase
      .from('user_vocabulary')
      .select()
      .eq('user_id', uid)
      .lte('next_review_at', DateTime.now().toIso8601String())
      .order('easiness_factor', ascending: true);

  return (data as List)
      .map((e) => VocabularyModel.fromJson(e as Map<String, dynamic>))
      .toList();
});

// ────────────────────────────────────────────────
// VocabularyNotifier（reviewWord 用）
// ────────────────────────────────────────────────
class VocabularyNotifier {
  final SupabaseClient _supabase;

  VocabularyNotifier(this._supabase);

  /// SM-2 アルゴリズムで復習語彙の next_review_at を更新
  /// grade: 0-5 (3 = 「わかった！」)
  Future<void> reviewWord(String word, {required int grade}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final existing = await _supabase
        .from('user_vocabulary')
        .select('ease_factor, repetitions, interval_days')
        .eq('user_id', userId)
        .eq('word', word)
        .maybeSingle();

    if (existing == null) return;

    final ef = ((existing['ease_factor'] ?? existing['easiness_factor']) as num).toDouble();
    final reps = (existing['repetitions'] as int?) ?? 0;
    final newEf = (ef + 0.1 - (5 - grade) * (0.08 + (5 - grade) * 0.02)).clamp(1.3, 2.5);
    final newReps = reps + 1;
    final intervalDays = ((existing['interval_days'] ?? 1) as num).toDouble();
    final newInterval = newReps == 1
        ? 1
        : newReps == 2
            ? 6
            : (intervalDays * newEf).round();
    final nextReview =
        DateTime.now().add(Duration(days: newInterval)).toIso8601String();

    await _supabase
        .from('user_vocabulary')
        .update({
          'ease_factor': newEf,
          'repetitions': newReps,
          'interval_days': newInterval,
          'next_review_at': nextReview,
          'last_reviewed_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId)
        .eq('word', word);
  }
}

final vocabularyNotifierProvider = Provider<VocabularyNotifier>((ref) {
  return VocabularyNotifier(ref.watch(supabaseClientProvider));
});
