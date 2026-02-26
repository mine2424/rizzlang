import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app.dart';
import 'core/services/env.dart';
import 'core/services/revenue_cat_service.dart';
import 'core/services/fcm_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) =>
    firebaseMessagingBackgroundHandler(message);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 環境設定をデバッグ表示
  if (kDebugMode) Env.printConfig();

  // ── Firebase 初期化（本番のみ・ローカルはスキップ可）──
  // ローカル開発時も Firebase は初期化が必要（FCM は実機のみ動作）
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ── Supabase 初期化 ──
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
    // ローカルではHTTPを許可
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
  );

  // ── RevenueCat 初期化 ──
  final currentUserId = Supabase.instance.client.auth.currentUser?.id;
  await RevenueCatService.initialize(currentUserId);

  runApp(
    const ProviderScope(
      child: RizzLangApp(),
    ),
  );
}
