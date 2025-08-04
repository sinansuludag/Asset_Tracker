import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';

/// Bilezik değer hesaplama servisi
/// Bilezik değeri = gramWeight × ayarPrice
class BraceletCalculationService {
  /// Bilezik değerini hesapla
  static double calculateBraceletValue({
    required BuyingAssetModel bracelet,
    required CurrencyResponse currencyData,
  }) {
    // Bilezik kontrolü
    if (!bracelet.isBracelet ||
        bracelet.gramWeight == null ||
        bracelet.ayarType == null) {
      return bracelet.quantity * bracelet.buyingPrice; // Normal hesaplama
    }

    // Ayar fiyatlarını WebSocket'den al
    final ayar14Data = currencyData.currencies['AYAR14'];
    final ayar22Data = currencyData.currencies['AYAR22'];

    if (ayar14Data == null || ayar22Data == null) {
      print('⚠️ Ayar fiyatları bulunamadı, manuel fiyat kullanılıyor');
      return bracelet.quantity * bracelet.buyingPrice;
    }

    // Issue gereksinimi: Ayar türüne göre fiyat seç
    final double ayarPrice;
    if (bracelet.ayarType == '14') {
      ayarPrice = ayar14Data.buying ?? 0.0;
    } else if (bracelet.ayarType == '22') {
      ayarPrice = ayar22Data.buying ?? 0.0;
    } else {
      print('⚠️ Geçersiz ayar türü: ${bracelet.ayarType}');
      return bracelet.quantity * bracelet.buyingPrice;
    }

    // Issue gereksinimi: Bilezik değeri = gramWeight × ayarPrice
    final calculatedValue = bracelet.gramWeight! * ayarPrice;

    print('💍 Bilezik hesaplama:');
    print('   Gram: ${bracelet.gramWeight}g');
    print('   Ayar: ${bracelet.ayarType}');
    print('   Ayar Fiyatı: ₺${ayarPrice.toStringAsFixed(2)}');
    print('   Toplam Değer: ₺${calculatedValue.toStringAsFixed(2)}');

    return calculatedValue;
  }

  /// Bilezik kar/zarar hesaplama
  static Map<String, double> calculateBraceletProfitLoss({
    required BuyingAssetModel bracelet,
    required CurrencyResponse currencyData,
  }) {
    final currentValue = calculateBraceletValue(
      bracelet: bracelet,
      currencyData: currencyData,
    );

    final investedAmount = bracelet.quantity * bracelet.buyingPrice;
    final profitLoss = currentValue - investedAmount;
    final profitLossPercentage =
        investedAmount > 0 ? (profitLoss / investedAmount) * 100 : 0.0;

    return {
      'currentValue': currentValue,
      'investedAmount': investedAmount,
      'profitLoss': profitLoss,
      'profitLossPercentage': profitLossPercentage,
    };
  }
}
