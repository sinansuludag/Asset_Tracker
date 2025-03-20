import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';

class UsernameValidator {
  UsernameValidator._();
  static String? usernameValidate(value) {
    if (value == null || value.isEmpty) {
      return TrStrings.requiredUsername;
    }
    return null;
  }
}
