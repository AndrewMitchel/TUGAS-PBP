import 'package:flutter/material.dart';

import '../fungsi/lokasi_user.dart';
import '../fungsi/search.dart';
import '../models/list_data.dart';
import '../models/recommended_data.dart';
import '../models/trending_data.dart';
import '../theme/app_theme.dart';
import '../widgets/background.dart';
import '../widgets/navbar.dart';
import 'cafe_detail_page.dart';
import 'profile_page.dart';
import 'list_cafe.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({
    super.key,
    required this.username,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // =====================================================
  // SEARCH CONTROLLER
  // =====================================================

  final TextEditingController searchController =
      TextEditingController();

  List<String> searchResults = [];

  // =====================================================
  // LOCATION
  // =====================================================

  String userLocation = 'Surabaya, Indonesia';

  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();

    // Awalnya semua cafe tersedia
    searchResults = SearchFunction.searchCafe('');

    searchController.addListener(_searchCafe);
  }

  // =====================================================
  // SEARCH LOGIC
  // =====================================================

  void _searchCafe() {
    final result =
        SearchFunction.searchCafe(searchController.text);

    setState(() {
      searchResults = result;
    });
  }

  // =====================================================
  // GET USER LOCATION
  // =====================================================

  Future<void> _getUserLocation() async {
    // Jangan jalankan lagi kalau sedang loading
    if (isLoadingLocation) {
      return;
    }

    setState(() {
      isLoadingLocation = true;
    });

    // Panggil fungsi lokasi dari lokasi_user.dart
    final String location =
        await LokasiUserFunction.getLokasiUser();

    // Pastikan halaman masih ada
    if (!mounted) {
      return;
    }

    setState(() {
      userLocation = location;
      isLoadingLocation = false;
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
    final bool isSearching =
        searchController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.background,

      // =====================================================
      // BODY
      // =====================================================

      body: Background(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              100,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // =====================================================
                // HEADER
                // =====================================================

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Hi, ${widget.username}',

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

                    // =====================================================
                    // PROFILE
                    // =====================================================

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                ProfilePage(
                              username: widget.username,
                            ),
                          ),
                        );
                      },

                      child: Container(
                        width: 42,
                        height: 42,

                        decoration:
                            const BoxDecoration(
                          color: AppTheme.green,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // =====================================================
                // LOCATION
                // =====================================================

                GestureDetector(
                  onTap: _getUserLocation,

                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppTheme.green,
                        size: 16,
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: isLoadingLocation
                            ? const Text(
                                'Mencari lokasi...',
                                style: TextStyle(
                                  color: AppTheme.grey,
                                  fontSize: 12,
                                ),
                              )
                            : Text(
                                userLocation,

                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: AppTheme.grey,
                                  fontSize: 12,
                                ),
                              ),
                      ),

                      // =====================================================
                      // REFRESH LOCATION
                      // =====================================================

                      if (isLoadingLocation)
                        const SizedBox(
                          width: 14,
                          height: 14,

                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.green,
                          ),
                        )
                      else
                        const Icon(
                          Icons.refresh,
                          color: AppTheme.green,
                          size: 16,
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // =====================================================
                // SEARCH
                // =====================================================

                Container(
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

                    decoration:
                        InputDecoration(
                      hintText:
                          'Search coffee shop...',

                      hintStyle:
                          const TextStyle(
                        color: AppTheme.grey,
                        fontSize: 13,
                      ),

                      prefixIcon:
                          const Icon(
                        Icons.search,
                        color: AppTheme.green,
                        size: 20,
                      ),

                      suffixIcon:
                          searchController.text
                                  .isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    searchController
                                        .clear();
                                  },

                                  icon:
                                      const Icon(
                                    Icons.close,
                                    color:
                                        AppTheme.grey,
                                    size: 19,
                                  ),
                                )
                              : const Icon(
                                  Icons.tune,
                                  color:
                                      AppTheme.green,
                                  size: 19,
                                ),

                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // SEARCH RESULT
                // =====================================================

                if (isSearching) ...[
                  const Text(
                    'Search Result',

                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 13),

                  if (searchResults.isEmpty)
                    _emptySearch()
                  else
                    ...searchResults.map((tokoId) {
                      final cafe =
                          cafeData[tokoId]!;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  CafeDetailPage(
                                tokoId: tokoId,
                                cafeName:
                                    cafe['name']!,
                                rating:
                                    cafe['rating']!,
                                distance:
                                    cafe['distance']!,
                                imageUrl:
                                    cafe['image']!,
                                about:
                                    cafe['about']!,
                                mapUrl:
                                    cafe['mapUrl']!,
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
                    }),

                  const SizedBox(height: 20),
                ],

                // =====================================================
                // NORMAL HOME CONTENT
                // =====================================================

                if (!isSearching) ...[
                  // =====================================================
                  // RECOMMENDED
                  // =====================================================

                  _sectionTitle(
                    'Recommended',
                    'See all',
                    'recommended',
                  ),

                  const SizedBox(height: 13),

                  SizedBox(
                    height: 205,

                    child: ListView.builder(
                      scrollDirection:
                          Axis.horizontal,

                      itemCount:
                          recommendedCafes.length,

                      itemBuilder:
                          (context, index) {
                        final tokoId =
                            recommendedCafes[index];

                        final cafe =
                            cafeData[tokoId]!;

                        return _coffeeCard(
                          context,
                          tokoId,
                          cafe['name']!,
                          cafe['distance']!,
                          cafe['rating']!,
                          cafe['image']!,
                          cafe['about']!,
                          cafe['mapUrl']!,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // =====================================================
                  // TRENDING COFFEE
                  // =====================================================

                  _sectionTitle(
                    'Trending Coffee',
                    'See all',
                    'trending',
                  ),

                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,

                    physics:
                        const NeverScrollableScrollPhysics(),

                    itemCount:
                        trendingCafes.length,

                    itemBuilder:
                        (context, index) {
                      final tokoId =
                          trendingCafes[index];

                      final cafe =
                          cafeData[tokoId]!;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  CafeDetailPage(
                                tokoId: tokoId,
                                cafeName:
                                    cafe['name']!,
                                rating:
                                    cafe['rating']!,
                                distance:
                                    cafe['distance']!,
                                imageUrl:
                                    cafe['image']!,
                                about:
                                    cafe['about']!,
                                mapUrl:
                                    cafe['mapUrl']!,
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
              ],
            ),
          ),
        ),
      ),

      // =====================================================
      // BOTTOM NAVIGATION
      // =====================================================

      bottomNavigationBar:
          Navbar(username: widget.username),
    );
  }

  // =====================================================
  // EMPTY SEARCH
  // =====================================================

  Widget _emptySearch() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 50),

      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off,

              color:
                  AppTheme.grey.withValues(alpha: 0.7),

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
      ),
    );
  }

  // =====================================================
  // SECTION TITLE
  // =====================================================

  Widget _sectionTitle(
    String title,
    String action,
    String type,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: const TextStyle(
            color: AppTheme.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        // =====================================================
        // SEE ALL
        // =====================================================

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) =>
                    ListCafePage(type: type),
              ),
            );
          },

          child: Text(
            action,

            style: const TextStyle(
              color: AppTheme.green,
              fontSize: 12,
            ),
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
    String tokoId,
    String name,
    String distance,
    String rating,
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
        width: 220,

        margin:
            const EdgeInsets.only(right: 14),

        decoration: BoxDecoration(
          color: AppTheme.card,

          borderRadius:
              BorderRadius.circular(16),

          border: Border.all(
            color: AppTheme.green
                .withValues(alpha: 0.10),
          ),
        ),

        clipBehavior: Clip.antiAlias,

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // =====================================================
            // FOTO
            // =====================================================

            SizedBox(
              height: 135,
              width: double.infinity,

              child: Image.asset(
                image,

                fit: BoxFit.cover,

                errorBuilder:
                    (context, error, stackTrace) {
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

            // =====================================================
            // INFORMASI
            // =====================================================

            Padding(
              padding:
                  const EdgeInsets.all(11),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

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

                        style:
                            const TextStyle(
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

                        style:
                            const TextStyle(
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
      margin:
          const EdgeInsets.only(bottom: 10),

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
          // FOTO
          // =====================================================

          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),

            child: Image.asset(
              image,

              width: 62,
              height: 62,

              fit: BoxFit.cover,

              errorBuilder:
                  (context, error, stackTrace) {
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

          // =====================================================
          // INFORMASI
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

                      style:
                          const TextStyle(
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

                      style:
                          const TextStyle(
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
    );
  }
}