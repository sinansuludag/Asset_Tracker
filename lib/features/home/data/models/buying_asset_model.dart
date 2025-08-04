import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';

/// Kullanıcının satın aldığı varlıkları temsil eden model
/// Firebase Firestore'da saklanacak gerçek veri yapısı
/// Issue'deki bilezik özel durumunu da destekler
class BuyingAssetModel extends AssetEntity {
  // Bilezik özel alanları
  final String? ayarType; // 14 veya 22 ayar (bilezik için zorunlu)
  final double? gramWeight; // Gram ağırlığı (bilezik için zorunlu)
  final String? assetSubType; // 'normal', 'bracelet' vs.

  BuyingAssetModel({
    required super.id,
    required super.assetType,
    required super.buyingDate,
    required super.buyingPrice,
    required super.quantity,
    required super.userId,
    this.ayarType,
    this.gramWeight,
    this.assetSubType,
  });

  @override
  BuyingAssetModel copyWith({
    String? id,
    String? assetType,
    DateTime? buyingDate,
    double? buyingPrice,
    double? quantity,
    String? userId,
    String? ayarType,
    double? gramWeight,
    String? assetSubType,
  }) {
    return BuyingAssetModel(
      id: id ?? this.id,
      assetType: assetType ?? this.assetType,
      buyingDate: buyingDate ?? this.buyingDate,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      quantity: quantity ?? this.quantity,
      userId: userId ?? this.userId,
      ayarType: ayarType ?? this.ayarType,
      gramWeight: gramWeight ?? this.gramWeight,
      assetSubType: assetSubType ?? this.assetSubType,
    );
  }

  /// Firebase Firestore'dan gelen JSON'u model'e çevirme
  factory BuyingAssetModel.fromJson(Map<String, dynamic> json) {
    return BuyingAssetModel(
      id: json['id'] ?? '',
      assetType: json['assetType'] ?? '',
      buyingDate: json['buyingDate'] != null
          ? DateTime.parse(json['buyingDate'])
          : DateTime.now(),
      buyingPrice: (json['buyingPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      userId: json['userId'] ?? '',
      ayarType: json['ayarType'],
      gramWeight: json['gramWeight']?.toDouble() ?? 0.0,
      assetSubType: json['assetSubType'] ?? 'normal',
    );
  }

  /// Model'i Firebase'e kaydetmek için JSON'a çevirme
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assetType': assetType,
      'buyingDate': buyingDate.toIso8601String(),
      'buyingPrice': buyingPrice,
      'quantity': quantity,
      'userId': userId,
      'ayarType': ayarType,
      'gramWeight': gramWeight,
      'assetSubType': assetSubType,
      'timestamp': DateTime.now().millisecondsSinceEpoch, // Sıralama için
    };
  }

  /// Bilezik kontrolü
  /// Varlığın bilezik olup olmadığını kontrol etme
  bool get isBracelet {
    return assetSubType == 'bracelet' ||
        (ayarType != null && gramWeight != null && gramWeight! > 0) ||
        _isAyarBasedAsset();
  }

  /// Ayar bazlı varlık kontrolü (AYAR14, AYAR22)
  bool _isAyarBasedAsset() {
    return assetType == 'AYAR14' || assetType == 'AYAR22';
  }

  ///Bilezik değeri hesaplama
  /// Bilezik seçilmesi durumunda değer = gramWeight × ayarPrice
  double calculateBraceletValue(double ayar14Price, double ayar22Price) {
    if (!isBracelet || gramWeight == null || ayarType == null) {
      return quantity * buyingPrice; // Normal hesaplama
    }

    // Ayar türüne göre fiyat belirleme
    final ayarPrice = ayarType == '14' ? ayar14Price : ayar22Price;
    return gramWeight! * ayarPrice;
  }

  /// Bilezik için görünen isim
  String get displayName {
    if (isBracelet && ayarType != null && gramWeight != null) {
      return '$ayarType Ayar Bilezik (${gramWeight!.toStringAsFixed(1)}g)';
    }
    return assetType; // Normal varlık adı
  }

  /// Bilezik için miktar birimi
  String get quantityUnit {
    if (isBracelet) {
      return 'gram';
    }

    // Normal varlıklar için birim belirleme
    switch (assetType.toLowerCase()) {
      case 'altin':
      case 'ayar14':
      case 'ayar22':
      case 'kulcealtin':
        return 'gram';
      case 'usdtry':
        return 'USD';
      case 'eurtry':
        return 'EUR';
      case 'gbptry':
        return 'GBP';
      default:
        return 'adet';
    }
  }
}
