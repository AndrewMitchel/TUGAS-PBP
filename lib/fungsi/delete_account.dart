import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteAccountService {
  static Future<void> deleteAccount() async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    if (session == null) {
      throw Exception(
        'Sesi login sudah berakhir. Silakan login kembali.',
      );
    }

    final response = await supabase.functions.invoke(
      'delete-account',
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.status < 200 || response.status >= 300) {
      final data = response.data;

      final message = data is Map
          ? data['error']?.toString()
          : null;

      throw Exception(
        message ?? 'Gagal menghapus akun.',
      );
    }

    final data = response.data;

    if (data is Map && data['success'] != true) {
      throw Exception(
        data['error']?.toString() ??
            'Penghapusan akun belum dikonfirmasi server.',
      );
    }

    await supabase.auth.signOut();
  }
}
