import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';

class PasswordValidator {
  PasswordValidator._();
  static const int _characterNumber = 6;
  static String? passwordValidate(value) {
    if (value == null || value.isEmpty) {
      return TrStrings.requiredPassword;
    } else if (value.length < _characterNumber) {
      return TrStrings.warningPasswordLength;
    }
    return null;
  }
}
