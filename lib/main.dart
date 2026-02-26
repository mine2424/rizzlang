import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app.dart';
import 'core/services/env.dart';
import 'core/services/revenue_cat_service.dart';
import 'core/services/fcm_service.dart';

// バックグラウンドハンドラーはトップレベルで登録（main より前に呼ばれるため）
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) =>
    firebaseMessagingBackgroundHandler(message);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Firebase 初期化 ──
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ── Supabase 初期化 ──
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
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
