import 'package:asset_tracker/common/widgets/text_form_field.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:flutter/material.dart';

CustomTextFormField customUsernameTextFormField(
    String? Function(String?)? validate, String? Function(String?)? onSaved) {
  return CustomTextFormField(
      prefixIcon: const Icon(Icons.person_2_rounded),
      validator: validate,
      onSaved: onSaved,
      labelText: TrStrings.labelUsername,
      hintText: TrStrings.hintTextUsername,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next);
}
