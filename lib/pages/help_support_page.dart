
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'Bagaimana cara mencari coffee shop?',
      'answer':
          'Buka halaman Explore untuk melihat daftar coffee shop. Kamu dapat menggunakan fitur pencarian dan filter yang tersedia untuk menemukan tempat yang sesuai.',
    },
    {
      'question': 'Bagaimana cara menyimpan coffee shop favorit?',
      'answer':
          'Buka detail coffee shop, lalu tekan tombol favorit. Coffee shop yang kamu simpan dapat dilihat melalui halaman Favorites.',
    },
    {
      'question': 'Di mana saya bisa melihat coffee shop yang pernah dibuka?',
      'answer':
          'Buka halaman Last Viewed untuk melihat daftar coffee shop yang pernah kamu kunjungi melalui aplikasi.',
    },
    {
      'question': 'Bagaimana cara mengganti username dan foto profil?',
      'answer':
          'Buka halaman Profile, masuk ke Settings, lalu pilih Edit Profile untuk mengubah informasi profil yang tersedia.',
    },
    {
      'question': 'Bagaimana jika aplikasi mengalami masalah?',
      'answer':
          'Periksa koneksi internet, lalu coba buka kembali halaman yang bermasalah. Jika masalah tetap terjadi, salin pesan bantuan di bawah dan simpan untuk dikirim ke tim pengembang.',
    },
    {
      'question': 'Bagaimana cara menghapus akun?',
      'answer':
          'Buka Settings pada halaman Profile, pilih Delete Account, kemudian konfirmasikan penghapusan. Penghapusan akun bersifat permanen.',
    },
  ];

  static const String _supportMessage =
      'Halo tim pengembang Coffee Finder,\n\n'
      'Saya mengalami kendala saat menggunakan aplikasi.\n\n'
      'Jenis kendala:\n'
      'Halaman yang bermasalah:\n'
      'Langkah yang sudah dicoba:\n'
      'Pesan error (jika ada):\n'
      'Perangkat:\n\n'
      'Mohon bantuannya. Terima kasih.';

  Future<void> _copySupportMessage(BuildContext context) async {
    await Clipboard.setData(
      const ClipboardData(text: _supportMessage),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Pesan bantuan berhasil disalin. Kamu bisa menyimpannya atau mengirimkannya kepada pengembang.',
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.white,
        elevation: 0,
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.support_agent,
                    color: AppTheme.green,
                    size: 42,
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Ada yang bisa kami bantu?',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Temukan jawaban melalui FAQ berikut atau salin pesan bantuan jika kamu mengalami kendala.',
                    style: TextStyle(
                      color: AppTheme.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._faqs.map(
              (faq) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    iconColor: AppTheme.green,
                    collapsedIconColor: AppTheme.grey,
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      16,
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          faq['answer']!,
                          style: const TextStyle(
                            color: AppTheme.grey,
                            height: 1.6,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppTheme.green.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.mail_outline,
                        color: AppTheme.green,
                        size: 25,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Butuh bantuan lebih lanjut?',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Salin format pesan berikut. Isi detail kendala sebelum mengirimkannya kepada pengembang.',
                    style: TextStyle(
                      color: AppTheme.grey,
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _copySupportMessage(context),
                      icon: const Icon(Icons.copy),
                      label: const Text('Salin Pesan Bantuan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
