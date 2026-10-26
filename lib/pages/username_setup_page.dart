
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../fungsi/user_profile.dart';
import '../theme/app_theme.dart';
import 'home_page.dart';

class UsernameSetupPage extends StatefulWidget {
  const UsernameSetupPage({super.key});

  @override
  State<UsernameSetupPage> createState() => _UsernameSetupPageState();
}

class _UsernameSetupPageState extends State<UsernameSetupPage> {
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();

    final metadata = Supabase.instance.client.auth.currentUser?.userMetadata;
    final fullName = metadata?['full_name'] ?? metadata?['name'];
    final username = metadata?['username'];

    if (fullName is String) {
      fullNameController.text = fullName;
    }

    if (username is String) {
      usernameController.text = username;
    }
  }

  Future<void> save() async {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();

    if (fullName.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama lengkap dan username wajib diisi.'),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await UserProfile.saveProfileDetails(
        fullName: fullName,
        username: username,
      );

      if (!mounted) return;

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage(username: username),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Gagal menyimpan profil: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      final errorMessage = e.toString().toLowerCase();

      String message;

      if (errorMessage.contains('profiles_username_key') ||
          errorMessage.contains('duplicate key value') ||
          errorMessage.contains('23505')) {
        message =
            'Username is already taken. Please choose another username.';
      } else {
        message = 'Gagal menyimpan profil. Silakan coba lagi.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.coffee,
                      color: AppTheme.green,
                      size: 58,
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Satu langkah lagi!',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lengkapi profil sekali saja. Setelah disimpan, kamu langsung masuk ke CoffeeSpot tanpa perlu login lagi.',
                      style: TextStyle(
                        color: AppTheme.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 26),
                    TextField(
                      controller: fullNameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Nama lengkap',
                        prefixIcon: const Icon(
                          Icons.badge_outlined,
                          color: AppTheme.green,
                        ),
                        filled: true,
                        fillColor: AppTheme.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    TextField(
                      controller: usernameController,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(
                          Icons.alternate_email,
                          color: AppTheme.green,
                        ),
                        filled: true,
                        fillColor: AppTheme.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Simpan dan lanjutkan'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
