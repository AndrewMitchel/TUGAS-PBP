import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'cafe_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // =====================================================
    // DATA FAVORITES
    // =====================================================

    final cafes = [
      [
        'Terrace Cafe',
        '4.8',
        '1.2 km',
        'assets/images/K1.jpg',
      ],
      [
        'Kopi Senja',
        '4.7',
        '0.8 km',
        'assets/images/K2.jpg',
      ],
      [
        'Lokal Coffee',
        '4.6',
        '1.5 km',
        'assets/images/K3.jpg',
      ],
      [
        'Monopole Coffee',
        '4.5',
        '2.1 km',
        'assets/images/K6.jpg',
      ],
      [
        'Sudut Kopi',
        '4.4',
        '2.8 km',
        'assets/images/K7.jpg',
      ],
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // FAVORITES LIST
      // =====================================================

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: cafes.length,

        itemBuilder: (context, index) {
          final cafe = cafes[index];

          return GestureDetector(
            // =====================================================
            // KLIK CAFE → CAFE DETAIL
            // =====================================================

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CafeDetailPage(
                    cafeName: cafe[0],
                    rating: cafe[1],
                    distance: cafe[2],
                    imageUrl: cafe[3],
                    slogan: 'Temukan kopi favoritmu di sini.',
                  ),
                ),
              );
            },

            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(8),

              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                children: [
                  // =====================================================
                  // FOTO CAFE
                  // =====================================================

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),

                    child: Image.asset(
                      cafe[3],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,

                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          width: 70,
                          height: 70,
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

                  // =====================================================
                  // INFO CAFE
                  // =====================================================

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          cafe[0],

                          style: const TextStyle(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppTheme.yellow,
                              size: 13,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              cafe[1],

                              style: const TextStyle(
                                color: AppTheme.grey,
                                fontSize: 11,
                              ),
                            ),

                            const SizedBox(width: 10),

                            const Icon(
                              Icons.location_on_outlined,
                              color: AppTheme.green,
                              size: 13,
                            ),

                            const SizedBox(width: 3),

                            Text(
                              cafe[2],

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

                  // =====================================================
                  // FAVORITE ICON
                  // =====================================================

                  const Icon(
                    Icons.favorite,
                    color: AppTheme.green,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}