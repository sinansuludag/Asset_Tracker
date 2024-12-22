import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/exceptions/firebase_auth_exceptions/firebase_error_type.dart';
import 'package:asset_tracker/core/exceptions/firebase_auth_exceptions/firebase_exception.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/firebase_error_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_manager.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin RegisterScreenMixin {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Text signUpTextTitle(BuildContext context) {
    return Text(
      TrStrings.signUp,
      style: context.textTheme.headlineLarge?.copyWith(
        color: context.colorScheme.primary,
      ),
    );
  }

  ElevatedButton customElevatedButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          try {
            final authNotifier = ref.read(authProvider.notifier);
            await authNotifier.register(
              emailController.text,
              passwordController.text,
              usernameController.text,
            );

            if (ref.watch(authProvider) == AuthState.authenticated) {
              usernameController.clear();
              emailController.clear();
              passwordController.clear();
              Navigator.pushReplacementNamed(context, RouteNames.home);
            } else {
              throw CustomFirebaseAuthException(
                  errorType: FirebaseAuthErrorType.timeout);
            }
          } on FirebaseAuthException catch (e) {
            // FirebaseAuthException'ı yakalayıp hata türünü belirliyoruz
            FirebaseAuthErrorType errorType = getErrorTypeFromAuthException(e);
            throw CustomFirebaseAuthException(errorType: errorType);
          } on CustomFirebaseAuthException catch (e) {
            // Hata mesajını dinamik olarak alıyoruz
            String errorMessage = e.errorType!.getErrorMessage();

            // Kullanıcıya hata mesajını gösteriyoruz
            context.showSnackBar(errorMessage);
          } catch (e) {
            context.showSnackBar(TrStrings.unknownError);
          }
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
