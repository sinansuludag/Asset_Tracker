import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';

class ContributorsScreen extends StatelessWidget {
  const ContributorsScreen({super.key});

  final List<Map<String, String>> contributors = const [
    {
      'name': 'Sinan Suludağ',
      'role': 'Uygulama Geliştiricisi',
      'bio':
          'Asset Tracker uygulamasının tüm yazılım geliştirme süreci, kullanıcı arayüzü tasarımı ve işlevsel bileşenleri Sinan Suludağ tarafından geliştirilmiştir.',
    },
    {
      'name': 'Emre Gültekir',
      'role': 'Mentor & Kıdemli Geliştirici',
      'bio':
          'Geliştirme süreci boyunca mentorluk desteği vermiştir. Kod kalitesi, veri yönetimi ve mimari tasarım konularında yönlendirmelerde bulunmuştur.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Katkıda Bulunanlar',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSecondary,
            )),
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: AppPaddings.horizontalSimetricDefaultPadding,
        child: ListView.separated(
          itemCount: contributors.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: MediaQuerySize(context).percent1Height),
          itemBuilder: (context, index) {
            final person = contributors[index];
            return _buildContributorCard(
              context,
              name: person['name']!,
              role: person['role']!,
              bio: person['bio']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContributorCard(BuildContext context,
      {required String name, required String role, required String bio}) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onSurface.withAlpha(10),
        borderRadius: AppBorderRadius.defaultBorderRadius,
      ),
      padding: AppPaddings.allDefaultPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 26,
            child: Icon(Icons.person, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSecondary,
                    )),
                Text(role,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: context.colorScheme.onSecondary.withAlpha(170),
                    )),
                SizedBox(height: MediaQuerySize(context).percent1Height),
                Text(bio,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSecondary,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
