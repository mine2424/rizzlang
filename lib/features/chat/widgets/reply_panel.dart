import 'package:flutter/material.dart';
import '../../../core/models/message_model.dart';
import '../../../core/theme/app_theme.dart';

class ReplyPanel extends StatelessWidget {
  const ReplyPanel({super.key, required this.reply});
  final GeneratedReply reply;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      color: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('✦ 自然な韓国語返信',
              style: TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            ),
            child: Text(reply.reply, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Row(children: [
            _Badge('なぜ', AppTheme.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(reply.why, style: TextStyle(fontSize: 12, color: AppTheme.muted))),
          ]),
          ...reply.slang.map((s) => Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(children: [
              _Badge('スラング', Colors.blue),
              const SizedBox(width: 8),
              Expanded(child: Text('${s.word} — ${s.meaning}',
                  style: TextStyle(fontSize: 12, color: AppTheme.muted))),
            ]),
          )),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
  );
}
