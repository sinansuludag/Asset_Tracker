import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

Center quantityTextFormField(
    BuildContext context, TextEditingController quantityAssetController) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.remove_circle, color: context.colorScheme.error),
        ),
        SizedBox(
          width: MediaQuerySize(context).percent40Width, // Genişlik belirleyin
          child: TextFormField(
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
                    )),
                filled: true,
                fillColor: context.colorScheme.onError.withAlpha(75)),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_circle, color: AppColors.success),
        ),
      ],
    ),
  );
}
