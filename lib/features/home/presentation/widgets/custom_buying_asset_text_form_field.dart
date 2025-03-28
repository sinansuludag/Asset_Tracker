import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

Padding customBuyingAssetTextFormField(
    TextEditingController buyingAssetController,
    String? Function(String?)? validate,
    BuildContext context) {
  return Padding(
    padding: AppPaddings.horizontalSimetricNormalPadding,
    child: SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: buyingAssetController,
        decoration: InputDecoration(
          labelText: TrStrings.buyinPrice,
          hintText: TrStrings.enterBuyingPrice,
          prefixIcon: Icon(
            Icons.price_change,
            color: context.colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: AppBorderRadius.lowBorderRadius,
            borderSide: BorderSide(
              color: context.colorScheme.onError,
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        validator: validate,
      ),
    ),
  );
}
