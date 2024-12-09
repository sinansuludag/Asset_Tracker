import 'package:asset_tracker/common/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

CustomTextFormField customPasswordTextFormField(
    final String? Function(String?)? validate,
    String? Function(String?)? onSaved) {
  return CustomTextFormField(
      prefixIcon: Icon(Icons.key),
      labelText: "Password",
      hintText: "Enter the password",
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      isPassword: true,
      validator: validate,
      onSaved: onSaved);
}
