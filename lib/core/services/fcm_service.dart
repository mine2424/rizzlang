import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_provider.dart';

// ────────────────────────────────────────────────
// Provider
// ────────────────────────────────────────────────
final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService(ref.watch(supabaseClientProvider));
});

// ────────────────────────────────────────────────
// バックグラウンドメッセージハンドラー（トップレベル関数必須）
// ────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // バックグラウンドでの受信はシステム通知として自動表示される
  debugPrint('FCM background: ${message.messageId}');
}

// ────────────────────────────────────────────────
// FcmService
// ────────────────────────────────────────────────
class FcmService {
  final SupabaseClient _supabase;
  final _localNotif = FlutterLocalNotificationsPlugin();

  FcmService(this._supabase);

  /// アプリ起動後 + ログイン後に一度呼ぶ
  Future<void> initialize({
    required void Function(String route) onTapNavigate,
  }) async {
    // ── バックグラウンドハンドラー登録 ──
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // ── ローカル通知 初期化（フォアグラウンド表示用）──
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false, // 後から明示的に許可ダイアログを出す
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localNotif.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (details) {
        // 通知タップ → チャット画面へ
        onTapNavigate('/chat');
      },
    );

    // ── Android 通知チャンネル作成 ──
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'rizzlang_reminders',
        'RizzLang リマインダー',
        description: '지우からのデイリーメッセージ通知',
        importance: Importance.high,
      );
      await _localNotif
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // ── フォアグラウンド受信時にローカル通知で表示 ──
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });

    // ── 通知タップで起動（バックグラウンド → フォアグラウンド）──
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onTapNavigate('/chat');
    });

    // ── 通知タップで起動（完全終了状態から）──
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      onTapNavigate('/chat');
    }
  }

  /// 通知許可ダイアログを表示してトークンを保存
  Future<bool> requestPermissionAndSaveToken() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (granted) {
      await _saveToken();
      // トークンがローテーションされた場合に再保存
      FirebaseMessaging.instance.onTokenRefresh.listen(_upsertToken);
    }

    return granted;
  }

  /// 通知を無効化（DB の enabled フラグを false に）
  Future<void> disableNotifications() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;
    await _supabase
        .from('fcm_tokens')
        .update({'enabled': false})
        .eq('user_id', uid);
  }

  /// 通知を有効化（enabled → true + トークン再保存）
  Future<void> enableNotifications() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;
    await _supabase
        .from('fcm_tokens')
        .update({'enabled': true})
        .eq('user_id', uid);
    await _saveToken();
  }

  // ────────────────────────────────────────────────
  // Private helpers
  // ────────────────────────────────────────────────
  Future<void> _saveToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await _upsertToken(token);
  }

  Future<void> _upsertToken(String token) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    await _supabase.from('fcm_tokens').upsert(
      {
        'user_id': uid,
        'token': token,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'enabled': true,
      },
      onConflict: 'user_id,token',
    );
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'rizzlang_reminders',
      'RizzLang リマインダー',
      channelDescription: '지우からのデイリーメッセージ通知',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotif.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}
