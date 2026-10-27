import 'package:flutter/material.dart';

import '../fungsi/delete_account.dart';
import '../theme/app_theme.dart';
import '../pages/edit_profile_page.dart';
import '../pages/login_page.dart';

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
      backgroundColor: AppTheme.background,
      child: SafeArea(
        child: Column(
          children: [
            // HEADER
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

            // ACCOUNT
            _sectionTitle('Account'),

            // EDIT PROFILE
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

            // DELETE ACCOUNT
            _settingMenu(
              context,
              icon: Icons.delete_outline,
              title: 'Delete Account',
              onTap: () {
                _showDeleteDialog(context);
              },
            ),

            const Spacer(),

            // ABOUT
            _settingMenu(
              context,
              icon: Icons.info_outline,
              title: 'About Coffee Spot',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Coffee Spot by Andrew',
                  applicationVersion: '1.0.0',
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
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        bool isDeleting = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                'This action will permanently delete your account and its associated data. This cannot be undone.',
                style: TextStyle(
                  color: AppTheme.grey,
                  fontSize: 13,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () {
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
                  onPressed: isDeleting
                      ? null
                      : () async {
                          setDialogState(() {
                            isDeleting = true;
                          });

                          try {
                            await DeleteAccountService.deleteAccount();

                            if (!context.mounted) return;

                            Navigator.of(dialogContext).pop();

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Akun berhasil dihapus.',
                                  ),
                                ),
                              );

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute<void>(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          } catch (error) {
                            if (!context.mounted) return;

                            setDialogState(() {
                              isDeleting = false;
                            });

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Gagal menghapus akun: $error',
                                  ),
                                ),
                              );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: isDeleting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}