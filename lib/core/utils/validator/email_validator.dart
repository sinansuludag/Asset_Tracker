import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';

class EmailValidator {
  EmailValidator._();

  // E-posta geçerliliği kontrolü
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return TrStrings.requiredEmail;
    } else if (!_isValidEmail(value)) {
      return TrStrings.invalidEmail;
    }
    return null;
  }

  // E-posta geçerliliği için RegExp
  static bool _isValidEmail(String value) {
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(value);
  }
}
