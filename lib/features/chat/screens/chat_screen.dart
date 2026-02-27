import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/providers/character_provider.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../paywall/paywall_sheet.dart';
import '../providers/chat_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/reply_panel.dart';
import '../widgets/streak_bar.dart';
import '../widgets/writing_check_panel.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController(keepScrollOffset: true);
  late final AnimationController _relationshipAnimCtrl;
  bool _isCheckMode = false;
  WritingCheckResult? _writingCheckResult;

  @override
  void initState() {
    super.initState();
    _relationshipAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _relationshipAnimCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _showPaywall() async {
    final purchased = await showPaywallSheet(context);
    if (purchased && mounted) {
      ref.read(chatProvider.notifier).onProUpgraded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final activeCharacter = ref.watch(activeCharacterProvider);

    // メッセージ追加時に末尾へスクロール
    ref.listen(chatProvider, (prev, next) {
      if (next.messages.length != prev?.messages.length) {
        _scrollToBottom();
      }
      // 上限到達 → ペイウォール自動表示
      if (next.isLimitExceeded && !(prev?.isLimitExceeded ?? false)) {
        _showPaywall();
      }
      // 仲直り完了 → 関係値+1 アニメーション
      if (next.showRelationshipUp && !(prev?.showRelationshipUp ?? false)) {
        _relationshipAnimCtrl.forward(from: 0);
        Future.delayed(const Duration(milliseconds: 2500), () {
          if (mounted) ref.read(chatProvider.notifier).dismissRelationshipUp();
        });
      }
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primary.withOpacity(0.2),
                  child: const Text('🌸', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeCharacter?.name ?? '지우 (ジウ)',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          '${activeCharacter?.flagEmoji ?? '🇰🇷'} ${activeCharacter?.languageDisplayName ?? '韓国語'} · オンライン',
                          style:
                              TextStyle(fontSize: 11, color: AppTheme.muted),
                        ),
                        if (chatState.scenarioDay != null) ...[
                          Text(
                            '  ·  ${chatState.scenarioDay}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.primary.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // 残り回数バッジ (Pro なら非表示)
              if (chatState.turnsRemaining >= 0)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _TurnsRemainingBadge(
                    remaining: chatState.turnsRemaining,
                    onTap: _showPaywall,
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              // ストリークバー
              const StreakBar(),

              // Tension フェーズバナー
              if (chatState.tensionPhase == 'friction' ||
                  chatState.tensionPhase == 'reconciliation')
                _TensionPhaseBanner(phase: chatState.tensionPhase!),

              // チャットメッセージ一覧
              Expanded(
                child: chatState.isLoading && chatState.messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        // 初回セッション（メッセージ1件以下）は週次サマリカードを先頭に追加
                        itemCount: chatState.messages.length +
                            (chatState.messages.length <= 1 ? 1 : 0),
                        itemBuilder: (context, index) {
                          // 最初のアイテムが週次サマリカード
                          if (chatState.messages.length <= 1 && index == 0) {
                            return const _WeeklySummaryCard();
                          }
                          final msgIndex = chatState.messages.length <= 1
                              ? index - 1
                              : index;
                          final message = chatState.messages[msgIndex];
                          return MessageBubble(message: message)
                              .animate()
                              .fadeIn(duration: 200.ms)
                              .slideY(begin: 0.1, end: 0);
                        },
                      ),
              ),

              // AI返信パネル（生成結果表示）
              if (chatState.lastReply != null)
                ReplyPanel(reply: chatState.lastReply!),

              // 添削結果パネル
              if (_writingCheckResult != null)
                WritingCheckPanel(result: _writingCheckResult!),

              // エラー時リトライバナー
              if (chatState.error != null)
                _RetryBanner(
                  onRetry: () =>
                      ref.read(chatProvider.notifier).retryLastMessage(),
                ),

              // 入力エリア or ペイウォールバナー
              chatState.isLimitExceeded
                  ? _buildPaywallBanner(context)
                  : _buildInputArea(chatState),
            ],
          ),
        ),

        // 仲直り完了オーバーレイ（Positioned.fillはStackの直接の子に置く）
        if (chatState.showRelationshipUp)
          Positioned.fill(
            child: IgnorePointer(
              child: _RelationshipUpContent(
                  controller: _relationshipAnimCtrl),
            ),
          ),
      ],
    );
  }

  // ────────────────────────────────────────────────
  // ペイウォールバナー（上限到達時に入力エリアを差し替え）
  // ────────────────────────────────────────────────
  Widget _buildPaywallBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border:
            Border(top: BorderSide(color: AppTheme.primary.withOpacity(0.3))),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 16, child: Text('🌸')),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Text(
                    '오빠... 오늘 대화 끝났어 ㅠ\nもっと話したいのに...',
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: _showPaywall,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              '지우との会話を続ける — Pro にアップグレード',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15, end: 0);
  }

  // ────────────────────────────────────────────────
  // 通常入力エリア
  // ────────────────────────────────────────────────
  Widget _buildInputArea(ChatState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: const Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // 添削モードトグルボタン
            _ModeToggleButton(
              isCheckMode: _isCheckMode,
              onTap: () => setState(() => _isCheckMode = !_isCheckMode),
            ),
            const SizedBox(width: 8),
            // テキストフィールド
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: _isCheckMode
                        ? AppTheme.primary.withOpacity(0.5)
                        : AppTheme.border,
                    width: _isCheckMode ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                            fontSize: 14, color: AppTheme.text1),
                        decoration: InputDecoration(
                          hintText: _isCheckMode
                              ? '外国語で直接書いてみよう ✍️'
                              : 'オッパに伝えたいことを...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          hintStyle: const TextStyle(
                              color: AppTheme.text3, fontSize: 13.5),
                        ),
                        maxLines: 4,
                        minLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 送信ボタン
            _SendButton(
              isCheckMode: _isCheckMode,
              onTap: _isCheckMode ? _onCheckWriting : _onSendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _onSendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _writingCheckResult = null);
    ref.read(chatProvider.notifier).generateReply(text);
    _controller.clear();
  }

  Future<void> _onCheckWriting() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final character = ref.read(activeCharacterProvider);
    final chatState = ref.read(chatProvider);
    final contextMessage = chatState.messages.isNotEmpty
        ? chatState.messages.last.content
        : null;
    try {
      final result = await ref.read(aiServiceProvider).checkWriting(
        userText: text,
        language: character?.language ?? 'ko',
        contextMessage: contextMessage,
      );
      if (mounted) {
        setState(() => _writingCheckResult = result);
        _controller.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('添削できませんでした。もう一度試してください。'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }
}

// ════════════════════════════════════════════════
// 週次サマリカード（初回セッション時に表示）
// ════════════════════════════════════════════════
class _WeeklySummaryCard extends ConsumerWidget {
  const _WeeklySummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakDataProvider);

    return streakAsync.when(
      loading: () => const SizedBox(height: 8),
      error: (_, __) => const SizedBox.shrink(),
      data: (data) {
        if (data.streak == 0 && data.weeklyVocab == 0) {
          return const SizedBox.shrink();
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary.withOpacity(0.12),
                AppTheme.primary.withOpacity(0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📊', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    '今週の学習まとめ',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatChip(
                    emoji: data.streak >= 30
                        ? '👑'
                        : data.streak >= 7
                            ? '🌟'
                            : '🔥',
                    label: '${data.streak}日連続',
                    highlight: data.streak >= 7,
                  ),
                  const SizedBox(width: 10),
                  if (data.weeklyVocab > 0)
                    _StatChip(
                      emoji: '📖',
                      label: '+${data.weeklyVocab}表現',
                      highlight: false,
                    ),
                  if (data.todayXp > 0) ...[
                    const SizedBox(width: 10),
                    _StatChip(
                      emoji: '⚡',
                      label: '+${data.todayXp} XP',
                      highlight: true,
                    ),
                  ],
                ],
              ),
              if (data.streak >= 3) ...[
                const SizedBox(height: 10),
                Text(
                  _getMotivationMessage(data.streak),
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: -0.1, end: 0, curve: Curves.easeOut);
      },
    );
  }

  String _getMotivationMessage(int streak) {
    if (streak >= 100) return '👑 伝説のレベル！지우も感動してる';
    if (streak >= 30) return '🌟 1ヶ月連続！本物の習慣になったね';
    if (streak >= 7) return '🔥 1週間連続！지우との絆が深まってる';
    return '${streak}日連続！いい調子！';
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.emoji,
    required this.label,
    required this.highlight,
  });

  final String emoji;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlight
            ? AppTheme.primary.withOpacity(0.15)
            : Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight
              ? AppTheme.primary.withOpacity(0.4)
              : Colors.white12,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: highlight ? AppTheme.primary : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// Tension フェーズバナー
// ════════════════════════════════════════════════
class _TensionPhaseBanner extends StatelessWidget {
  const _TensionPhaseBanner({required this.phase});
  final String phase;

  @override
  Widget build(BuildContext context) {
    final isFriction = phase == 'friction';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: (isFriction ? Colors.red : Colors.pink).withOpacity(0.12),
      child: Row(
        children: [
          Text(
            isFriction ? '😤' : '💕',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Text(
            isFriction
                ? '지우がちょっと拗ねています... 優しい言葉をかけよう'
                : '仲直りチャンス！감사하다고 전해봐요 💕',
            style: TextStyle(
              color: isFriction ? Colors.red[300] : Colors.pink[300],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3, end: 0);
  }
}

// ════════════════════════════════════════════════
// エラー時リトライバナー
// ════════════════════════════════════════════════
class _RetryBanner extends StatelessWidget {
  const _RetryBanner({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.red.withOpacity(0.08),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '生成に失敗しました',
              style: TextStyle(color: Colors.red[300], fontSize: 12),
            ),
          ),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Text(
                '再試行',
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}

// ════════════════════════════════════════════════
// 仲直り完了オーバーレイ（関係値+1 アニメーション）
// ════════════════════════════════════════════════
class _RelationshipUpContent extends StatelessWidget {
  const _RelationshipUpContent({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            final opacity = controller.value < 0.1
                ? controller.value / 0.1
                : controller.value > 0.7
                    ? (1 - controller.value) / 0.3
                    : 1.0;
            return Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '💕',
                      style: TextStyle(
                        fontSize: 64 + controller.value * 16,
                      ),
                    ).animate(controller: controller)
                        .scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1.1, 1.1),
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        '仲直り！ 関係値 +1 💖',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ).animate(controller: controller, delay: 300.ms)
                        .fadeIn()
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),
            );
          },
        );
  }
}

// ════════════════════════════════════════════════
// 残り回数バッジ (AppBar 右端)
// ════════════════════════════════════════════════
class _TurnsRemainingBadge extends StatelessWidget {
  const _TurnsRemainingBadge(
      {required this.remaining, required this.onTap});
  final int remaining;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isEmpty = remaining <= 0;
    return GestureDetector(
      onTap: isEmpty ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isEmpty
              ? AppTheme.primary.withOpacity(0.15)
              : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEmpty
                ? AppTheme.primary.withOpacity(0.5)
                : Colors.white12,
          ),
        ),
        child: Text(
          isEmpty ? '⚡ アップグレード' : '残り ${remaining}回',
          style: TextStyle(
            fontSize: 11,
            color: isEmpty ? AppTheme.primary : Colors.white54,
            fontWeight: isEmpty ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════
// 添削モードトグルボタン
// ════════════════════════════════════════════════
class _ModeToggleButton extends StatelessWidget {
  final bool isCheckMode;
  final VoidCallback onTap;

  const _ModeToggleButton({required this.isCheckMode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCheckMode
              ? AppTheme.primary.withOpacity(0.15)
              : AppTheme.surface2,
          border: Border.all(
            color: isCheckMode
                ? AppTheme.primary.withOpacity(0.5)
                : AppTheme.border,
          ),
        ),
        child: Center(
          child: Text(
            isCheckMode ? '📝' : '✍️',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════
// 送信ボタン
// ════════════════════════════════════════════════
class _SendButton extends StatelessWidget {
  final bool isCheckMode;
  final VoidCallback onTap;

  const _SendButton({required this.isCheckMode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isCheckMode
              ? const LinearGradient(
                  colors: [Color(0xFFFF8C42), Color(0xFFFF4E8B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppTheme.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isCheckMode ? '📝' : '➤',
            style: TextStyle(
              color: Colors.white,
              fontSize: isCheckMode ? 16 : 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
