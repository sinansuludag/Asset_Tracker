// import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
// import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
// import 'package:flutter/material.dart';
// import 'package:asset_tracker/core/extensions/build_context_extension.dart';
// import 'package:asset_tracker/core/constants/paddings/paddings.dart';

// class CheckForUpdateScreen extends StatelessWidget {
//   const CheckForUpdateScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final color = context.colorScheme;

//     // Geçici değerler – sadece UI için
//     final String currentVersion = '1.0.0';
//     final String lastChecked = 'Bugün 14:53';
//     final bool isUpToDate = true;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Güncellemeleri Denetle"),
//         scrolledUnderElevation: 0,
//       ),
//       body: Padding(
//         padding: AppPaddings.allDefaultPadding,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Spacer(flex: 1),
//             Icon(
//               isUpToDate
//                   ? Icons.check_circle_outline
//                   : Icons.new_releases_outlined,
//               size: 72,
//               color: isUpToDate ? color.primary : color.error,
//             ),
//             SizedBox(height: MediaQuerySize(context).percent2Height),
//             Text(
//               isUpToDate ? 'Güncelsiniz' : 'Yeni Sürüm Mevcut',
//               style: context.textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: MediaQuerySize(context).percent1Height),
//             Text(
//               isUpToDate
//                   ? 'Kullanılabilir yeni bir güncelleme yok'
//                   : 'Yeni özellikler için uygulamayı güncelleyin',
//               style: context.textTheme.bodyMedium,
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: MediaQuerySize(context).percent3Height),
//             rowTextWidget(context, 'Mevcut Sürüm:', currentVersion),
//             SizedBox(height: MediaQuerySize(context).percent1Height),
//             rowTextWidget(context, 'Son Kontrol:', lastChecked),
//             const Spacer(flex: 2),
//             Center(
//                 child: Material(
//               color: color.primary,
//               borderRadius: AppBorderRadius.defaultBorderRadius,
//               child: InkWell(
//                 borderRadius: AppBorderRadius.defaultBorderRadius,
//                 onTap: () {
//                   // Butona basılınca yapılacak işlem
//                 },
//                 child: Padding(
//                   padding: AppPaddings.verticalAndHorizontal_16_24,
//                   child: Text(
//                     'Yeniden Kontrol Et',
//                     style: context.textTheme.bodyMedium?.copyWith(
//                       color: color.onPrimary,
//                     ),
//                   ),
//                 ),
//               ),
//             )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget rowTextWidget(BuildContext context, String textKey, String textValue) {
//     return Padding(
//       padding: AppPaddings.horizontalSimetricLowPadding,
//       child: Container(
//         decoration: BoxDecoration(
//           color: context.colorScheme.onSurface.withAlpha(10),
//           borderRadius: AppBorderRadius.lowBorderRadius,
//         ),
//         child: Padding(
//           padding: AppPaddings.allLowPadding,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(textKey, style: context.textTheme.bodyMedium),
//               Text(textValue, style: context.textTheme.bodyMedium),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
