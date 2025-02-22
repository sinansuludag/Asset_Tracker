import 'package:asset_tracker/core/common/widgets/text_form_field.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/utils/validator/buying_asset_validator/buying_price_validator.dart';
import 'package:flutter/material.dart';

Padding customBuyingAssetTextFormField(
    TextEditingController buyingAssetController,
    String? Function(String?)? validate) {
  return Padding(
    padding: AppPaddings.horizontalSimetricLowPadding,
    child: CustomTextFormField(
        labelText: TrStrings.buyinPrice,
        hintText: TrStrings.enterBuyingPrice,
        prefixIcon: const Icon(Icons.price_change),
        controller: buyingAssetController,
        keyboardType: TextInputType.number,
        validator: validate,
        textInputAction: TextInputAction.next),
  );
}
