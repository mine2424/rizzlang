import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 今日の会話履歴をローカルにキャッシュするサービス。
/// Supabase への余分なリクエストを削減し、オフラインでも過去メッセージを表示できる。
class CacheService {
  static const String _messagesKeyPrefix = 'chat_messages_';
  static const String _dateKey = 'cache_date';

  CacheService._();

  static Future<CacheService> create() async {
    final instance = CacheService._();
    return instance;
  }

  String _todayKey() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return '$_messagesKeyPrefix$today';
  }

  /// 今日の会話メッセージをローカルキャッシュから取得する。
  /// 日付が変わっていた場合は古いキャッシュをクリアして null を返す。
  Future<List<Map<String, dynamic>>?> getTodayMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final cachedDate = prefs.getString(_dateKey);

    // 日付が変わっていたら古いキャッシュをクリア
    if (cachedDate != null && cachedDate != today) {
      await _clearOldCache(prefs, cachedDate);
    }

    final json = prefs.getString(_todayKey());
    if (json == null) return null;

    try {
      final List<dynamic> decoded = jsonDecode(json) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  /// 今日の会話メッセージをローカルキャッシュに保存する。
  Future<void> saveTodayMessages(List<Map<String, dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];

    await prefs.setString(_dateKey, today);
    await prefs.setString(_todayKey(), jsonEncode(messages));
  }

  /// 指定日のキャッシュを削除する。
  Future<void> _clearOldCache(SharedPreferences prefs, String date) async {
    final oldKey = '$_messagesKeyPrefix$date';
    await prefs.remove(oldKey);
    await prefs.remove(_dateKey);
  }

  /// キャッシュを全クリアする（ログアウト時などに使用）。
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    await prefs.remove(_todayKey());
    await prefs.remove('$_messagesKeyPrefix$today');
    await prefs.remove(_dateKey);
  }
}
