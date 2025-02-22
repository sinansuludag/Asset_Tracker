import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/mixins/screen_mixin/forget_password_screen_mixin.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/utils/validator/auth_validator/email_validator.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/custom_email_text_form_field.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/elevated_button.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/textTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgetPasswordScreen extends ConsumerWidget
    with ForgetPasswordScreenMixin {
  ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  textTitle(context,
                      title: TrStrings.forgetPasswordScreenTitle),
                  SizedBox(height: MediaQuerySize(context).percent2Height),
                  bodyText(context),
                  SizedBox(height: MediaQuerySize(context).percent10Height),
                  customEmailTextFormFeild(
                      EmailValidator.emailValidate, emailController),
                  SizedBox(height: MediaQuerySize(context).percent10Height),
                  customElevatedButton(
                      context: context,
                      ref: ref,
                      butonText: TrStrings.forgetPasswordScreenButtonText,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          forgetPasswordButton(context, ref);
                        }
                      }),
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

  Widget noAccountTextButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(TrStrings.fogetPasswordScreenNoAccountText,
            style: context.textTheme.bodyMedium
                ?.copyWith(color: context.colorScheme.onSecondary)),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.register);
          },
          child: Text(
            TrStrings.signUp,
            style: TextStyle(
              color: context.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }

  Text bodyText(BuildContext context) {
    return Text(
      TrStrings.forgetPasswordScreenText,
      textAlign: TextAlign.center,
      style: TextStyle(color: context.colorScheme.onSecondary),
    );
  }
}
