import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/exceptions/firebase_auth_exceptions/firebase_error_type.dart';
import 'package:asset_tracker/core/extensions/firebase_error_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin ForgetPasswordScreenMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  forgetPasswordButton(BuildContext context, WidgetRef ref) async {
    var email = emailController.text;
    var resetPassword = ref.read(firebaseAuthServiceProvider);
    try {
      ref.read(isLoadingProvider.notifier).state = true;
      await resetPassword.sendPasswordResetEmail(email);
    } catch (e) {
      if (e is FirebaseAuthException) {
        FirebaseAuthErrorType errorType =
            FirebaseErrorHandlingExtension.getErrorTypeFromAuthException(e);

        String errorMessage = errorType.getErrorMessage();
        context.showSnackBar(errorMessage);
      } else {
        // Diğer hata durumları
        context.showSnackBar(TrStrings.unknownError);
      }
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }

    emailController.clear();
    Navigator.pushNamed(context, RouteNames.login);
  }
}
