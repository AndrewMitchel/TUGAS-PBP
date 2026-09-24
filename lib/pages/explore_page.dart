import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../fungsi/filter.dart';
import '../fungsi/jarak.dart';
import '../fungsi/search.dart';
import '../models/list_data.dart';
import '../theme/app_theme.dart';
import '../widgets/filter_sheet.dart';
import 'cafe_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() =>
      _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with WidgetsBindingObserver {
  // =====================================================
  // SUPABASE
  // =====================================================

  final supabase =
      Supabase.instance.client;

  // =====================================================
  // SEARCH
  // =====================================================

  final TextEditingController
      searchController =
      TextEditingController();

  List<String> cafes = [];

  // =====================================================
  // FILTER
  // =====================================================

  double? selectedDistance;
  double? selectedRating;

  bool isFiltering = false;

  // =====================================================
  // LOADING
  // =====================================================

  bool isLoading = true;

  String? errorMessage;

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addObserver(this);

    searchController.addListener(
      _searchCafe,
    );

    JarakFunction.userPosition
        .addListener(_locationChanged);

    JarakFunction.startLiveLocation();

    _loadCoffeePlaces();
  }

  // =====================================================
  // LOCATION BERUBAH
  // =====================================================

  void _locationChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // =====================================================
  // REFRESH SAAT KEMBALI KE APP
  // =====================================================

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state ==
        AppLifecycleState.resumed) {
      JarakFunction.startLiveLocation();
      _loadCoffeePlaces();
    }
  }

  // =====================================================
  // HITUNG JARAK
  // =====================================================

  String getCafeDistance(
    String tokoId,
  ) {
    return JarakFunction.hitungJarakCafe(
      tokoId: tokoId,
      cafeData: cafeData,
    );
  }

  // =====================================================
  // LOAD DATA DARI SUPABASE
  // =====================================================

  Future<void>
      _loadCoffeePlaces() async {
    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response =
          await supabase
              .from('coffee_places')
              .select()
              .order(
                'id',
                ascending: true,
              );

      // =================================================
      // BERSIHKAN DATA LAMA
      // =================================================

      cafeData.clear();

      // =================================================
      // MASUKKAN DATA SUPABASE
      // =================================================

      for (final item
          in response) {
        final data =
            Map<String, dynamic>
                .from(item);

        final int id =
            (data['id'] as num)
                .toInt();

        final String tokoId =
            'toko$id';

        cafeData[tokoId] = {
          'name':
              data['name']
                      ?.toString()
                      .trim() ??
                  '',

          'rating':
              data['rating']
                      ?.toString()
                      .trim() ??
                  '0',

          'latitude':
              data['latitude']
                      ?.toString()
                      .trim() ??
                  '',

          'longitude':
              data['longitude']
                      ?.toString()
                      .trim() ??
                  '',

          'mapUrl':
              data['map_url']
                      ?.toString()
                      .trim() ??
                  '',

          'about':
              data['about']
                      ?.toString()
                      .trim() ??
                  '',

          'image':
              data['image_url']
                      ?.toString()
                      .trim() ??
                  '',

          'distance':
              '',

          'isRecommended':
              data['is_recommended']
                      ?.toString() ??
                  'false',

          'isTrending':
              data['is_trending']
                      ?.toString() ??
                  'false',
        };
      }

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;

        if (isFiltering) {
          cafes =
              FilterFunction
                  .filterCafe(
            maxDistance:
                selectedDistance,
            minRating:
                selectedRating,
            userPosition:
                JarakFunction
                    .userPosition
                    .value,
          );
        } else {
          cafes =
              SearchFunction
                  .searchCafe(
            searchController
                .text
                .trim(),
          );
        }
      });
    } catch (e) {
      debugPrint(
        'ERROR EXPLORE: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;

        errorMessage =
            'Gagal mengambil data coffee shop.';

        cafes = [];
      });
    }
  }

  // =====================================================
  // SEARCH
  // =====================================================

  void _searchCafe() {
    if (isLoading) {
      return;
    }

    final String keyword =
        searchController.text.trim();

    if (keyword.isNotEmpty) {
      setState(() {
        cafes =
            SearchFunction.searchCafe(
          keyword,
        );
      });

      return;
    }

    if (isFiltering) {
      setState(() {
        cafes =
            FilterFunction.filterCafe(
          maxDistance:
              selectedDistance,
          minRating:
              selectedRating,
          userPosition:
              JarakFunction
                  .userPosition
                  .value,
        );
      });

      return;
    }

    setState(() {
      cafes =
          SearchFunction
              .searchCafe('');
    });
  }

  // =====================================================
  // FILTER
  // =====================================================

  Future<void>
      _openFilter() async {
    final result =
        await showModalBottomSheet<
            Map<String, double?>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent,
      builder: (_) {
        return FilterSheet(
          selectedDistance:
              selectedDistance,
          selectedRating:
              selectedRating,
        );
      },
    );

    if (result == null) {
      return;
    }

    final double? distance =
        result['distance'];

    final double? rating =
        result['rating'];

    final bool filterAktif =
        distance != null ||
            rating != null;

    setState(() {
      selectedDistance =
          distance;

      selectedRating =
          rating;

      isFiltering =
          filterAktif;
    });

    if (filterAktif) {
      setState(() {
        cafes =
            FilterFunction.filterCafe(
          maxDistance:
              selectedDistance,
          minRating:
              selectedRating,
          userPosition:
              JarakFunction
                  .userPosition
                  .value,
        );
      });
    } else {
      setState(() {
        cafes =
            SearchFunction
                .searchCafe('');
      });
    }
  }

  // =====================================================
  // REFRESH
  // =====================================================

  Future<void>
      _refreshData() async {
    await JarakFunction
        .startLiveLocation();

    await _loadCoffeePlaces();
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this);

    JarakFunction.userPosition
        .removeListener(
      _locationChanged,
    );

    searchController
        .removeListener(
      _searchCafe,
    );

    searchController.dispose();

    super.dispose();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppTheme.background,

      appBar: AppBar(
        backgroundColor:
            AppTheme.background,
        elevation: 0,

        title: const Text(
          'Explore',
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed:
                isLoading
                    ? null
                    : _refreshData,
            icon: const Icon(
              Icons.refresh,
              color:
                  AppTheme.green,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(
                  color:
                      AppTheme.green,
                ),
              )
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        const Icon(
                          Icons
                              .cloud_off_outlined,
                          color:
                              AppTheme.grey,
                          size: 50,
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Text(
                          errorMessage!,
                          style:
                              const TextStyle(
                            color:
                                AppTheme.grey,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        ElevatedButton(
                          onPressed:
                              _refreshData,
                          child:
                              const Text(
                            'Coba Lagi',
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // =====================================================
                      // SEARCH
                      // =====================================================

                      Padding(
                        padding:
                            const EdgeInsets
                                .fromLTRB(
                          20,
                          10,
                          20,
                          15,
                        ),

                        child:
                            Container(
                          height: 48,

                          decoration:
                              BoxDecoration(
                            color:
                                AppTheme.card,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),

                            border:
                                Border.all(
                              color:
                                  AppTheme.green
                                      .withValues(
                                alpha:
                                    0.10,
                              ),
                            ),
                          ),

                          child:
                              TextField(
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
                                fontSize:
                                    13,
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
                                                AppTheme.grey,
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
                                                AppTheme.green,
                                            size: 19,
                                          ),
                                        ),

                              border:
                                  InputBorder
                                      .none,
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
                              const EdgeInsets
                                  .fromLTRB(
                            20,
                            0,
                            20,
                            10,
                          ),

                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .filter_alt_outlined,
                                color:
                                    AppTheme.green,
                                size: 15,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              const Text(
                                'Filter aktif',
                                style:
                                    TextStyle(
                                  color:
                                      AppTheme.green,
                                  fontSize:
                                      11,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const Spacer(),

                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDistance =
                                        null;

                                    selectedRating =
                                        null;

                                    isFiltering =
                                        false;

                                    cafes =
                                        SearchFunction
                                            .searchCafe(
                                      searchController
                                          .text,
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
                                    fontSize:
                                        11,
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
                        child:
                            cafes.isEmpty
                                ? _emptySearch()
                                : ListView
                                    .builder(
                                    padding:
                                        const EdgeInsets
                                            .fromLTRB(
                                      20,
                                      0,
                                      20,
                                      20,
                                    ),

                                    itemCount:
                                        cafes.length,

                                    itemBuilder:
                                        (
                                      context,
                                      index,
                                    ) {
                                      final String
                                          tokoId =
                                          cafes[
                                              index];

                                      final cafe =
                                          cafeData[
                                              tokoId]!;

                                      final String
                                          distance =
                                          getCafeDistance(
                                        tokoId,
                                      );

                                      return _cafeItem(
                                        context,
                                        tokoId,
                                        cafe['name'] ??
                                            '',
                                        cafe['rating'] ??
                                            '0',
                                        distance,
                                        cafe['image'] ??
                                            '',
                                        cafe['about'] ??
                                            '',
                                        cafe['mapUrl'] ??
                                            '',
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
            builder: (_) =>
                CafeDetailPage(
              tokoId: tokoId,
              cafeName: name,
              rating: rating,
              distance:
                  distance.isEmpty
                      ? '-'
                      : distance,
              imageUrl: image,
              about: about,
              mapUrl: mapUrl,
            ),
          ),
        );
      },

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 12,
        ),

        padding:
            const EdgeInsets.all(8),

        decoration:
            BoxDecoration(
          color:
              AppTheme.card,

          borderRadius:
              BorderRadius.circular(
            14,
          ),

          border: Border.all(
            color:
                AppTheme.green.withValues(
              alpha: 0.10,
            ),
          ),
        ),

        child: Row(
          children: [
            // FOTO
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                10,
              ),

              child:
                  image.trim().isEmpty
                      ? Container(
                          width: 75,
                          height: 75,
                          color:
                              AppTheme.cardLight,
                          child:
                              const Icon(
                            Icons.coffee,
                            color:
                                AppTheme.green,
                          ),
                        )
                      : Image.network(
                          image.trim(),
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              width: 75,
                              height: 75,
                              color:
                                  AppTheme.cardLight,
                              child:
                                  const Icon(
                                Icons.coffee,
                                color:
                                    AppTheme.green,
                              ),
                            );
                          },
                        ),
            ),

            const SizedBox(
              width: 12,
            ),

            // INFO
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color:
                          AppTheme.white,
                      fontWeight:
                          FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color:
                            AppTheme.yellow,
                        size: 13,
                      ),

                      const SizedBox(
                        width: 4,
                      ),

                      Text(
                        rating,
                        style:
                            const TextStyle(
                          color:
                              AppTheme.grey,
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      const Icon(
                        Icons
                            .location_on_outlined,
                        color:
                            AppTheme.green,
                        size: 13,
                      ),

                      const SizedBox(
                        width: 3,
                      ),

                      Expanded(
                        child: Text(
                          distance,
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              const TextStyle(
                            color:
                                AppTheme.grey,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    about.isEmpty
                        ? 'Coffee shop'
                        : about,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color:
                          AppTheme.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            Container(
              width: 34,
              height: 34,

              decoration:
                  BoxDecoration(
                color:
                    AppTheme.green,
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),

              child: const Icon(
                Icons
                    .arrow_forward_ios,
                color:
                    Colors.white,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // EMPTY
  // =====================================================

  Widget _emptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Icon(
            Icons.search_off,
            color:
                AppTheme.grey.withValues(
              alpha: 0.7,
            ),
            size: 50,
          ),

          const SizedBox(
            height: 12,
          ),

          const Text(
            'Cafe tidak ditemukan',
            style: TextStyle(
              color:
                  AppTheme.white,
              fontSize: 15,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          const Text(
            'Coba gunakan kata kunci lain.',
            style: TextStyle(
              color:
                  AppTheme.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}