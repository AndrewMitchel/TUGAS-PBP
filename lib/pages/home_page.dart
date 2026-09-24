import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../fungsi/jarak.dart';
import '../fungsi/filter.dart';
import '../fungsi/lokasi_user.dart';
import '../fungsi/search.dart';
import '../fungsi/user_profile.dart';
import '../models/list_data.dart';
import '../theme/app_theme.dart';
import '../widgets/background.dart';
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

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver {
  // =====================================================
  // LIVE LOCATION
  // =====================================================

  Position? userPosition;

  StreamSubscription<Position>? locationSubscription;

  // =====================================================
  // SUPABASE
  // =====================================================

  final supabase = Supabase.instance.client;

  bool isLoadingCoffeePlaces = true;

  String? coffeePlacesError;

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
  // LOCATION USER
  // =====================================================

  String userLocation = 'Mencari lokasi...';

  bool isLoadingLocation = false;

  // =====================================================
  // USERNAME
  // =====================================================

  late String currentUsername;

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    currentUsername =
        UserProfile.username.value ?? widget.username;

    UserProfile.username.addListener(
      _usernameChanged,
    );

    searchController.addListener(
      _searchCafe,
    );

    _loadCoffeePlaces();

    _getUserLocation();

    _startLiveLocation();
  }

  // =====================================================
  // REFRESH SAAT KEMBALI KE APP
  // =====================================================

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed) {
      _loadCoffeePlaces();
    }
  }

  // =====================================================
  // CEK BOOLEAN SUPABASE
  // =====================================================

  bool _isTrue(dynamic value) {
    if (value == true) {
      return true;
    }

    if (value is String) {
      final text =
          value.trim().toLowerCase();

      return text == 'true' ||
          text == '1' ||
          text == 'yes';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  // =====================================================
  // LOAD COFFEE PLACES DARI SUPABASE
  // =====================================================

  Future<void> _loadCoffeePlaces() async {
    if (mounted) {
      setState(() {
        isLoadingCoffeePlaces = true;
        coffeePlacesError = null;
      });
    }

    try {
      // ===================================================
      // AMBIL DATA DARI SUPABASE
      // ===================================================

      final response = await supabase
          .from('coffee_places')
          .select()
          .order(
            'id',
            ascending: true,
          );

      // ===================================================
      // BERSIHKAN DATA LAMA
      // ===================================================

      cafeData.clear();

      // ===================================================
      // MASUKKAN DATA SUPABASE
      // ===================================================

      for (final item in response) {
        final data =
            Map<String, dynamic>.from(item);

        final int id =
            (data['id'] as num).toInt();

        final String tokoId =
            'toko$id';

        final bool isRecommended =
            _isTrue(
          data['is_recommended'],
        );

        final bool isTrending =
            _isTrue(
          data['is_trending'],
        );

        final String imageUrl =
            data['image_url']
                    ?.toString()
                    .trim() ??
                '';

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
              imageUrl,

          'distance':
              '',

          'isRecommended':
              isRecommended.toString(),

          'isTrending':
              isTrending.toString(),
        };
      }

      if (!mounted) {
        return;
      }

      setState(() {
        isLoadingCoffeePlaces = false;

        searchResults =
            SearchFunction.searchCafe('');
      });

      // ===================================================
      // DEBUG
      // ===================================================

      debugPrint(
        '==========================================',
      );

      debugPrint(
        'JUMLAH CAFE: ${cafeData.length}',
      );

      debugPrint(
        'JUMLAH RECOMMENDED: '
        '${recommendedCafeIds.length}',
      );

      debugPrint(
        'JUMLAH TRENDING: '
        '${trendingCafeIds.length}',
      );

      for (final tokoId
          in recommendedCafeIds) {
        debugPrint(
          'RECOMMENDED: '
          '${cafeData[tokoId]?['name']}',
        );

        debugPrint(
          'RECOMMENDED FOTO: '
          '${cafeData[tokoId]?['image']}',
        );
      }

      for (final tokoId
          in trendingCafeIds) {
        debugPrint(
          'TRENDING: '
          '${cafeData[tokoId]?['name']}',
        );

        debugPrint(
          'TRENDING FOTO: '
          '${cafeData[tokoId]?['image']}',
        );
      }

      debugPrint(
        '==========================================',
      );
    } catch (e) {
      debugPrint(
        'ERROR LOAD COFFEE: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isLoadingCoffeePlaces = false;

        coffeePlacesError =
            'Gagal mengambil data coffee shop.';
      });
    }
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
  // START LIVE LOCATION
  // =====================================================

  Future<void> _startLiveLocation() async {
    final Position? position =
        await JarakFunction.getLokasiUser();

    if (!mounted) {
      return;
    }

    if (position != null) {
      setState(() {
        userPosition = position;
      });
    }

    const LocationSettings locationSettings =
        LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    locationSubscription =
        Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        if (!mounted) {
          return;
        }

        setState(() {
          userPosition = position;
        });
      },
    );
  }

  // =====================================================
  // HITUNG JARAK
  // =====================================================

  String getCafeDistance(String tokoId) {
    final cafe =
        cafeData[tokoId];

    if (cafe == null) {
      return '-';
    }

    if (userPosition == null) {
      return 'Menghitung...';
    }

    final double? cafeLatitude =
        double.tryParse(
      cafe['latitude'] ?? '',
    );

    final double? cafeLongitude =
        double.tryParse(
      cafe['longitude'] ?? '',
    );

    if (cafeLatitude == null ||
        cafeLongitude == null) {
      return '-';
    }

    return JarakFunction.hitungJarak(
      userLatitude:
          userPosition!.latitude,
      userLongitude:
          userPosition!.longitude,
      cafeLatitude:
          cafeLatitude,
      cafeLongitude:
          cafeLongitude,
    );
  }

  // =====================================================
  // BUKA DETAIL CAFE
  // =====================================================

  void _openCafeDetail(String tokoId) {
    final cafe =
        cafeData[tokoId];

    if (cafe == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CafeDetailPage(
          tokoId: tokoId,
          cafeName:
              cafe['name'] ?? '',
          rating:
              cafe['rating'] ?? '0',
          distance:
              getCafeDistance(tokoId),
          imageUrl:
              cafe['image'] ?? '',
          about:
              cafe['about'] ?? '',
          mapUrl:
              cafe['mapUrl'] ?? '',
        ),
      ),
    );
  }

  // =====================================================
  // SEARCH LOGIC
  // =====================================================

  void _searchCafe() {
    final String keyword =
        searchController.text.trim();

    if (isLoadingCoffeePlaces) {
      return;
    }

    if (keyword.isNotEmpty) {
      final result =
          SearchFunction.searchCafe(
        keyword,
      );

      setState(() {
        searchResults = result;
      });

      return;
    }

    if (isFiltering) {
      final result =
          FilterFunction.filterCafe(
        maxDistance:
            selectedDistance,
        minRating:
            selectedRating,
        userPosition:
            userPosition,
      );

      setState(() {
        searchResults = result;
      });

      return;
    }

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
      final filtered =
          FilterFunction.filterCafe(
        maxDistance:
            selectedDistance,
        minRating:
            selectedRating,
        userPosition:
            userPosition,
      );

      setState(() {
        searchResults =
            filtered;
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
      userLocation =
          location;

      isLoadingLocation =
          false;
    });
  }

  // =====================================================
  // RECOMMENDED DARI SUPABASE
  // =====================================================

  List<String> get recommendedCafeIds {
    return cafeData.keys
        .where((id) {
          final value =
              cafeData[id]?['isRecommended'];

          return value != null &&
              value
                      .trim()
                      .toLowerCase() ==
                  'true';
        })
        .toList();
  }

  // =====================================================
  // TRENDING DARI SUPABASE
  // =====================================================

  List<String> get trendingCafeIds {
    return cafeData.keys
        .where((id) {
          final value =
              cafeData[id]?['isTrending'];

          return value != null &&
              value
                      .trim()
                      .toLowerCase() ==
                  'true';
        })
        .toList();
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this);

    locationSubscription?.cancel();

    UserProfile.username.removeListener(
      _usernameChanged,
    );

    searchController.removeListener(
      _searchCafe,
    );

    searchController.dispose();

    super.dispose();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final bool isSearching =
        searchController.text
            .trim()
            .isNotEmpty;

    final bool showFilterResult =
        !isSearching &&
        isFiltering;

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
                              letterSpacing:
                                  0.5,
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
                        child:
                            const Icon(
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
                // LOCATION USER
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
                                AppTheme.green,
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
                    border:
                        Border.all(
                      color:
                          AppTheme.green
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
                    ...searchResults.map(
                      (tokoId) {
                        final cafe =
                            cafeData[tokoId]!;

                        return GestureDetector(
                          onTap: () {
                            _openCafeDetail(
                              tokoId,
                            );
                          },
                          child:
                              trendingCard(
                            cafe['name']!,
                            cafe['rating']!,
                            getCafeDistance(
                              tokoId,
                            ),
                            cafe['image']!,
                          ),
                        );
                      },
                    ),

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
                    ...searchResults.map(
                      (tokoId) {
                        final cafe =
                            cafeData[tokoId]!;

                        return GestureDetector(
                          onTap: () {
                            _openCafeDetail(
                              tokoId,
                            );
                          },
                          child:
                              trendingCard(
                            cafe['name']!,
                            cafe['rating']!,
                            getCafeDistance(
                              tokoId,
                            ),
                            cafe['image']!,
                          ),
                        );
                      },
                    ),

                  const SizedBox(
                    height: 20,
                  ),
                ],

                // =====================================================
                // LOADING
                // =====================================================

                if (isLoadingCoffeePlaces)
                  const Padding(
                    padding:
                        EdgeInsets.only(
                      top: 40,
                    ),
                    child: Center(
                      child:
                          CircularProgressIndicator(
                        color:
                            AppTheme.green,
                      ),
                    ),
                  )

                // =====================================================
                // ERROR
                // =====================================================

                else if (coffeePlacesError !=
                    null)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 30,
                    ),
                    child: Center(
                      child: Column(
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
                            coffeePlacesError!,
                            style:
                                const TextStyle(
                              color:
                                  AppTheme.grey,
                            ),
                            textAlign:
                                TextAlign.center,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          OutlinedButton(
                            onPressed:
                                _loadCoffeePlaces,
                            child:
                                const Text(
                              'Coba Lagi',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                // =====================================================
                // NORMAL HOME
                // =====================================================

                else if (!isSearching &&
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

                  if (recommendedCafeIds.isEmpty)
                    Container(
                      height: 100,
                      width: double.infinity,
                      alignment:
                          Alignment.center,
                      decoration:
                          BoxDecoration(
                        color:
                            AppTheme.card,
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                      child: const Text(
                        'Belum ada coffee shop recommended.',
                        style:
                            TextStyle(
                          color:
                              AppTheme.grey,
                          fontSize: 12,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 205,
                      child:
                          ListView.builder(
                        scrollDirection:
                            Axis.horizontal,
                        itemCount:
                            recommendedCafeIds
                                .length,
                        itemBuilder:
                            (context, index) {
                          final String tokoId =
                              recommendedCafeIds[
                                  index];

                          final cafe =
                              cafeData[
                                  tokoId]!;

                          final String name =
                              cafe['name'] ??
                                  '';

                          final String rating =
                              cafe['rating'] ??
                                  '0';

                          final String distance =
                              getCafeDistance(
                            tokoId,
                          );

                          final String image =
                              (cafe['image'] ??
                                      '')
                                  .trim();

                          final String about =
                              cafe['about'] ??
                                  '';

                          final String mapUrl =
                              cafe['mapUrl'] ??
                                  '';

                          debugPrint(
                            'CARD RECOMMENDED [$tokoId] '
                            'IMAGE = $image',
                          );

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
                                        name,
                                    rating:
                                        rating,
                                    distance:
                                        distance,
                                    imageUrl:
                                        image,
                                    about:
                                        about,
                                    mapUrl:
                                        mapUrl,
                                  ),
                                ),
                              );
                            },

                            child: Container(
                              width: 220,
                              margin:
                                  const EdgeInsets.only(
                                right: 14,
                              ),

                              decoration:
                                  BoxDecoration(
                                color:
                                    AppTheme.card,
                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                                border:
                                    Border.all(
                                  color:
                                      AppTheme.green
                                          .withValues(
                                    alpha: 0.10,
                                  ),
                                ),
                              ),

                              clipBehavior:
                                  Clip.antiAlias,

                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [
                                  // =================================================
                                  // FOTO RECOMMENDED
                                  // =================================================

                                  SizedBox(
                                    height: 135,
                                    width:
                                        double.infinity,

                                    child: image.isEmpty
                                        ? Container(
                                            color:
                                                AppTheme.cardLight,
                                            alignment:
                                                Alignment.center,
                                            child:
                                                const Icon(
                                              Icons.coffee,
                                              color:
                                                  AppTheme.green,
                                              size:
                                                  40,
                                            ),
                                          )
                                        : Image.network(
                                            image,
                                            width:
                                                double.infinity,
                                            height:
                                                135,
                                            fit:
                                                BoxFit.cover,

                                            loadingBuilder:
                                                (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress ==
                                                  null) {
                                                return child;
                                              }

                                              return Container(
                                                color:
                                                    AppTheme.cardLight,
                                                alignment:
                                                    Alignment.center,
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth:
                                                      2,
                                                  color:
                                                      AppTheme.green,
                                                ),
                                              );
                                            },

                                            errorBuilder:
                                                (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              debugPrint(
                                                'GAGAL FOTO RECOMMENDED: '
                                                '$image',
                                              );

                                              debugPrint(
                                                'ERROR FOTO: $error',
                                              );

                                              return Container(
                                                color:
                                                    AppTheme.cardLight,
                                                alignment:
                                                    Alignment.center,
                                                child:
                                                    const Icon(
                                                  Icons.coffee,
                                                  color:
                                                      AppTheme.green,
                                                  size:
                                                      40,
                                                ),
                                              );
                                            },
                                          ),
                                  ),

                                  // =================================================
                                  // INFO
                                  // =================================================

                                  Padding(
                                    padding:
                                        const EdgeInsets.all(
                                      11,
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          name,
                                          maxLines:
                                              1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style:
                                              const TextStyle(
                                            color:
                                                AppTheme.white,
                                            fontSize:
                                                14,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 5,
                                        ),

                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color:
                                                  AppTheme.yellow,
                                              size:
                                                  13,
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
                                                fontSize:
                                                    11,
                                              ),
                                            ),

                                            const SizedBox(
                                              width: 10,
                                            ),

                                            const Icon(
                                              Icons.location_on,
                                              color:
                                                  AppTheme.green,
                                              size:
                                                  13,
                                            ),

                                            const SizedBox(
                                              width: 2,
                                            ),

                                            Text(
                                              distance,
                                              style:
                                                  const TextStyle(
                                                color:
                                                    AppTheme.grey,
                                                fontSize:
                                                    11,
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
                        },
                      ),
                    ),

                  const SizedBox(
                    height: 28,
                  ),

                  // =====================================================
                  // TRENDING
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

                  if (trendingCafeIds.isEmpty)
                    Container(
                      height: 100,
                      width: double.infinity,
                      alignment:
                          Alignment.center,
                      decoration:
                          BoxDecoration(
                        color:
                            AppTheme.card,
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                      child: const Text(
                        'Belum ada coffee shop trending.',
                        style:
                            TextStyle(
                          color:
                              AppTheme.grey,
                          fontSize: 12,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount:
                          trendingCafeIds
                              .length,
                      itemBuilder:
                          (context, index) {
                        final tokoId =
                            trendingCafeIds[
                                index];

                        final cafe =
                            cafeData[
                                tokoId]!;

                        return GestureDetector(
                          onTap: () {
                            _openCafeDetail(
                              tokoId,
                            );
                          },
                          child:
                              trendingCard(
                            cafe['name']!,
                            cafe['rating']!,
                            getCafeDistance(
                              tokoId,
                            ),
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