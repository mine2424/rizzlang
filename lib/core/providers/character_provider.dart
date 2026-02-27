import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/character_model.dart';
import 'auth_provider.dart';

// ────────────────────────────────────────────────
// アクティブキャラクター Provider
// ────────────────────────────────────────────────
final activeCharacterProvider =
    StateNotifierProvider<ActiveCharacterNotifier, CharacterModel?>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ActiveCharacterNotifier(supabase);
});

class ActiveCharacterNotifier extends StateNotifier<CharacterModel?> {
  final SupabaseClient _supabase;

  ActiveCharacterNotifier(this._supabase) : super(null) {
    _loadActiveCharacter();
  }

  /// Supabase から users.active_character_id を取得して characters を join
  Future<void> _loadActiveCharacter() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // users テーブルから active_character_id を取得
      final userData = await _supabase
          .from('users')
          .select('active_character_id')
          .eq('id', userId)
          .single();

      final activeCharacterId = userData['active_character_id'] as String?;

      if (activeCharacterId == null) {
        // フォールバック: 지우 (デフォルト)
        await _fetchAndSetCharacter('c1da0000-0000-0000-0000-000000000001');
        return;
      }

      await _fetchAndSetCharacter(activeCharacterId);
    } catch (e) {
      // エラー時は지우をデフォルトとしてフォールバック
      try {
        await _fetchAndSetCharacter('c1da0000-0000-0000-0000-000000000001');
      } catch (_) {}
    }
  }

  /// characterId でキャラクター情報を取得してステートにセット
  Future<void> _fetchAndSetCharacter(String characterId) async {
    final charData = await _supabase
        .from('characters')
        .select('id, name, language, persona, avatar_url')
        .eq('id', characterId)
        .single();

    state = CharacterModel.fromJson(charData as Map<String, dynamic>);
  }

  /// キャラクター切り替え
  /// - user_characters に解放済みレコードがあるかチェック
  /// - users.active_character_id を更新
  /// - user_scenario_progress を作成/確認
  Future<void> switchCharacter(String characterId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    // 解放済みチェック
    final unlocked = await _supabase
        .from('user_characters')
        .select('character_id')
        .eq('user_id', userId)
        .eq('character_id', characterId)
        .maybeSingle();

    if (unlocked == null) {
      // 解放されていない → user_characters に追加（Pro ユーザー向け）
      await _supabase.from('user_characters').upsert(
        {
          'user_id': userId,
          'character_id': characterId,
          'is_active': true,
        },
        onConflict: 'user_id,character_id',
      );
    }

    // users.active_character_id を更新
    await _supabase
        .from('users')
        .update({'active_character_id': characterId})
        .eq('id', userId);

    // user_scenario_progress を作成/確認
    await _supabase.from('user_scenario_progress').upsert(
      {
        'user_id': userId,
        'character_id': characterId,
        'current_season': 1,
        'current_week': 1,
        'current_day': 1,
        'last_played_at': null,
      },
      onConflict: 'user_id,character_id',
      ignoreDuplicates: true,
    );

    // ステートを更新
    await _fetchAndSetCharacter(characterId);
  }

  /// 外部から再ロード（ログイン後など）
  Future<void> reload() => _loadActiveCharacter();
}

// ────────────────────────────────────────────────
// 全キャラクター一覧（言語選択画面用）
// ────────────────────────────────────────────────
final allCharactersProvider = FutureProvider<List<CharacterModel>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final response = await supabase
      .from('characters')
      .select('id, name, language, persona, avatar_url')
      .order('name');

  return (response as List)
      .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
      .toList();
});

// ────────────────────────────────────────────────
// ユーザーが解放済みのキャラクター一覧
// ────────────────────────────────────────────────
final unlockedCharactersProvider =
    FutureProvider<List<CharacterModel>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return [];

  // user_characters から解放済み character_id を取得し characters を結合
  final response = await supabase
      .from('user_characters')
      .select('character_id, characters(id, name, language, persona, avatar_url)')
      .eq('user_id', userId);

  return (response as List).map((e) {
    final charData = e['characters'] as Map<String, dynamic>;
    return CharacterModel.fromJson(charData);
  }).toList();
});
