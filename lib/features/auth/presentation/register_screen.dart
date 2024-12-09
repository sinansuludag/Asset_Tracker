import 'package:asset_tracker/common/widgets/social_card.dart';
import 'package:asset_tracker/common/widgets/text_form_field.dart';
import 'package:asset_tracker/core/theme/app_styles.dart';
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: height * 0.1,
                ),
                coinContainerAsset(colorScheme, height),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  "Sign Up",
                  style: textTheme.headlineLarge
                      ?.copyWith(color: colorScheme.primary),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                customUsernameTextFormField((value) {
                  if (value == null || value.isEmpty) {
                    return "Username is required";
                  }
                  return null;
                }, (value) {
                  username = value ?? '';
                }),
                SizedBox(height: height * 0.02),
                customEmailTextFormFeild((value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  return null;
                }, (value) {
                  email = value ?? '';
                }),
                SizedBox(height: height * 0.02),
                customPasswordTextFormField((value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
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
                      print(
                          ' email :$email password: $password username: $username');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text("Sign Up"),
                ),
                SizedBox(height: height * 0.04),
                signInAndUpRow(context, colorScheme,
                    "Already have an account? ", "Sign In", "login"),
                SizedBox(height: height * 0.02),
                socialCardsRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
