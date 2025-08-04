/// Issue gereksinimlerine uygun varlık türleri
enum AssetType {
  gold, // Altın (Has altın, 22 ayar, 14 ayar vs.)
  currency, // Döviz (Euro/TL, Sterlin/TL vs.)
  platinum, // Platin
  silver, // Gümüş (gelecekte kullanım için)
}

extension AssetTypeExtension on AssetType {
  /// Türkçe görüntüleme adı
  String get displayName {
    switch (this) {
      case AssetType.gold:
        return 'Altın';
      case AssetType.currency:
        return 'Döviz';
      case AssetType.platinum:
        return 'Platin';
      case AssetType.silver:
        return 'Gümüş';
    }
  }

  /// Emoji ikonu
  String get icon {
    switch (this) {
      case AssetType.gold:
        return '🥇';
      case AssetType.currency:
        return '💱';
      case AssetType.platinum:
        return '⚪';
      case AssetType.silver:
        return '🥈';
    }
  }
}
