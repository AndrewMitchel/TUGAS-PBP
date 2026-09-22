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

    // Cari berdasarkan nama atau about
    return cafeData.keys.where((tokoId) {
      final cafe = cafeData[tokoId]!;

      final name = cafe['name']!.toLowerCase();
      final about = cafe['about']!.toLowerCase();

      return name.contains(keyword) ||
          about.contains(keyword);
    }).toList();
  }
}