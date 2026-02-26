import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'core/services/env.dart';
import 'core/services/revenue_cat_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 初期化（FCM Push通知用）
  await Firebase.initializeApp();

  // Supabase 初期化
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  // RevenueCat 初期化
  // 起動時点でのログイン済みユーザーIDを渡す（未ログインなら null → 匿名ユーザー）
  final currentUserId = Supabase.instance.client.auth.currentUser?.id;
  await RevenueCatService.initialize(currentUserId);

  runApp(
    const ProviderScope(
      child: RizzLangApp(),
    ),
  );
}
