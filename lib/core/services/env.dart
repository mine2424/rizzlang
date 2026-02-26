import 'dart:io';

/// 環境変数管理
///
/// ── 使い方 ──
/// # ローカル開発（Supabase エミュレータ）
/// flutter run \
///   --dart-define=ENV=local \
///   --dart-define=RC_IOS_KEY=appl_dummy \
///   --dart-define=RC_ANDROID_KEY=goog_dummy
///
/// # 本番
/// flutter run \
///   --dart-define=ENV=production \
///   --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=eyJ... \
///   --dart-define=RC_IOS_KEY=appl_xxx \
///   --dart-define=RC_ANDROID_KEY=goog_xxx
///
/// VS Code: .vscode/launch.json の設定を使うのが便利

class Env {
  static const _env = String.fromEnvironment('ENV', defaultValue: 'local');

  static bool get isLocal => _env == 'local';
  static bool get isProduction => _env == 'production';

  // ────────────────────────────────────────────────
  // Supabase URL
  //   ローカル: エミュレータのアドレス（デバイス種別で自動判定）
  //   本番: dart-define で注入
  // ────────────────────────────────────────────────
  static String get supabaseUrl {
    if (isProduction) {
      return const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: '',
      );
    }
    // ローカル: Android エミュレータは 10.0.2.2、iOS/物理デバイスは localhost
    // 物理デバイスの場合は LOCAL_HOST を dart-define で上書き可能
    final host = const String.fromEnvironment(
      'LOCAL_HOST',
      defaultValue: '', // 空なら自動判定
    );
    if (host.isNotEmpty) return 'http://$host:54321';
    return Platform.isAndroid
        ? 'http://10.0.2.2:54321'
        : 'http://127.0.0.1:54321';
  }

  // ────────────────────────────────────────────────
  // Supabase Anon Key
  //   ローカルエミュレータの固定テストキー（公開情報）
  // ────────────────────────────────────────────────
  static String get supabaseAnonKey {
    if (isProduction) {
      return const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: '',
      );
    }
    // Supabase CLI のデフォルト anon key（ローカル専用・secrets ではない）
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
        '.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9'
        '.CRFA0NiK7usTLLqXy5sGzC6mRJUD4v9dxe6sCFpilcg';
  }

  // ────────────────────────────────────────────────
  // RevenueCat API Keys
  // ────────────────────────────────────────────────
  static const String rcIosKey = String.fromEnvironment(
    'RC_IOS_KEY',
    defaultValue: 'appl_local_test', // ローカルは StoreKit Configuration で動作
  );

  static const String rcAndroidKey = String.fromEnvironment(
    'RC_ANDROID_KEY',
    defaultValue: 'goog_local_test',
  );

  // ────────────────────────────────────────────────
  // デバッグ用ログ
  // ────────────────────────────────────────────────
  static void printConfig() {
    // ignore: avoid_print
    print('''
╔════════════════════════════════════════╗
║  RizzLang — ENV: $_env
╠════════════════════════════════════════╣
║  Supabase URL: $supabaseUrl
╚════════════════════════════════════════╝
    ''');
  }
}
