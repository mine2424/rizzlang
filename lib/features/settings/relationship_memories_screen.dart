import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/relationship_memory_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/relationship_memory_provider.dart';
import '../../core/theme/app_theme.dart';

class RelationshipMemoriesScreen extends ConsumerWidget {
  const RelationshipMemoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoriesAsync = ref.watch(relationshipMemoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('キャラの記憶'),
        centerTitle: true,
      ),
      body: memoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                '記憶の読み込みに失敗しました',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
        data: (memories) {
          if (memories.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '🌸',
                      style: const TextStyle(fontSize: 56),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'まだ記憶がありません',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '会話を重ねると지우が覚えていきます 🌸',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white38,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: memories.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: Colors.white12,
              indent: 72,
            ),
            itemBuilder: (context, index) {
              final memory = memories[index];
              return _MemoryTile(
                memory: memory,
                onDelete: () => _confirmDelete(context, ref, memory),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    RelationshipMemoryModel memory,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('記憶を削除'),
        content: Text(
          '第${memory.weekNumber}週の記憶を削除しますか？\nこの操作は取り消せません。',
          style: const TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              '削除',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteMemory(context, ref, memory.id);
    }
  }

  Future<void> _deleteMemory(
    BuildContext context,
    WidgetRef ref,
    String memoryId,
  ) async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase
          .from('relationship_memories')
          .delete()
          .eq('id', memoryId);

      ref.invalidate(relationshipMemoriesProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('記憶を削除しました'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('削除に失敗しました'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _MemoryTile extends StatelessWidget {
  const _MemoryTile({
    required this.memory,
    required this.onDelete,
  });

  final RelationshipMemoryModel memory;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      leading: CircleAvatar(
        backgroundColor: memory.emotionalWeight >= 7
            ? AppTheme.primary.withOpacity(0.2)
            : Colors.white12,
        child: Text(
          '${memory.weekNumber}',
          style: TextStyle(
            color: memory.emotionalWeight >= 7
                ? AppTheme.primary
                : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
      title: Text(
        memory.summary,
        style: const TextStyle(fontSize: 14, height: 1.5),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Text(
              '第${memory.weekNumber}週 (${memory.weekStart} 〜 ${memory.weekEnd})',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
            if (memory.emotionalWeight >= 7) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.4),
                  ),
                ),
                child: Text(
                  '💕 大切な記憶',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.white38),
        onPressed: onDelete,
      ),
    );
  }
}
