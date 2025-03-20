import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/exceptions/firebase_auth_exceptions/firebase_error_type.dart';
import 'package:asset_tracker/core/extensions/firebase_error_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/data/models/user_model.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_manager.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_provider.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_manager.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_provider.dart';
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
      ref.read(isLoadingProvider.notifier).state = true;
      final authNotifier = ref.read(authProvider.notifier);
      final userFirestoreNotifier = ref.read(userProvider.notifier);
      await authNotifier.register(
        emailController.text,
        passwordController.text,
        usernameController.text,
      );
      String id = authNotifier.user!.id;

      final user = UserModel(
          id: id,
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text);
      await userFirestoreNotifier.saveUserToFirestore(user);

      if (ref.watch(authProvider) == AuthState.authenticated &&
          ref.watch(userProvider) == UserState.succes) {
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
    } on FirebaseException catch (e) {
      // **Firestore spesifik hataları yakala**
      context.showSnackBar("Firestore Hatası: ${e.message}");
    } catch (e) {
      // Bilinmeyen hata durumu
      context.showSnackBar(TrStrings.unknownError);
    }
    // Yükleniyor durumunu pasif et
    finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }
}
