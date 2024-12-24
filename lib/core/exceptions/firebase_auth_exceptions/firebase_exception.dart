import 'package:asset_tracker/core/exceptions/firebase_auth_exceptions/firebase_error_type.dart';

class CustomFirebaseAuthException implements Exception {
  final FirebaseAuthErrorType errorType;

  CustomFirebaseAuthException({required this.errorType});

  @override
  String toString() {
    return '$errorType';
  }
}
