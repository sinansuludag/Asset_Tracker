// import 'package:asset_tracker/features/home/data/datasources/firebase_store/bracelet_calculation_service.dart';
// import 'package:asset_tracker/features/home/data/datasources/firebase_store/enhanced_portfolio_service.dart';
// import 'package:asset_tracker/features/home/data/models/portfolio_model.dart';
// import 'package:asset_tracker/features/home/data/models/user_asset_model.dart';
// import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
// import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
// import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// /// Geliştirilmiş Portföy State Notifier
// /// Eski PortfolioNotifier'ın yerini alır ve bilezik desteği ekler
// class EnhancedPortfolioNotifier extends StateNotifier<PortfolioModel> {
//   final Ref _ref;
//   final EnhancedPortfolioService _enhancedService;

//   EnhancedPortfolioNotifier(this._ref)
//       : _enhancedService = EnhancedPortfolioService(
//           FirebaseFirestore.instance,
//           FirebaseAuth.instance,
//         ),
//         super(PortfolioModel.initial()) {
//     _initializePortfolio();
//   }

//   void _initializePortfolio() {
//     // Currency güncellemelerini dinle
//     _ref.listen(currencyNotifierProvider, (previous, next) {
//       if (next.isNotEmpty) {
//         _calculateEnhancedPortfolio(next.first);
//       }
//     });

//     // İlk yükleme
//     refreshPortfolio();
//   }

//   /// Portföyü yenileme (Enhanced versiyon)
//   Future<void> refreshPortfolio() async {
//     state = state.copyWith(isLoading: true, hasError: false);

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         state = state.copyWith(isLoading: false, hasError: true);
//         return;
//       }

//       // Enhanced servis ile varlıkları çek
//       final userAssets = await _enhancedService.getUserAssetsStream().first;

//       // Güncel kurları al
//       final currencies = _ref.read(currencyNotifierProvider);

//       if (currencies.isNotEmpty) {
//         // Enhanced portföy hesaplama
//         _calculateEnhancedPortfolioWithAssets(userAssets, currencies.first);
//       } else {
//         state = state.copyWith(
//           assets: [],
//           isLoading: false,
//           hasError: false,
//         );
//       }
//     } catch (e) {
//       print('❌ Enhanced Portfolio refresh error: $e');
//       state = state.copyWith(
//         isLoading: false,
//         hasError: true,
//       );
//     }
//   }

//   /// Enhanced portföy hesaplama (Bilezik desteği ile)
//   void _calculateEnhancedPortfolio(CurrencyResponse currencyResponse) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       final userAssets = await _enhancedService.getUserAssetsStream().first;
//       _calculateEnhancedPortfolioWithAssets(userAssets, currencyResponse);
//     } catch (e) {
//       print('❌ Enhanced Portfolio calculation error: $e');
//     }
//   }

//   /// Gelişmiş portföy hesaplama
//   void _calculateEnhancedPortfolioWithAssets(
//       List<BuyingAssetModel> buyingAssets, CurrencyResponse currencyResponse) {
//     final List<UserAssetModel> userAssets = [];
//     double totalValue = 0.0;
//     double totalInvested = 0.0;

//     // Her varlık için hesaplama (bilezik desteği ile)
//     for (final buyingAsset in buyingAssets) {
//       final currencyData = currencyResponse.currencies[buyingAsset.assetType];
//       if (currencyData == null) continue;

//       double currentValue;
//       double investedAmount;

//       if (buyingAsset.isBracelet) {
//         // ✅ Issue gereksinimi: Bilezik özel hesaplama
//         currentValue = BraceletCalculationService.calculateBraceletValue(
//           bracelet: buyingAsset,
//           currencyData: currencyResponse,
//         );
//         investedAmount = buyingAsset.quantity * buyingAsset.buyingPrice;
//       } else {
//         // Normal varlık hesaplama
//         final currentPrice = currencyData.buying ?? 0.0;
//         currentValue = buyingAsset.quantity * currentPrice;
//         investedAmount = buyingAsset.quantity * buyingAsset.buyingPrice;
//       }

//       // UserAsset oluştur
//       final userAsset = _createEnhancedUserAsset(
//           buyingAsset, currencyData, currentValue, investedAmount);

//       userAssets.add(userAsset);
//       totalValue += currentValue;
//       totalInvested += investedAmount;
//     }

//     // Toplam kar/zarar hesaplama
//     final totalChange = totalValue - totalInvested;
//     final changePercentage =
//         totalInvested > 0 ? (totalChange / totalInvested) * 100 : 0.0;

//     // Enhanced state güncelleme
//     state = PortfolioModel(
//       totalValue: totalValue,
//       totalChange: totalChange,
//       changePercentage: changePercentage,
//       assets: userAssets,
//       isLoading: false,
//       hasError: false,
//     );

//     // Debug bilgisi
//     print('📊 Enhanced Portfolio hesaplama tamamlandı:');
//     print('   Toplam Değer: ₺${totalValue.toStringAsFixed(2)}');
//     print('   Toplam Yatırım: ₺${totalInvested.toStringAsFixed(2)}');
//     print(
//         '   Kar/Zarar: ₺${totalChange.toStringAsFixed(2)} (%${changePercentage.toStringAsFixed(2)})');
//     print('   Varlık Sayısı: ${userAssets.length}');
//   }

//   /// Enhanced UserAsset oluşturma
//   UserAssetModel _createEnhancedUserAsset(
//     BuyingAssetModel buyingAsset,
//     dynamic currencyData,
//     double currentValue,
//     double investedAmount,
//   ) {
//     final change = currentValue - investedAmount;
//     final changePercentage =
//         investedAmount > 0 ? (change / investedAmount) * 100 : 0.0;

//     return UserAssetModel(
//       id: buyingAsset.id,
//       assetType: buyingAsset.assetType,
//       displayName: _getEnhancedDisplayName(buyingAsset),
//       quantity: buyingAsset.quantity,
//       averagePrice: buyingAsset.buyingPrice,
//       currentPrice: currencyData.buying ?? 0.0,
//       currentValue: currentValue,
//       change: change,
//       changePercentage: changePercentage,
//       icon: _getEnhancedIcon(buyingAsset),
//       lastUpdated: DateTime.now(),
//     );
//   }

//   /// Bilezik desteği ile display name
//   String _getEnhancedDisplayName(BuyingAssetModel asset) {
//     if (asset.isBracelet) {
//       return '${asset.ayarType} Ayar Bilezik (${asset.gramWeight}g)';
//     }
//     return asset.assetType; // Extension kullanılabilir
//   }

//   /// Bilezik desteği ile ikon
//   String _getEnhancedIcon(BuyingAssetModel asset) {
//     if (asset.isBracelet) {
//       return '📿'; // Bilezik emojisi
//     }
//     // Normal ikon logic
//     switch (asset.assetType.toUpperCase()) {
//       case 'ALTIN':
//         return 'AU';
//       case 'EURTRY':
//         return '€';
//       case 'GBPTRY':
//         return '£';
//       default:
//         return '₺';
//     }
//   }

//   /// En performanslı varlıkları getir
//   // Map<String, dynamic> getTopPerformers() {
//   //   if (state.assets.isEmpty) return {};

//   //   final currencies = _ref.read(currencyNotifierProvider);
//   //   if (currencies.isEmpty) return {};

//   //   return _enhancedService.getTopPerformingAssets(
//   //     assets: state.assets
//   //         .map((ua) => BuyingAssetModel(
//   //               id: ua.id,
//   //               assetType: ua.assetType,
//   //               buyingDate: DateTime.now(),
//   //               buyingPrice: ua.averagePrice,
//   //               quantity: ua.quantity,
//   //               userId: '',
//   //             ))
//   //         .toList(),
//   //     currencyData: currencies.first,
//   //   );
//   // }
// }
