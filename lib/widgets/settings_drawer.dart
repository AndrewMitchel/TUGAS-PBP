import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../pages/edit_profile_page.dart';

// =====================================================
// SETTINGS DRAWER
// =====================================================

class SettingsDrawer extends StatelessWidget {
  final String username;

  const SettingsDrawer({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // =====================================================
      // WARNA DRAWER
      // =====================================================

      backgroundColor: AppTheme.background,

      child: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(
                20,
                25,
                20,
                25,
              ),

              color: AppTheme.card,

              child: const Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    color: AppTheme.green,
                    size: 25,
                  ),

                  SizedBox(width: 12),

                  Text(
                    'Settings',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // ACCOUNT
            // =====================================================

            _sectionTitle('Account'),

            // =====================================================
            // EDIT PROFILE
            // =====================================================

            _settingMenu(
              context,
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(
                      username: username,
                    ),
                  ),
                );
              },
            ),

            // =====================================================
            // DELETE ACCOUNT
            // =====================================================

            _settingMenu(
              context,
              icon: Icons.delete_outline,
              title: 'Delete Account',
              onTap: () {
                _showDeleteDialog(context);
              },
            ),

            const Spacer(),

            // =====================================================
            // ABOUT
            // =====================================================

            _settingMenu(
              context,
              icon: Icons.info_outline,
              title: 'About Coffee Finder',
              onTap: () {
                showAboutDialog(
                  context: context,

                  applicationName:
                      'Coffee Finder',

                  applicationVersion:
                      '1.0.0',

                  applicationLegalese:
                      'Coffee recommendation application.',
                );
              },
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // SECTION TITLE
  // =====================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        8,
      ),

      child: Align(
        alignment: Alignment.centerLeft,

        child: Text(
          title,

          style: const TextStyle(
            color: AppTheme.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // SETTING MENU
  // =====================================================

  Widget _settingMenu(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,

      leading: Icon(
        icon,
        color: AppTheme.grey,
        size: 21,
      ),

      title: Text(
        title,

        style: const TextStyle(
          color: AppTheme.white,
          fontSize: 13,
        ),
      ),

      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.grey,
        size: 19,
      ),
    );
  }

  // =====================================================
  // DELETE ACCOUNT DIALOG
  // =====================================================

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.card,

          title: const Text(
            'Delete Account?',

            style: TextStyle(
              color: AppTheme.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            'This action will permanently delete your account.',

            style: TextStyle(
              color: AppTheme.grey,
              fontSize: 13,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text(
                'Cancel',

                style: TextStyle(
                  color: AppTheme.grey,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                // =====================================================
                // NANTI DISAMBUNGKAN KE API / DATABASE
                // =====================================================

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Delete account belum terhubung ke database.',
                    ),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}