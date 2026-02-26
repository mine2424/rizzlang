import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/auth_provider.dart';

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
              const Text('✦', style: TextStyle(fontSize: 48, color: AppTheme.primary)),
              const SizedBox(height: 16),
              const Text('RizzLang',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppTheme.primary)),
              const SizedBox(height: 8),
              Text('AI外国人パートナーと毎日LINEして言語を身につける',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppTheme.muted)),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: authState.isLoading
                    ? null
                    : () => ref.read(authNotifierProvider.notifier).signInWithGoogle(),
                icon: const Text('G', style: TextStyle(fontWeight: FontWeight.bold)),
                label: const Text('Googleでログイン'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: authState.isLoading
                    ? null
                    : () => ref.read(authNotifierProvider.notifier).signInWithApple(),
                icon: const Icon(Icons.apple),
                label: const Text('Appleでログイン'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
