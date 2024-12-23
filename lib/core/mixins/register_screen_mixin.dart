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

mixin RegisterScreenMixin {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  registerButton(BuildContext context, WidgetRef ref) async {
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
        context.showSnackBar(TrStrings.succesRegister);
        Navigator.pushReplacementNamed(context, RouteNames.home);
      } else {
        throw Exception();
      }
    } on FirebaseAuthException catch (e) {
      // Firebase hatasını belirle
      FirebaseAuthErrorType errorType =
          FirebaseErrorHandlingExtension.getErrorTypeFromAuthException(e);

      // Hata türüne göre mesaj al
      String errorMessage = errorType.getErrorMessage();

      // Kullanıcıya mesaj göster
      context.showSnackBar(errorMessage);
    } catch (e) {
      // Bilinmeyen hata durumu
      context.showSnackBar(TrStrings.unknownError);
    }
  }
}
