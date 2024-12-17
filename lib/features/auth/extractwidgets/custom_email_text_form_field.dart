import 'package:asset_tracker/common/widgets/text_form_field.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:flutter/material.dart';

CustomTextFormField customEmailTextFormFeild(
    String? Function(String?)? validate, String? Function(String?)? onSaved) {
  return CustomTextFormField(
    prefixIcon: const Icon(Icons.email_outlined),
    labelText: TrStrings.labelEmail,
    hintText: TrStrings.hintTextEmail,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    validator: validate,
    onSaved: onSaved,
  );
}
