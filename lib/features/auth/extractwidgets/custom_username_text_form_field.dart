import 'package:asset_tracker/common/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

CustomTextFormField customUsernameTextFormField(
    String? Function(String?)? validate, String? Function(String?)? onSaved) {
  return CustomTextFormField(
      prefixIcon: Icon(Icons.person_2_rounded),
      validator: validate,
      onSaved: onSaved,
      labelText: "Username",
      hintText: "Enter the username",
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next);
}
