import 'package:asset_tracker/core/common/widgets/text_form_field.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/currency_notifier.dart';
import 'package:flutter/material.dart';

Padding customTextFormField(BuildContext context,
    CurrencyNotifier currencyNotifier, TextEditingController filterController) {
  return Padding(
    padding: AppPaddings.verticalAndHorizontal_8_24,
    child: CustomTextFormField(
      labelText: TrStrings.homeLabelText,
      hintText: TrStrings.homeHintText,
      controller: filterController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      prefixIcon: Icon(Icons.search, color: context.colorScheme.onSecondary),
      onChanged: (value) {
        currencyNotifier.updateSearchQuery(value ?? '');
      },
    ),
  );
}
