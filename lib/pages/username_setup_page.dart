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
  final controller = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    final metadataName = Supabase.instance.client.auth.currentUser?.userMetadata?['full_name'] ??
        Supabase.instance.client.auth.currentUser?.userMetadata?['name'];
    if (metadataName is String) controller.text = metadataName;
  }

  Future<void> save() async {
    final name = controller.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama/username wajib diisi.')));
      return;
    }
    setState(() => loading = true);
    try {
      await UserProfile.saveUsername(name);
      await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage(username: name)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan username. Pastikan tabel profiles sudah disiapkan.')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.background,
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 430), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.coffee, color: AppTheme.green, size: 58),
          const SizedBox(height: 22),
          const Text('Satu langkah lagi!', style: TextStyle(color: AppTheme.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tentukan nama yang akan tampil di halaman utama. Nama ini bisa diubah nanti di Settings.',
            style: TextStyle(color: AppTheme.grey, height: 1.5)),
          const SizedBox(height: 26),
          TextField(controller: controller, textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Nama / username',
              prefixIcon: const Icon(Icons.person_outline, color: AppTheme.green),
              filled: true, fillColor: AppTheme.card,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            )),
          const SizedBox(height: 18),
          SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
            onPressed: loading ? null : save,
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.green, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Simpan dan lanjutkan'),
          )),
        ],
      )),
    ))),
  );
}
