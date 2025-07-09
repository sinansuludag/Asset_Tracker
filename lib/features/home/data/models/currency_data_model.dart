/// Haremaltın WebSocket'inden gelen tek bir döviz/altın verisi
/// Her varlık için alış, satış, yüksek, düşük fiyat bilgileri
class CurrencyData {
  final String? code; // Para birimi kodu (USDTRY, ALTIN vs.)
  final double? buying; // Alış fiyatı (portföy hesaplama için kritik)
  final double? selling; // Satış fiyatı
  final double? low; // Günün en düşük fiyatı
  final double? high; // Günün en yüksek fiyatı
  final double? close; // Kapanış fiyatı
  final String? date; // Tarih
  final String? buyingDir; // Alış yönü (up/down) - trend göstergesi
  final String? sellingDir; // Satış yönü (up/down)

  CurrencyData({
    this.code,
    this.buying,
    this.selling,
    this.low,
    this.high,
    this.close,
    this.date,
    this.buyingDir,
    this.sellingDir,
  });

  /// Haremaltın WebSocket JSON formatından model oluşturma
  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    return CurrencyData(
      code: json['code'],
      // Haremaltın'dan gelen 'alis' field'ını 'buying'e çevir
      buying: double.tryParse(json['alis']?.toString() ?? '0') ?? 0.0,
      selling: double.tryParse(json['satis']?.toString() ?? '0') ?? 0.0,
      low: double.tryParse(json['dusuk']?.toString() ?? '0') ?? 0.0,
      high: double.tryParse(json['yuksek']?.toString() ?? '0') ?? 0.0,
      close: double.tryParse(json['kapanis']?.toString() ?? '0') ?? 0.0,
      date: json['tarih'],
      // Trend yönleri
      buyingDir: json['dir']?['alis_dir'] ?? '',
      sellingDir: json['dir']?['satis_dir'] ?? '',
    );
  }

  /// Immutable update için copyWith
  CurrencyData copyWith({
    String? code,
    double? buying,
    double? selling,
    double? low,
    double? high,
    double? close,
    String? date,
    String? buyingDir,
    String? sellingDir,
  }) {
    return CurrencyData(
      code: code ?? this.code,
      buying: buying ?? this.buying,
      selling: selling ?? this.selling,
      low: low ?? this.low,
      high: high ?? this.high,
      close: close ?? this.close,
      date: date ?? this.date,
      buyingDir: buyingDir ?? this.buyingDir,
      sellingDir: sellingDir ?? this.sellingDir,
    );
  }
}
