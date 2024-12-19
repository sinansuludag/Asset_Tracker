import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/utils/validator/email_validator.dart';
import 'package:asset_tracker/core/utils/validator/password_validator.dart';
import 'package:asset_tracker/features/auth/extractwidgets/coin_container_asset.dart';
import 'package:asset_tracker/features/auth/extractwidgets/custom_email_text_form_field.dart';
import 'package:asset_tracker/features/auth/extractwidgets/custom_text_form_field.dart';
import 'package:asset_tracker/features/auth/extractwidgets/signin_and_signup_row.dart';
import 'package:asset_tracker/features/auth/extractwidgets/social_card.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
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
                      context, MediaQuerySize(context).percent10Height),
                  coinContainerAsset(context),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent2Height),
                  signInTextTitle(context),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent5Height),
                  customEmailTextFormFeild(
                      EmailValidator.validate, _emailController),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent2Height),
                  customPasswordTextFormField(
                      PasswordValidator.passwordValidate, _passwordController),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent2Height),
                  customelevatedButton(context),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent2Height),
                  _forgetPasswordTextButton(context),
                  buildSizedBox(
                      context, MediaQuerySize(context).percent2Height),
                  signInAndUpRow(context, TrStrings.textForGoToRegister,
                      TrStrings.signUp, RouteNames.register),
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

  Text signInTextTitle(BuildContext context) {
    return Text(
      TrStrings.signIn,
      style: context.textTheme.headlineLarge
          ?.copyWith(color: context.colorScheme.onSurface),
    );
  }

  ElevatedButton customelevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          print("Giriş yapıldı");
          print(
              ' email :${_emailController.text} password: ${_passwordController.text}');
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 48),
        shape: const StadiumBorder(),
      ),
      child: const Text(TrStrings.signIn),
    );
  }

  SizedBox buildSizedBox(BuildContext context, double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget _forgetPasswordTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, RouteNames.forgetPassword);
      },
      child: Text(
        TrStrings.forgetPassword,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onError,
        ),
      ),
    );
  }
}
