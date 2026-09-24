import 'package:geolocator/geolocator.dart';

import '../models/list_data.dart';

// =====================================================
// FILTER FUNCTION
// =====================================================

class FilterFunction {
  // =====================================================
  // HITUNG JARAK CAFE
  // =====================================================

  static double hitungJarak({
    required Position userPosition,
    required String tokoId,
  }) {
    final cafe = cafeData[tokoId]!;

    final double? cafeLatitude =
        double.tryParse(
      cafe['latitude'] ?? '',
    );

    final double? cafeLongitude =
        double.tryParse(
      cafe['longitude'] ?? '',
    );

    // Kalau koordinat cafe tidak tersedia
    if (cafeLatitude == null ||
        cafeLongitude == null) {
      return double.infinity;
    }

    final double distanceInMeters =
        Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      cafeLatitude,
      cafeLongitude,
    );

    // Ubah meter menjadi kilometer
    return distanceInMeters / 1000;
  }

  // =====================================================
  // FILTER BERDASARKAN JARAK
  // =====================================================

  static List<String> filterByDistance({
    required double maxDistance,
    required Position userPosition,
  }) {
    return cafeData.keys.where((tokoId) {
      final double distance =
          hitungJarak(
        userPosition: userPosition,
        tokoId: tokoId,
      );

      return distance <= maxDistance;
    }).toList();
  }

  // =====================================================
  // FILTER BERDASARKAN RATING
  // =====================================================

  static List<String> filterByRating(
    double minRating,
  ) {
    return cafeData.keys.where((tokoId) {
      final cafe =
          cafeData[tokoId]!;

      final double rating =
          double.tryParse(
            cafe['rating'] ?? '',
          ) ??
          0;

      return rating >= minRating;
    }).toList();
  }

  // =====================================================
  // FILTER JARAK + RATING
  // =====================================================

  static List<String> filterCafe({
    double? maxDistance,
    double? minRating,
    Position? userPosition,
  }) {
    return cafeData.keys.where((tokoId) {
      final cafe =
          cafeData[tokoId]!;

      // =================================================
      // CEK JARAK
      // =================================================

      if (maxDistance != null) {
        // Kalau lokasi user belum tersedia,
        // cafe tidak bisa difilter berdasarkan jarak.
        if (userPosition == null) {
          return false;
        }

        final double distance =
            hitungJarak(
          userPosition:
              userPosition,
          tokoId: tokoId,
        );

        if (distance > maxDistance) {
          return false;
        }
      }

      // =================================================
      // CEK RATING
      // =================================================

      if (minRating != null) {
        final double rating =
            double.tryParse(
              cafe['rating'] ?? '',
            ) ??
            0;

        if (rating < minRating) {
          return false;
        }
      }

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