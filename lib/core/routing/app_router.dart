import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/presentation/pages/forget_password.dart';
import 'package:asset_tracker/features/auth/presentation/pages/login_screen.dart';
import 'package:asset_tracker/features/auth/presentation/pages/modern_forget_password_screen.dart';
import 'package:asset_tracker/features/auth/presentation/pages/modern_login_screen.dart';
import 'package:asset_tracker/features/auth/presentation/pages/modern_register_screen.dart';
import 'package:asset_tracker/features/auth/presentation/pages/register_screen.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/pages/currency_asset_screen.dart';
import 'package:asset_tracker/features/home/presentation/pages/home_screen.dart';
import 'package:asset_tracker/features/home/presentation/pages/main_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/aboutAppScreens/about_app_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/aboutAppScreens/about_description_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/aboutAppScreens/check_for_update_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/aboutAppScreens/contributors_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/aboutAppScreens/version_info_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/account_info_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/change_password_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/helpSupportScreens/contact_support_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/helpSupportScreens/faq_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/helpSupportScreens/feed_back_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/helpSupportScreens/help_support_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/language_settings_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/natification_settings_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/privacy_policy_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/rate_app_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/refresh_frequency_screen.dart';
import 'package:asset_tracker/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => ModernLoginScreen());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => ModernRegisterScreen());
      case RouteNames.forgetPassword:
        return MaterialPageRoute(builder: (_) => ModernForgetPasswordScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case RouteNames.currencyAssets:
        return MaterialPageRoute(builder: (_) => CurrencyAssetScreen());
      case RouteNames.accountInfo:
        return MaterialPageRoute(builder: (_) => AccountInfoScreen());
      case RouteNames.changePassword:
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());
      case RouteNames.changeLanguage:
        return MaterialPageRoute(builder: (_) => LanguageSettingsScreen());
      case RouteNames.helpSupport:
        return MaterialPageRoute(builder: (_) => HelpSupportScreen());
      case RouteNames.faqScreen:
        return MaterialPageRoute(builder: (_) => FAQScreen());
      case RouteNames.contactSupport:
        return MaterialPageRoute(builder: (_) => ContactSupportScreen());
      case RouteNames.feedBack:
        return MaterialPageRoute(builder: (_) => FeedbackScreen());
      case RouteNames.aboutApp:
        return MaterialPageRoute(builder: (_) => AboutAppScreen());
      case RouteNames.aboutDescription:
        return MaterialPageRoute(builder: (_) => AboutDescriptionScreen());
      case RouteNames.versionInfo:
        return MaterialPageRoute(builder: (_) => VersionInfoScreen());
      case RouteNames.checkforUpdate:
        return MaterialPageRoute(builder: (_) => CheckForUpdateScreen());
      case RouteNames.contributors:
        return MaterialPageRoute(builder: (_) => ContributorsScreen());
      case RouteNames.privacyPolicy:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());
      case RouteNames.rateApp:
        return MaterialPageRoute(builder: (_) => RateAppScreen());
      case RouteNames.notificationSettings:
        return MaterialPageRoute(builder: (_) => NotificationSettingsScreen());
      case RouteNames.refreshFrequency:
        return MaterialPageRoute(builder: (_) => RefreshFrequencyScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
