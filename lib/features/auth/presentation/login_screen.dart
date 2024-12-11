import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
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
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: Paddings.defaultPadding,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: height * 0.1),
                coinContainerAsset(colorScheme, height),
                SizedBox(height: height * 0.02),
                Text(
                  TrStrings.signIn,
                  style: textTheme.headlineLarge
                      ?.copyWith(color: colorScheme.primary),
                ),
                SizedBox(height: height * 0.05),
                customEmailTextFormFeild((value) {
                  if (value == null || value.isEmpty) {
                    return TrStrings.requiredEmail;
                  }
                  return null;
                }, (value) {
                  email = value ?? '';
                }),
                SizedBox(height: height * 0.02),
                customPasswordTextFormField((value) {
                  if (value == null || value.isEmpty) {
                    return TrStrings.requiredPassword;
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                }, (value) {
                  password = value ?? '';
                }),
                SizedBox(height: height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _formKey.currentState!.reset();
                      print("Giriş yapıldı");
                      print(' email :$email password: $password');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(TrStrings.signIn),
                ),
                SizedBox(height: height * 0.02),
                _textButton(context),
                SizedBox(height: height * 0.02),
                signInAndUpRow(
                    context,
                    colorScheme,
                    TrStrings.textForGoToRegister,
                    TrStrings.signUp,
                    '/register'),
                SizedBox(height: height * 0.02),
                socialCardsRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        TrStrings.forgetPassword,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.64),
            ),
      ),
    );
  }
}
