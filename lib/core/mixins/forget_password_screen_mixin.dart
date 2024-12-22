import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/presentation/pages/forget_password.dart';
import 'package:flutter/material.dart';

mixin ForgetPasswordScreenMixin on State<ForgetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  ElevatedButton forgetPasswordElevatedButton(
    BuildContext context,
  ) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          emailController.clear();
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

  Text bodyText(BuildContext context) {
    return Text(
      TrStrings.forgetPasswordScreenText,
      textAlign: TextAlign.center,
      style: TextStyle(color: context.colorScheme.onSecondary),
    );
  }

  Text titleText(BuildContext context) {
    return Text(
      TrStrings.forgetPasswordScreenTitle,
      style: context.textTheme.headlineMedium
          ?.copyWith(color: context.colorScheme.onSurface),
    );
  }
}
