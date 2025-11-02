import 'package:asset_tracker/core/riverpod/all_riverpod.dart';
import 'package:asset_tracker/core/routing/app_router.dart';
import 'package:asset_tracker/core/theme/color_scheme.dart';
import 'package:asset_tracker/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// MyApp sınıfı, uygulamanın en üst seviyedeki widget’ıdır.
// ConsumerWidget, Riverpod provider’larını dinleyebilmemizi sağlar.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // themeModeProvider'ı dinliyoruz. (Light/Dark modunu belirler)
    final themeMode = ref.watch(themeModeProvider);

    // Sistem çubuğunun (status bar) görünümünü ayarlıyoruz
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Status bar’ı şeffaf yapar
        statusBarIconBrightness:
            Brightness.dark, // Status bar simgelerini koyu (dark) renkte yapar
      ),
    );

    // ScreenUtilInit ile ekran boyutlarına göre responsive tasarım başlatılır
    return ScreenUtilInit(
        designSize: const Size(360, 800), // Tasarımın referans boyutu
        minTextAdapt: true, // Yazı boyutlarını otomatik uyumlandır
        splitScreenMode: true, // Bölünmüş ekran modunu destekler
        builder: (context, child) {
          // Uygulamanın temel MaterialApp widget’ı
          return MaterialApp(
            debugShowCheckedModeBanner:
                false, // Sağ üstteki "Debug" etiketini gizler

            // Açık tema tanımı
            theme: ThemeData(
              colorScheme: AppColorScheme.lightColorScheme, // Açık renk şeması
              textTheme: AppTextTheme.lightTextTheme, // Açık mod yazı teması
            ),

            // Karanlık tema tanımı
            darkTheme: ThemeData(
              colorScheme:
                  AppColorScheme.darkColorScheme, // Karanlık renk şeması
              textTheme: AppTextTheme.darkTextTheme, // Karanlık mod yazı teması
            ),

            themeMode:
                themeMode, // Aktif tema modunu provider’dan alır (Light/Dark/System)

            onGenerateRoute: AppRouter
                .generateRoute, // Uygulama içinde sayfa geçişlerini yöneten fonksiyon
            initialRoute:
                '/', // Uygulamanın açılış rotası (genellikle Splash veya Home)
          );
        });
  }
}
