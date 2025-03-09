import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/show_dialog_extension.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Center quantityTextFormField(
    BuildContext context,
    TextEditingController quantityAssetController,
    String? Function(String?)? validate,
    WidgetRef ref) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            final currentAmount = ref.read(assetAmountProvider.notifier).state;
            if (currentAmount > 0) {
              ref.read(assetAmountProvider.notifier).state = currentAmount - 1;
              double updateAmount = currentAmount - 1;
              quantityAssetController.text =
                  updateAmount >= 0 ? updateAmount.toString() : '0.0';
            } else {
              context.showDialogFonk(context, TrStrings.warningBuyingAsset);
            }
          },
          icon: Icon(Icons.remove_circle, color: context.colorScheme.error),
        ),
        SizedBox(
          width: MediaQuerySize(context).percent40Width,
          child: TextFormField(
            validator: validate,
            controller: quantityAssetController,
            readOnly: false,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: TrStrings.buyingScreenEnterQuantity,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: AppBorderRadius.highBorderRadius,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppBorderRadius.highBorderRadius,
                borderSide: BorderSide(
                  color: context.colorScheme.primary,
                ),
              ),
              filled: true,
              fillColor: context.colorScheme.onError.withAlpha(75),
            ),
            onChanged: (value) {
              final newValue = double.tryParse(value) ?? 0;
              if (newValue < 0) {
                context.showDialogFonk(context, TrStrings.warningBuyingAsset);
                quantityAssetController.text = '0.0';
                ref.read(assetAmountProvider.notifier).state = 0.0;
              } else {
                ref.read(assetAmountProvider.notifier).state = newValue;
              }
            },
          ),
        ),
        IconButton(
          onPressed: () {
            final currentAmount = ref.read(assetAmountProvider.notifier).state;
            ref.read(assetAmountProvider.notifier).state = currentAmount + 1;
            quantityAssetController.text = (currentAmount + 1).toString();
          },
          icon: const Icon(Icons.add_circle, color: AppColors.success),
        ),
      ],
    ),
  );
}
