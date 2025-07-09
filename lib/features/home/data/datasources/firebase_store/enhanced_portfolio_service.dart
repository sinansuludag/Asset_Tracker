import 'package:asset_tracker/features/home/data/datasources/firebase_store/bracelet_calculation_service.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Geliştirilmiş portföy servisi - Bilezik hesaplama dahil
class EnhancedPortfolioService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  EnhancedPortfolioService(this._firestore, this._auth);

  /// Kullanıcının tüm varlıklarını getir (real-time)
  Stream<List<BuyingAssetModel>> getUserAssetsStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('user_assets')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BuyingAssetModel.fromJson(doc.data()))
            .toList());
  }

  /// Portföy özet bilgileri hesapla
  Map<String, dynamic> calculatePortfolioSummary({
    required List<BuyingAssetModel> assets,
    required CurrencyResponse currencyData,
  }) {
    double totalCurrentValue = 0.0;
    double totalInvestedAmount = 0.0;
    int totalAssetCount = assets.length;
    int braceletCount = 0;
    double braceletTotalValue = 0.0;

    for (final asset in assets) {
      final currencyInfo = currencyData.currencies[asset.assetType];
      if (currencyInfo == null) continue;

      double currentValue;
      double investedAmount;

      if (asset.isBracelet) {
        // Bilezik özel hesaplama
        braceletCount++;
        currentValue = BraceletCalculationService.calculateBraceletValue(
          bracelet: asset,
          currencyData: currencyData,
        );
        braceletTotalValue += currentValue;
        investedAmount = asset.quantity * asset.buyingPrice;
      } else {
        // Normal varlık hesaplama
        final currentPrice = currencyInfo.buying ?? 0.0;
        currentValue = asset.quantity * currentPrice;
        investedAmount = asset.quantity * asset.buyingPrice;
      }

      totalCurrentValue += currentValue;
      totalInvestedAmount += investedAmount;
    }

    final totalProfitLoss = totalCurrentValue - totalInvestedAmount;
    final totalProfitLossPercentage = totalInvestedAmount > 0
        ? (totalProfitLoss / totalInvestedAmount) * 100
        : 0.0;

    return {
      'totalCurrentValue': totalCurrentValue,
      'totalInvestedAmount': totalInvestedAmount,
      'totalProfitLoss': totalProfitLoss,
      'totalProfitLossPercentage': totalProfitLossPercentage,
      'totalAssetCount': totalAssetCount,
      'braceletCount': braceletCount,
      'braceletTotalValue': braceletTotalValue,
      'braceletPercentage': totalCurrentValue > 0
          ? (braceletTotalValue / totalCurrentValue) * 100
          : 0.0,
    };
  }

  /// Varlıkları türe göre analiz et
  Map<String, dynamic> analyzeAssetsByType({
    required List<BuyingAssetModel> assets,
    required CurrencyResponse currencyData,
  }) {
    final Map<String, double> typeValues = {};
    final Map<String, int> typeCounts = {};

    for (final asset in assets) {
      final currencyInfo = currencyData.currencies[asset.assetType];
      if (currencyInfo == null) continue;

      double currentValue;
      if (asset.isBracelet) {
        currentValue = BraceletCalculationService.calculateBraceletValue(
          bracelet: asset,
          currencyData: currencyData,
        );
      } else {
        final currentPrice = currencyInfo.buying ?? 0.0;
        currentValue = asset.quantity * currentPrice;
      }

      // Tür bazında toplama
      final assetTypeKey = asset.isBracelet ? 'Bilezik' : asset.assetType;
      typeValues[assetTypeKey] =
          (typeValues[assetTypeKey] ?? 0.0) + currentValue;
      typeCounts[assetTypeKey] = (typeCounts[assetTypeKey] ?? 0) + 1;
    }

    // Yüzde hesaplama
    final totalValue = typeValues.values.fold(0.0, (sum, value) => sum + value);
    final Map<String, double> typePercentages = {};

    typeValues.forEach((type, value) {
      typePercentages[type] = totalValue > 0 ? (value / totalValue) * 100 : 0.0;
    });

    return {
      'typeValues': typeValues,
      'typeCounts': typeCounts,
      'typePercentages': typePercentages,
      'totalValue': totalValue,
    };
  }

  /// En karlı/zararlı varlıkları getir
  Map<String, dynamic> getTopPerformingAssets({
    required List<BuyingAssetModel> assets,
    required CurrencyResponse currencyData,
  }) {
    BuyingAssetModel? mostProfitable;
    BuyingAssetModel? mostLoss;
    double maxProfit = double.negativeInfinity;
    double maxLoss = double.infinity;

    for (final asset in assets) {
      final currencyInfo = currencyData.currencies[asset.assetType];
      if (currencyInfo == null) continue;

      double currentValue;
      if (asset.isBracelet) {
        currentValue = BraceletCalculationService.calculateBraceletValue(
          bracelet: asset,
          currencyData: currencyData,
        );
      } else {
        final currentPrice = currencyInfo.buying ?? 0.0;
        currentValue = asset.quantity * currentPrice;
      }

      final investedAmount = asset.quantity * asset.buyingPrice;
      final profitLoss = currentValue - investedAmount;

      if (profitLoss > maxProfit) {
        maxProfit = profitLoss;
        mostProfitable = asset;
      }

      if (profitLoss < maxLoss) {
        maxLoss = profitLoss;
        mostLoss = asset;
      }
    }

    return {
      'mostProfitable': mostProfitable,
      'mostLoss': mostLoss,
      'maxProfit': maxProfit,
      'maxLoss': maxLoss,
    };
  }

  /// Varlık ekleme (bilezik desteği ile)
  Future<bool> addAssetWithBraceletSupport(BuyingAssetModel asset) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Bilezik validasyonu
      if (asset.isBracelet) {
        if (asset.ayarType == null || asset.gramWeight == null) {
          print('❌ Bilezik için ayar ve gram ağırlığı gerekli');
          return false;
        }

        if (!['14', '22'].contains(asset.ayarType)) {
          print('❌ Geçersiz ayar türü: ${asset.ayarType}');
          return false;
        }

        if (asset.gramWeight! <= 0) {
          print('❌ Gram ağırlığı pozitif olmalı');
          return false;
        }
      }

      // Firestore'a kaydet
      final docRef = _firestore.collection('user_assets').doc();
      final assetWithId = asset.copyWith(
        id: docRef.id,
        userId: user.uid,
      );

      await docRef.set(assetWithId.toJson());
      print('✅ Varlık başarıyla eklendi: ${assetWithId.id}');
      return true;
    } catch (e) {
      print('❌ Varlık ekleme hatası: $e');
      return false;
    }
  }

  /// Bilezik önerileri getir
  Future<Map<String, dynamic>> getBraceletRecommendations({
    required double gramWeight,
    required double budget,
    required CurrencyResponse currencyData,
  }) async {
    try {
      final recommendations =
          BraceletCalculationService.getRecommendedBraceletPrices(
        gramWeight: gramWeight,
        currencyData: currencyData,
      );

      final optimalAyar =
          BraceletCalculationService.getOptimalAyarRecommendation(
        gramWeight: gramWeight,
        currencyData: currencyData,
        budget: budget,
      );

      return {
        'success': true,
        'recommendations': recommendations,
        'optimalAyar': optimalAyar,
        'gramWeight': gramWeight,
        'budget': budget,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
