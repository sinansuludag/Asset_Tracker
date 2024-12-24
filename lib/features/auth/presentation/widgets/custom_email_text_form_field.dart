import 'package:asset_tracker/core/common/widgets/text_form_field.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:flutter/material.dart';

CustomTextFormField customEmailTextFormFeild(
    String? Function(String?)? validate,
    TextEditingController emailController) {
  return CustomTextFormField(
    controller: emailController,
    prefixIcon: const Icon(Icons.email_outlined),
    labelText: TrStrings.labelEmail,
    hintText: TrStrings.hintTextEmail,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    validator: validate,
  );
}
