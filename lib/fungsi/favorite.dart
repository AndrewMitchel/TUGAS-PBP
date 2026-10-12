
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteFunction {
  static final Set<String> _favorites = {};
  static final SupabaseClient _supabase = Supabase.instance.client;

  static String? get _userId => _supabase.auth.currentUser?.id;

  /// Membersihkan cache lokal tanpa menghapus data Supabase.
  static void clearLocal() {
    _favorites.clear();
  }

  /// Memuat favorite milik akun yang sedang login.
  static Future<void> loadFromDatabase() async {
    final userId = _userId;

    if (userId == null) {
      clearLocal();
      return;
    }

    try {
      final rows = await _supabase
          .from('user_favorites')
          .select('cafe_id')
          .eq('user_id', userId);

      // Pastikan akun belum berganti selama query berjalan.
      if (_userId != userId) return;

      _favorites
        ..clear()
        ..addAll(
          (rows as List).map(
            (row) => row['cafe_id'].toString(),
          ),
        );

      print(
        'Favorite dimuat untuk user $userId: ${_favorites.length} data',
      );
    } catch (e) {
      print('GAGAL MEMUAT FAVORITE: $e');
      rethrow;
    }
  }

  static bool isFavorite(String cafeId) {
    return _favorites.contains(cafeId);
  }

  /// Menambah atau menghapus favorite di Supabase.
  /// true = ditambahkan, false = dihapus.
  static Future<bool> toggleFavorite(String cafeId) async {
    final userId = _userId;

    if (userId == null) {
      throw const AuthException(
        'Silakan login terlebih dahulu.',
      );
    }

    final wasFavorite = _favorites.contains(cafeId);

    try {
      if (wasFavorite) {
        await _supabase
            .from('user_favorites')
            .delete()
            .eq('user_id', userId)
            .eq('cafe_id', cafeId);

        if (_userId == userId) {
          _favorites.remove(cafeId);
        }

        print('Favorite dihapus: $cafeId');
        return false;
      }

      await _supabase.from('user_favorites').upsert(
        {
          'user_id': userId,
          'cafe_id': cafeId,
        },
        onConflict: 'user_id,cafe_id',
      );

      if (_userId == userId) {
        _favorites.add(cafeId);
      }

      print('Favorite disimpan: $cafeId');
      return true;
    } catch (e) {
      print('GAGAL MEMPERBARUI FAVORITE: $e');
      rethrow;
    }
  }

  static List<String> getFavorites() {
    return _favorites.toList();
  }

  /// Menghapus semua favorite milik akun aktif dari database.
  static Future<void> clearFavorites() async {
    final userId = _userId;

    if (userId == null) {
      clearLocal();
      return;
    }

    await _supabase
        .from('user_favorites')
        .delete()
        .eq('user_id', userId);

    if (_userId == userId) {
      clearLocal();
    }
  }
}