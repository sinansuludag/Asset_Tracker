import 'package:asset_tracker/common/widgets/text_form_field.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:flutter/material.dart';

CustomTextFormField customPasswordTextFormField(
    final String? Function(String?)? validate,
    String? Function(String?)? onSaved) {
  return CustomTextFormField(
      prefixIcon: Icon(Icons.key),
      labelText: TrStrings.labelPassword,
      hintText: TrStrings.hintTextPassword,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      isPassword: true,
      validator: validate,
      onSaved: onSaved);
}
