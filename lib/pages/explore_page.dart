import 'package:flutter/material.dart';

import '../models/list_data.dart';
import '../theme/app_theme.dart';
import 'cafe_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController searchController = TextEditingController();

  // Semua toko diambil dari list_data.dart
  List<String> cafes = [];

  @override
  void initState() {
    super.initState();

    cafes = cafeData.keys.toList();

    searchController.addListener(_searchCafe);
  }

  void _searchCafe() {
    final keyword = searchController.text.toLowerCase().trim();

    setState(() {
      if (keyword.isEmpty) {
        // Kalau search kosong, tampilkan semua cafe
        cafes = cafeData.keys.toList();
      } else {
        // Filter berdasarkan nama cafe
        cafes = cafeData.keys.where((tokoId) {
          final cafe = cafeData[tokoId]!;

          final name = cafe['name']!.toLowerCase();
          final slogan = cafe['slogan']!.toLowerCase();

          return name.contains(keyword) ||
              slogan.contains(keyword);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_searchCafe);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Explore',
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.tune,
              color: AppTheme.green,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // SEARCH BAR
            // =========================
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                15,
              ),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.green.withValues(alpha: 0.10),
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(
                    color: AppTheme.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search coffee shop...',
                    hintStyle: const TextStyle(
                      color: AppTheme.grey,
                      fontSize: 13,
                    ),

                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppTheme.green,
                      size: 20,
                    ),

                    // Tombol X muncul kalau sedang mengetik
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppTheme.grey,
                              size: 19,
                            ),
                          )
                        : null,

                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // =========================
            // HASIL PENCARIAN
            // =========================
            Expanded(
              child: cafes.isEmpty
                  ? _emptySearch()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        20,
                      ),
                      itemCount: cafes.length,
                      itemBuilder: (context, index) {
                        final tokoId = cafes[index];
                        final cafe = cafeData[tokoId]!;

                        return _cafeItem(
                          context,
                          cafe['name']!,
                          cafe['rating']!,
                          cafe['distance']!,
                          cafe['image']!,
                          cafe['slogan']!,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // CAFE ITEM
  // =========================

  Widget _cafeItem(
    BuildContext context,
    String name,
    String rating,
    String distance,
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
        margin: const EdgeInsets.only(bottom: 12),
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
            // FOTO CAFE
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    width: 75,
                    height: 75,
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

            // INFO CAFE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

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

                      const SizedBox(width: 12),

                      const Icon(
                        Icons.location_on_outlined,
                        color: AppTheme.green,
                        size: 13,
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

                  const SizedBox(height: 5),

                  Text(
                    slogan,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ARROW
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
      ),
    );
  }

  // =========================
  // KALAU HASIL 0
  // =========================

  Widget _emptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: AppTheme.grey.withValues(alpha: 0.7),
            size: 50,
          ),

          const SizedBox(height: 12),

          const Text(
            'Cafe tidak ditemukan',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Coba gunakan kata kunci lain.',
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