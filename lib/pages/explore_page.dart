import 'package:flutter/material.dart';

import '../fungsi/filter.dart';
import '../fungsi/search.dart';
import '../models/list_data.dart';
import '../theme/app_theme.dart';
import '../widgets/filter_sheet.dart';
import 'cafe_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController searchController =
      TextEditingController();

  // =====================================================
  // DATA CAFE
  // =====================================================

  List<String> cafes = [];

  // =====================================================
  // FILTER
  // =====================================================

  double? selectedDistance;
  double? selectedRating;

  bool isFiltering = false;

  @override
  void initState() {
    super.initState();

    // Tampilkan semua cafe saat pertama kali dibuka
    cafes = SearchFunction.searchCafe('');

    searchController.addListener(_searchCafe);
  }

  // =====================================================
  // SEARCH
  // =====================================================

  void _searchCafe() {
    final String keyword =
        searchController.text.trim();

    // =====================================================
    // KALAU ADA SEARCH
    // =====================================================

    if (keyword.isNotEmpty) {
      final result =
          SearchFunction.searchCafe(keyword);

      setState(() {
        cafes = result;
      });

      return;
    }

    // =====================================================
    // KALAU SEARCH DIKOSONGKAN DAN FILTER AKTIF
    // =====================================================

    if (isFiltering) {
      final result =
          FilterFunction.filterCafe(
        maxDistance: selectedDistance,
        minRating: selectedRating,
      );

      setState(() {
        cafes = result;
      });

      return;
    }

    // =====================================================
    // KALAU TIDAK ADA SEARCH DAN FILTER
    // =====================================================

    setState(() {
      cafes = SearchFunction.searchCafe('');
    });
  }

  // =====================================================
  // BUKA FILTER
  // =====================================================

  Future<void> _openFilter() async {
    final result = await showModalBottomSheet<
        Map<String, double?>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FilterSheet(
          selectedDistance: selectedDistance,
          selectedRating: selectedRating,
        );
      },
    );

    // Kalau ditutup tanpa Apply
    if (result == null) {
      return;
    }

    final double? distance =
        result['distance'];

    final double? rating =
        result['rating'];

    // =====================================================
    // CEK FILTER
    // =====================================================

    final bool filterAktif =
        distance != null || rating != null;

    setState(() {
      selectedDistance = distance;
      selectedRating = rating;
      isFiltering = filterAktif;
    });

    // =====================================================
    // TERAPKAN FILTER
    // =====================================================

    if (filterAktif) {
      final filtered =
          FilterFunction.filterCafe(
        maxDistance: selectedDistance,
        minRating: selectedRating,
      );

      setState(() {
        cafes = filtered;
      });
    } else {
      // Kalau filter di-reset
      setState(() {
        cafes = SearchFunction.searchCafe('');
      });
    }
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

      // =====================================================
      // APP BAR
      // =====================================================

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
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // SEARCH BAR
            // =====================================================

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
                  borderRadius:
                      BorderRadius.circular(14),

                  border: Border.all(
                    color: AppTheme.green
                        .withValues(alpha: 0.10),
                  ),
                ),

                child: TextField(
                  controller: searchController,

                  style: const TextStyle(
                    color: AppTheme.white,
                  ),

                  decoration: InputDecoration(
                    hintText:
                        'Search coffee shop...',

                    hintStyle: const TextStyle(
                      color: AppTheme.grey,
                      fontSize: 13,
                    ),

                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppTheme.green,
                      size: 20,
                    ),

                    // =====================================================
                    // FILTER / CLEAR BUTTON
                    // =====================================================

                    suffixIcon:
                        searchController.text.isNotEmpty
                            ? IconButton(
                                // Kalau sedang search,
                                // tombol berubah menjadi tombol clear
                                onPressed: () {
                                  searchController.clear();
                                },

                                icon: const Icon(
                                  Icons.close,
                                  color:
                                      AppTheme.grey,
                                  size: 19,
                                ),
                              )
                            : IconButton(
                                // Kalau search kosong,
                                // tombol ini membuka FilterSheet
                                onPressed: _openFilter,

                                icon: const Icon(
                                  Icons.tune,
                                  color:
                                      AppTheme.green,
                                  size: 19,
                                ),
                              ),

                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // =====================================================
            // FILTER STATUS
            // =====================================================

            if (isFiltering)
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  10,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_alt_outlined,
                      color: AppTheme.green,
                      size: 15,
                    ),

                    const SizedBox(width: 5),

                    const Text(
                      'Filter aktif',
                      style: TextStyle(
                        color: AppTheme.green,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    // =====================================================
                    // RESET FILTER
                    // =====================================================

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDistance = null;
                          selectedRating = null;
                          isFiltering = false;

                          cafes =
                              SearchFunction
                                  .searchCafe(
                            searchController.text,
                          );
                        });
                      },

                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: AppTheme.green,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // =====================================================
            // HASIL
            // =====================================================

            Expanded(
              child: cafes.isEmpty
                  ? _emptySearch()
                  : ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        20,
                      ),

                      itemCount: cafes.length,

                      itemBuilder:
                          (context, index) {
                        final tokoId =
                            cafes[index];

                        final cafe =
                            cafeData[tokoId]!;

                        return _cafeItem(
                          context,
                          tokoId,
                          cafe['name']!,
                          cafe['rating']!,
                          cafe['distance']!,
                          cafe['image']!,
                          cafe['about']!,
                          cafe['mapUrl']!,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // CAFE ITEM
  // =====================================================

  Widget _cafeItem(
    BuildContext context,
    String tokoId,
    String name,
    String rating,
    String distance,
    String image,
    String about,
    String mapUrl,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) => CafeDetailPage(
              tokoId: tokoId,
              cafeName: name,
              rating: rating,
              distance: distance,
              imageUrl: image,
              about: about,
              mapUrl: mapUrl,
            ),
          ),
        );
      },

      child: Container(
        margin:
            const EdgeInsets.only(bottom: 12),

        padding:
            const EdgeInsets.all(8),

        decoration: BoxDecoration(
          color: AppTheme.card,

          borderRadius:
              BorderRadius.circular(14),

          border: Border.all(
            color: AppTheme.green
                .withValues(alpha: 0.10),
          ),
        ),

        child: Row(
          children: [
            // =====================================================
            // FOTO CAFE
            // =====================================================

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),

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

                    color:
                        AppTheme.cardLight,

                    child: const Icon(
                      Icons.coffee,
                      color:
                          AppTheme.green,
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
                    name,

                    style: const TextStyle(
                      color: AppTheme.white,
                      fontWeight:
                          FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color:
                            AppTheme.yellow,
                        size: 13,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        rating,

                        style:
                            const TextStyle(
                          color: AppTheme.grey,
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Icon(
                        Icons
                            .location_on_outlined,
                        color:
                            AppTheme.green,
                        size: 13,
                      ),

                      const SizedBox(width: 3),

                      Text(
                        distance,

                        style:
                            const TextStyle(
                          color: AppTheme.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    about,

                    maxLines: 1,

                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        const TextStyle(
                      color: AppTheme.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // =====================================================
            // ARROW
            // =====================================================

            Container(
              width: 34,
              height: 34,

              decoration: BoxDecoration(
                color: AppTheme.green,

                borderRadius:
                    BorderRadius.circular(10),
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

  // =====================================================
  // KALAU HASIL 0
  // =====================================================

  Widget _emptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Icon(
            Icons.search_off,

            color: AppTheme.grey
                .withValues(alpha: 0.7),

            size: 50,
          ),

          const SizedBox(height: 12),

          const Text(
            'Cafe tidak ditemukan',

            style: TextStyle(
              color: AppTheme.white,
              fontSize: 15,
              fontWeight:
                  FontWeight.w600,
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