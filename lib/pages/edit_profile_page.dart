import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../fungsi/user_profile.dart';
import '../theme/app_theme.dart';

// =====================================================
// EDIT PROFILE PAGE
// =====================================================

class EditProfilePage extends StatefulWidget {
  final String username;

  const EditProfilePage({
    super.key,
    required this.username,
  });

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {
  // =====================================================
  // USERNAME CONTROLLER
  // =====================================================

  late TextEditingController usernameController;

  // =====================================================
  // IMAGE PICKER
  // =====================================================

  final ImagePicker imagePicker =
      ImagePicker();

  // =====================================================
  // FOTO YANG SEDANG DIPILIH
  // =====================================================

  XFile? selectedPhoto;

  // =====================================================
  // DATA FOTO DALAM BYTES
  // =====================================================

  Uint8List? selectedPhotoBytes;

  @override
  void initState() {
    super.initState();

    // =====================================================
    // SET USERNAME AWAL
    // =====================================================

    usernameController =
        TextEditingController(
      text: widget.username,
    );

    // =====================================================
    // AMBIL FOTO YANG SUDAH DIPILIH
    // =====================================================

    selectedPhoto =
        UserProfile.profilePhoto.value;

    // =====================================================
    // LOAD FOTO YANG SUDAH ADA
    // =====================================================

    _loadExistingPhoto();
  }

  // =====================================================
  // LOAD FOTO EXISTING
  // =====================================================

  Future<void> _loadExistingPhoto() async {
    if (selectedPhoto == null) {
      return;
    }

    try {
      final Uint8List bytes =
          await selectedPhoto!.readAsBytes();

      if (!mounted) {
        return;
      }

      setState(() {
        selectedPhotoBytes = bytes;
      });
    } catch (e) {
      // Foto tidak bisa dibaca.
      // Biarkan icon profile tetap tampil.
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  // =====================================================
  // PILIH FOTO
  // =====================================================

  Future<void> _pickPhoto() async {
    try {
      // =====================================================
      // BUKA GALLERY / FILE PICKER
      // =====================================================

      final XFile? pickedFile =
          await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      // =====================================================
      // JIKA USER MEMBATALKAN
      // =====================================================

      if (pickedFile == null) {
        return;
      }

      // =====================================================
      // BACA FOTO SEBAGAI BYTES
      // =====================================================

      final Uint8List bytes =
          await pickedFile.readAsBytes();

      // =====================================================
      // SIMPAN FOTO KE USER PROFILE
      // =====================================================

      UserProfile.setProfilePhoto(
        pickedFile,
      );

      // =====================================================
      // UPDATE FOTO LANGSUNG
      // =====================================================

      if (!mounted) {
        return;
      }

      setState(() {
        selectedPhoto = pickedFile;
        selectedPhotoBytes = bytes;
      });
    } catch (e) {
      // =====================================================
      // JIKA TERJADI ERROR
      // =====================================================

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal memilih foto.',
          ),
        ),
      );
    }
  }

  // =====================================================
  // SAVE PROFILE
  // =====================================================

  void _saveProfile() {
    final String newUsername =
        usernameController.text.trim();

    // =====================================================
    // VALIDASI USERNAME
    // =====================================================

    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Username tidak boleh kosong',
          ),
        ),
      );

      return;
    }

    // =====================================================
    // SIMPAN USERNAME
    // =====================================================

    UserProfile.setUsername(
      newUsername,
    );

    // =====================================================
    // FOTO SUDAH DISIMPAN SAAT DIPILIH
    // =====================================================

    // Tidak perlu menyimpan foto lagi di sini.

    // =====================================================
    // KEMBALI KE HALAMAN SEBELUMNYA
    // =====================================================

    Navigator.pop(context);

    // =====================================================
    // TAMPILKAN NOTIFIKASI
    // =====================================================

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Profile berhasil disimpan.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppTheme.background,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor:
            AppTheme.background,

        title: const Text(
          'Edit Profile',

          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: ListView(
        padding:
            const EdgeInsets.all(20),

        children: [
          // =====================================================
          // PROFILE PHOTO
          // =====================================================

          Center(
            child: Stack(
              children: [
                // =====================================================
                // FOTO PROFILE
                // =====================================================

                GestureDetector(
                  onTap: _pickPhoto,

                  child: Container(
                    width: 100,
                    height: 100,

                    decoration:
                        BoxDecoration(
                      color:
                          AppTheme.card,

                      shape:
                          BoxShape.circle,

                      border:
                          Border.all(
                        color:
                            AppTheme.green,

                        width: 2,
                      ),
                    ),

                    child:
                        selectedPhotoBytes != null
                            ? ClipOval(
                                child:
                                    Image.memory(
                                  selectedPhotoBytes!,

                                  width: 100,
                                  height: 100,

                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,

                                size: 50,

                                color:
                                    AppTheme.grey,
                              ),
                  ),
                ),

                // =====================================================
                // CAMERA BUTTON
                // =====================================================

                Positioned(
                  right: 0,
                  bottom: 0,

                  child:
                      GestureDetector(
                    onTap: _pickPhoto,

                    child: Container(
                      width: 32,
                      height: 32,

                      decoration:
                          const BoxDecoration(
                        color:
                            AppTheme.green,

                        shape:
                            BoxShape.circle,
                      ),

                      child:
                          const Icon(
                        Icons
                            .camera_alt_outlined,

                        color:
                            Colors.white,

                        size: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          // =====================================================
          // USERNAME LABEL
          // =====================================================

          const Text(
            'Username',

            style: TextStyle(
              color:
                  AppTheme.grey,

              fontSize: 12,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          // =====================================================
          // USERNAME FIELD
          // =====================================================

          TextField(
            controller:
                usernameController,

            style:
                const TextStyle(
              color:
                  AppTheme.white,
            ),

            decoration:
                InputDecoration(
              filled: true,

              fillColor:
                  AppTheme.card,

              prefixIcon:
                  const Icon(
                Icons.person_outline,

                color:
                    AppTheme.grey,
              ),

              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),

                borderSide:
                    BorderSide.none,
              ),
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          // =====================================================
          // SAVE BUTTON
          // =====================================================

          SizedBox(
            height: 50,

            child:
                ElevatedButton(
              onPressed:
                  _saveProfile,

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppTheme.green,

                foregroundColor:
                    Colors.white,

                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),

              child: const Text(
                'Save Changes',

                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}