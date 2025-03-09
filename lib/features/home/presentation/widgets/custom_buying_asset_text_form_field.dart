import 'package:asset_tracker/core/common/widgets/text_form_field.dart';
import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/utils/validator/buying_asset_validator/buying_price_validator.dart';
import 'package:flutter/material.dart';

Padding customBuyingAssetTextFormField(
    TextEditingController buyingAssetController,
    String? Function(String?)? validate,
    BuildContext context) {
  return Padding(
    padding: AppPaddings.horizontalSimetricNormalPadding,
    child: TextFormField(
      controller: buyingAssetController,
      decoration: InputDecoration(
        labelText: TrStrings.buyinPrice,
        hintText: TrStrings.enterBuyingPrice,
        prefixIcon: const Icon(Icons.price_change),
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.lowBorderRadius,
          borderSide: BorderSide(
            color: context.colorScheme.onError,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: validate,
    ),
  );
}


// CustomTextFormField(
//         labelText: TrStrings.buyinPrice,
//         hintText: TrStrings.enterBuyingPrice,
//         prefixIcon: const Icon(Icons.price_change),
//         controller: buyingAssetController,
//         keyboardType: TextInputType.number,
//         validator: validate,
//         textInputAction: TextInputAction.next)