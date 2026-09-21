import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/background.dart';
import 'cafe_detail_page.dart';
import 'explore_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, required this.username});

  // =====================================================
  // DATA RECOMMENDED
  // =====================================================

  static const List<Map<String, String>> recommendedCafes = [
    {
      'name': 'Terrace Cafe',
      'distance': '1.2 km',
      'rating': '4.8',
      'image': 'assets/images/K1.jpg',
      'slogan': 'Nikmati kopi dalam suasana yang tenang.',
    },
    {
      'name': 'Kopi Senja',
      'distance': '0.9 km',
      'rating': '4.7',
      'image': 'assets/images/K2.jpg',
      'slogan': 'Secangkir kopi untuk menemani hari.',
    },
    {
      'name': 'Lokal Coffee',
      'distance': '1.5 km',
      'rating': '4.6',
      'image': 'assets/images/K3.jpg',
      'slogan': 'Rasa lokal, cerita yang berkesan.',
    },
    {
      'name': 'Kopi Tengah',
      'distance': '1.8 km',
      'rating': '4.7',
      'image': 'assets/images/K4.jpg',
      'slogan': 'Temukan waktu terbaik di tengah kesibukan.',
    },
  ];

  // =====================================================
  // DATA TRENDING
  // =====================================================

  static const List<Map<String, String>> trendingCafes = [
    {
      'name': 'Calibre Coffee',
      'rating': '4.8',
      'distance': '0.9 km',
      'image': 'assets/images/K5.jpg',
      'slogan': 'Coffee made for your everyday moments.',
    },
    {
      'name': 'Monopole Coffee',
      'rating': '4.6',
      'distance': '1.5 km',
      'image': 'assets/images/K6.jpg',
      'slogan': 'A little coffee, a better day.',
    },
    {
      'name': 'Sudut Kopi',
      'rating': '4.5',
      'distance': '2.1 km',
      'image': 'assets/images/K7.jpg',
      'slogan': 'Tempat sederhana untuk cerita luar biasa.',
    },
    {
      'name': 'Satu Hari Kopi',
      'rating': '4.5',
      'distance': '2.4 km',
      'image': 'assets/images/K8.jpg',
      'slogan': 'Satu hari, satu cerita, satu cangkir kopi.',
    },
    {
      'name': 'Kopi Rumah',
      'rating': '4.7',
      'distance': '2.8 km',
      'image': 'assets/images/K9.jpg',
      'slogan': 'Rasa nyaman seperti di rumah sendiri.',
    },
    {
      'name': 'Kopi Kecil',
      'rating': '5.0',
      'distance': '3.0 km',
      'image': 'assets/images/K10.jpg',
      'slogan': 'Kecil tempatnya, besar rasanya.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: Background(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =====================================================
                // HEADER
                // =====================================================

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $username',
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Mau ngopi kemana hari ini?',
                            style: TextStyle(
                              color: AppTheme.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppTheme.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // =====================================================
                // LOCATION
                // =====================================================

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppTheme.green,
                      size: 16,
                    ),

                    const SizedBox(width: 5),

                    const Text(
                      'Surabaya, Indonesia',
                      style: TextStyle(
                        color: AppTheme.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // =====================================================
                // SEARCH
                // =====================================================

                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.green.withValues(alpha: 0.10),
                    ),
                  ),
                  child: const TextField(
                    style: TextStyle(color: AppTheme.white),
                    decoration: InputDecoration(
                      hintText: 'Search coffee shop...',
                      hintStyle: TextStyle(
                        color: AppTheme.grey,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppTheme.green,
                        size: 20,
                      ),
                      suffixIcon: Icon(
                        Icons.tune,
                        color: AppTheme.green,
                        size: 19,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // RECOMMENDED
                // =====================================================

                _sectionTitle('Recommended', 'See all'),

                const SizedBox(height: 13),

                SizedBox(
                  height: 205,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendedCafes.length,
                    itemBuilder: (context, index) {
                      final cafe = recommendedCafes[index];

                      return _coffeeCard(
                        context,
                        cafe['name']!,
                        cafe['distance']!,
                        cafe['rating']!,
                        cafe['image']!,
                        cafe['slogan']!,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // TRENDING COFFEE
                // =====================================================

                _sectionTitle('Trending Coffee', 'See all'),

                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trendingCafes.length,
                  itemBuilder: (context, index) {
                    final cafe = trendingCafes[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CafeDetailPage(
                              cafeName: cafe['name']!,
                              rating: cafe['rating']!,
                              distance: cafe['distance']!,
                              imageUrl: cafe['image']!,
                              slogan: cafe['slogan']!,
                            ),
                          ),
                        );
                      },
                      child: _trendingCard(
                        cafe['name']!,
                        cafe['rating']!,
                        cafe['distance']!,
                        cafe['image']!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // =====================================================
      // BOTTOM NAVIGATION
      // =====================================================

      bottomNavigationBar: _bottomNavigation(context),
    );
  }

  // =====================================================
  // SECTION TITLE
  // =====================================================

  Widget _sectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          action,
          style: const TextStyle(
            color: AppTheme.green,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // =====================================================
  // COFFEE CARD
  // =====================================================

  Widget _coffeeCard(
    BuildContext context,
    String name,
    String distance,
    String rating,
    String image,
    String slogan,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CafeDetailPage(
              cafeName: name,
              rating: rating,
              distance: distance,
              imageUrl: image,
              slogan: slogan,
            ),
          ),
        );
      },

      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.green.withValues(alpha: 0.10),
          ),
        ),
        clipBehavior: Clip.antiAlias,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 135,
              width: double.infinity,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.cardLight,
                    child: const Icon(
                      Icons.coffee,
                      color: AppTheme.green,
                      size: 40,
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(11),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppTheme.yellow,
                        size: 13,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        rating,
                        style: const TextStyle(
                          color: AppTheme.grey,
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Icon(
                        Icons.location_on,
                        color: AppTheme.green,
                        size: 13,
                      ),

                      const SizedBox(width: 2),

                      Text(
                        distance,
                        style: const TextStyle(
                          color: AppTheme.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // TRENDING CARD
  // =====================================================

  Widget _trendingCard(
    String name,
    String rating,
    String distance,
    String image,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),

      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.green.withValues(alpha: 0.10),
        ),
      ),

      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: Image.asset(
              image,
              width: 62,
              height: 62,
              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 62,
                  height: 62,
                  color: AppTheme.cardLight,
                  child: const Icon(
                    Icons.coffee,
                    color: AppTheme.green,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppTheme.yellow,
                      size: 12,
                    ),

                    const SizedBox(width: 3),

                    Text(
                      rating,
                      style: const TextStyle(
                        color: AppTheme.grey,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Icon(
                      Icons.location_on_outlined,
                      color: AppTheme.green,
                      size: 12,
                    ),

                    const SizedBox(width: 3),

                    Text(
                      distance,
                      style: const TextStyle(
                        color: AppTheme.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              color: AppTheme.green,
              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // BOTTOM NAVIGATION
  // =====================================================

  Widget _bottomNavigation(BuildContext context) {
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
            Icons.home_outlined,
            'Home',
            true,
            null,
          ),

          _navItem(
            Icons.search,
            'Explore',
            false,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExplorePage(),
                ),
              );
            },
          ),

          _navItem(
            Icons.favorite_border,
            'Favorites',
            false,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
          ),

          _navItem(
            Icons.person_outline,
            'Profile',
            false,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(
                    username: username,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // =====================================================
  // NAV ITEM
  // =====================================================

  Widget _navItem(
    IconData icon,
    String label,
    bool active,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),

          const SizedBox(height: 4),

          Text(
            label,
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