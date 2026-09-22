import 'package:flutter/material.dart';

import '../fungsi/lastviewed.dart';
import '../models/list_data.dart';
import '../theme/app_theme.dart';
import 'cafe_detail_page.dart';

// =====================================================
// LAST VIEWED PAGE
// =====================================================

class LastViewedPage extends StatefulWidget {
  const LastViewedPage({super.key});

  @override
  State<LastViewedPage> createState() => _LastViewedPageState();
}

class _LastViewedPageState extends State<LastViewedPage> {

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {

    // Ambil semua cafe yang terakhir dilihat
    final List<String> lastViewed =
        LastViewedFunction.getLastViewed();

    return Scaffold(
      backgroundColor: AppTheme.background,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: AppTheme.background,

        title: const Text(
          'Last Viewed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: lastViewed.isEmpty
          ? _emptyState()
          : ListView(
              padding: const EdgeInsets.all(20),

              children: [
                // =====================================================
                // HEADER
                // =====================================================

                const Text(
                  'Recently Viewed',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Your recently viewed coffee shops',
                  style: TextStyle(
                    color: AppTheme.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 18),

                // =====================================================
                // LIST LAST VIEWED
                // =====================================================

                ...lastViewed.map(
                  (tokoId) {

                    // Ambil data cafe berdasarkan ID
                    final cafe = cafeData[tokoId];

                    // Kalau data cafe tidak ditemukan,
                    // jangan tampilkan card
                    if (cafe == null) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),

                      child: _cafeCard(
                        context,
                        tokoId,
                        cafe,
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  // =====================================================
  // CAFE CARD
  // =====================================================

  Widget _cafeCard(
    BuildContext context,
    String tokoId,
    Map<String, String> cafe,
  ) {
    return GestureDetector(
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
        ).then((_) {
          // Refresh setelah kembali
          setState(() {});
        });
      },

      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
        ),

        clipBehavior: Clip.antiAlias,

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =====================================================
            // IMAGE
            // =====================================================

            SizedBox(
              width: 115,
              height: 125,

              child: Image.asset(
                cafe['image']!,
                fit: BoxFit.cover,
              ),
            ),

            // =====================================================
            // INFORMATION
            // =====================================================

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(13),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // =====================================================
                    // NAME
                    // =====================================================

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

                    // =====================================================
                    // RATING & DISTANCE
                    // =====================================================

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
                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: AppTheme.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // =====================================================
                    // ABOUT
                    // =====================================================

                    Text(
                      cafe['about']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: AppTheme.grey,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 7),

                    // =====================================================
                    // VIEW DETAIL
                    // =====================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end,

                      children: [
                        const Text(
                          'View Details',
                          style: TextStyle(
                            color: AppTheme.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 4),

                        const Icon(
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
    );
  }

  // =====================================================
  // EMPTY STATE
  // =====================================================

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            // =====================================================
            // ICON
            // =====================================================

            Container(
              width: 75,
              height: 75,

              decoration: const BoxDecoration(
                color: AppTheme.card,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.history,
                color: AppTheme.grey,
                size: 35,
              ),
            ),

            const SizedBox(height: 20),

            // =====================================================
            // TITLE
            // =====================================================

            const Text(
              'No Last Viewed',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // =====================================================
            // DESCRIPTION
            // =====================================================

            const Text(
              'You haven\'t viewed any coffee shop yet.',
              textAlign: TextAlign.center,

              style: TextStyle(
                color: AppTheme.grey,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}