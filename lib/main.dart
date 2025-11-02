import 'package:asset_tracker/core/app/my_app.dart';
import 'package:asset_tracker/core/utils/initialize_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Flutter'ın widget sisteminin başlatılmadan önce düzgün çalışması için gerekli işlemleri yapar
  WidgetsFlutterBinding.ensureInitialized();

  // Uygulamanın sadece dikey modda çalışmasını sağlamak için cihazın yönünü belirler
  // Bu durumda cihaz yalnızca dikey (portrait) konumda çalışacaktır.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation
        .portraitUp, // Cihaz dikey olarak, yukarıya bakan yönde çalışacak.
    DeviceOrientation
        .portraitDown, // Cihaz dikey olarak, aşağıya bakan yönde de çalışacak.
  ]);

  // Firebase'i başlatan asenkron fonksiyonu çağırır.
  // Bu işlem, Firebase servislerinin düzgün çalışabilmesi için gereklidir.
  await initializeFirebase();

  // .env dosyasını yükler, burada çevresel değişkenler (API anahtarları, URL’ler vb.) saklanır.
  // Yükleme işlemi tamamlandığında .env içerisindeki veriler kullanılabilir.
  await dotenv.load(fileName: ".env");

  // .env dosyasındaki 'WEBSOCKET_URL' anahtarını alır ve konsola yazdırır.
  // Genellikle debug amaçlı kullanılır, böylece doğru URL’nin yüklendiği doğrulanabilir.
  print(dotenv.env['WEBSOCKET_URL']);

  // ProviderScope, uygulama genelinde Riverpod kullanabilmek için gereklidir.
  // Bu, uygulamanın tüm state yönetimini sağlamak için kullanılır.
  runApp(const ProviderScope(child: MyApp()));
}
