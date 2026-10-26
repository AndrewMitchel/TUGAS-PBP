
import 'package:supabase_flutter/supabase_flutter.dart';

/// Recent cafes are cached locally and persisted per authenticated user.
class LastViewedFunction {
  static final List<String> _lastViewed = [];
  static final _supabase = Supabase.instance.client;

  static String? get _userId => _supabase.auth.currentUser?.id;

  /// Clear local cache only, without deleting database history.
  static void clearLocal() {
    _lastViewed.clear();
  }

  /// Load the latest 5 cafes viewed by the currently logged-in user.
  static Future<void> loadFromDatabase() async {
    final userId = _userId;

    if (userId == null) {
      _lastViewed.clear();
      return;
    }

    final rows = await _supabase
        .from('user_recently_viewed')
        .select('cafe_id, viewed_at')
        .eq('user_id', userId)
        .order('viewed_at', ascending: false)
        .limit(5);

    // Don't apply results if the user changed during the request.
    if (_userId != userId) return;

    _lastViewed
      ..clear()
      ..addAll(
        (rows as List).map((row) => row['cafe_id'].toString()),
      );
  }

  /// Add a cafe to the recent list and save it to the database.
  static Future<void> addLastViewed(String tokoId) async {
    final userId = _userId;

    if (userId == null) return;

    // Update the database first so failures can be reported to the caller.
    await _supabase.from('user_recently_viewed').upsert(
      {
        'user_id': userId,
        'cafe_id': tokoId,
        'viewed_at': DateTime.now().toUtc().toIso8601String(),
      },
      onConflict: 'user_id,cafe_id',
    );

    // Don't update the local cache if the active account changed.
    if (_userId != userId) return;

    _lastViewed.remove(tokoId);
    _lastViewed.insert(0, tokoId);

    if (_lastViewed.length > 5) {
      _lastViewed.removeRange(5, _lastViewed.length);
    }

    await _trimDatabaseHistory(userId);
  }

  /// Keep only the 5 most recently viewed cafes for this user.
  static Future<void> _trimDatabaseHistory(String userId) async {
    final rows = await _supabase
        .from('user_recently_viewed')
        .select('cafe_id')
        .eq('user_id', userId)
        .order('viewed_at', ascending: false);

    // Never trim history belonging to another active account.
    if (_userId != userId) return;

    final ids = (rows as List)
        .map((row) => row['cafe_id'].toString())
        .toList();

    for (final id in ids.skip(5)) {
      await _supabase
          .from('user_recently_viewed')
          .delete()
          .eq('user_id', userId)
          .eq('cafe_id', id);
    }
  }

  /// Return a copy so callers cannot modify the internal cache directly.
  static List<String> getLastViewed() {
    return List<String>.from(_lastViewed);
  }

  /// Delete recent history from the current user's database and local cache.
  static Future<void> clearLastViewed() async {
    final userId = _userId;

    if (userId == null) {
      _lastViewed.clear();
      return;
    }

    await _supabase
        .from('user_recently_viewed')
        .delete()
        .eq('user_id', userId);

    if (_userId == userId) {
      _lastViewed.clear();
    }
  }
}