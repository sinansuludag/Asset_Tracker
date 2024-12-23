/// Firebase Hata Tipleri
enum FirebaseAuthErrorType {
  // Authentication Hataları

  /// Ağ hatası
  networkError('network-request-failed'),

  /// Kullanıcı bulunamadı
  userNotFound('user-not-found'),

  /// Yanlış şifre
  wrongPassword('wrong-password'),

  /// E-posta zaten kullanımda
  emailAlreadyInUse('email-already-in-use'),

  /// Hesap farklı kimlik bilgisiyle mevcut
  accountExistsWithDifferentCredential(
      'account-exists-with-different-credential'),

  /// Geçersiz kimlik bilgisi
  invalidCredential('invalid-credential'),

  /// Kullanıcı hesabı devre dışı
  userDisabled('user-disabled'),

  /// Zayıf şifre
  weakPassword('weak-password'),

  /// Son oturum açma gereklidir
  requiresRecentLogin('requires-recent-login'),

  /// Operasyon izinli değil
  operationNotAllowed('operation-not-allowed'),

  // Genel Hatalar

  /// Bilinmeyen hata
  unknownError('unknown-error'),

  /// Zaman aşımı
  timeout('timeout');

  // Değerlerin string karşılıklarını tutmak için
  final String code;

  // Constructor tanımı
  const FirebaseAuthErrorType(this.code);

  // Firebase hata koduna göre eşleştirme
  static FirebaseAuthErrorType fromCode(String code) {
    return FirebaseAuthErrorType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => FirebaseAuthErrorType.unknownError,
    );
  }
}
