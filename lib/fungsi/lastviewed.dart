import 'package:supabase_flutter/supabase_flutter.dart';

/// Recent cafes are cached for quick UI reads and persisted per authenticated user.
class LastViewedFunction {
  static final List<String> _lastViewed = [];
  static final _supabase = Supabase.instance.client;
  static String? get _userId => _supabase.auth.currentUser?.id;

  static Future<void> loadFromDatabase() async {
    final userId = _userId;
    if (userId == null) { _lastViewed.clear(); return; }
    final rows = await _supabase.from('user_recently_viewed')
        .select('cafe_id, viewed_at').eq('user_id', userId)
        .order('viewed_at', ascending: false).limit(5);
    _lastViewed
      ..clear()
      ..addAll((rows as List).map((row) => row['cafe_id'].toString()));
  }

  static void addLastViewed(String tokoId) {
    final userId = _userId;
    if (userId == null) return;
    _lastViewed.remove(tokoId);
    _lastViewed.insert(0, tokoId);
    if (_lastViewed.length > 5) _lastViewed.removeLast();
    _supabase.from('user_recently_viewed').upsert({
      'user_id': userId,
      'cafe_id': tokoId,
      'viewed_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id,cafe_id');
    _trimDatabaseHistory(userId);
  }

  static Future<void> _trimDatabaseHistory(String userId) async {
    try {
      final rows = await _supabase.from('user_recently_viewed')
          .select('cafe_id').eq('user_id', userId)
          .order('viewed_at', ascending: false);
      final ids = (rows as List).map((row) => row['cafe_id'].toString()).toList();
      for (final id in ids.skip(5)) {
        await _supabase.from('user_recently_viewed').delete()
            .eq('user_id', userId).eq('cafe_id', id);
      }
    } catch (_) {
      // The main insert remains saved; the next load can still display recent items.
    }
  }

  static List<String> getLastViewed() => List<String>.from(_lastViewed);

  static Future<void> clearLastViewed() async {
    final userId = _userId;
    _lastViewed.clear();
    if (userId != null) await _supabase.from('user_recently_viewed').delete().eq('user_id', userId);
  }
}
