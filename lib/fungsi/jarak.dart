import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class JarakFunction {
  // =====================================================
  // POSISI USER GLOBAL
  // =====================================================

  static final ValueNotifier<Position?> userPosition =
      ValueNotifier<Position?>(null);

  // =====================================================
  // STREAM GPS
  // =====================================================

  static StreamSubscription<Position>?
      _locationSubscription;

  static bool _isStarted = false;

  // =====================================================
  // MULAI GPS
  // =====================================================

  static Future<bool> startLiveLocation() async {
    // Kalau sudah pernah dijalankan,
    // tidak perlu membuat stream baru.
    if (_isStarted) {
      return userPosition.value != null;
    }

    try {
      // =================================================
      // CEK LOCATION SERVICE
      // =================================================

      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        debugPrint(
          'LOCATION ERROR: Location service tidak aktif.',
        );

        return false;
      }

      // =================================================
      // CEK PERMISSION
      // =================================================

      LocationPermission permission =
          await Geolocator.checkPermission();

      debugPrint(
        'LOCATION PERMISSION: $permission',
      );

      if (permission ==
          LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();

        debugPrint(
          'LOCATION PERMISSION AFTER REQUEST: '
          '$permission',
        );
      }

      if (permission ==
              LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {
        debugPrint(
          'LOCATION ERROR: Permission lokasi ditolak.',
        );

        return false;
      }

      // =================================================
      // AMBIL POSISI SAAT INI
      // =================================================

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy:
              LocationAccuracy.high,
        ),
      );

      userPosition.value = position;

      debugPrint(
        'USER LOCATION: '
        '${position.latitude}, '
        '${position.longitude}',
      );

      // =================================================
      // LIVE LOCATION
      // =================================================

      const LocationSettings
          locationSettings =
          LocationSettings(
        accuracy:
            LocationAccuracy.high,
        distanceFilter: 10,
      );

      _locationSubscription =
          Geolocator.getPositionStream(
        locationSettings:
            locationSettings,
      ).listen(
        (Position position) {
          userPosition.value =
              position;

          debugPrint(
            'USER LOCATION UPDATE: '
            '${position.latitude}, '
            '${position.longitude}',
          );
        },
      );

      _isStarted = true;

      return true;
    } catch (e) {
      debugPrint(
        'LOCATION ERROR: $e',
      );

      return false;
    }
  }

  // =====================================================
  // FUNGSI LAMA
  // TETAP DIPERTAHANKAN
  // =====================================================

  static Future<Position?> getLokasiUser() async {
    final bool success =
        await startLiveLocation();

    if (!success) {
      return userPosition.value;
    }

    return userPosition.value;
  }

  // =====================================================
  // HITUNG JARAK
  // =====================================================

  static String hitungJarak({
    required double userLatitude,
    required double userLongitude,
    required double cafeLatitude,
    required double cafeLongitude,
  }) {
    final double distanceInMeters =
        Geolocator.distanceBetween(
      userLatitude,
      userLongitude,
      cafeLatitude,
      cafeLongitude,
    );

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    }

    final double distanceInKm =
        distanceInMeters / 1000;

    return '${distanceInKm.toStringAsFixed(1)} km';
  }

  // =====================================================
  // HITUNG JARAK LANGSUNG DARI TOKO ID
  // =====================================================

  static String hitungJarakCafe({
    required String tokoId,
    required Map<String, Map<String, String>>
        cafeData,
  }) {
    final Position? position =
        userPosition.value;

    if (position == null) {
      return 'Menghitung...';
    }

    final cafe =
        cafeData[tokoId];

    if (cafe == null) {
      return '-';
    }

    final double? latitude =
        double.tryParse(
      cafe['latitude'] ?? '',
    );

    final double? longitude =
        double.tryParse(
      cafe['longitude'] ?? '',
    );

    if (latitude == null ||
        longitude == null) {
      return '-';
    }

    return hitungJarak(
      userLatitude:
          position.latitude,
      userLongitude:
          position.longitude,
      cafeLatitude:
          latitude,
      cafeLongitude:
          longitude,
    );
  }

  // =====================================================
  // STOP GPS
  // =====================================================

  static Future<void> stopLiveLocation() async {
    await _locationSubscription?.cancel();

    _locationSubscription = null;

    _isStarted = false;
  }
}