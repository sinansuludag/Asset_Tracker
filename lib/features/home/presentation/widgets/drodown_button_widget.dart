import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/utils/currency_list.dart';
import 'package:flutter/material.dart';

Center dropDownButtonwidget(BuildContext context, String? selectedAsset,
    ValueChanged<String?> onChanged) {
  return Center(
    child: Padding(
      padding: AppPaddings.horizontalSimetricDefaultPadding,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.colorScheme.onError),
          borderRadius: AppBorderRadius.lowBorderRadius,
        ),
        child: DropdownButton<String>(
          value: selectedAsset,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSecondary,
          ),
          dropdownColor: context.colorScheme.secondary,
          menuWidth: MediaQuerySize(context).percent90Width,
          hint: const Text(
            TrStrings.chooseAssetType,
          ),
          items: Currency.currencyNames.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: AppPaddings.horizontalSimetricLowPadding,
                child: Text(item),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          underline: const SizedBox(),
          isExpanded: true,
        ),
      ),
    ),
  );
}
