// import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
// import 'package:asset_tracker/core/routing/route_names.dart';
// import 'package:flutter/material.dart';
// import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
// import 'package:asset_tracker/core/constants/paddings/paddings.dart';
// import 'package:asset_tracker/core/extensions/build_context_extension.dart';
// import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';

// class HelpSupportScreen extends StatelessWidget {
//   const HelpSupportScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: AppPaddings.horizontalSimetricDefaultPadding,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Yardım ve Destek',
//                   style: context.textTheme.headlineMedium?.copyWith(
//                     color: context.colorScheme.onSecondary,
//                   )),
//               SizedBox(height: MediaQuerySize(context).percent2Height),
//               Center(
//                 child: Container(
//                   width: MediaQuerySize(context).percent50Width,
//                   height: MediaQuerySize(context).percent50Width,
//                   decoration: const BoxDecoration(
//                     borderRadius: AppBorderRadius.lowBorderRadius,
//                   ),
//                   child: Image.asset(
//                     'bro'.png,
//                     //fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Text(
//                 'Yardım almak veya destek ekibimize ulaşmak için aşağıdaki seçenekleri kullanabilirsiniz.',
//                 style: context.textTheme.bodyMedium?.copyWith(
//                   color: context.colorScheme.onSecondary,
//                 ),
//               ),
//               SizedBox(height: MediaQuerySize(context).percent4Height),
//               helpSupportFormContainerWidget(
//                   context, 'Sık sorulan sorular', Icons.question_answer, () {
//                 Navigator.pushNamed(context, RouteNames.faqScreen);
//               }),
//               SizedBox(height: MediaQuerySize(context).percent1Height),
//               helpSupportFormContainerWidget(
//                   context, 'Destek Ekibiyle İletişime Geç', Icons.mail_outline,
//                   () {
//                 Navigator.pushNamed(context, RouteNames.contactSupport);
//               }),
//               SizedBox(height: MediaQuerySize(context).percent1Height),
//               helpSupportFormContainerWidget(
//                   context, 'Geri Bildirim Gönder', Icons.feedback_outlined, () {
//                 Navigator.pushNamed(context, RouteNames.feedBack);
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Container helpSupportFormContainerWidget(
//     BuildContext context,
//     String labelText,
//     IconData iconData,
//     VoidCallback onTap,
//   ) {
//     return Container(
//       decoration: BoxDecoration(
//         color: context.colorScheme.onSecondary.withAlpha(10),
//         borderRadius: AppBorderRadius.defaultBorderRadius,
//       ),
//       child: ListTile(
//         leading: Icon(iconData, color: context.colorScheme.onSecondary),
//         title: Text(
//           labelText,
//           style: context.textTheme.bodyLarge?.copyWith(
//             color: context.colorScheme.onSecondary,
//           ),
//         ),
//         trailing:
//             Icon(Icons.chevron_right, color: context.colorScheme.onSecondary),
//         onTap: onTap,
//       ),
//     );
//   }
// }
