import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../core/providers/character_provider.dart';
import '../../core/services/revenue_cat_service.dart';
import '../../core/theme/app_theme.dart';

// ────────────────────────────────────────────────
// 購入状態プロバイダー
// ────────────────────────────────────────────────
enum _PurchaseStatus { idle, loading, success, error }

final _purchaseStatusProvider =
    StateProvider<_PurchaseStatus>((_) => _PurchaseStatus.idle);

final _errorMessageProvider = StateProvider<String?>((_) => null);

// ────────────────────────────────────────────────
// ペイウォール BottomSheet を表示するヘルパー
// ────────────────────────────────────────────────
Future<bool> showPaywallSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const PaywallSheet(),
  );
  return result ?? false;
}

// ────────────────────────────────────────────────
// PaywallSheet 本体
// ────────────────────────────────────────────────
class PaywallSheet extends ConsumerStatefulWidget {
  const PaywallSheet({super.key});

  @override
  ConsumerState<PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends ConsumerState<PaywallSheet> {
  Package? _package;
  String _priceText = '¥1,480 / 月';

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final service = ref.read(revenueCatServiceProvider);
    final offerings = await service.getOfferings();
    final pkg = offerings?.current?.monthly ??
        offerings?.current?.availablePackages.firstOrNull;
    if (mounted && pkg != null) {
      setState(() {
        _package = pkg;
        _priceText = pkg.storeProduct.priceString;
      });
    }
  }

  Future<void> _onPurchase() async {
    ref.read(_purchaseStatusProvider.notifier).state = _PurchaseStatus.loading;
    ref.read(_errorMessageProvider.notifier).state = null;

    final service = ref.read(revenueCatServiceProvider);
    final result = await service.purchaseMonthly();

    if (!mounted) return;

    if (result.isSuccess) {
      ref.read(_purchaseStatusProvider.notifier).state = _PurchaseStatus.success;
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) Navigator.of(context).pop(true);
    } else if (result.isCancelled) {
      ref.read(_purchaseStatusProvider.notifier).state = _PurchaseStatus.idle;
    } else {
      ref.read(_purchaseStatusProvider.notifier).state = _PurchaseStatus.error;
      ref.read(_errorMessageProvider.notifier).state = result.errorMessage;
    }
  }

  Future<void> _onRestore() async {
    ref.read(_purchaseStatusProvider.notifier).state = _PurchaseStatus.loading;

    final service = ref.read(revenueCatServiceProvider);
    final result = await service.restorePurchases();

    if (!mounted) return;

    if (result.isSuccess) {
      ref.read(_purchaseStatusProvider.notifier).state = _PurchaseStatus.success;
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) Navigator.of(context).pop(true);
    } else {
      ref.read(_purchaseStatusProvider.notifier).state = _PurchaseStatus.error;
      ref.read(_errorMessageProvider.notifier).state = result.errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(_purchaseStatusProvider);
    final errorMsg = ref.watch(_errorMessageProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      padding: EdgeInsets.fromLTRB(
        24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ドラッグハンドル
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // ── 成功状態 ──
          if (status == _PurchaseStatus.success) ...[
            _buildSuccess(context),
          ] else ...[
            // ── キャラクターメッセージ ──
            _buildCharacterMessage(context),
            const SizedBox(height: 28),

            // ── 特典リスト ──
            _buildBenefits(context),
            const SizedBox(height: 28),

            // ── 価格 ──
            _buildPriceCard(context),
            const SizedBox(height: 20),

            // ── エラーメッセージ ──
            if (errorMsg != null) ...[
              Text(
                errorMsg,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
              const SizedBox(height: 12),
            ],

            // ── 購入ボタン ──
            _buildPurchaseButton(context, status),
            const SizedBox(height: 12),

            // ── 復元リンク ──
            TextButton(
              onPressed: status == _PurchaseStatus.loading ? null : _onRestore,
              child: Text(
                '以前の購入を復元する',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ),

            const SizedBox(height: 4),
            Text(
              'サブスクリプションはいつでもキャンセル可能です',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white24, fontSize: 11),
            ),
          ],
        ],
      ),
    ).animate().slideY(begin: 0.3, end: 0, duration: 350.ms, curve: Curves.easeOut);
  }

  Widget _buildCharacterMessage(BuildContext context) {
    final character = ref.watch(activeCharacterProvider);
    final lang = character?.language ?? 'ko';

    // 言語別リミット到達メッセージ
    final Map<String, (String, String)> _limitMessages = {
      'ko': ('오빠... 오늘 대화 끝났어 ㅠ', '（今日の会話が終わっちゃった ㅠ）'),
      'en': ("babe... we ran out of messages today ㅠ", "(I wanna keep talking with you...)"),
      'tr': ('canım... bugün konuşmamız bitti ㅠ', '（今日の会話が終わっちゃった ㅠ）'),
      'vi': ('anh ơi... hôm nay mình hết lượt rồi ㅠ', '（今日の会話が終わっちゃった ㅠ）'),
      'ar': ('habibi... we ran out of messages today ㅠ', '（今日の会話が終わっちゃった ㅠ）'),
    };
    final charName = character?.shortName ?? '지우';
    final (mainMsg, subMsg) = _limitMessages[lang] ?? _limitMessages['ko']!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          child: Text(
            character?.flagEmoji ?? '🌸',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainMsg,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subMsg,
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  '$charNameがもっと話したそうにしています... 🥺',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0);
  }

  Widget _buildBenefits(BuildContext context) {
    final character = ref.watch(activeCharacterProvider);
    final charName = character?.shortName ?? '지우';
    final benefits = [
      ('💬', '会話が無制限', '毎日何度でも$charNameと話せる'),
      ('🌍', '全言語パートナーが解放', '5人のキャラクターと学べる（EN/TR/VI/AR）'),
      ('📚', '語彙帳 全機能', 'SRS（間隔反復）で効率的に復習'),
      ('🎭', '全シナリオ解放', 'Season 1〜 完全アクセス'),
      ('⚡', '広告なし', 'ストレスフリーな学習体験'),
    ];

    return Column(
      children: benefits
          .asMap()
          .entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(entry.value.$1, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.value.$2,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          entry.value.$3,
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate(delay: (entry.key * 80).ms).fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPriceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withOpacity(0.15),
            AppTheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RizzLang Pro',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '自動更新 • いつでもキャンセル可',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
          Text(
            _priceText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseButton(BuildContext context, _PurchaseStatus status) {
    final isLoading = status == _PurchaseStatus.loading;

    return FilledButton(
      onPressed: isLoading ? null : _onPurchase,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: AppTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        disabledBackgroundColor: AppTheme.primary.withOpacity(0.4),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : const Text(
              'Pro にアップグレード',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text('🎉', style: const TextStyle(fontSize: 64))
            .animate()
            .scale(duration: 500.ms, curve: Curves.elasticOut),
        const SizedBox(height: 16),
        Text(
          'Pro になりました！',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ).animate(delay: 200.ms).fadeIn(),
        const SizedBox(height: 8),
        Text(
          '지우との会話が無制限になりました ✨',
          style: TextStyle(color: Colors.white60),
        ).animate(delay: 400.ms).fadeIn(),
        const SizedBox(height: 32),
      ],
    );
  }
}
