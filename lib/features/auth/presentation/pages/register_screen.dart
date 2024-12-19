import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/utils/validator/email_validator.dart';
import 'package:asset_tracker/core/utils/validator/password_validator.dart';
import 'package:asset_tracker/core/utils/validator/username_validator.dart';
import 'package:asset_tracker/features/auth/extractwidgets/coin_container_asset.dart';
import 'package:asset_tracker/features/auth/extractwidgets/custom_email_text_form_field.dart';
import 'package:asset_tracker/features/auth/extractwidgets/custom_text_form_field.dart';
import 'package:asset_tracker/features/auth/extractwidgets/custom_username_text_form_field.dart';
import 'package:asset_tracker/features/auth/extractwidgets/signin_and_signup_row.dart';
import 'package:asset_tracker/features/auth/extractwidgets/social_card.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: GestureDetector(
        onTap: () {
          // Ekrana tıklanırsa klavye kapanacak
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: AppPaddings.allDefaultPadding,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildSizedBox(
                    context,
                    MediaQuerySize(context).percent10Height,
                  ),
                  coinContainerAsset(context),
                  buildSizedBox(
                    context,
                    MediaQuerySize(context).percent2Height,
                  ),
                  signUpTextTitle(context),
                  buildSizedBox(
                    context,
                    MediaQuerySize(context).percent5Height,
                  ),
                  customUsernameTextFormField(
                      UsernameValidator.usernameValidate, _usernameController),
                  buildSizedBox(
                    context,
                    MediaQuerySize(context).percent2Height,
                  ),
                  customEmailTextFormFeild(
                      EmailValidator.validate, _emailController),
                  buildSizedBox(
                    context,
                    MediaQuerySize(context).percent2Height,
                  ),
                  customPasswordTextFormField(
                      PasswordValidator.passwordValidate, _passwordController),
                  buildSizedBox(
                    context,
                    MediaQuerySize(context).percent2Height,
                  ),
                  customElevatedButton(context),
                  buildSizedBox(
                    context,
                    MediaQuerySize(context).percent4Height,
                  ),
                  signInAndUpRow(context, TrStrings.textForGoToLogin,
                      TrStrings.signIn, RouteNames.login),
                  buildSizedBox(
                    context,
                    MediaQuerySize(context).percent2Height,
                  ),
                  socialCardsRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text signUpTextTitle(BuildContext context) {
    return Text(
      TrStrings.signUp,
      style: context.textTheme.headlineLarge
          ?.copyWith(color: context.colorScheme.primary),
    );
  }

  ElevatedButton customElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          print("Giriş yapıldı");
          print(
              ' email :${_emailController.text} password: ${_passwordController.text} username: ${_usernameController.text}');
          _emailController.clear();
          _passwordController.clear();
          _usernameController.clear();
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 48),
        shape: const StadiumBorder(),
      ),
      child: const Text(TrStrings.signUp),
    );
  }

  SizedBox buildSizedBox(BuildContext context, double height) {
    return SizedBox(height: height);
  }
}
