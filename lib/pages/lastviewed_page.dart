import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../fungsi/jarak.dart';
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
  State<LastViewedPage> createState() =>
      _LastViewedPageState();
}

class _LastViewedPageState
    extends State<LastViewedPage>
    with WidgetsBindingObserver {
  // =====================================================
  // SUPABASE
  // =====================================================

  final supabase =
      Supabase.instance.client;

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

    // Mulai GPS dari fungsi pusat
    JarakFunction.startLiveLocation();

    // Update tampilan saat lokasi berubah
    JarakFunction.userPosition
        .addListener(_locationChanged);

    _loadData();
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
      _loadData();
    }
  }

  // =====================================================
  // LOAD DATA SUPABASE
  // =====================================================

  Future<void> _loadData() async {
    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // =================================================
      // AMBIL SEMUA DATA CAFE
      // =================================================

      final response =
          await supabase
              .from('coffee_places')
              .select()
              .order(
                'id',
                ascending: true,
              );

      // =================================================
      // MASUKKAN KE cafeData
      // =================================================

      cafeData.clear();

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
      });
    } catch (e) {
      debugPrint(
        'ERROR LAST VIEWED: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;

        errorMessage =
            'Gagal mengambil data coffee shop.';
      });
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
  // REFRESH
  // =====================================================

  Future<void> _refreshData() async {
    await JarakFunction
        .startLiveLocation();

    await _loadData();
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

    super.dispose();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final List<String> lastViewed =
        LastViewedFunction
            .getLastViewed()
            .where(
              (tokoId) =>
                  cafeData.containsKey(
                tokoId,
              ),
            )
            .toList();

    return Scaffold(
      backgroundColor:
          AppTheme.background,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor:
            AppTheme.background,

        elevation: 0,

        title: const Text(
          'Last Viewed',
          style: TextStyle(
            color: AppTheme.white,
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

      // =====================================================
      // BODY
      // =====================================================

      body: isLoading
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
              : lastViewed.isEmpty
                  ? _emptyState()
                  : ListView(
                      padding:
                          const EdgeInsets
                              .all(20),

                      children: [
                        // =====================================================
                        // HEADER
                        // =====================================================

                        const Text(
                          'Recently Viewed',
                          style:
                              TextStyle(
                            color:
                                AppTheme.white,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        const Text(
                          'Your recently viewed coffee shops',
                          style:
                              TextStyle(
                            color:
                                AppTheme.grey,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        // =====================================================
                        // LIST LAST VIEWED
                        // =====================================================

                        ...lastViewed.map(
                          (tokoId) {
                            final cafe =
                                cafeData[
                                    tokoId];

                            if (cafe ==
                                null) {
                              return const SizedBox
                                  .shrink();
                            }

                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom: 12,
                              ),

                              child:
                                  _cafeCard(
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
    final String distance =
        getCafeDistance(
      tokoId,
    );

    final String image =
        (cafe['image'] ?? '')
            .trim();

    final String name =
        cafe['name'] ?? '';

    final String rating =
        cafe['rating'] ?? '0';

    final String about =
        cafe['about'] ?? '';

    final String mapUrl =
        cafe['mapUrl'] ?? '';

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CafeDetailPage(
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

        if (mounted) {
          setState(() {});
        }
      },

      child: Container(
        decoration:
            BoxDecoration(
          color:
              AppTheme.card,

          borderRadius:
              BorderRadius.circular(
            16,
          ),
        ),

        clipBehavior:
            Clip.antiAlias,

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // =====================================================
            // IMAGE
            // =====================================================

            SizedBox(
              width: 115,
              height: 125,

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
                        size: 40,
                      ),
                    )
                  : Image.network(
                      image,
                      width: 115,
                      height: 125,
                      fit: BoxFit.cover,

                      errorBuilder:
                          (
                        context,
                        error,
                        stackTrace,
                      ) {
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
                            size: 40,
                          ),
                        );
                      },
                    ),
            ),

            // =====================================================
            // INFORMATION
            // =====================================================

            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  13,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // =====================================================
                    // NAME
                    // =====================================================

                    Text(
                      name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        color:
                            AppTheme.white,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    // =====================================================
                    // RATING & DISTANCE
                    // =====================================================

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color:
                              AppTheme.yellow,
                          size: 15,
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Text(
                          rating,
                          style:
                              const TextStyle(
                            color:
                                AppTheme.white,
                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        const Icon(
                          Icons
                              .location_on_outlined,
                          color:
                              AppTheme.green,
                          size: 15,
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
                      height: 8,
                    ),

                    // =====================================================
                    // ABOUT
                    // =====================================================

                    Text(
                      about.isEmpty
                          ? 'Coffee shop'
                          : about,

                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis,

                      style:
                          const TextStyle(
                        color:
                            AppTheme.grey,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    // =====================================================
                    // VIEW DETAIL
                    // =====================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .end,

                      children: [
                        const Text(
                          'View Details',
                          style:
                              TextStyle(
                            color:
                                AppTheme.green,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        const Icon(
                          Icons.arrow_forward,
                          color:
                              AppTheme.green,
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
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            // ICON
            Container(
              width: 75,
              height: 75,

              decoration:
                  const BoxDecoration(
                color:
                    AppTheme.card,
                shape:
                    BoxShape.circle,
              ),

              child: const Icon(
                Icons.history,
                color:
                    AppTheme.grey,
                size: 35,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // TITLE
            const Text(
              'No Last Viewed',
              style:
                  TextStyle(
                color:
                    AppTheme.white,
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // DESCRIPTION
            const Text(
              'You haven\'t viewed any coffee shop yet.',
              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                color:
                    AppTheme.grey,
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