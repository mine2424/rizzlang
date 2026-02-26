import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    int index = 0;
    if (location == '/vocabulary') index = 1;
    if (location == '/settings') index = 2;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: AppTheme.surface,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.muted,
        onTap: (i) {
          if (i == 0) context.go('/chat');
          if (i == 1) context.go('/vocabulary');
          if (i == 2) context.go('/settings');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'チャット'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: '語彙帳'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: '設定'),
        ],
      ),
    );
  }
}
