import 'package:asset_tracker/features/markets/domain/entities/market_watchlist_entity.dart';

class MarketWatchlistModel extends MarketWatchlistEntity {
  const MarketWatchlistModel({
    required super.id,
    required super.userId,
    required super.marketCode,
    required super.alertPrice,
    required super.alertType,
    required super.isActive,
    required super.createdAt,
  });

  factory MarketWatchlistModel.fromJson(Map<String, dynamic> json) {
    return MarketWatchlistModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      marketCode: json['marketCode'] ?? '',
      alertPrice: (json['alertPrice'] as num?)?.toDouble() ?? 0.0,
      alertType: json['alertType'] ?? 'above',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  @override
  MarketWatchlistModel copyWith({
    String? id,
    String? userId,
    String? marketCode,
    double? alertPrice,
    String? alertType,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return MarketWatchlistModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      marketCode: marketCode ?? this.marketCode,
      alertPrice: alertPrice ?? this.alertPrice,
      alertType: alertType ?? this.alertType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
