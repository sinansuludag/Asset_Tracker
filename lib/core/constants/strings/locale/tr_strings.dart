class TrStrings {
  TrStrings._();

  ///Splash screen
  static const String splashTitleText1 = "Varlık";
  static const String splashTitleText2 = "İzleme";

  ///Login and register screen
  static const String signIn = "Giriş Yap";
  static const String signUp = "Kayıt Ol";
  static const String forgetPassword = "Şifremi Unuttum?";
  static const String textForGoToRegister = "Hesabınız yok mu? ";
  static const String textForGoToLogin = "Zaten bir hesabınız var mı? ";
  static const String requiredEmail = "Email zorunlu";
  static const String requiredPassword = "Şifre zorunlu";
  static const String requiredUsername = "Kullanıcı adı zorunlu";
  static const String labelEmail = "Email";
  static const String hintTextEmail = "Emailinizi giriniz";
  static const String labelPassword = "Şifre";
  static const String hintTextPassword = "Şifrenizi giriniz";
  static const String labelUsername = "Kullanıcı adi";
  static const String hintTextUsername = "Kullanıcı adınızı giriniz";
  static const String warningPasswordLength = "Şifre en az 6 karakterli olmalı";
  static const String invalidEmail = "Lütfen geçerli bir email adresi giriniz";

  ///ForgetPassword screen
  static const String forgetPasswordScreenTitle = "Şifremi Unuttum";
  static const String forgetPasswordScreenText =
      "Lütfen e-postanızı girin ve e-postanıza gelen bağlantıyı kullanarak yeni şifrenizi oluşturabilirsiniz.";
  static const String forgetPasswordScreenButtonText = "Devam Et";
  static const String fogetPasswordScreenNoAccountText = "Hesabınız yok mu? ";

  ///SnackBar messages
  static const String succesLogin = "Başarılı bir şekilde giriş yapıldı.";
  static const String succesRegister = "Başarılı bir şekilde kayıt olundu.";

  ///Exception messages
  static const String networkError = "İnternet bağlantınızı kontrol edin.";
  static const String userNotFound =
      "Kullanıcı bulunamadı. Lütfen tekrar deneyin.";
  static const String wrongPassword = "Yanlış şifre. Lütfen tekrar deneyin.";
  static const String emailAlreadyInUse = "Bu e-posta adresi zaten kullanımda.";
  static const String accountExistsWithDifferentCredential =
      "Bu e-posta adresi farklı bir kimlik bilgisi ile zaten kullanımda.";
  static const String unknownError = "Bilinmeyen bir hata oluştu.";
  static const String timeout = "Zaman aşımına uğradı. Lütfen tekrar deneyin.";
  static const String invalidCredential = "Geçersiz kimlik bilgisi.";
  static const String userDisabled = "Kullanıcı hesabı devre dışı";
  static const String weakPassword = "Zayıf şifre";
  static const String requiresRecentLogin = "Son oturum açma gereklidir";
  static const String operationNotAllowed = "Operasyon izinli değil";
}
