import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:flutter/material.dart';

Text expansionTileTitleText(String? currencyCode, BuildContext context) {
  return Text(
    (currencyCode != null && currencyCode.isNotEmpty)
        ? currencyCode.getCurrencyName()
        : TrStrings.unknown,
    style: context.textTheme.bodyLarge,
  );
}
