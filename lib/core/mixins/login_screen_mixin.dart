import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/exceptions/firebase_auth_exceptions/firebase_error_type.dart';
import 'package:asset_tracker/core/extensions/firebase_error_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_manager.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin LoginScreenMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  loginButton(BuildContext context, WidgetRef ref) async {
    try {
      // Auth işlemi
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.signIn(
        emailController.text,
        passwordController.text,
      );

      // Eğer giriş başarılıysa yönlendirme yap
      if (ref.watch(authProvider) == AuthState.authenticated) {
        emailController.clear();
        passwordController.clear();
        context.showSnackBar(TrStrings.succesLogin);
        Navigator.pushReplacementNamed(context, RouteNames.home);
      } else {
        throw Exception();
      }
    } catch (e) {
      // Hata tipi kontrolü
      if (e is FirebaseAuthException) {
        FirebaseAuthErrorType errorType =
            FirebaseErrorHandlingExtension.getErrorTypeFromAuthException(e);

        String errorMessage = errorType.getErrorMessage();
        context.showSnackBar(errorMessage);
      } else {
        // Diğer hata durumları
        context.showSnackBar(TrStrings.unknownError);
      }
    }
  }
}
