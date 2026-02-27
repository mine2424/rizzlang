import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/character_model.dart';
import '../../../core/providers/character_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/revenue_cat_service.dart';
import '../../../core/theme/app_theme.dart';

class LanguageSelectScreen extends ConsumerStatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  ConsumerState<LanguageSelectScreen> createState() =>
      _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends ConsumerState<LanguageSelectScreen> {
  String? _selectedCharacterId;
  bool _isSwitching = false;

  @override
  void initState() {
    super.initState();
    // 現在アクティブなキャラクターを初期選択にする
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final active = ref.read(activeCharacterProvider);
      if (active != null) {
        setState(() => _selectedCharacterId = active.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allCharactersAsync = ref.watch(allCharactersProvider);
    final activeCharacter = ref.watch(activeCharacterProvider);
    final isProAsync = ref.watch(proStatusProvider);
    final isPro = isProAsync.valueOrNull ?? false;

    // 初期選択: アクティブキャラクター
    _selectedCharacterId ??= activeCharacter?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('学習言語を選択'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── ヘッダー ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'どの言語を学ぶ？',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'あなたのパートナーを選んでください',
                  style: TextStyle(
                    color: AppTheme.muted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── キャラクターカード一覧 ──
          Expanded(
            child: allCharactersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'キャラクターを読み込めませんでした',
                  style: TextStyle(color: AppTheme.muted),
                ),
              ),
              data: (characters) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                itemCount: characters.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final character = characters[index];
                  final isDefault =
                      character.id == 'c1da0000-0000-0000-0000-000000000001';
                  final isUnlocked = isPro || isDefault;
                  final isSelected = _selectedCharacterId == character.id;

                  return _CharacterCard(
                    character: character,
                    isSelected: isSelected,
                    isUnlocked: isUnlocked,
                    onTap: isUnlocked
                        ? () => setState(
                            () => _selectedCharacterId = character.id)
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // ── 決定ボタン（固定フッター）──
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: Colors.white12),
          ),
        ),
        child: FilledButton(
          onPressed: _selectedCharacterId == null || _isSwitching
              ? null
              : _onDecide,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: AppTheme.primary,
            disabledBackgroundColor: AppTheme.primary.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _isSwitching
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                      CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text(
                  '決定する',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _onDecide() async {
    final characterId = _selectedCharacterId;
    if (characterId == null) return;

    setState(() => _isSwitching = true);
    try {
      await ref
          .read(activeCharacterProvider.notifier)
          .switchCharacter(characterId);
      if (mounted) context.go('/chat');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('切り替えに失敗しました: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSwitching = false);
    }
  }
}

// ════════════════════════════════════════════════
// キャラクターカード
// ════════════════════════════════════════════════
class _CharacterCard extends StatelessWidget {
  const _CharacterCard({
    required this.character,
    required this.isSelected,
    required this.isUnlocked,
    this.onTap,
  });

  final CharacterModel character;
  final bool isSelected;
  final bool isUnlocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? AppTheme.primary
        : Colors.white12;
    final bgColor = isSelected
        ? AppTheme.primary.withOpacity(0.08)
        : AppTheme.surfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // 国旗
            Text(
              character.flagEmoji,
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(width: 14),

            // キャラ情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        character.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppTheme.primary.withOpacity(0.3)),
                        ),
                        child: Text(
                          character.languageDisplayName,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    character.shortDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: isUnlocked ? Colors.white54 : Colors.white24,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ロック or 選択状態
            if (!isUnlocked) ...[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔒', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 2),
                  Text(
                    'Proで解放',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ] else if (isSelected) ...[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
            ] else ...[
              Icon(Icons.chevron_right, color: Colors.white24, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
