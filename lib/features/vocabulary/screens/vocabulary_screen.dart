import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/vocabulary_model.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/vocabulary_provider.dart';

// ════════════════════════════════════════════════
// VocabularyScreen — タブ付き語彙帳
// ════════════════════════════════════════════════
class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayCount = ref.watch(todayVocabCountProvider).valueOrNull ?? 0;
    final dueCount = ref.watch(dueReviewCountProvider).valueOrNull ?? 0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ヘッダー ──
            _buildHeader(todayCount, dueCount),

            // ── タブバー ──
            TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primary,
              labelColor: AppTheme.primary,
              unselectedLabelColor: Colors.white38,
              tabs: const [
                Tab(text: '全て'),
                Tab(text: '今日の復習'),
                Tab(text: '習得済み'),
              ],
            ),

            // ── タブビュー ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ── 全て ──
                  _AllVocabTab(),
                  // ── 今日の復習 ──
                  _TodayReviewTab(),
                  // ── 習得済み ──
                  _MasteredTab(),
                ],
              ),
            ),
          ],
        ),
      ),

      // ── 復習開始 FAB（全てタブのみ） ──
      floatingActionButton: dueCount > 0
          ? FloatingActionButton.extended(
              onPressed: () => _startReview(),
              backgroundColor: AppTheme.primary,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text('復習する ($dueCount件)'),
            ).animate().scale(duration: 300.ms, curve: Curves.elasticOut)
          : null,
    );
  }

  // ────────────────────────────────────────────────
  // ヘッダー
  // ────────────────────────────────────────────────
  Widget _buildHeader(int todayCount, int dueCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📚', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Text(
                '語彙帳',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _StatBadge(
                icon: '✨',
                label: '今日 +$todayCount表現',
                color: AppTheme.primary,
              ),
              const SizedBox(width: 10),
              if (dueCount > 0)
                _StatBadge(
                  icon: '🔔',
                  label: '復習 $dueCount件',
                  color: Colors.orange,
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // 復習セッション開始
  // ────────────────────────────────────────────────
  Future<void> _startReview() async {
    final dueVocabs = await ref.read(
      vocabularyProvider.selectAsync(
        (all) => all.where((v) => v.nextReview.isBefore(DateTime.now())).toList(),
      ),
    );

    if (!mounted || dueVocabs.isEmpty) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReviewSession(vocabs: dueVocabs),
    );

    ref.invalidate(vocabularyProvider);
    ref.invalidate(dueReviewCountProvider);
    ref.invalidate(todayReviewProvider);
  }
}

// ════════════════════════════════════════════════
// タブ: 全て
// ════════════════════════════════════════════════
class _AllVocabTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabAsync = ref.watch(vocabularyProvider);
    return vocabAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('読み込み失敗 :(', style: const TextStyle(color: Colors.white54)),
      ),
      data: (vocabs) => vocabs.isEmpty
          ? _buildEmptyState(
              '📖',
              'まだ語彙がありません',
              'チャットで韓国語を話すと\n自動で語彙帳に追加されます',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: vocabs.length,
              itemBuilder: (ctx, i) => _VocabCard(vocab: vocabs[i])
                  .animate(delay: (i * 40).ms)
                  .fadeIn(duration: 250.ms)
                  .slideX(begin: 0.05, end: 0),
            ),
    );
  }
}

// ════════════════════════════════════════════════
// タブ: 今日の復習
// ════════════════════════════════════════════════
class _TodayReviewTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewAsync = ref.watch(todayReviewProvider);
    return reviewAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('読み込み失敗 :(', style: const TextStyle(color: Colors.white54)),
      ),
      data: (vocabs) => vocabs.isEmpty
          ? _buildEmptyState(
              '🎉',
              '今日の復習はありません',
              'すべて覚えています！',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: vocabs.length,
              itemBuilder: (ctx, i) => _VocabCard(vocab: vocabs[i])
                  .animate(delay: (i * 40).ms)
                  .fadeIn(duration: 250.ms)
                  .slideX(begin: 0.05, end: 0),
            ),
    );
  }
}

// ════════════════════════════════════════════════
// タブ: 習得済み（reviewCount >= 5 を「習得済み」とする）
// ════════════════════════════════════════════════
class _MasteredTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabAsync = ref.watch(vocabularyProvider);
    return vocabAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('読み込み失敗 :(', style: const TextStyle(color: Colors.white54)),
      ),
      data: (vocabs) {
        final mastered = vocabs.where((v) => v.reviewCount >= 5).toList();
        return mastered.isEmpty
            ? _buildEmptyState(
                '🌱',
                'まだ習得済みの語彙がありません',
                '復習を重ねて語彙をマスターしよう！',
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                itemCount: mastered.length,
                itemBuilder: (ctx, i) => _VocabCard(vocab: mastered[i])
                    .animate(delay: (i * 40).ms)
                    .fadeIn(duration: 250.ms)
                    .slideX(begin: 0.05, end: 0),
              );
      },
    );
  }
}

Widget _buildEmptyState(String emoji, String title, String sub) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 56)).animate().scale(
              duration: 400.ms,
              curve: Curves.elasticOut,
            ),
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(sub,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, height: 1.6)),
      ],
    ),
  );
}

// ════════════════════════════════════════════════
// SRS 復習セッション（BottomSheet）
// ════════════════════════════════════════════════
class _ReviewSession extends ConsumerWidget {
  const _ReviewSession({required this.vocabs});
  final List<VocabularyModel> vocabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewNotifierProvider(vocabs));
    final notifier = ref.read(reviewNotifierProvider(vocabs).notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ドラッグハンドル
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ヘッダー
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Text('🔮 復習セッション',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                  state.isCompleted
                      ? '完了！'
                      : '${state.currentIndex + 1} / ${state.queue.length}',
                  style: TextStyle(color: Colors.white38),
                ),
              ],
            ),
          ),

          // プログレスバー
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.queue.isEmpty
                    ? 0
                    : state.currentIndex / state.queue.length,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                minHeight: 6,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // コンテンツ
          Expanded(
            child: state.isCompleted
                ? _buildCompleted(context)
                : _buildCard(context, state, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    ReviewState state,
    ReviewNotifier notifier,
  ) {
    final vocab = state.current!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // フリップカード
          Expanded(
            child: GestureDetector(
              onTap: notifier.flip,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: child,
                ),
                child: state.isFlipped
                    ? _FlipCard(
                        key: const ValueKey('back'),
                        front: false,
                        word: vocab.word,
                        content: vocab.meaning,
                        example: vocab.example,
                      )
                    : _FlipCard(
                        key: const ValueKey('front'),
                        front: true,
                        word: vocab.word,
                        content: '타탁! タップして意味を確認',
                      ),
              ),
            ),
          ),

          // 評価ボタン（裏面表示時のみ）
          if (state.isFlipped) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _GradeButton(
                    label: '😅\nもう一度',
                    color: Colors.red.shade400,
                    onTap: () => notifier.answer(1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _GradeButton(
                    label: '🤔\nなんとか',
                    color: Colors.orange.shade400,
                    onTap: () => notifier.answer(3),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _GradeButton(
                    label: '✅\nわかった！',
                    color: Colors.green.shade400,
                    onTap: () => notifier.answer(5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ] else ...[
            const SizedBox(height: 16),
            Text(
              'タップしてめくる',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }

  Widget _buildCompleted(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('🎉', style: const TextStyle(fontSize: 72))
            .animate()
            .scale(duration: 500.ms, curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('復習完了！',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            .animate(delay: 200.ms)
            .fadeIn(),
        const SizedBox(height: 8),
        Text('全ての語彙を復習しました 🌸',
            style: TextStyle(color: Colors.white54))
            .animate(delay: 400.ms)
            .fadeIn(),
        const SizedBox(height: 40),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            minimumSize: const Size(200, 52),
          ),
          child: const Text('閉じる', style: TextStyle(fontSize: 16)),
        ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0),
      ],
    );
  }
}

// ════════════════════════════════════════════════
// サブウィジェット
// ════════════════════════════════════════════════

class _VocabCard extends StatelessWidget {
  const _VocabCard({required this.vocab});
  final VocabularyModel vocab;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isDue = vocab.nextReview.isBefore(now);
    final isToday = vocab.learnedAt
        .isAfter(DateTime(now.year, now.month, now.day));

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDue
              ? Colors.orange.withOpacity(0.4)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          // 語彙・意味
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vocab.word,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  vocab.meaning,
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                if (vocab.example != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    vocab.example!,
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 右側バッジ
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isToday)
                _SmallBadge('新規', AppTheme.primary),
              if (isDue) ...[
                const SizedBox(height: 4),
                _SmallBadge('復習', Colors.orange),
              ],
              const SizedBox(height: 6),
              Text(
                '${vocab.reviewCount}回',
                style: TextStyle(color: Colors.white24, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlipCard extends StatelessWidget {
  const _FlipCard({
    super.key,
    required this.front,
    required this.word,
    required this.content,
    this.example,
  });
  final bool front;
  final String word;
  final String content;
  final String? example;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: front ? AppTheme.surface : AppTheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: front
              ? Colors.white12
              : AppTheme.primary.withOpacity(0.5),
          width: front ? 1 : 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            word,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: front ? Colors.white : AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: front ? 14 : 24,
              color: front ? Colors.white38 : Colors.white87,
              fontWeight: front ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          if (!front && example != null) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                example!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 13, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GradeButton extends StatelessWidget {
  const _GradeButton({
    required this.label,
    required this.color,
    required this.onTap,
  });
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.icon, required this.label, required this.color});
  final String icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$icon $label',
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount = 0,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.15) : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.white12,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? AppTheme.primary : Colors.white54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
