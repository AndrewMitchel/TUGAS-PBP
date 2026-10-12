import 'package:supabase_flutter/supabase_flutter.dart';

/// Favorites are cached for the current session and persisted per Supabase user.
class FavoriteFunction {
  static final Set<String> _favorites = {};
  static final _supabase = Supabase.instance.client;
  static String? get _userId => _supabase.auth.currentUser?.id;

  static Future<void> loadFromDatabase() async {
    final userId = _userId;
    if (userId == null) { _favorites.clear(); return; }
    final rows = await _supabase.from('user_favorites').select('cafe_id').eq('user_id', userId);
    _favorites
      ..clear()
      ..addAll((rows as List).map((row) => row['cafe_id'].toString()));
  }

  static bool isFavorite(String tokoId) => _favorites.contains(tokoId);

  static bool toggleFavorite(String tokoId) {
    final userId = _userId;
    if (userId == null) throw const AuthException('Silakan login terlebih dahulu.');
    if (_favorites.remove(tokoId)) {
      _supabase.from('user_favorites').delete().eq('user_id', userId).eq('cafe_id', tokoId);
      return false;
    }
    _favorites.add(tokoId);
    _supabase.from('user_favorites').upsert({'user_id': userId, 'cafe_id': tokoId}, onConflict: 'user_id,cafe_id');
    return true;
  }

  static List<String> getFavorites() => _favorites.toList();

  static Future<void> clearFavorites() async {
    final userId = _userId;
    _favorites.clear();
    if (userId != null) await _supabase.from('user_favorites').delete().eq('user_id', userId);
  }
}
