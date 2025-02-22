import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';

class BuyingPriceValidator {
  BuyingPriceValidator._();
  static String? buyingPriceValidate(value) {
    if (value == null || value.isEmpty) {
      return TrStrings.requiredBuyingPrice;
    }
    return null;
  }
}
