import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/env.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✦',
                  style: TextStyle(fontSize: 48, color: AppTheme.primary)),
              const SizedBox(height: 16),
              const Text(
                'RizzLang',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'AI外国人パートナーと毎日LINEして言語を身につける',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppTheme.muted),
              ),
              const SizedBox(height: 48),

              // ── Google ログイン ──
              ElevatedButton.icon(
                onPressed: authState.isLoading
                    ? null
                    : () => ref
                        .read(authNotifierProvider.notifier)
                        .signInWithGoogle(),
                icon: const Text('G',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                label: const Text('Googleでログイン'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              const SizedBox(height: 12),

              // ── Apple ログイン ──
              ElevatedButton.icon(
                onPressed: authState.isLoading
                    ? null
                    : () => ref
                        .read(authNotifierProvider.notifier)
                        .signInWithApple(),
                icon: const Icon(Icons.apple),
                label: const Text('Appleでログイン'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),

              // ────────────────────────────────────────
              // ⚡ デバッグログイン（ローカル開発専用）
              // kDebugMode && ENV=local のときのみ表示
              // ────────────────────────────────────────
              if (kDebugMode && Env.isLocal) ...[
                const SizedBox(height: 28),
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white12)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('ローカル開発',
                          style: TextStyle(color: Colors.white24, fontSize: 11)),
                    ),
                    Expanded(child: Divider(color: Colors.white12)),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: authState.isLoading
                      ? null
                      : () => _debugSignIn(context, ref),
                  icon: const Text('⚡', style: TextStyle(fontSize: 16)),
                  label: const Text(
                    'テストユーザーでログイン\ntest@rizzlang.local / test1234',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange, width: 1),
                  ),
                ),
              ],

              // エラー表示
              if (authState.hasError) ...[
                const SizedBox(height: 16),
                Text(
                  '⚠️ ${authState.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _debugSignIn(BuildContext context, WidgetRef ref) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: 'test@rizzlang.local',
        password: 'test1234',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('デバッグログイン失敗: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }
}
