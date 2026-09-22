import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../pages/list_cafe.dart';

// =====================================================
// SECTION TITLE
// =====================================================

Widget sectionTitle(
  BuildContext context,
  String title,
  String action,
  String type,
) {
  return Row(
    mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

    children: [
      Text(
        title,
        style: const TextStyle(
          color: AppTheme.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),

      GestureDetector(
        onTap: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  ListCafePage(type: type),
            ),
          );
        },

        child: Text(
          action,
          style: const TextStyle(
            color: AppTheme.green,
            fontSize: 12,
          ),
        ),
      ),
    ],
  );
}