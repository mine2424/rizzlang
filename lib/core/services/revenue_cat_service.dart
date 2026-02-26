import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_provider.dart';

// ────────────────────────────────────────────────
// RevenueCat API Keys
// ────────────────────────────────────────────────
// dart-define で渡す:
//   --dart-define=RC_IOS_KEY=appl_xxxxx
//   --dart-define=RC_ANDROID_KEY=goog_xxxxx
const _rcIosKey = String.fromEnvironment('RC_IOS_KEY', defaultValue: '');
const _rcAndroidKey = String.fromEnvironment('RC_ANDROID_KEY', defaultValue: '');

// RevenueCat Entitlement & Product IDs
// ※ RevenueCat Dashboard で合わせること
const kEntitlementPro = 'pro';
const kProductMonthly = 'com.rizzlang.pro.monthly'; // App Store / Google Play の Product ID

// ────────────────────────────────────────────────
// Provider
// ────────────────────────────────────────────────
final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService(ref.watch(supabaseClientProvider));
});

final proStatusProvider = FutureProvider<bool>((ref) async {
  return ref.watch(revenueCatServiceProvider).isProUser();
});

// ────────────────────────────────────────────────
// RevenueCatService
// ────────────────────────────────────────────────
class RevenueCatService {
  final SupabaseClient _supabase;

  RevenueCatService(this._supabase);

  /// アプリ起動時に一度だけ呼ぶ（main.dart or AuthProvider 内）
  static Future<void> initialize(String? userId) async {
    await Purchases.setLogLevel(LogLevel.warning);

    final config = PurchasesConfiguration(
      Platform.isIOS ? _rcIosKey : _rcAndroidKey,
    )..appUserID = userId; // Supabase UID を RevenueCat の AppUserID に紐付け

    await Purchases.configure(config);
  }

  /// ログイン後に RevenueCat の AppUserID を Supabase UID へ切り替え
  static Future<void> logIn(String userId) async {
    await Purchases.logIn(userId);
  }

  /// ログアウト時に匿名ユーザーへ戻す
  static Future<void> logOut() async {
    await Purchases.logOut();
  }

  // ────────────────────────────────────────────────
  // Offerings（サブスクプラン一覧）
  // ────────────────────────────────────────────────
  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      return null;
    }
  }

  // ────────────────────────────────────────────────
  // Purchase
  // ────────────────────────────────────────────────
  Future<PurchaseResult> purchaseMonthly() async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.monthly ??
          offerings.current?.availablePackages.firstOrNull;

      if (package == null) {
        return PurchaseResult.error('利用可能なプランが見つかりません');
      }

      final info = await Purchases.purchasePackage(package);

      if (_isProActive(info)) {
        // Supabase の plan も即時更新（Webhook と二重になるが安全側）
        await _syncPlanToSupabase('pro');
        return PurchaseResult.success();
      }

      return PurchaseResult.error('購入は完了しましたが、プランの反映に失敗しました');
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseResult.cancelled();
      }
      return PurchaseResult.error(_localizeError(e));
    } catch (e) {
      return PurchaseResult.error('購入処理中にエラーが発生しました');
    }
  }

  // ────────────────────────────────────────────────
  // Restore
  // ────────────────────────────────────────────────
  Future<PurchaseResult> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();

      if (_isProActive(info)) {
        await _syncPlanToSupabase('pro');
        return PurchaseResult.success(restored: true);
      }

      return PurchaseResult.error('有効なサブスクリプションが見つかりませんでした');
    } catch (e) {
      return PurchaseResult.error('復元処理中にエラーが発生しました');
    }
  }

  // ────────────────────────────────────────────────
  // Pro ステータス確認
  // ────────────────────────────────────────────────
  Future<bool> isProUser() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return _isProActive(info);
    } catch (_) {
      // 取得失敗時はローカル DB の plan にフォールバック
      final user = await _supabase
          .from('users')
          .select('plan')
          .eq('id', _currentUserId)
          .single();
      return user['plan'] == 'pro';
    }
  }

  // ────────────────────────────────────────────────
  // Private helpers
  // ────────────────────────────────────────────────
  bool _isProActive(CustomerInfo info) {
    return info.entitlements.active.containsKey(kEntitlementPro);
  }

  String get _currentUserId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  Future<void> _syncPlanToSupabase(String plan) async {
    final uid = _currentUserId;
    if (uid.isEmpty) return;
    await _supabase.from('users').update({'plan': plan}).eq('id', uid);
  }

  String _localizeError(PurchasesErrorCode code) {
    return switch (code) {
      PurchasesErrorCode.networkError => 'ネットワークエラーが発生しました',
      PurchasesErrorCode.invalidCredentialsError => '認証エラーが発生しました',
      PurchasesErrorCode.productAlreadyPurchasedError => 'すでにこのプランを購入済みです',
      PurchasesErrorCode.paymentPendingError => '決済が保留中です。しばらくお待ちください',
      _ => '購入処理中にエラーが発生しました（${code.name}）',
    };
  }
}

// ────────────────────────────────────────────────
// PurchaseResult (Result型)
// ────────────────────────────────────────────────
class PurchaseResult {
  final bool isSuccess;
  final bool isCancelled;
  final bool isRestored;
  final String? errorMessage;

  const PurchaseResult._({
    required this.isSuccess,
    this.isCancelled = false,
    this.isRestored = false,
    this.errorMessage,
  });

  factory PurchaseResult.success({bool restored = false}) =>
      PurchaseResult._(isSuccess: true, isRestored: restored);

  factory PurchaseResult.cancelled() =>
      PurchaseResult._(isSuccess: false, isCancelled: true);

  factory PurchaseResult.error(String message) =>
      PurchaseResult._(isSuccess: false, errorMessage: message);
}
