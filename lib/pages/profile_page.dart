import 'package:flutter/material.dart';
import 'package:flutter_application_1/fungsi/favorite.dart';
import 'lastviewed_page.dart';
import '../fungsi/favorite.dart';
import '../fungsi/lastviewed.dart';
import '../theme/app_theme.dart';
import 'favorites_page.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        backgroundColor: AppTheme.background,

        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          // =====================================================
          // PROFILE IMAGE
          // =====================================================
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.card,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.green, width: 2),
              ),
              child: const Icon(Icons.person, size: 40, color: AppTheme.grey),
            ),
          ),

          const SizedBox(height: 15),

          // =====================================================
          // USERNAME
          // =====================================================
          Center(
            child: Text(
              username,
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 5),

          // =====================================================
          // PROFILE DESCRIPTION
          // =====================================================
          const Center(
            child: Text(
              'Coffee Explorer',
              style: TextStyle(color: AppTheme.grey, fontSize: 12),
            ),
          ),

          const SizedBox(height: 20),

          // =====================================================
          // MY FAVORITES
          // =====================================================
          _menu(Icons.favorite_border, 'My Favorites', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            );
          }),

          // =====================================================
          // LAST VIEWED
          // =====================================================
          _menu(Icons.location_on_outlined, 'Last Viewed', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LastViewedPage()),
            );
          }),
          // =====================================================
          // HELP & SUPPORT
          // =====================================================
          _menu(Icons.help_outline, 'Help & Support', () {}),

          // =====================================================
          // LOG OUT
          // =====================================================
          _menu(Icons.logout, 'Log Out', () {
            // =====================================================
            // LOGOUT POPUP
            // =====================================================

            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.transparent,

                  child: Container(
                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(22),

                      border: Border.all(
                        color: AppTheme.green.withValues(alpha: 0.25),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // =====================================================
                        // LOGOUT ICON
                        // =====================================================

                        Container(
                          width: 58,
                          height: 58,

                          decoration: BoxDecoration(
                            color: AppTheme.green.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.logout_rounded,
                            color: AppTheme.green,
                            size: 27,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // =====================================================
                        // TITLE
                        // =====================================================
                        const Text(
                          'Log Out?',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // =====================================================
                        // DESCRIPTION
                        // =====================================================
                        const Text(
                          'Are you sure you want to log out\n'
                          'from your account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.grey,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // =====================================================
                        // BUTTON
                        // =====================================================
                        Row(
                          children: [
                            // =====================================================
                            // CANCEL BUTTON
                            // =====================================================

                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },

                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.white,

                                  side: BorderSide(
                                    color: AppTheme.grey.withValues(alpha: 0.3),
                                  ),

                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),

                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // =====================================================
                            // LOGOUT BUTTON
                            // =====================================================
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Tutup popup
                                  FavoriteFunction.clearFavorites();
                                  LastViewedFunction.clearLastViewed();
                                  Navigator.pop(context);

                                  // Kembali ke halaman Login
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginPage(),
                                    ),
                                  );
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.green,
                                  foregroundColor: Colors.white,
                                  elevation: 0,

                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),

                                child: const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // =====================================================
  // MENU PROFILE
  // =====================================================

  Widget _menu(IconData icon, String title, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(14),
        ),

        child: Row(
          children: [
            Icon(icon, color: AppTheme.grey, size: 20),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: AppTheme.white, fontSize: 13),
              ),
            ),

            const Icon(Icons.chevron_right, color: AppTheme.grey, size: 19),
          ],
        ),
      ),
    );
  }
}
