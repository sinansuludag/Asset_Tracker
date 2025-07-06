// import 'package:asset_tracker/core/routing/route_names.dart';
// import 'package:flutter/material.dart';
// import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
// import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
// import 'package:asset_tracker/core/constants/paddings/paddings.dart';
// import 'package:asset_tracker/core/extensions/build_context_extension.dart';
// import 'package:asset_tracker/core/margins/margins.dart';

// class AboutAppScreen extends StatelessWidget {
//   const AboutAppScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     final List<Map<String, Object>> aboutSettings = [
//       {
//         'icon': Icons.description_outlined,
//         'title': 'Uygulama Açıklaması',
//         'subtitle':
//             'Asset Tracker; varlık izleme, döviz kuru takibi ve kâr-zarar hesaplamaları için geliştirilmiş bir mobil uygulamadır.',
//         'onTap': () {
//           Navigator.pushNamed(context, RouteNames.aboutDescription);
//         },
//         'trailing': const SizedBox.shrink(),
//       },
//       {
//         'icon': Icons.info_outline,
//         'title': 'Sürüm',
//         'subtitle': '1.0.0',
//         'onTap': () {
//           Navigator.pushNamed(context, RouteNames.versionInfo);
//         },
//         'trailing': const SizedBox.shrink(),
//       },
//       {
//         'icon': Icons.system_update,
//         'title': 'Güncellemeleri Denetle',
//         'subtitle': 'Uygulamanın son sürümde olup olmadığını kontrol et',
//         'onTap': () {
//           Navigator.pushNamed(context, RouteNames.checkforUpdate);
//         },
//       },
//       {
//         'icon': Icons.people_outline,
//         'title': 'Katkıda Bulunanlar',
//         'subtitle': 'Geliştirme ekibi ve destek verenler',
//         'onTap': () {
//           Navigator.pushNamed(context, RouteNames.contributors);
//         },
//       },
//       {
//         'icon': Icons.code,
//         'title': 'Açık Kaynak Lisanslar',
//         'subtitle': 'Uygulamada kullanılan paketlerin lisansları',
//         'onTap': () => showLicensePage(
//               context: context,
//               applicationName: 'Asset Tracker',
//               applicationVersion: '1.0.0',
//             ),
//       },
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//       ),
//       body: Padding(
//         padding: AppPaddings.horizontalSimetricDefaultPadding,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Uygulama Hakkında',
//                 style: context.textTheme.headlineMedium?.copyWith(
//                   color: context.colorScheme.onSecondary,
//                 )),
//             SizedBox(height: MediaQuerySize(context).percent2Height),
//             settingContainerComponentWidget(
//               context,
//               'Genel Bilgiler',
//               aboutSettings,
//             ),
//             SizedBox(height: MediaQuerySize(context).percent3Height),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget settingContainerComponentWidget(
//     BuildContext context,
//     String title,
//     List<Map<String, Object>> settingsItems,
//   ) {
//     return Container(
//       decoration: BoxDecoration(
//         color: context.colorScheme.onSurface.withAlpha(10),
//         borderRadius: AppBorderRadius.defaultBorderRadius,
//       ),
//       padding: AppPaddings.horizontalSimetricLowPadding,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: AppPaddings.verticalSimetricLowPadding,
//             child: Text(
//               title,
//               style: context.textTheme.titleMedium?.copyWith(
//                 color: context.colorScheme.onSecondary,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           ...List.generate(settingsItems.length, (index) {
//             final item = settingsItems[index];
//             return Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: AppBorderRadius.defaultBorderRadius,
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       onTap: item['onTap'] as VoidCallback,
//                       borderRadius: AppBorderRadius.lowBorderRadius,
//                       child: Padding(
//                         padding: AppPaddings.verticalAndHorizontal_8_16,
//                         child: ListTile(
//                           dense: true,
//                           visualDensity:
//                               const VisualDensity(horizontal: 0, vertical: -3),
//                           contentPadding: EdgeInsets.zero,
//                           leading: Icon(item['icon'] as IconData,
//                               color: context.colorScheme.onSecondary),
//                           title: Text(item['title'] as String,
//                               style: context.textTheme.bodyLarge?.copyWith(
//                                 color: context.colorScheme.onSecondary,
//                               )),
//                           subtitle: item['subtitle'] != null
//                               ? Text(
//                                   item['subtitle'] as String,
//                                   style: context.textTheme.bodySmall?.copyWith(
//                                     color: context.colorScheme.onSecondary,
//                                   ),
//                                 )
//                               : null,
//                           trailing: item['trailing'] as Widget? ??
//                               const Icon(Icons.chevron_right),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (index != settingsItems.length - 1)
//                   Divider(
//                     color: context.colorScheme.onSecondary.withAlpha(35),
//                     thickness: 1,
//                     height: 0,
//                   )
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
