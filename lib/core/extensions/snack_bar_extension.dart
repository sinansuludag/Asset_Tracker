import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
  void showSnackBar(String message) {
    // mounted kontrolü yaparak snack bar'ın sadece aktif bir widget'ta gösterilmesini sağlıyoruz.
    if (mounted) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
