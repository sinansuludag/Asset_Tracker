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

  ///Home screen
  static const String homeScreenTitle = "Varlık İzleme";
  static const String buying = 'Alış';
  static const String selling = 'Satış';
  static const String unknown = 'Bilinmiyor';
  static const String lowest = 'En Düşük';
  static const String highest = 'En Yüksek';
  static const String close = 'Kapanış';
  static const String homeLabelText = 'Bir varlık arayın...';
  static const String homeHintText = 'Bir varlık arayın...';
  static const String bottomNavigationHome = 'Anasayfa';
  static const String bottomNavigationCurrency = 'Varlıklar';
  static const String bottomNavigationProfile = 'Profil';
  static const String buyingAssetScreenTitle = "Varlık Satın Al";
  static const String chooseAssetType = "  Varlık Türünü Seçin";
  static const String buyinPrice = 'Alış Fiyatı';
  static const String enterBuyingPrice = 'Alış Fiyatı Giriniz';
  static const String buyingScreenButtonText = 'Ekle';
  static const String buyingScreenEnterQuantity = 'Miktar Giriniz';
  static const String showDialogTitleText = 'Uyarı';
  static const String showDialogButtonText = 'Tamam';
  static const String dataPickerText = 'Tarih Seç';
  static const String quantityAssetEmpty = "Miktar boş olamaz";
  static const String requiredBuyingPrice = "Alış fiyatını giriniz";
  static const String requiredQuantityAmount = "Miktarı giriniz";
  static const String succesBuyingAsset =
      "Varlık başarılı bir şekilde eklendi.";
  static const String errorBuyingAsset = "Varlık eklenirken bir hata oluştu.";
  static const String warningBuyingAsset = "Miktar 0'dan küçük olamaz";
  static const String buyingAssetDialogTitleText = "Uyarı";
  static const String buyingAssetDialogButtonText = "Tamam";
  static const String cancelButtonText = 'İptal';

  ///Home Screen Currency Names
  static const altin = 'Altın';
  static const ata5Eski = '5\'li Ata (Eski)';
  static const ata5Yeni = '5\'li Ata (Yeni)';
  static const ataEski = 'Ata (Eski)';
  static const ataYeni = 'Ata (Yeni)';
  static const audTry = 'Avustralya Doları';
  static const audUsd = 'Avustralya Doları/ABD Doları';
  static const ayar14 = '14 Ayar Altın';
  static const ayar22 = '22 Ayar Altın';
  static const cadTry = 'Kanada Doları';
  static const ceyrekEski = 'Çeyrek Altın (Eski)';
  static const ceyrekYeni = 'Çeyrek Altın (Yeni)';
  static const chfTry = 'İsviçre Frangı';
  static const dkkTry = 'Danimarka Kronu';
  static const eurKg = '1 Kg Altın (Euro)';
  static const eurTry = 'Euro';
  static const eurUsd = 'Euro/ABD Doları';
  static const gbpTry = 'İngiliz Sterlini';
  static const gbpUsd = 'İngiliz Sterlini/ABD Doları';
  static const gremeseEski = 'Ziynet 2.5 Altın (Eski)';
  static const gremeseYeni = 'Ziynet 2.5 Altın (Yeni)';
  static const gumusTry = 'Gümüş';
  static const gumusUsd = 'Gümüş/ABD Doları';
  static const jpyTry = 'Japon Yeni';
  static const kulceAltin = '24 Ayar Gram Altın';
  static const nokTry = 'Norveç Kronu';
  static const ons = 'Ons Altın';
  static const paladyum = 'Paladyum';
  static const platin = 'Platin';
  static const sarTry = 'Suudi Arabistan Riyali';
  static const sekTry = 'İsveç Kronu';
  static const tekEski = 'Tam Altın (Eski)';
  static const tekYeni = 'Tam Altın (Yeni)';
  static const usdCad = 'ABD Doları/Kanada Doları';
  static const usdChf = 'ABD Doları/İsviçre Frangı';
  static const usdJpy = 'ABD Doları/Japon Yeni';
  static const usdKg = '1 Kg Altın (ABD Doları)';
  static const usdPure = 'Saf Altın (USD)';
  static const usdTry = 'ABD Doları';
  static const usdSar = 'ABD Doları/Suudi Arabistan Riyali';
  static const xagUsd = 'Ons Gümüş/ABD Doları';
  static const xauXag = 'Ons Altın/Ons Gümüş Paritesi';
  static const xpdUsd = 'Ons Paladyum/ABD Doları';
  static const xptUsd = 'Ons Platin/ABD Doları';
  static const yarimEski = 'Yarım Altın (Eski)';
  static const yarimYeni = 'Yarım Altın (Yeni)';
}
