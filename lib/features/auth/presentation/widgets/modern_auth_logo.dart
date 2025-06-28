import 'package:animate_do/animate_do.dart';
import 'package:asset_tracker/core/constants/dimensions/app_dimensions.dart';
import 'package:flutter/material.dart';

class ModernAuthLogo extends StatelessWidget {
  final String title;
  final String subtitle;

  const ModernAuthLogo({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Column(
        children: [
          // Logo container with glassmorphism effect
          Container(
            width: AppDimensions.authLogoSize,
            height: AppDimensions.authLogoSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Pulse(
                infinite: true,
                duration: const Duration(seconds: 2),
                child: Icon(
                  Icons.diamond,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spaceL),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: AppDimensions.spaceS),

          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
