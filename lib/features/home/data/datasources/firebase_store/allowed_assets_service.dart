import 'package:asset_tracker/features/home/data/models/asset_definition_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_type_enum.dart';

/// İzinli varlıklar servisi - Sadece extension'daki varlıklar
class AllowedAssetsService {
  static const List<AssetDefinitionModel> _allowedAssets = [
    // =====================================================
    // ALTIN GRUBU
    // =====================================================
    AssetDefinitionModel(
      id: 'ALTIN',
      displayName: 'Altın',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: 'AU',
    ),
    AssetDefinitionModel(
      id: 'KULCEALTIN',
      displayName: '24 Ayar Gram Altın',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '24K',
    ),
    AssetDefinitionModel(
      id: 'AYAR22',
      displayName: '22 Ayar Altın',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '22K',
    ),
    AssetDefinitionModel(
      id: 'AYAR14',
      displayName: '14 Ayar Altın',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '14K',
    ),

    // =====================================================
    // ALTIN SİKKELER
    // =====================================================
    AssetDefinitionModel(
      id: 'TEK_YENI',
      displayName: 'Tam Altın (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1',
    ),
    AssetDefinitionModel(
      id: 'TEK_ESKI',
      displayName: 'Tam Altın (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1',
    ),
    AssetDefinitionModel(
      id: 'YARIM_YENI',
      displayName: 'Yarım Altın (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1/2',
    ),
    AssetDefinitionModel(
      id: 'YARIM_ESKI',
      displayName: 'Yarım Altın (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1/2',
    ),
    AssetDefinitionModel(
      id: 'CEYREK_YENI',
      displayName: 'Çeyrek Altın (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1/4',
    ),
    AssetDefinitionModel(
      id: 'CEYREK_ESKI',
      displayName: 'Çeyrek Altın (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1/4',
    ),
    AssetDefinitionModel(
      id: 'ATA_YENI',
      displayName: 'Ata (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: 'ATA',
    ),
    AssetDefinitionModel(
      id: 'ATA_ESKI',
      displayName: 'Ata (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: 'ATA',
    ),
    AssetDefinitionModel(
      id: 'ATA5_YENI',
      displayName: '5\'li Ata (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '5ATA',
    ),
    AssetDefinitionModel(
      id: 'ATA5_ESKI',
      displayName: '5\'li Ata (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '5ATA',
    ),
    AssetDefinitionModel(
      id: 'GREMESE_YENI',
      displayName: 'Ziynet 2.5 Altın (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: 'GR',
    ),
    AssetDefinitionModel(
      id: 'GREMESE_ESKI',
      displayName: 'Ziynet 2.5 Altın (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: 'GR',
    ),

    // =====================================================
    // DÖVİZLER
    // =====================================================
    AssetDefinitionModel(
      id: 'USDTRY',
      displayName: 'ABD Doları',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: '\$',
    ),
    AssetDefinitionModel(
      id: 'EURTRY',
      displayName: 'Euro',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: '€',
    ),
    AssetDefinitionModel(
      id: 'GBPTRY',
      displayName: 'İngiliz Sterlini',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: '£',
    ),
    AssetDefinitionModel(
      id: 'CHFTRY',
      displayName: 'İsviçre Frangı',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: 'CHF',
    ),
    AssetDefinitionModel(
      id: 'CADTRY',
      displayName: 'Kanada Doları',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: 'CAD',
    ),
    AssetDefinitionModel(
      id: 'AUDTRY',
      displayName: 'Avustralya Doları',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: 'AUD',
    ),
    AssetDefinitionModel(
      id: 'JPYTRY',
      displayName: 'Japon Yeni',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: '¥',
    ),
    AssetDefinitionModel(
      id: 'SARTRY',
      displayName: 'Suudi Arabistan Riyali',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: 'SAR',
    ),
    AssetDefinitionModel(
      id: 'NOKTRY',
      displayName: 'Norveç Kronu',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: 'NOK',
    ),
    AssetDefinitionModel(
      id: 'DKKTRY',
      displayName: 'Danimarka Kronu',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: 'DKK',
    ),
    AssetDefinitionModel(
      id: 'SEKTRY',
      displayName: 'İsveç Kronu',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      symbol: 'SEK',
    ),

    // =====================================================
    // METALLER
    // =====================================================
    AssetDefinitionModel(
      id: 'GUMUSTRY',
      displayName: 'Gümüş',
      isSelectable: true,
      isVisible: true,
      type: AssetType.silver,
      symbol: 'AG',
    ),
    AssetDefinitionModel(
      id: 'PLATIN',
      displayName: 'Platin',
      isSelectable: true,
      isVisible: true,
      type: AssetType.platinum,
      symbol: 'PT',
    ),
    AssetDefinitionModel(
      id: 'PALADYUM',
      displayName: 'Paladyum',
      isSelectable: true,
      isVisible: true,
      type: AssetType.platinum,
      symbol: 'PD',
    ),

    // =====================================================
    // SADECE GÖSTERİM (ONS - Eklenemez)
    // =====================================================
    AssetDefinitionModel(
      id: 'ONS',
      displayName: 'Ons Altın',
      isSelectable: false, // ❌ ONS eklenemez, sadece görünür
      isVisible: true,
      type: AssetType.gold,
      symbol: 'OZ',
    ),
  ];

  /// Tüm varlıkları getir
  static List<AssetDefinitionModel> getAllAssets() {
    return List.from(_allowedAssets);
  }

  /// Ana sayfada gösterilecek varlıkları getir (isVisible: true)
  static List<AssetDefinitionModel> getVisibleAssets() {
    return _allowedAssets.where((asset) => asset.isVisible).toList();
  }

  /// Kullanıcının ekleyebileceği varlıkları getir (isSelectable: true)
  static List<AssetDefinitionModel> getSelectableAssets() {
    return _allowedAssets.where((asset) => asset.isSelectable).toList();
  }

  /// Türe göre varlıkları getir
  static List<AssetDefinitionModel> getAssetsByType(AssetType type) {
    return _allowedAssets.where((asset) => asset.type == type).toList();
  }

  /// ID'ye göre varlık getir
  static AssetDefinitionModel? getAssetById(String id) {
    try {
      return _allowedAssets.firstWhere((asset) => asset.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Varlığın eklenip eklenemeyeceğini kontrol et
  static bool canAddAsset(String assetId) {
    final asset = getAssetById(assetId);
    return asset?.isSelectable ?? false;
  }

  /// Ana sayfada gösterilecek öncelikli varlıklar (market overview için)
  static List<AssetDefinitionModel> getPriorityAssets() {
    final priorities = [
      'ALTIN', // Altın
      'USDTRY', // ABD Doları
      'EURTRY', // Euro
      'GBPTRY', // İngiliz Sterlini
      'GUMUSTRY', // Gümüş
      'PLATIN', // Platin
      'ONS', // Ons
    ];
    return priorities
        .map((id) => getAssetById(id))
        .where((asset) => asset != null)
        .cast<AssetDefinitionModel>()
        .toList();
  }

  /// Bilezik için ayar listesi
  static List<String> getBraceletAyarOptions() {
    return ['14', '22'];
  }
}
