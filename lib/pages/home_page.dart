import 'package:flutter/material.dart';

import '../fungsi/filter.dart';
import '../fungsi/lokasi_user.dart';
import '../fungsi/search.dart';
import '../fungsi/user_profile.dart';
import '../models/list_data.dart';
import '../models/recommended_data.dart';
import '../models/trending_data.dart';
import '../theme/app_theme.dart';
import '../widgets/background.dart';
import '../widgets/coffee_card.dart';
import '../widgets/empty_search.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/navbar.dart';
import '../widgets/section_title.dart';
import '../widgets/trending_card.dart';
import 'cafe_detail_page.dart';
import 'profile_page.dart';

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
  // FILTER
  // =====================================================

  double? selectedDistance;
  double? selectedRating;

  bool isFiltering = false;

  // =====================================================
  // LOCATION
  // =====================================================

  String userLocation = 'Mencari lokasi...';

  bool isLoadingLocation = false;

  // =====================================================
  // USERNAME
  // =====================================================

  late String currentUsername;

  @override
  void initState() {
    super.initState();

    // =====================================================
    // SET USERNAME AWAL
    // =====================================================

    currentUsername =
        UserProfile.username.value ?? widget.username;

    // =====================================================
    // DENGARKAN PERUBAHAN USERNAME
    // =====================================================

    UserProfile.username.addListener(
      _usernameChanged,
    );

    // =====================================================
    // SEARCH AWAL
    // =====================================================

    searchResults =
        SearchFunction.searchCafe('');

    searchController.addListener(_searchCafe);

    // =====================================================
    // OTOMATIS CARI LOKASI
    // =====================================================

    _getUserLocation();
  }

  // =====================================================
  // USERNAME BERUBAH
  // =====================================================

  void _usernameChanged() {
    if (!mounted) {
      return;
    }

    final String? newUsername =
        UserProfile.username.value;

    if (newUsername == null ||
        newUsername.isEmpty) {
      return;
    }

    setState(() {
      currentUsername = newUsername;
    });
  }

  // =====================================================
  // SEARCH LOGIC
  // =====================================================

  void _searchCafe() {
    final String keyword =
        searchController.text.trim();

    // =====================================================
    // KALAU USER SEDANG SEARCH
    // =====================================================

    if (keyword.isNotEmpty) {
      final result =
          SearchFunction.searchCafe(keyword);

      setState(() {
        searchResults = result;
      });

      return;
    }

    // =====================================================
    // KALAU FILTER AKTIF
    // =====================================================

    if (isFiltering) {
      final result =
          FilterFunction.filterCafe(
        maxDistance: selectedDistance,
        minRating: selectedRating,
      );

      setState(() {
        searchResults = result;
      });

      return;
    }

    // =====================================================
    // KALAU TIDAK ADA SEARCH DAN FILTER
    // =====================================================

    setState(() {
      searchResults =
          SearchFunction.searchCafe('');
    });
  }

  // =====================================================
  // BUKA FILTER
  // =====================================================

  Future<void> _openFilter() async {
    final result =
        await showModalBottomSheet<
            Map<String, double?>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FilterSheet(
          selectedDistance:
              selectedDistance,
          selectedRating:
              selectedRating,
        );
      },
    );

    // Kalau user menutup filter tanpa Apply
    if (result == null) {
      return;
    }

    final double? distance =
        result['distance'];

    final double? rating =
        result['rating'];

    // =====================================================
    // CEK APAKAH FILTER AKTIF
    // =====================================================

    final bool filterAktif =
        distance != null || rating != null;

    setState(() {
      selectedDistance = distance;
      selectedRating = rating;
      isFiltering = filterAktif;
    });

    // =====================================================
    // AMBIL HASIL FILTER
    // =====================================================

    if (filterAktif) {
      final filtered =
          FilterFunction.filterCafe(
        maxDistance:
            selectedDistance,
        minRating:
            selectedRating,
      );

      setState(() {
        searchResults = filtered;
      });
    } else {
      setState(() {
        searchResults =
            SearchFunction.searchCafe('');
      });
    }
  }

  // =====================================================
  // GET USER LOCATION
  // =====================================================

  Future<void> _getUserLocation() async {
    if (isLoadingLocation) {
      return;
    }

    setState(() {
      isLoadingLocation = true;
    });

    final String location =
        await LokasiUserFunction
            .getLokasiUser();

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
    // =====================================================
    // HAPUS LISTENER USERNAME
    // =====================================================

    UserProfile.username.removeListener(
      _usernameChanged,
    );

    // =====================================================
    // HAPUS SEARCH LISTENER
    // =====================================================

    searchController.removeListener(
      _searchCafe,
    );

    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching =
        searchController.text
            .trim()
            .isNotEmpty;

    // =====================================================
    // FILTER HASIL
    // =====================================================

    final bool showFilterResult =
        !isSearching && isFiltering;

    return Scaffold(
      backgroundColor:
          AppTheme.background,

      // =====================================================
      // BODY
      // =====================================================

      body: Background(
        child: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(
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
                            'Hi, $currentUsername',

                            style:
                                const TextStyle(
                              color:
                                  AppTheme.white,
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          const Text(
                            'Mau ngopi kemana hari ini?',

                            style:
                                TextStyle(
                              color:
                                  AppTheme.grey,
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
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProfilePage(
                              username:
                                  currentUsername,
                            ),
                          ),
                        );

                        // =====================================================
                        // USERNAME SUDAH DIHANDLE
                        // OLEH LISTENER DI ATAS
                        // =====================================================
                      },

                      child: Container(
                        width: 42,
                        height: 42,

                        decoration:
                            const BoxDecoration(
                          color:
                              AppTheme.green,
                          shape:
                              BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons
                              .person_outline,
                          color:
                              Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 25,
                ),

                // =====================================================
                // LOCATION
                // =====================================================

                GestureDetector(
                  onTap:
                      _getUserLocation,

                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .location_on_outlined,
                        color:
                            AppTheme.green,
                        size: 16,
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Expanded(
                        child:
                            isLoadingLocation
                                ? const Text(
                                    'Mencari lokasi...',
                                    style:
                                        TextStyle(
                                      color:
                                          AppTheme.grey,
                                      fontSize:
                                          12,
                                    ),
                                  )
                                : Text(
                                    userLocation,
                                    maxLines:
                                        1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        const TextStyle(
                                      color:
                                          AppTheme.grey,
                                      fontSize:
                                          12,
                                    ),
                                  ),
                      ),

                      if (isLoadingLocation)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                AppTheme
                                    .green,
                          ),
                        )
                      else
                        const Icon(
                          Icons.refresh,
                          color:
                              AppTheme.green,
                          size: 16,
                        ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                // =====================================================
                // SEARCH
                // =====================================================

                Container(
                  height: 48,

                  decoration:
                      BoxDecoration(
                    color:
                        AppTheme.card,

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),

                    border: Border.all(
                      color: AppTheme.green
                          .withValues(
                        alpha: 0.10,
                      ),
                    ),
                  ),

                  child: TextField(
                    controller:
                        searchController,

                    style:
                        const TextStyle(
                      color:
                          AppTheme.white,
                    ),

                    decoration:
                        InputDecoration(
                      hintText:
                          'Search coffee shop...',

                      hintStyle:
                          const TextStyle(
                        color:
                            AppTheme.grey,
                        fontSize: 13,
                      ),

                      prefixIcon:
                          const Icon(
                        Icons.search,
                        color:
                            AppTheme.green,
                        size: 20,
                      ),

                      suffixIcon:
                          searchController
                                  .text
                                  .isNotEmpty
                              ? IconButton(
                                  onPressed:
                                      () {
                                    searchController
                                        .clear();
                                  },
                                  icon:
                                      const Icon(
                                    Icons.close,
                                    color:
                                        AppTheme
                                            .grey,
                                    size: 19,
                                  ),
                                )
                              : IconButton(
                                  onPressed:
                                      _openFilter,
                                  icon:
                                      const Icon(
                                    Icons.tune,
                                    color:
                                        AppTheme
                                            .green,
                                    size: 19,
                                  ),
                                ),

                      border:
                          InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 28,
                ),

                // =====================================================
                // SEARCH RESULT
                // =====================================================

                if (isSearching) ...[
                  const Text(
                    'Search Result',
                    style:
                        TextStyle(
                      color:
                          AppTheme.white,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 13,
                  ),

                  if (searchResults.isEmpty)
                    emptySearch()
                  else
                    ...searchResults
                        .map((tokoId) {
                      final cafe =
                          cafeData[tokoId]!;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CafeDetailPage(
                                tokoId:
                                    tokoId,
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
                        child:
                            trendingCard(
                          cafe['name']!,
                          cafe['rating']!,
                          cafe['distance']!,
                          cafe['image']!,
                        ),
                      );
                    }),

                  const SizedBox(
                    height: 20,
                  ),
                ],

                // =====================================================
                // FILTER RESULT
                // =====================================================

                if (showFilterResult) ...[
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [
                      const Text(
                        'Filter Result',
                        style:
                            TextStyle(
                          color:
                              AppTheme.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDistance =
                                null;
                            selectedRating =
                                null;
                            isFiltering =
                                false;
                            searchResults =
                                SearchFunction
                                    .searchCafe(
                              '',
                            );
                          });
                        },
                        child:
                            const Text(
                          'Reset',
                          style:
                              TextStyle(
                            color:
                                AppTheme.green,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 13,
                  ),

                  if (searchResults.isEmpty)
                    emptySearch()
                  else
                    ...searchResults
                        .map((tokoId) {
                      final cafe =
                          cafeData[tokoId]!;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CafeDetailPage(
                                tokoId:
                                    tokoId,
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
                        child:
                            trendingCard(
                          cafe['name']!,
                          cafe['rating']!,
                          cafe['distance']!,
                          cafe['image']!,
                        ),
                      );
                    }),

                  const SizedBox(
                    height: 20,
                  ),
                ],

                // =====================================================
                // NORMAL HOME CONTENT
                // =====================================================

                if (!isSearching &&
                    !isFiltering) ...[
                  // =====================================================
                  // RECOMMENDED
                  // =====================================================

                  sectionTitle(
                    context,
                    'Recommended',
                    'See all',
                    'recommended',
                  ),

                  const SizedBox(
                    height: 13,
                  ),

                  SizedBox(
                    height: 205,
                    child:
                        ListView.builder(
                      scrollDirection:
                          Axis.horizontal,

                      itemCount:
                          recommendedCafes
                              .length,

                      itemBuilder:
                          (context, index) {
                        final tokoId =
                            recommendedCafes[
                                index];

                        final cafe =
                            cafeData[
                                tokoId]!;

                        return coffeeCard(
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

                  const SizedBox(
                    height: 28,
                  ),

                  // =====================================================
                  // TRENDING COFFEE
                  // =====================================================

                  sectionTitle(
                    context,
                    'Trending Coffee',
                    'See all',
                    'trending',
                  ),

                  const SizedBox(
                    height: 10,
                  ),

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
                                tokoId:
                                    tokoId,
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

                        child:
                            trendingCard(
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
          Navbar(
        username:
            currentUsername,
      ),
    );
  }
}
