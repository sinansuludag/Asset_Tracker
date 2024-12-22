import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Hata Tipleri
enum FirebaseAuthErrorType {
  // Authentication Hataları
  networkError, // Ağ hatası
  userNotFound, // Kullanıcı bulunamadı
  wrongPassword, // Yanlış şifre
  emailAlreadyInUse, // E-posta zaten kullanımda

  accountExistsWithDifferentCredential, // Hesap farklı kimlik bilgisiyle mevcut

  // Genel Hatalar
  unknownError, // Bilinmeyen hata
  timeout, // Zaman aşımı
}

/// FirebaseAuthException İçin Hata Türü Belirleme
FirebaseAuthErrorType getErrorTypeFromAuthException(FirebaseAuthException e) {
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
    default:
      return FirebaseAuthErrorType.unknownError;
  }
}
