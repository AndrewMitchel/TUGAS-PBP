import 'package:flutter/material.dart';

import '../models/list_data.dart';
import '../theme/app_theme.dart';
import 'cafe_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // =====================================================
    // DATA FAVORITES
    // =====================================================

    final favoriteCafes = [
      'toko1',
      'toko2',
      'toko3',
      'toko6',
      'toko7',
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
        itemCount: favoriteCafes.length,
        itemBuilder: (context, index) {
          final tokoId = favoriteCafes[index];
          final cafe = cafeData[tokoId]!;

          return GestureDetector(
            // =====================================================
            // KLIK CAFE → CAFE DETAIL
            // =====================================================

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
                    mapUrl: cafe['mapUrl']!,
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
                      cafe['image']!,
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
                          cafe['name']!,
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
                              cafe['rating']!,
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
                              cafe['distance']!,
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