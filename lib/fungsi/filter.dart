import '../models/list_data.dart';

// =====================================================
// FILTER FUNCTION
// =====================================================

class FilterFunction {
  // =====================================================
  // FILTER BERDASARKAN JARAK
  // =====================================================

  static List<String> filterByDistance(double maxDistance) {
    return cafeData.keys.where((tokoId) {
      final cafe = cafeData[tokoId]!;

      // Ambil jarak dari data cafe
      // Contoh: "1.2 km"
      final String distanceText = cafe['distance']!;

      // Hapus tulisan "km"
      // Contoh: "1.2 km" -> "1.2"
      final double distance =
          double.tryParse(
            distanceText
                .replaceAll('km', '')
                .trim(),
          ) ??
          999;

      // Cafe masuk kalau jaraknya
      // sama dengan atau kurang dari filter
      return distance <= maxDistance;
    }).toList();
  }

  // =====================================================
  // FILTER BERDASARKAN RATING
  // =====================================================

  static List<String> filterByRating(double minRating) {
    return cafeData.keys.where((tokoId) {
      final cafe = cafeData[tokoId]!;

      // Ambil rating dari data cafe
      // Contoh: "4.8"
      final double rating =
          double.tryParse(
            cafe['rating']!,
          ) ??
          0;

      // Cafe masuk kalau ratingnya
      // sama dengan atau lebih tinggi dari filter
      return rating >= minRating;
    }).toList();
  }

  // =====================================================
  // FILTER JARAK + RATING
  // =====================================================

  static List<String> filterCafe({
    double? maxDistance,
    double? minRating,
  }) {
    return cafeData.keys.where((tokoId) {
      final cafe = cafeData[tokoId]!;

      // =====================================================
      // CEK JARAK
      // =====================================================

      if (maxDistance != null) {
        final double distance =
            double.tryParse(
              cafe['distance']!
                  .replaceAll('km', '')
                  .trim(),
            ) ??
            999;

        // Kalau jarak melebihi filter,
        // cafe tidak dimasukkan
        if (distance > maxDistance) {
          return false;
        }
      }

      // =====================================================
      // CEK RATING
      // =====================================================

      if (minRating != null) {
        final double rating =
            double.tryParse(
              cafe['rating']!,
            ) ??
            0;

        // Kalau rating kurang dari filter,
        // cafe tidak dimasukkan
        if (rating < minRating) {
          return false;
        }
      }

      // Kalau semua syarat terpenuhi
      return true;
    }).toList();
  }

  // =====================================================
  // RESET FILTER
  // =====================================================

  static List<String> resetFilter() {
    return cafeData.keys.toList();
  }
}