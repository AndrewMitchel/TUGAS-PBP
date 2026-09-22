class FavoriteFunction {
  static final Set<String> _favorites = {};

  static bool isFavorite(String tokoId) {
    return _favorites.contains(tokoId);
  }

  static bool toggleFavorite(String tokoId) {
    if (_favorites.contains(tokoId)) {
      _favorites.remove(tokoId);
      return false;
    }

    _favorites.add(tokoId);
    return true;
  }

  static List<String> getFavorites() {
    return _favorites.toList();
  }
        // =====================================================
      // HAPUS SEMUA FAVORITE
      // =====================================================

      static void clearFavorites() {
        _favorites.clear();
}
}