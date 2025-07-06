// import 'package:flutter/material.dart';
// import 'package:asset_tracker/core/extensions/build_context_extension.dart';
// import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
// import 'package:asset_tracker/core/constants/paddings/paddings.dart';
// import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';

// class ContactSupportScreen extends StatelessWidget {
//   const ContactSupportScreen({super.key});

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
//               Text('Bize bir mesaj bırakın',
//                   style: context.textTheme.headlineMedium?.copyWith(
//                     color: context.colorScheme.onSecondary,
//                     fontWeight: FontWeight.bold,
//                   )),
//               SizedBox(height: MediaQuerySize(context).percent3Height),
//               _buildInputField(
//                 context,
//                 label: 'Konu',
//                 hint: 'Kısa bir konu girin',
//               ),
//               SizedBox(height: MediaQuerySize(context).percent1_5Height),
//               _buildInputField(
//                 context,
//                 label: 'E-posta',
//                 hint: 'E-posta adresiniz',
//               ),
//               SizedBox(height: MediaQuerySize(context).percent1_5Height),
//               _buildInputField(
//                 context,
//                 label: 'Mesajınız',
//                 hint: 'Destek talebinizi buraya yazın...',
//                 maxLines: 7,
//               ),
//               SizedBox(height: MediaQuerySize(context).percent4Height),
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
//                     // Mesaj gönderme işlemi
//                   },
//                   child: const Text('Gönder'),
//                 ),
//               )
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
//         const SizedBox(height: 8),
//         TextFormField(
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             hintText: hint,
//             filled: true,
//             fillColor: context.colorScheme.onSecondary.withAlpha(10),
//             border: OutlineInputBorder(
//               borderRadius: AppBorderRadius.defaultBorderRadius,
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
