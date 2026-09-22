import 'package:flutter/material.dart';

import '../models/list_data.dart';
import '../models/recommended_data.dart';
import '../models/trending_data.dart';
import '../theme/app_theme.dart';
import 'cafe_detail_page.dart';

// =====================================================
// LIST CAFE PAGE
// =====================================================

class ListCafePage extends StatelessWidget {
  final String type;

  const ListCafePage({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {

    // =====================================================
    // PILIH DATA
    // =====================================================

    final List<String> cafeList;

    if (type == 'recommended') {
      cafeList = recommendedCafes;
    } else {
      cafeList = trendingCafes;
    }

    // =====================================================
    // JUDUL HALAMAN
    // =====================================================

    final String title =
        type == 'recommended'
            ? 'Recommended'
            : 'Trending';

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.white,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // LIST CAFE
      // =====================================================

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: cafeList.length,

        itemBuilder: (context, index) {

          final String tokoId = cafeList[index];

          // Ambil detail cafe dari list_data.dart
          final cafe = cafeData[tokoId];

          // Kalau ID tidak ditemukan
          if (cafe == null) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 15),

            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CafeDetailPage(
                      tokoId: tokoId,
                      cafeName: cafe['name']!,
                      rating: cafe['rating']!,
                      distance: cafe['distance']!,
                      imageUrl: cafe['image']!,
                      about: cafe['about']!,
                      mapUrl: cafe['mapUrl']!,
                    ),
                  ),
                );
              },

              child: Container(
                height: 130,

                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(16),
                ),

                clipBehavior: Clip.antiAlias,

                child: Row(
                  children: [

                    // =====================================================
                    // FOTO
                    // =====================================================

                    SizedBox(
                      width: 120,
                      height: 130,

                      child: Image.asset(
                        cafe['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // =====================================================
                    // INFORMASI
                    // =====================================================

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(13),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              cafe['name']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                color: AppTheme.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Row(
                              children: [

                                const Icon(
                                  Icons.star,
                                  color: AppTheme.yellow,
                                  size: 15,
                                ),

                                const SizedBox(width: 4),

                                Text(
                                  cafe['rating']!,
                                  style: const TextStyle(
                                    color: AppTheme.white,
                                    fontSize: 11,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                const Icon(
                                  Icons.location_on_outlined,
                                  color: AppTheme.grey,
                                  size: 15,
                                ),

                                const SizedBox(width: 3),

                                Expanded(
                                  child: Text(
                                    cafe['distance']!,
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      color: AppTheme.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 7),

                            Expanded(
                              child: Text(
                                cafe['about']!,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: AppTheme.grey,
                                  fontSize: 10,
                                  height: 1.4,
                                ),
                              ),
                            ),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end,

                              children: const [

                                Text(
                                  'View Details',
                                  style: TextStyle(
                                    color: AppTheme.green,
                                    fontSize: 10,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                SizedBox(width: 4),

                                Icon(
                                  Icons.arrow_forward,
                                  color: AppTheme.green,
                                  size: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}