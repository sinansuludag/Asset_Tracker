import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_provider.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/pages/modern_portfolio_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyAssetScreen extends ConsumerWidget {
  const CurrencyAssetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Redirect to modern portfolio screen for better UX
    return const ModernPortfolioScreen();
  }
}
