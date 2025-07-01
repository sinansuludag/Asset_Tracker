class MarketWatchlistEntity {
  final String id;
  final String userId;
  final String marketCode;
  final double alertPrice;
  final String alertType; // 'above', 'below'
  final bool isActive;
  final DateTime createdAt;

  const MarketWatchlistEntity({
    required this.id,
    required this.userId,
    required this.marketCode,
    required this.alertPrice,
    required this.alertType,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'marketCode': marketCode,
      'alertPrice': alertPrice,
      'alertType': alertType,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MarketWatchlistEntity copyWith({
    String? id,
    String? userId,
    String? marketCode,
    double? alertPrice,
    String? alertType,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return MarketWatchlistEntity(
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
