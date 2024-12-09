import 'package:asset_tracker/common/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

CustomTextFormField customEmailTextFormFeild(
    String? Function(String?)? validate, String? Function(String?)? onSaved) {
  return CustomTextFormField(
    prefixIcon: Icon(Icons.email_outlined),
    labelText: "Email",
    hintText: "Enter the email",
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    validator: validate,
    onSaved: onSaved,
  );
}
