import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  final String username;

  const ProfilePage({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.card,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.green,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: AppTheme.grey,
              ),
            ),
          ),

          const SizedBox(height: 15),

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

          const Center(
            child: Text(
              'Coffee Explorer',
              style: TextStyle(
                color: AppTheme.grey,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(
                  number: '12',
                  label: 'Visited',
                ),
                _Stat(
                  number: '5',
                  label: 'Favorites',
                ),
                _Stat(
                  number: '3',
                  label: 'Reviews',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _menu(
            Icons.favorite_border,
            'My Favorites',
          ),

          _menu(
            Icons.location_on_outlined,
            'Visited Places',
          ),

          _menu(
            Icons.settings_outlined,
            'Settings',
          ),

          _menu(
            Icons.help_outline,
            'Help & Support',
          ),

          _menu(
            Icons.logout,
            'Log Out',
          ),
        ],
      ),
    );
  }

  Widget _menu(
    IconData icon,
    String title,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.grey,
            size: 20,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 13,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppTheme.grey,
            size: 19,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String number;
  final String label;

  const _Stat({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: AppTheme.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}