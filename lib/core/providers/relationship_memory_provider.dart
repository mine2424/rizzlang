import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/relationship_memory_model.dart';
import 'auth_provider.dart';
import 'character_provider.dart';

final relationshipMemoriesProvider =
    FutureProvider<List<RelationshipMemoryModel>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final character = ref.watch(activeCharacterProvider);
  final userId = supabase.auth.currentUser?.id;
  if (userId == null || character == null) return [];

  final data = await supabase
      .from('relationship_memories')
      .select()
      .eq('user_id', userId)
      .eq('character_id', character.id)
      .order('week_number', ascending: false)
      .limit(8);

  return (data as List)
      .map((e) => RelationshipMemoryModel.fromJson(e as Map<String, dynamic>))
      .toList();
});
