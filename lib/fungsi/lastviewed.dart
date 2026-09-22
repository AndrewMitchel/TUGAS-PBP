// =====================================================
// LAST VIEWED FUNCTION
// =====================================================

class LastViewedFunction {
  // Menyimpan daftar cafe yang terakhir dilihat
  static final List<String> _lastViewed = [];

  // =====================================================
  // SIMPAN CAFE YANG BARU DILIHAT
  // =====================================================

  static void addLastViewed(String tokoId) {
    // Kalau cafe sudah pernah dilihat,
    // hapus dulu supaya tidak terjadi duplikat
    _lastViewed.remove(tokoId);

    // Masukkan cafe terbaru ke posisi paling atas
    _lastViewed.insert(0, tokoId);

    // Batasi hanya 5 cafe terakhir
    if (_lastViewed.length > 5) {
      _lastViewed.removeLast();
    }
  }

  // =====================================================
  // AMBIL DAFTAR LAST VIEWED
  // =====================================================

  static List<String> getLastViewed() {
    return List<String>.from(_lastViewed);
  }

  // =====================================================
  // HAPUS SEMUA LAST VIEWED
  // =====================================================

  static void clearLastViewed() {
    _lastViewed.clear();
  }
}