import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StreakBar extends StatelessWidget {
  const StreakBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.08),
        border: Border(bottom: BorderSide(color: AppTheme.primary.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Text('🔥 7日連続', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: 0.68,
                backgroundColor: AppTheme.primary.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('+12 XP', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
