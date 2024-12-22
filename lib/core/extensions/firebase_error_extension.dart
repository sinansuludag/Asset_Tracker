import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/exceptions/firebase_auth_exceptions/firebase_error_type.dart';

extension FirebaseErrorHandling on FirebaseAuthErrorType {
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
      default:
        return TrStrings.unknownError;
    }
  }
}
