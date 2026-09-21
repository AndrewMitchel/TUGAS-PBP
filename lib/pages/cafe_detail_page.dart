import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CafeDetailPage extends StatelessWidget {
  final String cafeName;
  final String rating;
  final String distance;
  final String imageUrl;
  final String slogan;

  const CafeDetailPage({
    super.key,
    required this.cafeName,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    required this.slogan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =====================================================
                  // CAFE NAME + RATING
                  // =====================================================

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cafeName,
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        color: AppTheme.yellow,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: AppTheme.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // =====================================================
                  // DISTANCE
                  // =====================================================

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppTheme.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$distance away',
                        style: const TextStyle(
                          color: AppTheme.grey,
                        ),
                      ),
                    ],
                  ),

                  // =====================================================
                  // SLOGAN
                  // =====================================================

                 

                  const SizedBox(height: 22),

                  // =====================================================
                  // TAGS
                  // =====================================================

                  Row(
                    children: [
                      _tag(Icons.coffee, 'Coffee'),
                      _tag(Icons.restaurant, 'Food'),
                      _tag(Icons.wifi, 'WiFi'),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // =====================================================
                  // ABOUT
                  // =====================================================

                  const Text(
                    'About',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    slogan,
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =====================================================
                  // FACILITIES
                  // =====================================================

                  const Text(
                    'Fasilitas',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _facility(Icons.coffee, 'Coffee'),
                      _facility(Icons.wifi, 'WiFi'),
                      _facility(Icons.power, 'Outlet'),
                      _facility(Icons.ac_unit, 'AC'),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // =====================================================
                  // VIEW LOCATION
                  // =====================================================

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'View Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // TAG
  // =====================================================

  Widget _tag(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(right: 7),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.green,
            size: 13,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // FACILITY
  // =====================================================

  Widget _facility(IconData icon, String text) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.grey,
              size: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}