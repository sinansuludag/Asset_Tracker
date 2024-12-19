import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/presentation/pages/forget_password.dart';
import 'package:asset_tracker/features/auth/presentation/pages/login_screen.dart';
import 'package:asset_tracker/features/auth/presentation/pages/register_screen.dart';
import 'package:asset_tracker/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteNames.forgetPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
