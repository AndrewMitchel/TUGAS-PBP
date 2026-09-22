import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// =====================================================
// TRENDING CARD
// =====================================================

Widget trendingCard(
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