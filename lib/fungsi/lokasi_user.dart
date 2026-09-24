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
        permission =
            await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return 'Permission ditolak';
        }
      }

      if (permission ==
          LocationPermission.deniedForever) {
        return 'Permission ditolak permanen';
      }

      // =====================================================
      // AMBIL KOORDINAT USER
      // =====================================================

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy:
              LocationAccuracy.medium,
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
        '&addressdetails=1'
        '&accept-language=id',
      );

      // =====================================================
      // REQUEST KE OPENSTREETMAP
      // =====================================================

      final response = await http
          .get(
        url,
        headers: {
          'User-Agent':
              'CoffeeFinder/1.0',
          'Accept':
              'application/json',
        },
      )
          .timeout(
        const Duration(
          seconds: 10,
        ),
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

      // =====================================================
      // AMBIL ADDRESS
      // =====================================================

      final Map<String, dynamic> address =
          data['address'] != null
              ? Map<String, dynamic>.from(
                  data['address'],
                )
              : {};

      // =====================================================
      // AMBIL NAMA KECAMATAN
      // =====================================================

      final String kecamatan =
          address['suburb']?.toString() ??
          address['district']?.toString() ??
          address['city_district']?.toString() ??
          address['village']?.toString() ??
          '';

      // =====================================================
      // AMBIL NAMA KABUPATEN / KOTA
      // =====================================================

      final String kabupatenKota =
          address['city']?.toString() ??
          address['town']?.toString() ??
          address['municipality']?.toString() ??
          address['county']?.toString() ??
          '';

      // =====================================================
      // GABUNGKAN KECAMATAN + KABUPATEN/KOTA
      // =====================================================

      if (kecamatan.isNotEmpty &&
          kabupatenKota.isNotEmpty) {
        return '$kecamatan, $kabupatenKota';
      }

      // =====================================================
      // KALAU HANYA KABUPATEN / KOTA
      // =====================================================

      if (kabupatenKota.isNotEmpty) {
        return kabupatenKota;
      }

      // =====================================================
      // KALAU HANYA KECAMATAN
      // =====================================================

      if (kecamatan.isNotEmpty) {
        return kecamatan;
      }

      // =====================================================
      // FALLBACK
      // AMBIL DISPLAY NAME DARI NOMINATIM
      // =====================================================

      final String displayName =
          data['display_name']?.toString() ?? '';

      if (displayName.isNotEmpty) {
        return displayName;
      }

      // =====================================================
      // LOKASI BENAR-BENAR TIDAK DITEMUKAN
      // =====================================================

      return 'Lokasi tidak ditemukan';
    } catch (e) {
      // =====================================================
      // KALAU TERJADI ERROR
      // =====================================================

      return 'Gagal mendapatkan lokasi';
    }
  }
}