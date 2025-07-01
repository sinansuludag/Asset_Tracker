import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/markets/domain/entities/market_entity.dart';

class MarketModel extends MarketEntity {
  const MarketModel({
    required super.code,
    required super.name,
    required super.category,
    required super.currentPrice,
    required super.change,
    required super.changePercentage,
    required super.volume,
    required super.high,
    required super.low,
    required super.trend,
    required super.lastUpdated,
    required super.isTrending,
  });

  factory MarketModel.fromCurrencyData(String code, CurrencyData data) {
    final name = code.getCurrencyName();
    final category = _getCategoryFromCode(code);
    final currentPrice = data.buying ?? 0.0;
    final change = _calculateChange(data);
    final changePercentage = _calculateChangePercentage(data);
    final volume = _getVolumeFromCode(code);
    final trend = data.buyingDir ?? 'stable';
    final isTrending = _isTrendingAsset(code, changePercentage);

    return MarketModel(
      code: code,
      name: name,
      category: category,
      currentPrice: currentPrice,
      change: change,
      changePercentage: changePercentage,
      volume: volume,
      high: data.high ?? currentPrice,
      low: data.low ?? currentPrice,
      trend: trend,
      lastUpdated: DateTime.now(),
      isTrending: isTrending,
    );
  }

  factory MarketModel.fromJson(Map<String, dynamic> json) {
    return MarketModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
      change: (json['change'] as num?)?.toDouble() ?? 0.0,
      changePercentage: (json['changePercentage'] as num?)?.toDouble() ?? 0.0,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.0,
      high: (json['high'] as num?)?.toDouble() ?? 0.0,
      low: (json['low'] as num?)?.toDouble() ?? 0.0,
      trend: json['trend'] ?? 'stable',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      isTrending: json['isTrending'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'category': category,
      'currentPrice': currentPrice,
      'change': change,
      'changePercentage': changePercentage,
      'volume': volume,
      'high': high,
      'low': low,
      'trend': trend,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isTrending': isTrending,
    };
  }

  @override
  MarketModel copyWith({
    String? code,
    String? name,
    String? category,
    double? currentPrice,
    double? change,
    double? changePercentage,
    double? volume,
    double? high,
    double? low,
    String? trend,
    DateTime? lastUpdated,
    bool? isTrending,
  }) {
    return MarketModel(
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      currentPrice: currentPrice ?? this.currentPrice,
      change: change ?? this.change,
      changePercentage: changePercentage ?? this.changePercentage,
      volume: volume ?? this.volume,
      high: high ?? this.high,
      low: low ?? this.low,
      trend: trend ?? this.trend,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isTrending: isTrending ?? this.isTrending,
    );
  }

  String get icon => _getMarketIcon(code);
  String get volumeLabel => _getVolumeLabel(volume);

  static String _getCategoryFromCode(String code) {
    const metalCodes = [
      'ALTIN',
      'GUMUSTRY',
      'AYAR14',
      'AYAR22',
      'ONS',
      'PALADYUM',
      'PLATIN'
    ];
    const currencyCodes = [
      'USDTRY',
      'EURTRY',
      'GBPTRY',
      'AUDTRY',
      'CADTRY',
      'CHFTRY'
    ];
    const cryptoCodes = ['BTCTRY', 'ETHTRY', 'ADATRY']; // Example crypto codes

    if (metalCodes.contains(code)) return 'metals';
    if (currencyCodes.contains(code)) return 'currency';
    if (cryptoCodes.contains(code)) return 'crypto';
    return 'other';
  }

  static double _calculateChange(CurrencyData data) {
    // Mock calculation - in real app, you'd calculate from previous price
    final currentPrice = data.buying ?? 0.0;
    final changePercentage = (data.buyingDir == 'up') ? 0.5 : -0.3;
    return currentPrice * (changePercentage / 100);
  }

  static double _calculateChangePercentage(CurrencyData data) {
    // Mock calculation
    return (data.buyingDir == 'up') ? 0.5 : -0.3;
  }

  static double _getVolumeFromCode(String code) {
    // Mock volume data
    const volumeMap = {
      'ALTIN': 1000000.0,
      'USDTRY': 2500000.0,
      'EURTRY': 800000.0,
      'GUMUSTRY': 500000.0,
    };
    return volumeMap[code] ?? 100000.0;
  }

  static bool _isTrendingAsset(String code, double changePercentage) {
    const trendingAssets = ['ALTIN', 'USDTRY'];
    return trendingAssets.contains(code) || changePercentage.abs() > 2.0;
  }

  static String _getMarketIcon(String code) {
    switch (code) {
      case 'ALTIN':
        return 'AU';
      case 'USDTRY':
        return '\$';
      case 'EURTRY':
        return '€';
      case 'GBPTRY':
        return '£';
      case 'GUMUSTRY':
        return 'AG';
      case 'AYAR14':
        return '14K';
      case 'AYAR22':
        return '22K';
      default:
        return code.substring(0, 2).toUpperCase();
    }
  }

  String _getVolumeLabel(double volume) {
    if (volume > 2000000) return 'Çok Yüksek';
    if (volume > 1000000) return 'Yüksek Hacim';
    if (volume > 500000) return 'Orta Hacim';
    return 'Düşük Hacim';
  }
}
