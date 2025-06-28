import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
  void showSnackBar(String message, IconData icon, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: AppPaddings.verticalAndHorizontal_16_24,
          padding: AppPaddings.verticalAndHorizontal_16_24,
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorderRadius.defaultBorderRadius,
          ),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
