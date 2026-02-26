import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/providers/auth_provider.dart';
import 'core/services/fcm_service.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/home_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/vocabulary/screens/vocabulary_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';

// ────────────────────────────────────────────────
// GoRouter の NavigatorKey（FCM通知タップ用）
// ────────────────────────────────────────────────
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/chat',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull?.session != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation.startsWith('/onboarding');

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/chat';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: '/chat',
            builder: (_, __) => const ChatScreen(),
          ),
          GoRoute(
            path: '/vocabulary',
            builder: (_, __) => const VocabularyScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});

// ────────────────────────────────────────────────
// RizzLangApp
// ────────────────────────────────────────────────
class RizzLangApp extends ConsumerStatefulWidget {
  const RizzLangApp({super.key});

  @override
  ConsumerState<RizzLangApp> createState() => _RizzLangAppState();
}

class _RizzLangAppState extends ConsumerState<RizzLangApp> {
  @override
  void initState() {
    super.initState();
    _initFcm();
  }

  Future<void> _initFcm() async {
    final fcm = ref.read(fcmServiceProvider);
    await fcm.initialize(
      onTapNavigate: (route) {
        // 通知タップで指定ルートへ遷移
        _rootNavigatorKey.currentContext?.go(route);
      },
    );

    // ログイン済みなら即トークン取得・保存
    final isLoggedIn =
        ref.read(authStateProvider).valueOrNull?.session != null;
    if (isLoggedIn) {
      await fcm.requestPermissionAndSaveToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    // ログイン完了を検知してFCMトークンを保存
    ref.listen(authStateProvider, (prev, next) {
      final wasLoggedIn = prev?.valueOrNull?.session != null;
      final isLoggedIn = next.valueOrNull?.session != null;
      if (!wasLoggedIn && isLoggedIn) {
        ref.read(fcmServiceProvider).requestPermissionAndSaveToken();
      }
    });

    return MaterialApp.router(
      title: 'RizzLang',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
