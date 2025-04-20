import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';

class VersionInfoScreen extends StatelessWidget {
  const VersionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sürüm Bilgisi')),
      body: Padding(
        padding: AppPaddings.horizontalSimetricDefaultPadding,
        child: Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
              borderRadius: AppBorderRadius.defaultBorderRadius),
          child: Padding(
            padding: AppPaddings.allDefaultPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sürüm 1.0.0',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    )),
                SizedBox(height: MediaQuerySize(context).percent1Height),
                Text('İlk Yayın',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSecondary,
                    )),
                SizedBox(height: MediaQuerySize(context).percent1Height),
                Text(
                  'Asset Tracker’ın ilk sürümü ile karşınızdayız! Varlık yönetimi artık çok daha kolay.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSecondary,
                  ),
                ),
                SizedBox(height: MediaQuerySize(context).percent1_5Height),

                /// Özellikler listesi
                _feature(context, 'Varlık ekleme ve düzenleme'),
                _feature(context, 'Anlık portföy performans takibi'),
                _feature(context, 'Kâr-zarar hesaplama ve raporlama'),
                _feature(context, 'Firebase destekli güvenli veri saklama'),
                _feature(context, 'Uygulama içi tema desteği (açık/koyu)'),
                _feature(
                    context, 'Bildirim ayarları ve senkronizasyon kontrolleri'),
                _feature(context,
                    'Hesap yönetimi: profil bilgisi ve şifre değiştirme'),
                _feature(context, '“Uygulama Hakkında” ve gizlilik ekranları'),
                _feature(context, 'Yardım ve SSS sayfaları ile destek erişimi'),
                _feature(context, '🌍 Çoklu Dil Desteği'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _feature(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.primary,
              )),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSecondary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
