import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';

/// Haremaltın WebSocket'inden gelen tam response
/// Tüm döviz/altın verilerini içeren ana model
class CurrencyResponse {
  final Map<String, CurrencyData> currencies; // Tüm para birimleri
  final String metaTime; // Veri zamanı
  final String metaDate; // Veri tarihi

  CurrencyResponse({
    required this.currencies,
    required this.metaTime,
    required this.metaDate,
  });

  /// Haremaltın WebSocket JSON formatından model oluşturma
  /// Format: {"data": {"ALTIN": {...}, "USDTRY": {...}}, "meta": {...}}
  factory CurrencyResponse.fromJson(Map<String, dynamic> json) {
    Map<String, CurrencyData> currencyMap = {};

    // 'data' field'ındaki her para birimi için CurrencyData oluştur
    final dataMap = json['data'] as Map<String, dynamic>? ?? {};
    dataMap.forEach((key, value) {
      if (value != null) {
        currencyMap[key] = CurrencyData.fromJson(value);
      }
    });

    return CurrencyResponse(
      currencies: currencyMap,
      metaTime: json['meta']?['time']?.toString() ?? '',
      metaDate: json['meta']?['tarih']?.toString() ?? '',
    );
  }

  /// Immutable update için copyWith
  CurrencyResponse copyWith({
    Map<String, CurrencyData>? currencies,
    String? metaTime,
    String? metaDate,
  }) {
    return CurrencyResponse(
      currencies: currencies ?? this.currencies,
      metaTime: metaTime ?? this.metaTime,
      metaDate: metaDate ?? this.metaDate,
    );
  }

  /// Belirli bir varlığın verilerini getirme
  CurrencyData? getCurrencyData(String assetCode) {
    return currencies[assetCode];
  }

  /// Issue gereksinimi: Sadece izinli varlıkları filtrele
  CurrencyResponse filterByAllowedAssets(List<String> allowedAssetIds) {
    final filteredCurrencies = <String, CurrencyData>{};

    for (final assetId in allowedAssetIds) {
      if (currencies.containsKey(assetId)) {
        filteredCurrencies[assetId] = currencies[assetId]!;
      }
    }

    return copyWith(currencies: filteredCurrencies);
  }
}
