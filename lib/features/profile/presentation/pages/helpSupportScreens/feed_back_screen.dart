// import 'package:flutter/material.dart';
// import 'package:asset_tracker/core/extensions/build_context_extension.dart';
// import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
// import 'package:asset_tracker/core/constants/paddings/paddings.dart';
// import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';

// class FeedbackScreen extends StatelessWidget {
//   const FeedbackScreen({super.key});

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
//               Text('Uygulama hakkındaki düşüncelerinizi bizimle paylaşın',
//                   style: context.textTheme.headlineMedium?.copyWith(
//                     color: context.colorScheme.onSecondary,
//                   )),
//               SizedBox(height: MediaQuerySize(context).percent3Height),
//               _buildInputField(
//                 context,
//                 label: 'Başlık',
//                 hint: 'Geri bildiriminiz için bir başlık girin',
//               ),
//               SizedBox(height: MediaQuerySize(context).percent2Height),
//               _buildInputField(
//                 context,
//                 label: 'Geri Bildiriminiz',
//                 hint: 'Uygulama hakkındaki görüşlerinizi buraya yazın...',
//                 maxLines: 6,
//               ),
//               SizedBox(height: MediaQuerySize(context).percent3Height),
//               SizedBox(
//                 width: double.infinity,
//                 height: MediaQuerySize(context).percent7Height,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: context.colorScheme.primary,
//                     foregroundColor: context.colorScheme.onPrimary,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: AppBorderRadius.defaultBorderRadius,
//                     ),
//                   ),
//                   onPressed: () {
//                     // Geri bildirim gönderme işlemi
//                   },
//                   child: const Text('Gönder'),
//                 ),
//               ),
//               SizedBox(height: MediaQuerySize(context).percent2Height),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField(BuildContext context,
//       {required String label, required String hint, int maxLines = 1}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: context.textTheme.titleMedium?.copyWith(
//             color: context.colorScheme.onSecondary,
//           ),
//         ),
//         SizedBox(height: MediaQuerySize(context).percent1Height),
//         TextFormField(
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             hintText: hint,
//             filled: true,
//             fillColor: context.colorScheme.onSecondary.withAlpha(10),
//             border: const OutlineInputBorder(
//               borderRadius: AppBorderRadius.defaultBorderRadius,
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
