import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/presentation/pages/forget_password.dart';
import 'package:asset_tracker/features/auth/presentation/pages/login_screen.dart';
import 'package:asset_tracker/features/auth/presentation/pages/register_screen.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/pages/currency_asset_screen.dart';
import 'package:asset_tracker/features/home/presentation/pages/home_screen.dart';
import 'package:asset_tracker/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case RouteNames.forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteNames.currencyAssets:
        return MaterialPageRoute(builder: (_) => CurrencyAssetScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
