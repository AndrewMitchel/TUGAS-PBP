import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../fungsi/lastviewed.dart';
import '../fungsi/favorite.dart';
import '../theme/app_theme.dart';

class CafeDetailPage extends StatefulWidget {
  final String tokoId;
  final String cafeName;
  final String rating;
  final String distance;
  final String imageUrl;
  final String about;
  final String mapUrl;

  const CafeDetailPage({
    super.key,
    required this.tokoId,
    required this.cafeName,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    required this.about,
    required this.mapUrl,
  });

  @override
  State<CafeDetailPage> createState() =>
      _CafeDetailPageState();
}

class _CafeDetailPageState extends State<CafeDetailPage> {
  // =====================================================
  // CEK STATUS FAVORITE
  // =====================================================

  late bool isFavorite;

  @override
  void initState() {
    super.initState();

    LastViewedFunction.addLastViewed(widget.tokoId);

    isFavorite = FavoriteFunction.isFavorite(
      widget.tokoId,
    );
  }

  // =====================================================
  // TOGGLE FAVORITE
  // =====================================================

  void _toggleFavorite() {
    setState(() {
      isFavorite = FavoriteFunction.toggleFavorite(
        widget.tokoId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: CustomScrollView(
        slivers: [
          // =====================================================
          // FOTO CAFE
          // =====================================================

          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.background,

            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: const Color.fromARGB(
                255,
                241,
                238,
                236,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            // =====================================================
            // FAVORITE BUTTON
            // =====================================================

            actions: [
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isFavorite
                      ? AppTheme.green
                      : Colors.white,
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // =====================================================
          // DETAIL CAFE
          // =====================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // =====================================================
                  // NAMA + RATING
                  // =====================================================

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.cafeName,
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.star,
                        color: AppTheme.yellow,
                        size: 18,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        widget.rating,
                        style: const TextStyle(
                          color: AppTheme.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // =====================================================
                  // JARAK
                  // =====================================================

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppTheme.grey,
                        size: 16,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        '${widget.distance} away',
                        style: const TextStyle(
                          color: AppTheme.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // =====================================================
                  // TAG
                  // =====================================================

                  Row(
                    children: [
                      _tag(
                        Icons.coffee,
                        'Coffee',
                      ),

                      _tag(
                        Icons.restaurant,
                        'Food',
                      ),

                      _tag(
                        Icons.wifi,
                        'WiFi',
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // =====================================================
                  // ABOUT
                  // =====================================================

                  const Text(
                    'About',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    widget.about,
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =====================================================
                  // FASILITAS
                  // =====================================================

                  const Text(
                    'Fasilitas',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _facility(
                        Icons.coffee,
                        'Coffee',
                      ),

                      _facility(
                        Icons.wifi,
                        'WiFi',
                      ),

                      _facility(
                        Icons.power,
                        'Outlet',
                      ),

                      _facility(
                        Icons.ac_unit,
                        'AC',
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // =====================================================
                  // VIEW LOCATION
                  // =====================================================

                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (widget.mapUrl.isEmpty) {
                          return;
                        }

                        final uri = Uri.parse(
                          widget.mapUrl,
                        );

                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode
                                .externalApplication,
                          );
                        }
                      },

                      icon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.black,
                      ),

                      label: const Text(
                        'View Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.green,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // TAG
  // =====================================================

  Widget _tag(
    IconData icon,
    String text,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.green,
            size: 14,
          ),

          const SizedBox(width: 5),

          Text(
            text,
            style: const TextStyle(
              color: AppTheme.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // FACILITY
  // =====================================================

  Widget _facility(
    IconData icon,
    String text,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.green,
            size: 20,
          ),

          const SizedBox(height: 5),

          Text(
            text,
            style: const TextStyle(
              color: AppTheme.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}