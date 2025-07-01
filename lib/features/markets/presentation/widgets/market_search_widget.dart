import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/features/markets/presentation/state_management/providers/markets_providers.dart';

class MarketSearchWidget extends ConsumerWidget {
  const MarketSearchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) =>
              ref.read(searchQueryProvider.notifier).state = value,
          decoration: InputDecoration(
            hintText: "Varlık ara...",
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textSecondary,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            hintStyle: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
