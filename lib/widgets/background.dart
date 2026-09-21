import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF5F0E6),
            Color(0xFFEDE3D2),
          ],
        ),
      ),
      child: Stack(
        children: [
          // HIJAU HALUS - KANAN ATAS
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF006241)
                    .withValues(alpha: 0.10),
              ),
            ),
          ),

          // HIJAU HALUS - KIRI BAWAH
          Positioned(
            bottom: -120,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF006241)
                    .withValues(alpha: 0.07),
              ),
            ),
          ),

          child,
        ],
      ),
    );
  }
}