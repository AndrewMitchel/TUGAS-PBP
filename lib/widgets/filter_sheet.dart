import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// =====================================================
// FILTER SHEET
// =====================================================

class FilterSheet extends StatefulWidget {
  final double? selectedDistance;
  final double? selectedRating;

  const FilterSheet({
    super.key,
    this.selectedDistance,
    this.selectedRating,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  // =====================================================
  // FILTER YANG DIPILIH
  // =====================================================

  double? selectedDistance;
  double? selectedRating;

  @override
  void initState() {
    super.initState();

    // Ambil filter yang sebelumnya sudah dipilih
    selectedDistance = widget.selectedDistance;
    selectedRating = widget.selectedRating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        15,
        20,
        25,
      ),

      decoration: const BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // HEADER
          // =====================================================

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppTheme.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =====================================================
          // JARAK
          // =====================================================

          const Text(
            'Jarak',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterChip(
                label: 'Semua',
                selected: selectedDistance == null,
                onTap: () {
                  setState(() {
                    selectedDistance = null;
                  });
                },
              ),

              _filterChip(
                label: '≤ 1 km',
                selected: selectedDistance == 1,
                onTap: () {
                  setState(() {
                    selectedDistance = 1;
                  });
                },
              ),

              _filterChip(
                label: '≤ 2 km',
                selected: selectedDistance == 2,
                onTap: () {
                  setState(() {
                    selectedDistance = 2;
                  });
                },
              ),

              _filterChip(
                label: '≤ 3 km',
                selected: selectedDistance == 3,
                onTap: () {
                  setState(() {
                    selectedDistance = 3;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =====================================================
          // RATING
          // =====================================================

          const Text(
            'Rating',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterChip(
                label: 'Semua',
                selected: selectedRating == null,
                onTap: () {
                  setState(() {
                    selectedRating = null;
                  });
                },
              ),

              _filterChip(
                label: '4.0+',
                selected: selectedRating == 4.0,
                onTap: () {
                  setState(() {
                    selectedRating = 4.0;
                  });
                },
              ),

              _filterChip(
                label: '4.5+',
                selected: selectedRating == 4.5,
                onTap: () {
                  setState(() {
                    selectedRating = 4.5;
                  });
                },
              ),

              _filterChip(
                label: '4.8+',
                selected: selectedRating == 4.8,
                onTap: () {
                  setState(() {
                    selectedRating = 4.8;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 25),

          // =====================================================
          // APPLY FILTER
          // =====================================================

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  {
                    'distance': selectedDistance,
                    'rating': selectedRating,
                  },
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.green,
                foregroundColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),

              child: const Text(
                'Apply Filter',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // FILTER CHIP
  // =====================================================

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: selected
              ? AppTheme.green
              : AppTheme.cardLight,

          borderRadius:
              BorderRadius.circular(10),
        ),

        child: Text(
          label,

          style: TextStyle(
            color: selected
                ? Colors.white
                : AppTheme.grey,

            fontSize: 12,

            fontWeight: selected
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}