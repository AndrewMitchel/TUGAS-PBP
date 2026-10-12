import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Profil pengguna tersimpan di tabel Supabase `profiles`.
class UserProfile {
  static final ValueNotifier<String?> username = ValueNotifier<String?>(null);
  static final ValueNotifier<XFile?> profilePhoto = ValueNotifier<XFile?>(null);
  static final ValueNotifier<String?> avatarUrl = ValueNotifier<String?>(null);

  static SupabaseClient get _db => Supabase.instance.client;

  static Future<Map<String, dynamic>?> load() async {
    final user = _db.auth.currentUser;
    if (user == null) return null;
    try {
      final row = await _db.from('profiles').select().eq('id', user.id).maybeSingle();
      if (row == null) return null;
      final name = (row['username'] ?? '').toString().trim();
      username.value = name.isEmpty ? null : name;
      avatarUrl.value = row['avatar_url']?.toString();
      return Map<String, dynamic>.from(row);
    } catch (e) {
      debugPrint('Gagal memuat profil: $e');
      rethrow;
    }
  }

  static Future<void> saveUsername(String newUsername) async {
    final user = _db.auth.currentUser;
    if (user == null) throw const AuthException('Silakan login kembali.');
    final clean = newUsername.trim();
    if (clean.isEmpty) throw const AuthException('Username tidak boleh kosong.');
    await _db.from('profiles').upsert({
      'id': user.id,
      'username': clean,
      'email': user.email,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
    await _db.auth.updateUser(UserAttributes(data: {'username': clean}));
    username.value = clean;
  }

  static Future<void> saveProfilePhoto(XFile photo) async {
    final user = _db.auth.currentUser;
    if (user == null) throw const AuthException('Silakan login kembali.');
    final bytes = await photo.readAsBytes();
    final extension = photo.name.contains('.') ? photo.name.split('.').last : 'jpg';
    final objectPath = '${user.id}/avatar.$extension';
    await _db.storage.from('avatars').uploadBinary(
      objectPath,
      bytes,
      fileOptions: FileOptions(
        upsert: true,
        contentType: photo.mimeType ?? 'image/jpeg',
      ),
    );
    final url = _db.storage.from('avatars').getPublicUrl(objectPath);
    await _db.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
      'avatar_url': url,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
    profilePhoto.value = photo;
    avatarUrl.value = url;
  }

  static void setUsername(String newUsername) => username.value = newUsername;
  static void setProfilePhoto(XFile photo) => profilePhoto.value = photo;

  static void clear() {
    username.value = null;
    profilePhoto.value = null;
    avatarUrl.value = null;
  }
}
