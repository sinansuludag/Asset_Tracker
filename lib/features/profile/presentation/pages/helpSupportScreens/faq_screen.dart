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
          'Uygulama, döviz ve kripto para birimlerinin anlık değerlerini WebSocket üzerinden alır. Kullanıcı, bu varlıklara dair alım/satım bilgilerini manuel olarak sisteme girer ve geçmiş işlemlerini grafiksel olarak takip edebilir.'
    },
    {
      'question': 'Veriler ne sıklıkla güncelleniyor?',
      'answer':
          'Varsayılan olarak veriler her 30 saniyede bir güncellenir. Ancak kullanıcı ayarlardan bu süreyi 5 saniye, 1 dakika, 5 dakika gibi farklı aralıklara değiştirebilir veya "Yalnızca Manuel" seçeneğini seçerek yalnızca yenile butonuna bastığında verilerin güncellenmesini sağlayabilir.'
    },
    {
      'question': 'Yenileme sıklığı nasıl değiştirilir?',
      'answer':
          'Profil > Uygulama Ayarları > Yenileme Sıklığı bölümünden veri güncellenme aralığını belirleyebilirsiniz.'
    },
    {
      'question': 'Bildirimleri nasıl kapatabilirim?',
      'answer':
          'Profil > Uygulama Ayarları > Bildirim Ayarları kısmından bildirim tercihlerinizi yönetebilirsiniz. Sistem bildirimleri uygulamanın bazı bölümlerinde aktif olabilir.'
    },
    {
      'question': 'Verilerim güvende mi?',
      'answer':
          'Cihazda tutulan veriler henüz şifrelenmemektedir. Ancak hassas bilgiler Firebase altyapısında güvenli şekilde saklanmaktadır. Yakında sürümlerde yerel veriler için şifreleme desteği eklenecektir.'
    },
    {
      'question': 'Karanlık mod desteği var mı?',
      'answer':
          'Evet. Profil > Uygulama Ayarları kısmından karanlık moda geçiş yapabilir ya da sistem temasını otomatik olarak kullanabilirsiniz.'
    },
    {
      'question': 'Dil ayarlarını nasıl değiştirebilirim?',
      'answer':
          'Profil > Uygulama Ayarları > Dil bölümünden mevcut diller arasında geçiş yapabilirsiniz.'
    },
    {
      'question': 'Uygulama çevrimdışı çalışır mı?',
      'answer':
          'Hayır. Uygulama, veri güncellemeleri için sürekli internet bağlantısına ihtiyaç duyar.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sık Sorulan Sorular"),
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: AppPaddings.horizontalSimetricDefaultPadding,
        child: ListView.builder(
          itemCount: faqList.length,
          itemBuilder: (context, index) {
            final question = faqList[index]['question']!;
            final answer = faqList[index]['answer']!;
            return _buildFAQCard(context, question, answer);
          },
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
