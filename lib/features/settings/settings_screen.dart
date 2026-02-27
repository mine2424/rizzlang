import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/providers/character_provider.dart';
import '../../core/services/fcm_service.dart';
import '../../core/services/revenue_cat_service.dart';
import '../../core/theme/app_theme.dart';
import '../paywall/paywall_sheet.dart';
import 'relationship_memories_screen.dart'; // ignore: unused_import

// ────────────────────────────────────────────────
// 通知設定の状態管理
// ────────────────────────────────────────────────
final _notifEnabledProvider = StateProvider<bool>((ref) => true);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifEnabled = ref.watch(_notifEnabledProvider);
    final isPro = ref.watch(proStatusProvider).valueOrNull ?? false;
    final activeCharacter = ref.watch(activeCharacterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          // ── アカウントセクション ──
          _SectionHeader(label: 'アカウント'),
          _SettingsTile(
            icon: Icons.person_outline,
            title: 'プロフィール',
            subtitle: isPro ? 'Pro プラン' : 'Free プラン（3回/日）',
            trailing: isPro
                ? _ProBadge()
                : TextButton(
                    onPressed: () => _showPaywall(context, ref),
                    child: Text(
                      'アップグレード',
                      style: TextStyle(color: AppTheme.primary, fontSize: 13),
                    ),
                  ),
          ),
          _SettingsDivider(),

          // ── 通知セクション ──
          _SectionHeader(label: '通知'),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'デイリーリマインダー',
            subtitle: '毎日9時に지우からお知らせ',
            trailing: Switch.adaptive(
              value: notifEnabled,
              activeColor: AppTheme.primary,
              onChanged: (val) => _toggleNotification(ref, val),
            ),
          ),
          _SettingsDivider(),

          // ── 학습（학습）セクション ──
          _SectionHeader(label: '학습 設定'),
          _SettingsTile(
            icon: Icons.language,
            title: '学習言語を変更',
            subtitle: activeCharacter?.languageDisplayName ?? '韓国語',
            onTap: () => context.push('/language-select'),
          ),
          _SettingsDivider(),
          ListTile(
            leading: const Icon(Icons.favorite_border, color: AppTheme.primary),
            title: const Text(
              '지우の記憶',
              style: TextStyle(fontSize: 15, color: Colors.white87),
            ),
            subtitle: const Text(
              '過去の会話で積み重ねた記憶',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white38),
            onTap: () => context.push('/relationship-memories'),
          ),
          _SettingsDivider(),
          _SettingsTile(
            icon: Icons.person_2_outlined,
            title: '${activeCharacter?.shortName ?? 'キャラクター'}からの呼び方',
            subtitle: 'オッパ / 자기야 / カスタム',
            onTap: () => _showCallNameDialog(context, ref),
          ),
          _SettingsDivider(),

          // ── サポートセクション ──
          _SectionHeader(label: 'サポート'),
          _SettingsTile(
            icon: Icons.restore,
            title: '購入を復元する',
            subtitle: '以前のPro購入を復元',
            onTap: () => _restorePurchases(context, ref),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'プライバシーポリシー',
            onTap: () => _launchUrl('https://mine2424.github.io/rizzlang-landing/#privacy'),
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: '利用規約',
            onTap: () => _launchUrl('https://mine2424.github.io/rizzlang-landing/#terms'),
          ),
          _SettingsDivider(),

          // ── ログアウト ──
          _SectionHeader(label: 'アカウント操作'),
          _SettingsTile(
            icon: Icons.logout,
            title: 'ログアウト',
            titleColor: Colors.redAccent,
            onTap: () => _signOut(context, ref),
          ),

          const SizedBox(height: 40),

          // ── アプリバージョン ──
          Center(
            child: Text(
              'RizzLang v1.0.0',
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // アクション
  // ────────────────────────────────────────────────
  Future<void> _toggleNotification(WidgetRef ref, bool enabled) async {
    ref.read(_notifEnabledProvider.notifier).state = enabled;
    final fcm = ref.read(fcmServiceProvider);
    if (enabled) {
      await fcm.enableNotifications();
    } else {
      await fcm.disableNotifications();
    }
  }

  Future<void> _showPaywall(BuildContext context, WidgetRef ref) async {
    final purchased = await showPaywallSheet(context);
    if (purchased) {
      ref.invalidate(proStatusProvider);
    }
  }

  Future<void> _restorePurchases(BuildContext context, WidgetRef ref) async {
    final service = ref.read(revenueCatServiceProvider);
    final result = await service.restorePurchases();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess ? '購入を復元しました ✅' : result.errorMessage ?? '復元できませんでした',
        ),
        backgroundColor:
            result.isSuccess ? Colors.green.shade700 : Colors.red.shade700,
      ),
    );

    if (result.isSuccess) ref.invalidate(proStatusProvider);
  }

  Future<void> _showCallNameDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (ctx) => _CallNameDialog(),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('ログアウト'),
        content: const Text('ログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('ログアウト',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authNotifierProvider.notifier).signOut();
      context.go('/login');
    }
  }
}

// ────────────────────────────────────────────────
// 呼称変更ダイアログ
// ────────────────────────────────────────────────
class _CallNameDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CallNameDialog> createState() => _CallNameDialogState();
}

class _CallNameDialogState extends ConsumerState<_CallNameDialog> {
  String _selected = 'オッパ';
  bool _isCustom = false;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _isCustom && _ctrl.text.isNotEmpty ? _ctrl.text : _selected;
    try {
      final uid = ref.read(currentUserProvider)?.id;
      if (uid != null) {
        final client = ref.read(supabaseClientProvider);
        await client.from('users').update({'user_call_name': name}).eq('id', uid);
      }
    } catch (_) {}
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      title: const Text('지우からの呼び方'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...['オッパ', '자기야'].map(
            (opt) => RadioListTile<String>(
              title: Text(opt),
              value: opt,
              groupValue: _isCustom ? '' : _selected,
              activeColor: AppTheme.primary,
              onChanged: (v) => setState(() {
                _selected = v!;
                _isCustom = false;
              }),
            ),
          ),
          RadioListTile<String>(
            title: const Text('カスタム'),
            value: 'custom',
            groupValue: _isCustom ? 'custom' : _selected,
            activeColor: AppTheme.primary,
            onChanged: (_) => setState(() => _isCustom = true),
          ),
          if (_isCustom)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _ctrl,
                autofocus: true,
                decoration: const InputDecoration(hintText: '呼び方を入力'),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
          child: const Text('保存'),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────
// サブウィジェット
// ────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white54, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: titleColor ?? Colors.white87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: TextStyle(color: Colors.white38, fontSize: 12))
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right, color: Colors.white24)
              : null),
      onTap: onTap,
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.white12, indent: 56);
  }
}

class _ProBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
