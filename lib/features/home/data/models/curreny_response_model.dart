import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';

/// Tüm döviz verilerini içeren ana response model
class CurrencyResponse {
  final Map<String, CurrencyData> currencies; // Tüm para birimleri
  final String metaTime; // Veri zamanı
  final String metaDate; // Veri tarihi

  CurrencyResponse({
    required this.currencies,
    required this.metaTime,
    required this.metaDate,
  });

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) {
    // Her para birimi için CurrencyData oluştur
    Map<String, CurrencyData> currencyMap = {};
    json['data']?.forEach((key, value) {
      currencyMap[key] = CurrencyData.fromJson(value ?? {});
    });

    return CurrencyResponse(
      currencies: currencyMap,
      metaTime: json['meta']['time'].toString(),
      metaDate: json['meta']['tarih'] ?? '',
    );
  }

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
}
