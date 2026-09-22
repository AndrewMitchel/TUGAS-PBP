import 'package:flutter/material.dart';

import '../fungsi/favorite.dart';
import '../models/list_data.dart';
import '../theme/app_theme.dart';
import 'cafe_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // =====================================================
  // DATA FAVORITES
  // =====================================================

  List<String> favoriteCafes = [];

  @override
  void initState() {
    super.initState();

    _loadFavorites();
  }

  // =====================================================
  // LOAD FAVORITES
  // =====================================================

  void _loadFavorites() {
    setState(() {
      favoriteCafes = FavoriteFunction.getFavorites();
    });
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: favoriteCafes.isEmpty
          ? _emptyFavorites()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favoriteCafes.length,
              itemBuilder: (context, index) {
                final tokoId = favoriteCafes[index];
                final cafe = cafeData[tokoId]!;

                return _favoriteItem(
                  context,
                  tokoId,
                  cafe,
                );
              },
            ),
    );
  }

  // =====================================================
  // FAVORITE ITEM
  // =====================================================

  Widget _favoriteItem(
    BuildContext context,
    String tokoId,
    Map<String, String> cafe,
  ) {
    return GestureDetector(
      // =====================================================
      // KLIK CAFE → CAFE DETAIL
      // =====================================================

      onTap: () async {
        await Navigator.push(
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

        // Setelah kembali dari detail,
        // cek ulang data favorites
        _loadFavorites();
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

            IconButton(
              onPressed: () {
                // Hapus cafe dari favorites
                FavoriteFunction.toggleFavorite(tokoId);

                // Update tampilan Favorites
                setState(() {
                  favoriteCafes =
                      FavoriteFunction.getFavorites();
                });
              },
              icon: const Icon(
                Icons.favorite,
                color: AppTheme.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // KALAU FAVORITES KOSONG
  // =====================================================

  Widget _emptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            color: AppTheme.grey.withValues(alpha: 0.7),
            size: 55,
          ),

          const SizedBox(height: 15),

          const Text(
            'Belum ada cafe favorit',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Cafe yang kamu sukai akan muncul di sini.',
            style: TextStyle(
              color: AppTheme.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
