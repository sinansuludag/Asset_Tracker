import 'package:asset_tracker/core/routing/app_router.dart';
import 'package:asset_tracker/core/theme/color_scheme.dart';
import 'package:asset_tracker/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Durum çubuğunu şeffaf yapıyoruz
        statusBarIconBrightness:
            Brightness.dark, // Durum çubuğu simgelerini koyu yapıyoruz
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: AppColorScheme.lightColorScheme,
        textTheme: AppTextTheme.lightTextTheme,
      ),
      darkTheme: ThemeData(
        colorScheme: AppColorScheme.darkColorScheme,
        textTheme: AppTextTheme.darkTextTheme,
      ),
      themeMode: ThemeMode.light,
      onGenerateRoute: AppRouter.generateRoute, // Rota yöneticisini kullan
      initialRoute: '/', // Başlangıç rotası
    );
  }
}
