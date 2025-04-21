import 'package:asset_tracker/core/riverpod/all_riverpod.dart';
import 'package:asset_tracker/core/routing/app_router.dart';
import 'package:asset_tracker/core/theme/color_scheme.dart';
import 'package:asset_tracker/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
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
      themeMode: themeMode,
      onGenerateRoute: AppRouter.generateRoute, // Rota yöneticisini kullan
      initialRoute: '/', // Başlangıç rotası
    );
  }
}
