// import 'package:asset_tracker/core/constants/colors/app_colors.dart';
// import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
// import 'package:asset_tracker/core/utils/currency_list.dart';
// import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // UPDATED: Simple modal dialog without complex animations
// void showModernBuyingDialog(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     isDismissible: true,
//     enableDrag: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) => const ModernBuyingAssetDialog(),
//   );
// }

// class ModernBuyingAssetDialog extends ConsumerStatefulWidget {
//   const ModernBuyingAssetDialog({super.key});

//   @override
//   ConsumerState<ModernBuyingAssetDialog> createState() =>
//       _ModernBuyingAssetDialogState();
// }

// class _ModernBuyingAssetDialogState
//     extends ConsumerState<ModernBuyingAssetDialog> {
//   final _buyingAssetController = TextEditingController();
//   final _quantityAssetController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   DateTime? _selectedDate;
//   String? selectedAsset;

//   @override
//   void dispose() {
//     _buyingAssetController.dispose();
//     _quantityAssetController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.85,
//       minChildSize: 0.5,
//       maxChildSize: 0.95,
//       builder: (context, scrollController) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Handle
//               Container(
//                 margin: const EdgeInsets.only(top: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),

//               // Header
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: const BoxDecoration(
//                         gradient: AppColors.primaryGradient,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.add,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Yeni Varlık Ekle",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleLarge
//                                 ?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.textPrimary,
//                                 ),
//                           ),
//                           Text(
//                             "Portföyünüze yeni bir yatırım ekleyin",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(
//                                   color: AppColors.textSecondary,
//                                 ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.close),
//                       style: IconButton.styleFrom(
//                         backgroundColor: Colors.grey[100],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Form Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildSectionTitle("Varlık Türü"),
//                         const SizedBox(height: 12),
//                         _buildAssetDropdown(),
//                         const SizedBox(height: 24),
//                         _buildSectionTitle("Alış Fiyatı"),
//                         const SizedBox(height: 12),
//                         _buildPriceField(),
//                         const SizedBox(height: 24),
//                         _buildSectionTitle("Miktar"),
//                         const SizedBox(height: 12),
//                         _buildQuantityField(),
//                         const SizedBox(height: 24),
//                         _buildSectionTitle("Alış Tarihi"),
//                         const SizedBox(height: 12),
//                         _buildDatePicker(),
//                         const SizedBox(height: 40),
//                         _buildActionButtons(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: AppColors.textPrimary,
//           ),
//     );
//   }

//   Widget _buildAssetDropdown() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: DropdownButtonFormField<String>(
//         value: selectedAsset,
//         decoration: const InputDecoration(
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           prefixIcon: Icon(Icons.account_balance_wallet_outlined),
//         ),
//         hint: const Text("Varlık türünü seçin"),
//         isExpanded: true, // FIXED: Prevents overflow
//         items: Currency.currencyNames.map((currency) {
//           return DropdownMenuItem(
//             value: currency,
//             child: Text(
//               currency,
//               overflow: TextOverflow.ellipsis, // FIXED: Prevents text overflow
//               maxLines: 1,
//             ),
//           );
//         }).toList(),
//         onChanged: (value) {
//           setState(() {
//             selectedAsset = value;
//           });
//         },
//         validator: (value) {
//           if (value == null) return "Lütfen bir varlık seçin";
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildPriceField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: TextFormField(
//         controller: _buyingAssetController,
//         decoration: const InputDecoration(
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           prefixIcon: Icon(Icons.attach_money),
//           hintText: "Alış fiyatını giriniz",
//           suffix: Text("₺"),
//         ),
//         keyboardType: TextInputType.number,
//         validator: (value) {
//           if (value == null || value.isEmpty) return "Alış fiyatı gerekli";
//           if (double.tryParse(value) == null)
//             return "Geçerli bir fiyat giriniz";
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildQuantityField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () {
//               final currentValue =
//                   double.tryParse(_quantityAssetController.text) ?? 0;
//               if (currentValue > 0) {
//                 _quantityAssetController.text = (currentValue - 1).toString();
//               }
//             },
//             icon: const Icon(Icons.remove_circle_outline),
//             color: AppColors.primaryGreen,
//           ),
//           Expanded(
//             child: TextFormField(
//               controller: _quantityAssetController,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Miktar",
//                 contentPadding: EdgeInsets.symmetric(vertical: 16),
//               ),
//               textAlign: TextAlign.center,
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) return "Miktar gerekli";
//                 if (double.tryParse(value) == null)
//                   return "Geçerli bir miktar giriniz";
//                 return null;
//               },
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               final currentValue =
//                   double.tryParse(_quantityAssetController.text) ?? 0;
//               _quantityAssetController.text = (currentValue + 1).toString();
//             },
//             icon: const Icon(Icons.add_circle_outline),
//             color: AppColors.primaryGreen,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDatePicker() {
//     return GestureDetector(
//       onTap: () async {
//         final date = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2020),
//           lastDate: DateTime.now(),
//         );
//         if (date != null) {
//           setState(() {
//             _selectedDate = date;
//           });
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         decoration: BoxDecoration(
//           color: Colors.grey[50],
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey[200]!),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.calendar_today_outlined),
//             const SizedBox(width: 12),
//             Text(
//               _selectedDate != null
//                   ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
//                   : "Tarih seçin",
//               style: TextStyle(
//                 color: _selectedDate != null ? Colors.black : Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () => Navigator.pop(context),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               side: BorderSide(color: Colors.grey[300]!),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text("İptal"),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           flex: 2,
//           child: ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState!.validate() &&
//                   selectedAsset != null &&
//                   _selectedDate != null) {
//                 // Handle form submission
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Varlık başarıyla eklendi!"),
//                     backgroundColor: AppColors.primaryGreen,
//                   ),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Lütfen tüm alanları doldurun"),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               backgroundColor: AppColors.primaryGreen,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               "Varlık Ekle",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
