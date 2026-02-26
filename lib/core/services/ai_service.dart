import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';

/// Supabase Edge Function 経由で Gemini 1.5 Flash を呼び出すサービス
/// APIキーはEdge Function側でのみ管理し、クライアントに露出しない
class AIService {
  final SupabaseClient _supabase;

  AIService(this._supabase);

  /// ユーザーの日本語入力から韓国語返信・解説を生成
  Future<GeneratedReply> generateReply({
    required String userText,
    required String conversationId,
    required List<MessageModel> history,
    required int userLevel,
    required String userCallName,
  }) async {
    final response = await _supabase.functions.invoke(
      'generate-reply',
      body: {
        'userText': userText,
        'conversationId': conversationId,
        'history': history.map((m) => m.toJson()).toList(),
        'userLevel': userLevel,
        'userCallName': userCallName,
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
  Future<GeneratedReply> generateDemoReply(String userText) async {
    final response = await _supabase.functions.invoke(
      'generate-demo-reply',
      body: {'userText': userText},
    );

    if (response.status != 200) {
      throw AIServiceException('デモの生成に失敗しました。');
    }

    return GeneratedReply.fromJson(response.data as Map<String, dynamic>);
  }
}

class AIServiceException implements Exception {
  final String message;
  final int? statusCode;

  AIServiceException(this.message, {this.statusCode});

  @override
  String toString() => 'AIServiceException: $message (status: $statusCode)';
}
