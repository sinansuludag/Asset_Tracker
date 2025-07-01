abstract class MarketEntity {
  final String code;
  final String name;
  final String category; // 'metals', 'currency', 'crypto'
  final double currentPrice;
  final double change;
  final double changePercentage;
  final double volume;
  final double high;
  final double low;
  final String trend; // 'up', 'down', 'stable'
  final DateTime lastUpdated;
  final bool isTrending;

  const MarketEntity({
    required this.code,
    required this.name,
    required this.category,
    required this.currentPrice,
    required this.change,
    required this.changePercentage,
    required this.volume,
    required this.high,
    required this.low,
    required this.trend,
    required this.lastUpdated,
    required this.isTrending,
  });

  Map<String, dynamic> toJson();

  MarketEntity copyWith({
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
  });
}
