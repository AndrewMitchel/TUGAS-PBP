import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cafes = [
      ['Terrace Cafe', '4.8', '1.2 km'],
      ['Kopi Senja', '4.7', '0.8 km'],
      ['Lokal Coffee', '4.6', '1.5 km'],
      ['Monopole Coffee', '4.5', '2.1 km'],
      ['Sudut Kopi', '4.4', '2.8 km'],
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: cafes.length,
        itemBuilder: (context, index) {
          final cafe = cafes[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=300&q=80',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cafe[0],
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
                            cafe[1],
                            style: const TextStyle(
                              color: AppTheme.grey,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            cafe[2],
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
                const Icon(
                  Icons.favorite,
                  color: AppTheme.green,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}