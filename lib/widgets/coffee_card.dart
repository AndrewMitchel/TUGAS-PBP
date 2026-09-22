import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../pages/cafe_detail_page.dart';

// =====================================================
// COFFEE CARD
// =====================================================

Widget coffeeCard(
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