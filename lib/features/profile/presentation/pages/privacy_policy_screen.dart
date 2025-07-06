// import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
// import 'package:flutter/material.dart';
// import 'package:asset_tracker/core/extensions/build_context_extension.dart';
// import 'package:asset_tracker/core/constants/paddings/paddings.dart';

// class PrivacyPolicyScreen extends StatelessWidget {
//   const PrivacyPolicyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Gizlilik Politikası"),
//         scrolledUnderElevation: 0,
//       ),
//       body: Padding(
//         padding: AppPaddings.allDefaultPadding,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Gizlilik Politikası',
//                 style: context.textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 )),
//             SizedBox(height: MediaQuerySize(context).percent1_5Height),
//             Text(
//               'Asset Tracker uygulaması, kullanıcı gizliliğine önem verir. Uygulama içerisinde herhangi bir kişisel veri toplanmaz, analiz edilmez veya üçüncü taraflarla paylaşılmaz.',
//               style: context.textTheme.bodyMedium,
//             ),
//             SizedBox(height: MediaQuerySize(context).percent1_5Height),
//             Text(
//               'Kayıtlı varlık verileri yalnızca kullanıcının kendi görüntülemesi ve yönetmesi amacıyla Firebase üzerinde saklanır. Bu veriler başka kullanıcılarla paylaşılmaz ve yalnızca ilgili kullanıcıya özel olarak şifreli biçimde tutulur.',
//               style: context.textTheme.bodyMedium,
//             ),
//             SizedBox(height: MediaQuerySize(context).percent1_5Height),
//             Text(
//               'Uygulama içerisinde Google, Facebook gibi harici kimlik doğrulama, analiz veya reklam hizmetleri kullanılmamaktadır.',
//               style: context.textTheme.bodyMedium,
//             ),
//             SizedBox(height: MediaQuerySize(context).percent1_5Height),
//             Text(
//               'Gizlilik politikası, uygulama işlevlerine yeni özellikler eklenmesi durumunda güncellenebilir. Bu tür değişiklikler durumunda kullanıcılar bu ekran üzerinden bilgilendirilecektir.',
//               style: context.textTheme.bodyMedium,
//             ),
//             SizedBox(height: MediaQuerySize(context).percent3Height),
//             GestureDetector(
//               onTap: () {},
//               child: Text(
//                 'Destek veya sorularınız için bizimle iletişime geçin.',
//                 style: context.textTheme.bodyMedium?.copyWith(
//                   color: context.colorScheme.primary,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: FilledButton(
//                 onPressed: () {
//                   // Kabul edildi veya geri dön
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Anladım'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
