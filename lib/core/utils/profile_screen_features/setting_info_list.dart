import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> accountSettings(BuildContext context) => [
      {
        'icon': Icons.person,
        'title': 'Hesap Bilgileri',
        'subtitle': 'Hesap bilgilerinizi görüntüleyin ve düzenleyin',
        'onTap': () {
          Navigator.pushNamed(context, RouteNames.accountInfo);
        },
      },
      {
        'icon': Icons.lock,
        'title': 'Şifre Değiştir',
        'subtitle': 'Şifre bilgilerinizi güncelleyin',
        'onTap': () {
          Navigator.pushNamed(context, RouteNames.changePassword);
        },
      },
    ];

List<Map<String, dynamic>> appSettings(BuildContext context) => [
      {
        'icon': Icons.language,
        'title': 'Dil',
        'subtitle': 'Uygulama dilini değiştirin',
        'onTap': () {
          Navigator.pushNamed(context, RouteNames.changeLanguage);
        },
      },
      {
        'icon': Icons.dark_mode,
        'title': 'Karanlık Mod',
        'subtitle': 'Koyu temayı aç/kapat',
        'trailing': Switch(value: true, onChanged: (val) {}),
        'onTap': () {},
      },
      // {
      //   'icon': Icons.sync,
      //   'title': 'Otomatik Senkronizasyon',
      //   'subtitle': 'Arka planda verileri otomatik güncelle',
      //   'trailing': Switch(value: false, onChanged: (val) {}),
      //   'onTap': () {},
      // },
      {
        'icon': Icons.system_security_update,
        'title': 'Sistem Temasını Kullan',
        'subtitle': 'Cihaz ayarlarına göre tema değiştir',
        'trailing': Switch(value: true, onChanged: (val) {}),
        'onTap': () {},
      },
      {
        'icon': Icons.watch_later_outlined,
        'title': 'Yenileme Sıklığı',
        'subtitle': 'Veri yenileme aralığını ayarla',
        'onTap': () {
          Navigator.pushNamed(context, RouteNames.refreshFrequency);
        },
      },
      {
        'icon': Icons.notifications,
        'title': 'Bildirim Ayarları',
        'subtitle': 'Bildirim tercihlerini yönet',
        'trailing': Switch(value: true, onChanged: (val) {}),
        'onTap': () {
          Navigator.pushNamed(context, RouteNames.notificationSettings);
        },
      },
      // {
      //   'icon': Icons.security,
      //   'title': 'Güvenlik Ayarları',
      //   'subtitle': 'Gizlilik ve güvenlik ayarlarını düzenle',
      //   'onTap': () {},
      // },
    ];

List<Map<String, dynamic>> supportSettings(BuildContext context) => [
      {
        'icon': Icons.help_outline,
        'title': 'Yardım ve Destek',
        'subtitle': 'Yardım alın veya destekle iletişime geçin',
        'onTap': () {
          Navigator.pushNamed(context, RouteNames.helpSupport);
        },
      },
      {
        'icon': Icons.info_outline,
        'title': 'Uygulama Hakkında',
        'subtitle': 'Sürüm ve yasal bilgiler',
        'onTap': () {
          Navigator.pushNamed(context, RouteNames.aboutApp);
        },
      },
      {
        'icon': Icons.privacy_tip_outlined,
        'title': 'Gizlilik Politikası',
        'subtitle': 'Gizlilik koşullarını okuyun',
        'onTap': () {
          Navigator.pushNamed(context, RouteNames.privacyPolicy);
        },
      },
      {
        'icon': Icons.star_border,
        'title': 'Uygulamayı Değerlendir',
        'subtitle': 'Puan verin veya yorum yapın',
        'onTap': () {
          Navigator.pushNamed(context, RouteNames.rateApp);
        },
      },
    ];
