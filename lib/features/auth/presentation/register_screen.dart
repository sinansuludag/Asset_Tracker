import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/domain/validator/email_validator.dart';
import 'package:asset_tracker/features/auth/domain/validator/password_validator.dart';
import 'package:asset_tracker/features/auth/domain/validator/username_validator.dart';
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
  String username = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: AppPaddings.defaultPadding,
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
                coinContainerAsset(colorScheme, context),
                buildSizedBox(
                  context,
                  MediaQuerySize(context).percent2Height,
                ),
                signUpTextTitle(textTheme, colorScheme),
                buildSizedBox(
                  context,
                  MediaQuerySize(context).percent5Height,
                ),
                customUsernameTextFormField(UsernameValidator.usernameValidate,
                    (value) {
                  username = value ?? '';
                }),
                buildSizedBox(
                  context,
                  MediaQuerySize(context).percent2Height,
                ),
                customEmailTextFormFeild(EmailValidator.validate, (value) {
                  email = value ?? '';
                }),
                buildSizedBox(
                  context,
                  MediaQuerySize(context).percent2Height,
                ),
                customPasswordTextFormField(PasswordValidator.passwordValidate,
                    (value) {
                  password = value ?? '';
                }),
                buildSizedBox(
                  context,
                  MediaQuerySize(context).percent2Height,
                ),
                customElevatedButton(colorScheme),
                buildSizedBox(
                  context,
                  MediaQuerySize(context).percent4Height,
                ),
                signInAndUpRow(context, colorScheme, TrStrings.textForGoToLogin,
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
    );
  }

  Text signUpTextTitle(TextTheme textTheme, ColorScheme colorScheme) {
    return Text(
      TrStrings.signUp,
      style: textTheme.headlineLarge?.copyWith(color: colorScheme.primary),
    );
  }

  ElevatedButton customElevatedButton(ColorScheme colorScheme) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          _formKey.currentState!.reset();
          print("Giriş yapıldı");
          print(' email :$email password: $password username: $username');
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onPrimary,
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
