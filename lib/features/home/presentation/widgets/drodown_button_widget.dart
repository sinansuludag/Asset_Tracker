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
        height: MediaQuerySize(context).percent6Height,
        padding: AppPaddings.horizontalSimetricLowPadding,
        decoration: BoxDecoration(
          border: Border.all(color: context.colorScheme.onError),
          borderRadius: AppBorderRadius.lowBorderRadius,
          color: context.colorScheme.surface,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedAsset,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSecondary,
            ),
            dropdownColor: context.colorScheme.secondary,
            isExpanded: true, // Açılır menünün tam genişlikte olmasını sağlar
            alignment: Alignment.center, // Açılan menünün ortalanmasını sağlar
            hint: Row(
              children: [
                Icon(Icons.attach_money, color: context.colorScheme.primary),
                const Text(TrStrings.chooseAssetType),
              ],
            ),
            items: Currency.currencyNames.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on,
                        color: Colors.green), // Seçilen öğelerde ikon görünür
                    SizedBox(
                      width: MediaQuerySize(context).percent2Width,
                    ),
                    Text(item),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
            selectedItemBuilder: (BuildContext context) {
              return Currency.currencyNames.map((item) {
                return Row(
                  children: [
                    Icon(Icons.attach_money,
                        color: context.colorScheme
                            .primary), // Seçili öğede ikon ekliyoruz
                    SizedBox(
                      width: MediaQuerySize(context).percent2Width,
                    ),
                    Text(item, style: context.textTheme.bodyLarge),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    ),
  );
}
