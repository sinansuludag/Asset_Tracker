import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/utils/validator/email_validator.dart';
import 'package:asset_tracker/features/auth/extractwidgets/custom_email_text_form_field.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
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
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: MediaQuerySize(context).percent4Height),
                  Text(
                    TrStrings.forgetPasswordScreenTitle,
                    style: context.textTheme.headlineMedium
                        ?.copyWith(color: context.colorScheme.onSurface),
                  ),
                  SizedBox(height: MediaQuerySize(context).percent2Height),
                  Text(
                    TrStrings.forgetPasswordScreenText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colorScheme.onSecondary),
                  ),
                  SizedBox(height: MediaQuerySize(context).percent10Height),
                  customEmailTextFormFeild(
                      EmailValidator.validate, _emailController),
                  SizedBox(height: MediaQuerySize(context).percent10Height),
                  signInElevatedButton(context),
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

  ElevatedButton signInElevatedButton(
    BuildContext context,
  ) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          print('Email: ${_emailController.text}');
          _emailController.clear();
          Navigator.pushNamed(context, RouteNames.login);
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 5,
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        minimumSize: Size(MediaQuerySize(context).percent60Width,
            MediaQuerySize(context).percent12Width),
        shape: const StadiumBorder(),
      ),
      child: const Text(TrStrings.signIn),
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
}
