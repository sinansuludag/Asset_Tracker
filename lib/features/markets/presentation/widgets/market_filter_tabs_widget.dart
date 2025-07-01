import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/features/markets/presentation/state_management/providers/markets_providers.dart';

class MarketFilterTabsWidget extends ConsumerWidget {
  const MarketFilterTabsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildFilterTab(
              context,
              ref,
              'all',
              'Tümü',
              selectedCategory == 'all',
            ),
            _buildFilterTab(
              context,
              ref,
              'metals',
              'Metaller',
              selectedCategory == 'metals',
            ),
            _buildFilterTab(
              context,
              ref,
              'currency',
              'Döviz',
              selectedCategory == 'currency',
            ),
            _buildFilterTab(
              context,
              ref,
              'crypto',
              'Kripto',
              selectedCategory == 'crypto',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(
    BuildContext context,
    WidgetRef ref,
    String category,
    String label,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            ref.read(selectedCategoryProvider.notifier).state = category,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
          ),
        ),
      ),
    );
  }
}
