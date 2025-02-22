import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';

class QuantityAmountValidator {
  QuantityAmountValidator._();
  static String? quantityAmountValidate(value) {
    if (value == null || value.isEmpty) {
      return TrStrings.requiredQuantityAmount;
    }
    return null;
  }
}
