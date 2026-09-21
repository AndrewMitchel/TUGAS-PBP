import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    // =====================================================
    // DATA CAFE
    // =====================================================

    final cafes = [
      [
        'Calibre Coffee',
        '4.8',
        '0.9 km',
        'assets/images/K5.jpg',
      ],
      [
        'Aucafe Specialty Coffee',
        '4.6',
        '1.3 km',
        'assets/images/K6.jpg',
      ],
      [
        'Völks Coffee',
        '4.7',
        '1.8 km',
        'assets/images/K7.jpg',
      ],
      [
        'Satu Hari Kopi',
        '4.5',
        '2.4 km',
        'assets/images/K8.jpg',
      ],
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: AppTheme.background,

        title: const Text(
          'Explore',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          // =====================================================
          // SEARCH
          // =====================================================

          Container(
            height: 48,

            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(14),
            ),

            child: const TextField(
              style: TextStyle(
                color: AppTheme.white,
              ),

              decoration: InputDecoration(
                hintText: 'Search coffee shop...',

                hintStyle: TextStyle(
                  color: AppTheme.grey,
                ),

                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.grey,
                ),

                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // =====================================================
          // FILTER
          // =====================================================

          SizedBox(
            height: 40,

            child: ListView(
              scrollDirection: Axis.horizontal,

              children: [
                _chip('All', true),
                _chip('Coffee', false),
                _chip('Food', false),
                _chip('Work', false),
                _chip('Outdoor', false),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // =====================================================
          // CAFE LIST
          // =====================================================

          ...cafes.map(
            (cafe) => _cafeItem(
              cafe[0],
              cafe[1],
              cafe[2],
              cafe[3],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // CHIP
  // =====================================================

  Widget _chip(String text, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),

      padding: const EdgeInsets.symmetric(
        horizontal: 17,
      ),

      decoration: BoxDecoration(
        color: active
            ? AppTheme.green
            : AppTheme.card,

        borderRadius: BorderRadius.circular(12),
      ),

      alignment: Alignment.center,

      child: Text(
        text,

        style: TextStyle(
          color: active
              ? Colors.black
              : AppTheme.grey,

          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // =====================================================
  // CAFE ITEM
  // =====================================================

  Widget _cafeItem(
    String name,
    String rating,
    String distance,
    String image,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(9),

      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        children: [
          // =====================================================
          // FOTO CAFE
          // =====================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(11),

            child: Image.asset(
              image,

              width: 70,
              height: 70,

              fit: BoxFit.cover,

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  width: 70,
                  height: 70,

                  color: AppTheme.cardLight,

                  child: const Icon(
                    Icons.coffee,
                    color: AppTheme.green,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 13),

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
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 7),

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

                    const SizedBox(width: 10),

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
              ],
            ),
          ),

          // =====================================================
          // ARROW
          // =====================================================

          const Icon(
            Icons.chevron_right,
            color: AppTheme.grey,
          ),
        ],
      ),
    );
  }
}