import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';
import '../providers/auth_provider.dart';

final aiServiceProvider = Provider<AIService>((ref) {
  return AIService(ref.watch(supabaseClientProvider));
});

/// Supabase Edge Function 経由で Gemini 1.5 Flash を呼び出すサービス
/// APIキーはEdge Function側でのみ管理し、クライアントに露出しない
class AIService {
  final SupabaseClient _supabase;

  AIService(this._supabase);

  /// ユーザーの日本語入力からキャラクターの返信・解説を生成（多言語対応）
  Future<GeneratedReply> generateReply({
    required String userText,
    required String conversationId,
    required List<MessageModel> history,
    required int userLevel,
    required String userCallName,
    String? characterId,
    int editCount = 0,
    int retryCount = 0,
  }) async {
    final response = await _supabase.functions.invoke(
      'generate-reply',
      body: {
        'userText': userText,
        'conversationId': conversationId,
        'history': history.map((m) => m.toJson()).toList(),
        'userLevel': userLevel,
        'userCallName': userCallName,
        if (characterId != null) 'characterId': characterId,
        'editCount': editCount,
        'retryCount': retryCount,
      },
    );

    if (response.status != 200) {
      throw AIServiceException(
        'AI生成に失敗しました。しばらくしてからもう一度お試しください。',
        statusCode: response.status,
      );
    }

    return GeneratedReply.fromJson(response.data as Map<String, dynamic>);
  }

  /// 未認証ユーザー向けデモ返信（オンボーディング用）
  Future<GeneratedReply> generateDemoReply(String userText, {String? characterId}) async {
    final response = await _supabase.functions.invoke(
      'generate-demo-reply',
      body: {
        'userText': userText,
        if (characterId != null) 'characterId': characterId,
      },
    );

    if (response.status != 200) {
      throw AIServiceException('デモの生成に失敗しました。');
    }

    return GeneratedReply.fromJson(response.data as Map<String, dynamic>);
  }

  /// 外国語テキストをAIで添削（スコア付き）
  Future<WritingCheckResult> checkWriting({
    required String userText,
    required String language,
    String? contextMessage,
  }) async {
    final response = await _supabase.functions.invoke(
      'check-writing',
      body: {
        'userText': userText,
        'language': language,
        if (contextMessage != null) 'contextMessage': contextMessage,
      },
    );

    if (response.status != 200) {
      throw AIServiceException(
        '添削に失敗しました。もう一度お試しください。',
        statusCode: response.status,
      );
    }

    return WritingCheckResult.fromJson(response.data as Map<String, dynamic>);
  }
}

// ────────────────────────────────────────────────
// 添削結果モデル
// ────────────────────────────────────────────────
class WritingCheckResult {
  final String corrected;
  final List<WritingError> errors;
  final int score;
  final String praise;
  final String tip;

  const WritingCheckResult({
    required this.corrected,
    required this.errors,
    required this.score,
    required this.praise,
    required this.tip,
  });

  factory WritingCheckResult.fromJson(Map<String, dynamic> json) {
    return WritingCheckResult(
      corrected: json['corrected'] as String? ?? '',
      errors: (json['errors'] as List<dynamic>? ?? [])
          .map((e) => WritingError.fromJson(e as Map<String, dynamic>))
          .toList(),
      score: json['score'] as int? ?? 0,
      praise: json['praise'] as String? ?? '',
      tip: json['tip'] as String? ?? '',
    );
  }
}

class WritingError {
  final String original;
  final String corrected;
  final String explanation;

  const WritingError({
    required this.original,
    required this.corrected,
    required this.explanation,
  });

  factory WritingError.fromJson(Map<String, dynamic> json) {
    return WritingError(
      original: json['original'] as String? ?? '',
      corrected: json['corrected'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
    );
  }
}

class AIServiceException implements Exception {
  final String message;
  final int? statusCode;

  AIServiceException(this.message, {this.statusCode});

  @override
  String toString() => 'AIServiceException: $message (status: $statusCode)';
}
