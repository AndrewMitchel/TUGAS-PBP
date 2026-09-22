import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// =====================================================
// LOKASI USER FUNCTION
// =====================================================

class LokasiUserFunction {
  // =====================================================
  // AMBIL LOKASI USER
  // =====================================================

  static Future<String> getLokasiUser() async {
    try {
      // =====================================================
      // CEK LOCATION SERVICE
      // =====================================================

      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return 'Location tidak aktif';
      }

      // =====================================================
      // CEK PERMISSION
      // =====================================================

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return 'Permission ditolak';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return 'Permission ditolak permanen';
      }

      // =====================================================
      // AMBIL KOORDINAT USER
      // =====================================================

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          // LOW cukup karena kita hanya membutuhkan
          // nama kecamatan dan kabupaten/kota
          accuracy: LocationAccuracy.low,
        ),
      );

      // =====================================================
      // REVERSE GEOCODING
      // KOORDINAT -> NAMA LOKASI
      // =====================================================

      final Uri url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${position.latitude}'
        '&lon=${position.longitude}'
        '&format=json'
        '&addressdetails=1',
      );

      // =====================================================
      // REQUEST KE OPENSTREETMAP
      // =====================================================

      final response = await http.get(
        url,
      ).timeout(
        const Duration(seconds: 10),
      );

      // =====================================================
      // CEK RESPONSE
      // =====================================================

      if (response.statusCode != 200) {
        return 'Gagal mengambil alamat';
      }

      // =====================================================
      // UBAH RESPONSE MENJADI JSON
      // =====================================================

      final Map<String, dynamic> data =
          jsonDecode(response.body);

      final Map<String, dynamic> address =
          data['address'] ?? {};

      // =====================================================
      // AMBIL NAMA KECAMATAN
      // =====================================================

      final String kecamatan =
          address['suburb'] ??
          address['district'] ??
          address['city_district'] ??
          '';

      // =====================================================
      // AMBIL NAMA KABUPATEN / KOTA
      // =====================================================

      final String kabupatenKota =
          address['city'] ??
          address['town'] ??
          address['municipality'] ??
          '';

      // =====================================================
      // GABUNGKAN KECAMATAN + KABUPATEN/KOTA
      // =====================================================

      if (kecamatan.isNotEmpty &&
          kabupatenKota.isNotEmpty) {
        return '$kecamatan, $kabupatenKota';
      }

      // =====================================================
      // KALAU KECAMATAN TIDAK DITEMUKAN
      // =====================================================

      if (kabupatenKota.isNotEmpty) {
        return kabupatenKota;
      }

      // =====================================================
      // KALAU KABUPATEN/KOTA TIDAK DITEMUKAN
      // =====================================================

      if (kecamatan.isNotEmpty) {
        return kecamatan;
      }

      return 'Lokasi tidak ditemukan';
    } catch (e) {
      // =====================================================
      // KALAU TERJADI ERROR
      // =====================================================

      return 'Gagal mendapatkan lokasi';
    }
  }
}