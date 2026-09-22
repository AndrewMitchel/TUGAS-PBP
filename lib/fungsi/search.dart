import '../models/list_data.dart';

class SearchFunction {
  // =====================================================
  // SEARCH CAFE
  // =====================================================

  static List<String> searchCafe(String keyword) {
    keyword = keyword.toLowerCase().trim();

    // Kalau search kosong, tampilkan semua cafe
    if (keyword.isEmpty) {
      return cafeData.keys.toList();
    }

    // =====================================================
    // CARI BERDASARKAN NAMA CAFE SAJA
    // =====================================================

    return cafeData.keys.where((tokoId) {
      final cafe = cafeData[tokoId]!;

      // Ambil nama cafe
      final name = cafe['name']!.toLowerCase();

      // Cek apakah nama cafe mengandung keyword
      return name.contains(keyword);
    }).toList();
  }
}