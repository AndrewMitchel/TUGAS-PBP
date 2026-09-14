import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Background extends StatelessWidget {
  final Widget child; // 1. Tambahkan variabel child

  // 2. Wajibkan parameter child di dalam constructor
  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.background,
            AppTheme.darkBlue,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Bentuk biru kanan atas
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 330,
              height: 330,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF084BFF),
                    Color(0xFF031B87),
                  ],
                ),
              ),
            ),
          ),

          // Bentuk biru kiri bawah
          Positioned(
            bottom: -150,
            left: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF064DFF),
                    Color(0xFF02145D),
                  ],
                ),
              ),
            ),
          ),

          // Bentuk tambahan kanan
          Positioned(
            top: 70,
            right: -130,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xFF07165E).withOpacity(0.8),
                borderRadius: BorderRadius.circular(160),
              ),
            ),
          ),

          // 3. Masukkan child di sini agar form login berada di lapisan teratas
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}