import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// =====================================================
// EMPTY SEARCH
// =====================================================

Widget emptySearch() {
  return Padding(
    padding:
        const EdgeInsets.symmetric(vertical: 50),

    child: Center(
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            color:
                AppTheme.grey.withValues(alpha: 0.7),
            size: 50,
          ),

          const SizedBox(height: 12),

          const Text(
            'Cafe tidak ditemukan',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Coba gunakan kata kunci lain.',
            style: TextStyle(
              color: AppTheme.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}