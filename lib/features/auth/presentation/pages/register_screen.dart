import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/mixins/screen_mixin/register_screen_mixin.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/utils/validator/email_validator.dart';
import 'package:asset_tracker/core/utils/validator/password_validator.dart';
import 'package:asset_tracker/core/utils/validator/username_validator.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/coin_container_asset.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/custom_email_text_form_field.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/custom_username_text_form_field.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/elevated_button.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/signin_and_signup_row.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/social_card.dart';
import 'package:asset_tracker/features/auth/presentation/widgets/textTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerWidget with RegisterScreenMixin {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: AppPaddings.allDefaultPadding,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildSizedBox(
                      context, MediaQuerySize(context).percent10Height),
                  coinContainerAsset(context),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent2Height),
                  textTitle(context, title: TrStrings.signUp),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent5Height),
                  customUsernameTextFormField(
                    UsernameValidator.usernameValidate,
                    usernameController,
                  ),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent2Height),
                  customEmailTextFormFeild(
                    EmailValidator.validate,
                    emailController,
                  ),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent2Height),
                  customPasswordTextFormField(
                    PasswordValidator.passwordValidate,
                    passwordController,
                  ),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent2Height),
                  customElevatedButton(
                    context: context,
                    ref: ref,
                    butonText: TrStrings.signUp,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        registerButton(context, ref);
                      }
                    },
                  ),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent4Height),
                  signInAndUpRow(
                    context,
                    TrStrings.textForGoToLogin,
                    TrStrings.signIn,
                    RouteNames.login,
                  ),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent2Height),
                  socialCardsRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildSizedBox(BuildContext context, double height) {
    return SizedBox(height: height);
  }
}
