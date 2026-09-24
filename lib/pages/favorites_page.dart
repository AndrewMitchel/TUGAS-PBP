import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../fungsi/favorite.dart';
import '../fungsi/jarak.dart';
import '../models/list_data.dart';
import '../theme/app_theme.dart';
import 'cafe_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() =>
      _FavoritesPageState();
}

class _FavoritesPageState
    extends State<FavoritesPage>
    with WidgetsBindingObserver {
  // =====================================================
  // SUPABASE
  // =====================================================

  final supabase =
      Supabase.instance.client;

  // =====================================================
  // DATA FAVORITES
  // =====================================================

  List<String> favoriteCafes = [];

  bool isLoading = true;

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addObserver(this);

    JarakFunction.userPosition
        .addListener(_locationChanged);

    JarakFunction.startLiveLocation();

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
  // REFRESH
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
  // LOAD DATA
  // =====================================================

  Future<void> _loadData() async {
    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // =================================================
      // DATA SUPABASE
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

      // =================================================
      // FAVORITES
      // =================================================

      if (!mounted) {
        return;
      }

      setState(() {
        favoriteCafes =
            FavoriteFunction
                .getFavorites()
                .where(
                  (tokoId) =>
                      cafeData.containsKey(
                    tokoId,
                  ),
                )
                .toList();

        isLoading = false;
      });
    } catch (e) {
      debugPrint(
        'ERROR FAVORITES: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        favoriteCafes = [];
        isLoading = false;
      });
    }
  }

  // =====================================================
  // REFRESH DATA
  // =====================================================

  Future<void>
      _refreshData() async {
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
    return Scaffold(
      backgroundColor:
          AppTheme.background,

      appBar: AppBar(
        backgroundColor:
            AppTheme.background,
        elevation: 0,

        title: const Text(
          'Favorites',
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

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(
                color:
                    AppTheme.green,
              ),
            )
          : favoriteCafes.isEmpty
              ? _emptyFavorites()
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  itemCount:
                      favoriteCafes.length,

                  itemBuilder:
                      (context, index) {
                    final String tokoId =
                        favoriteCafes[
                            index];

                    final cafe =
                        cafeData[
                            tokoId];

                    if (cafe == null) {
                      return const SizedBox();
                    }

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
    final String distance =
        getCafeDistance(
      tokoId,
    );

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CafeDetailPage(
              tokoId: tokoId,
              cafeName:
                  cafe['name'] ?? '',
              rating:
                  cafe['rating'] ?? '0',
              distance:
                  distance,
              imageUrl:
                  cafe['image'] ?? '',
              about:
                  cafe['about'] ?? '',
              mapUrl:
                  cafe['mapUrl'] ?? '',
            ),
          ),
        );

        _loadData();
      },

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 10,
        ),

        padding:
            const EdgeInsets.all(8),

        decoration:
            BoxDecoration(
          color:
              AppTheme.card,

          borderRadius:
              BorderRadius.circular(
            15,
          ),
        ),

        child: Row(
          children: [
            // =====================================================
            // FOTO
            // =====================================================

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                10,
              ),

              child:
                  (cafe['image'] ??
                              '')
                          .trim()
                          .isEmpty
                      ? Container(
                          width: 70,
                          height: 70,
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
                          cafe['image']!
                              .trim(),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              width: 70,
                              height: 70,
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

            // =====================================================
            // INFO
            // =====================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    cafe['name'] ?? '',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color:
                          AppTheme.white,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 7,
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
                        cafe['rating'] ??
                            '0',
                        style:
                            const TextStyle(
                          color:
                              AppTheme.grey,
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
                ],
              ),
            ),

            const SizedBox(
              width: 5,
            ),

            // =====================================================
            // FAVORITE BUTTON
            // =====================================================

            IconButton(
              onPressed: () {
                FavoriteFunction
                    .toggleFavorite(
                  tokoId,
                );

                setState(() {
                  favoriteCafes =
                      FavoriteFunction
                          .getFavorites()
                          .where(
                            (id) =>
                                cafeData
                                    .containsKey(
                                  id,
                                ),
                          )
                          .toList();
                });
              },

              icon:
                  const Icon(
                Icons.favorite,
                color:
                    AppTheme.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // EMPTY FAVORITES
  // =====================================================

  Widget _emptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Icon(
            Icons.favorite_border,
            color:
                AppTheme.grey.withValues(
              alpha: 0.7,
            ),
            size: 55,
          ),

          const SizedBox(
            height: 15,
          ),

          const Text(
            'Belum ada cafe favorit',
            style:
                TextStyle(
              color:
                  AppTheme.white,
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          const Text(
            'Cafe yang kamu sukai akan muncul di sini.',
            style:
                TextStyle(
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