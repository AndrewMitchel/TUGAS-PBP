import 'package:flutter/material.dart';

import '../models/model.dart';
import '../pages/explore_page.dart';
import '../pages/favorites_page.dart';
import '../pages/profile_page.dart';
import '../theme/app_theme.dart';

class Navbar extends StatelessWidget {
  final String username;

  const Navbar({
    super.key,
    required this.username,
  });

  // =====================================================
  // DATA NAVBAR
  // =====================================================

  static const List<NavItem> navItems = [
    NavItem(
      icon: Icons.home_outlined,
      label: 'Home',
    ),
    NavItem(
      icon: Icons.search,
      label: 'Explore',
    ),
    NavItem(
      icon: Icons.favorite_border,
      label: 'Favorites',
    ),
    NavItem(
      icon: Icons.person_outline,
      label: 'Profile',
    ),
  ];

  // =====================================================
  // NAVBAR
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.greenDark,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            context,
            navItems[0],
            true,
          ),
          _navItem(
            context,
            navItems[1],
            false,
          ),
          _navItem(
            context,
            navItems[2],
            false,
          ),
          _navItem(
            context,
            navItems[3],
            false,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ITEM NAVBAR
  // =====================================================

  Widget _navItem(
    BuildContext context,
    NavItem item,
    bool active,
  ) {
    return GestureDetector(
      onTap: () {
        // HOME
        if (item.label == 'Home') {
          return;
        }

        // EXPLORE
        if (item.label == 'Explore') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ExplorePage(),
            ),
          );
        }

        // FAVORITES
        if (item.label == 'Favorites') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FavoritesPage(),
            ),
          );
        }

        // PROFILE
        if (item.label == 'Profile') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(
                username: username,
              ),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            color: Colors.white,
            size: 21,
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              color: active
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.6),
              fontSize: 10,
              fontWeight: active
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}