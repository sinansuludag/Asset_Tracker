import 'package:asset_tracker/features/home/domain/entities/asset_type_enum.dart';

/// Varlık tanımı model'i - issue'deki hangi varlıkların gösterileceğini belirler
/// Bu model sayesinde sadece izinli varlıklar gösterilir ve eklenebilir
class AssetDefinitionModel {
  final String id; // Veri kodu: ALTIN, EURTRY, vb.
  final String displayName; // Kullanıcıya gösterilecek isim
  final bool isSelectable; // Kullanıcı ekleyebilir mi? (EURUSD ve ONS false)
  final bool isVisible; // Ana sayfada gösterilecek mi?
  final AssetType type; // Altın, Döviz, Bilezik gibi tür bilgisi
  final String? description; // Açıklama metni (issue'den alınan)
  final String symbol; // Görsel sembol (AU, €, $ vs.)

  const AssetDefinitionModel({
    required this.id,
    required this.displayName,
    required this.isSelectable,
    required this.isVisible,
    required this.type,
    this.description,
    required this.symbol,
  });

  /// Firebase'den gelen JSON'u model'e çevir
  factory AssetDefinitionModel.fromJson(Map<String, dynamic> json) {
    return AssetDefinitionModel(
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '',
      isSelectable: json['isSelectable'] ?? false,
      isVisible: json['isVisible'] ?? false,
      type: AssetType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AssetType.gold,
      ),
      description: json['description'],
      symbol: json['symbol'] ?? '',
    );
  }

  /// Model'i JSON'a çevir (Firebase'e kaydetmek için)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'isSelectable': isSelectable,
      'isVisible': isVisible,
      'type': type.toString().split('.').last,
      'description': description,
      'symbol': symbol,
    };
  }
}
