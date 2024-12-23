import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/exceptions/firebase_auth_exceptions/firebase_error_type.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseErrorHandlingExtension on FirebaseAuthErrorType {
  String getErrorMessage() {
    switch (this) {
      case FirebaseAuthErrorType.networkError:
        return TrStrings.networkError;
      case FirebaseAuthErrorType.userNotFound:
        return TrStrings.userNotFound;
      case FirebaseAuthErrorType.wrongPassword:
        return TrStrings.wrongPassword;
      case FirebaseAuthErrorType.emailAlreadyInUse:
        return TrStrings.emailAlreadyInUse;
      case FirebaseAuthErrorType.accountExistsWithDifferentCredential:
        return TrStrings.accountExistsWithDifferentCredential;
      case FirebaseAuthErrorType.timeout:
        return TrStrings.timeout;
      case FirebaseAuthErrorType.invalidCredential:
        return TrStrings.invalidCredential;
      case FirebaseAuthErrorType.userDisabled:
        return TrStrings.userDisabled;
      case FirebaseAuthErrorType.weakPassword:
        return TrStrings.weakPassword;
      case FirebaseAuthErrorType.requiresRecentLogin:
        return TrStrings.requiresRecentLogin;
      case FirebaseAuthErrorType.operationNotAllowed:
        return TrStrings.operationNotAllowed;
      default:
        return TrStrings.unknownError;
    }
  }

  /// FirebaseAuthException İçin Hata Türü Belirleme
  static FirebaseAuthErrorType getErrorTypeFromAuthException(
      FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return FirebaseAuthErrorType.userNotFound;
      case 'wrong-password':
        return FirebaseAuthErrorType.wrongPassword;
      case 'email-already-in-use':
        return FirebaseAuthErrorType.emailAlreadyInUse;
      case 'account-exists-with-different-credential':
        return FirebaseAuthErrorType.accountExistsWithDifferentCredential;
      case 'network-request-failed':
        return FirebaseAuthErrorType.networkError;
      case 'timeout':
        return FirebaseAuthErrorType.timeout;
      case 'invalid-credential':
        return FirebaseAuthErrorType.invalidCredential;
      case 'user-disabled':
        return FirebaseAuthErrorType.userDisabled;
      case 'weak-password':
        return FirebaseAuthErrorType.weakPassword;
      case 'requires-recent-login':
        return FirebaseAuthErrorType.requiresRecentLogin;
      case 'operation-not-allowed':
        return FirebaseAuthErrorType.operationNotAllowed;
      default:
        return FirebaseAuthErrorType.unknownError;
    }
  }
}
