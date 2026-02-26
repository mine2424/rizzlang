import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

enum MessageRole { user, character }

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required MessageRole role,
    required String content,          // 送信テキスト（韓国語 or 日本語）
    String? originalJapanese,         // ユーザーが入力した日本語
    required DateTime createdAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

@freezed
class SlangItem with _$SlangItem {
  const factory SlangItem({
    required String word,
    required String meaning,
  }) = _SlangItem;

  factory SlangItem.fromJson(Map<String, dynamic> json) =>
      _$SlangItemFromJson(json);
}

@freezed
class GeneratedReply with _$GeneratedReply {
  const factory GeneratedReply({
    required String reply,           // 韓国語返信
    required String why,             // 理由（30文字以内）
    @Default([]) List<SlangItem> slang, // スラング解説
    required String nextMessage,     // 地우の次のセリフ
  }) = _GeneratedReply;

  factory GeneratedReply.fromJson(Map<String, dynamic> json) =>
      _$GeneratedReplyFromJson(json);
}
