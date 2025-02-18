class CurrencyData {
  final String? code;
  final double? buying;
  final double? selling;
  final double? low;
  final double? high;
  final double? close;
  final String? date;
  final String? buyingDir;
  final String? sellingDir;

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

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    return CurrencyData(
      code: json['code'],
      buying: double.tryParse(json['alis'].toString()) ?? 0.0,
      selling: double.tryParse(json['satis'].toString()) ?? 0.0,
      low: double.tryParse(json['dusuk'].toString()) ?? 0.0,
      high: double.tryParse(json['yuksek'].toString()) ?? 0.0,
      close: double.tryParse(json['kapanis'].toString()) ?? 0.0,
      date: json['tarih'],
      buyingDir: json['dir']?['alis_dir'] ?? '',
      sellingDir: json['dir']?['satis_dir'] ?? '',
    );
  }

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
