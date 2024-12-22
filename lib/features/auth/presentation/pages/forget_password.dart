import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/mixins/forget_password_screen_mixin.dart';
import 'package:asset_tracker/core/utils/validator/email_validator.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/custom_email_text_form_field.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with ForgetPasswordScreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: context.colorScheme.surface,
        title: Text(
          TrStrings.forgetPasswordScreenTitle,
          style: TextStyle(color: context.colorScheme.onSecondary),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: AppPaddings.horizontalSimetricDefaultPadding,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: MediaQuerySize(context).percent4Height),
                  titleText(context),
                  SizedBox(height: MediaQuerySize(context).percent2Height),
                  bodyText(context),
                  SizedBox(height: MediaQuerySize(context).percent10Height),
                  customEmailTextFormFeild(
                      EmailValidator.validate, emailController),
                  SizedBox(height: MediaQuerySize(context).percent10Height),
                  forgetPasswordElevatedButton(context),
                  SizedBox(height: MediaQuerySize(context).percent10Height),
                  noAccountTextButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
