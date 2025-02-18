import 'package:asset_tracker/core/common/widgets/text_form_field.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:flutter/material.dart';

Padding customBuyingAssetTextFormField(
    TextEditingController buyingAssetController) {
  return Padding(
    padding: AppPaddings.horizontalSimetricLowPadding,
    child: CustomTextFormField(
        labelText: TrStrings.buyinPrice,
        hintText: TrStrings.enterBuyingPrice,
        prefixIcon: const Icon(Icons.price_change),
        controller: buyingAssetController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next),
  );
}
