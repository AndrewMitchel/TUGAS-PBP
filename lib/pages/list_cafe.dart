import 'package:flutter/material.dart';

import '../models/list_data.dart';
import '../theme/app_theme.dart';
import 'cafe_detail_page.dart';

// =====================================================
// LIST CAFE PAGE
// =====================================================

class ListCafePage extends StatelessWidget {
  final String type;

  const ListCafePage({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    // =====================================================
    // PILIH DATA DARI SUPABASE
    // =====================================================

    final List<String> cafeList =
        cafeData.keys.where((tokoId) {
      final cafe = cafeData[tokoId];

      if (cafe == null) {
        return false;
      }

      if (type == 'recommended') {
        return cafe['isRecommended'] == 'true';
      }

      if (type == 'trending') {
        return cafe['isTrending'] == 'true';
      }

      return false;
    }).toList();

    // =====================================================
    // JUDUL HALAMAN
    // =====================================================

    final String title =
        type == 'recommended'
            ? 'Recommended'
            : 'Trending';

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.white,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // LIST CAFE
      // =====================================================

      body: cafeList.isEmpty
          ? Center(
              child: Text(
                type == 'recommended'
                    ? 'Belum ada coffee shop Recommended.'
                    : 'Belum ada coffee shop Trending.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.grey,
                  fontSize: 14,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: cafeList.length,

              itemBuilder: (context, index) {
                final String tokoId =
                    cafeList[index];

                final cafe =
                    cafeData[tokoId];

                if (cafe == null) {
                  return const SizedBox.shrink();
                }

                final String imageUrl =
                    cafe['image'] ?? '';

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15,
                  ),

                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
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
                                cafe['distance'] ?? '-',
                            imageUrl:
                                imageUrl,
                            about:
                                cafe['about'] ?? '',
                            mapUrl:
                                cafe['mapUrl'] ?? '',
                          ),
                        ),
                      );
                    },

                    child: Container(
                      height: 130,

                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius:
                            BorderRadius.circular(16),
                      ),

                      clipBehavior:
                          Clip.antiAlias,

                      child: Row(
                        children: [
                          // =================================
                          // FOTO
                          // =================================

                          SizedBox(
                            width: 120,
                            height: 130,

                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
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
                                        child:
                                            const Icon(
                                          Icons
                                              .coffee,
                                          color:
                                              AppTheme
                                                  .green,
                                          size: 35,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color:
                                        AppTheme.cardLight,
                                    child:
                                        const Icon(
                                      Icons.coffee,
                                      color:
                                          AppTheme.green,
                                      size: 35,
                                    ),
                                  ),
                          ),

                          // =================================
                          // INFORMASI
                          // =================================

                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets
                                      .all(13),

                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [
                                  // =======================
                                  // NAMA
                                  // =======================

                                  Text(
                                    cafe['name'] ??
                                        '',
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        const TextStyle(
                                      color:
                                          AppTheme
                                              .white,
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 7,
                                  ),

                                  // =======================
                                  // RATING + JARAK
                                  // =======================

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color:
                                            AppTheme
                                                .yellow,
                                        size: 15,
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
                                              AppTheme
                                                  .white,
                                          fontSize:
                                              11,
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 10,
                                      ),

                                      const Icon(
                                        Icons
                                            .location_on_outlined,
                                        color:
                                            AppTheme
                                                .grey,
                                        size: 15,
                                      ),

                                      const SizedBox(
                                        width: 3,
                                      ),

                                      Expanded(
                                        child: Text(
                                          cafe['distance'] ??
                                              '-',
                                          maxLines:
                                              1,
                                          overflow:
                                              TextOverflow
                                                  .ellipsis,
                                          style:
                                              const TextStyle(
                                            color:
                                                AppTheme
                                                    .grey,
                                            fontSize:
                                                11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 7,
                                  ),

                                  // =======================
                                  // ABOUT
                                  // =======================

                                  Expanded(
                                    child: Text(
                                      cafe['about'] ??
                                          '',
                                      maxLines: 2,
                                      overflow:
                                          TextOverflow
                                              .ellipsis,
                                      style:
                                          const TextStyle(
                                        color:
                                            AppTheme
                                                .grey,
                                        fontSize: 10,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),

                                  // =======================
                                  // VIEW DETAILS
                                  // =======================

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .end,
                                    children: const [
                                      Text(
                                        'View Details',
                                        style:
                                            TextStyle(
                                          color:
                                              AppTheme
                                                  .green,
                                          fontSize: 10,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),

                                      SizedBox(
                                        width: 4,
                                      ),

                                      Icon(
                                        Icons
                                            .arrow_forward,
                                        color:
                                            AppTheme
                                                .green,
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
                  ),
                );
              },
            ),
    );
  }
}