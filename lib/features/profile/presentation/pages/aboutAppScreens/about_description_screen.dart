import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';

class AboutDescriptionScreen extends StatelessWidget {
  const AboutDescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: AppPaddings.horizontalSimetricDefaultPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Uygulama Açıklaması',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              Text(
                'Asset Tracker nedir?',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent1Height),
              Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurface.withAlpha(10),
                  borderRadius: AppBorderRadius.defaultBorderRadius,
                ),
                child: Padding(
                  padding: AppPaddings.allDefaultPadding,
                  child: Text(
                    'Asset Tracker, bireylerin ve yatırımcıların döviz kuru bazlı varlıklarını kolay ve etkili bir şekilde yönetebilmeleri için tasarlanmış modern bir mobil uygulamadır.',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              Text(
                'Ne işe yarar?',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent1_5Height),
              Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurface.withAlpha(10),
                  borderRadius: AppBorderRadius.defaultBorderRadius,
                ),
                child: Padding(
                  padding: AppPaddings.allDefaultPadding,
                  child: Text(
                    '• Anlık döviz kuru verilerini takip edebilirsiniz.\n'
                    '• Portföyünüze yeni varlıklar ekleyebilir veya mevcutları düzenleyebilirsiniz.\n'
                    '• Varlıklarınızın toplam değerini, alım fiyatını, ortalama maliyetini ve güncel piyasa karşılığını görebilirsiniz.\n'
                    '• Gerçek zamanlı kâr-zarar analizleri ile ne kadar kazandığınızı veya kaybettiğinizi anlık olarak görüntüleyebilirsiniz.\n'
                    '• Tüm veriler Firebase üzerinden güvenli şekilde bulutta saklanır. Böylece cihaz değiştirseniz bile verileriniz kaybolmaz.\n'
                    '• Otomatik senkronizasyon özelliği ile uygulama verilerinizi bulutla sürekli güncel tutar.',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              Text(
                'Gizlilik ve Güvenlik',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent1_5Height),
              Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurface.withAlpha(10),
                  borderRadius: AppBorderRadius.defaultBorderRadius,
                ),
                child: Padding(
                  padding: AppPaddings.allDefaultPadding,
                  child: Text(
                    'Uygulama, kullanıcı verilerini üçüncü taraflarla paylaşmaz. '
                    'Tüm veriler Firebase altyapısı üzerinde saklanır ve sadece kullanıcıya özel erişimle güvence altına alınır. '
                    'Veriler, Firebase Authentication ve Firestore güvenlik kuralları çerçevesinde korunur. '
                    'Gizliliğiniz her şeyden önce gelir.',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
