import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

// =====================================================
// USER PROFILE
// =====================================================

class UserProfile {
  // =====================================================
  // USERNAME AKTIF
  // =====================================================

  static final ValueNotifier<String?> username =
      ValueNotifier<String?>(null);

  // =====================================================
  // FOTO PROFILE
  // =====================================================

  // Foto disimpan sebagai XFile selama aplikasi berjalan.
  // Tidak disimpan ke database / local storage.
  static final ValueNotifier<XFile?> profilePhoto =
      ValueNotifier<XFile?>(null);

  // =====================================================
  // SET USERNAME
  // =====================================================

  static void setUsername(String newUsername) {
    username.value = newUsername;
  }

  // =====================================================
  // SET FOTO PROFILE
  // =====================================================

  static void setProfilePhoto(XFile photo) {
    profilePhoto.value = photo;
  }

  // =====================================================
  // CLEAR DATA
  // =====================================================

  static void clear() {
    username.value = null;
    profilePhoto.value = null;
  }
}
