import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: const Color(0xFF1765E8),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          const Spacer(),

          Text(
            title,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,

            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}