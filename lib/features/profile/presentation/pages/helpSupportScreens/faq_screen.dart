import 'package:flutter/material.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  final List<Map<String, String>> faqList = const [
    {
      'question': 'Uygulama nasıl çalışıyor?',
      'answer':
          'Uygulama, varlıklarınızı takip etmenizi sağlar ve döviz kurlarını anlık olarak sunar.'
    },
    {
      'question': 'Veriler ne sıklıkla güncelleniyor?',
      'answer': 'Veriler her 5 dakikada bir otomatik olarak güncellenir.'
    },
    {
      'question': 'Bildirimleri nasıl kapatabilirim?',
      'answer':
          'Profil > Bildirim Ayarları kısmından bildirim tercihlerinizi değiştirebilirsiniz.'
    },
    {
      'question': 'Verilerim güvende mi?',
      'answer':
          'Uygulama, verilerinizi sadece cihazda tutar ve güvenliğiniz için yerel şifreleme kullanır.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: AppPaddings.horizontalSimetricDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sık Sorulan Sorular',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: context.colorScheme.onSecondary,
                )),
            SizedBox(height: MediaQuerySize(context).percent2Height),
            ...faqList.map((item) =>
                _buildFAQCard(context, item['question']!, item['answer']!)),
            SizedBox(height: MediaQuerySize(context).percent3Height),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSecondary.withAlpha(10),
        borderRadius: AppBorderRadius.defaultBorderRadius,
      ),
      child: ClipRRect(
        borderRadius: AppBorderRadius.defaultBorderRadius,
        child: ExpansionTile(
          shape: Border.all(
            color: context.colorScheme.onSecondary.withAlpha(10),
            width: 0,
          ),
          tilePadding: AppPaddings.verticalAndHorizontal_4_8,
          childrenPadding: AppPaddings.verticalAndHorizontal_4_8,
          title: Text(
            question,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSecondary,
            ),
          ),
          iconColor: context.colorScheme.onSecondary,
          collapsedIconColor: context.colorScheme.onSecondary,
          children: [
            Text(
              answer,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSecondary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
