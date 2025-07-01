import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:flutter/material.dart';

class PortfolioAssetsWidget extends StatelessWidget {
  final List<dynamic> assets;
  final Map<String, dynamic> currencyData;
  final Map<String, double> lastKnownPrices;
  final Function(dynamic) onAssetTap;
  final Function(dynamic) onAssetDelete;

  const PortfolioAssetsWidget({
    super.key,
    required this.assets,
    required this.currencyData,
    required this.lastKnownPrices,
    required this.onAssetTap,
    required this.onAssetDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Varlıklarım",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all assets
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tüm varlıklar sayfası yakında..."),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                },
                child: Text(
                  "Tümünü Gör",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...assets.map((asset) => _buildAssetCard(context, asset)),
        ],
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, dynamic asset) {
    if (asset == null) return const SizedBox();

    final currentPrice = _getCurrentPrice(asset.assetType);
    final totalInvested = asset.buyingPrice * asset.quantity;
    final currentValue = currentPrice * asset.quantity;
    final change = currentValue - totalInvested;
    final changePercentage =
        totalInvested > 0 ? (change / totalInvested) * 100 : 0.0;
    final isPositive = change >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border(
          left: BorderSide(
            color: isPositive ? Colors.green : Colors.red,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onAssetTap(asset),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Asset Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Center(
                    child: Text(
                      _getAssetIcon(asset.assetType),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Asset Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDisplayName(asset.assetType),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${asset.quantity} adet • Ort. ₺${asset.buyingPrice.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Value and Change
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₺${currentValue.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${isPositive ? '+' : ''}₺${change.toStringAsFixed(2)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isPositive ? Colors.green : Colors.red,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isPositive
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${isPositive ? '+' : ''}${changePercentage.toStringAsFixed(1)}%",
                            style: TextStyle(
                              color: isPositive ? Colors.green : Colors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // More Options
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      onAssetDelete(asset);
                    } else if (value == 'edit') {
                      // Edit functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Düzenleme özelliği yakında..."),
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text("Düzenle"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Sil", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getCurrentPrice(String assetType) {
    // First try to get from current currency data
    final currencyInfo = currencyData[assetType];
    if (currencyInfo?.buying != null) {
      return currencyInfo.buying;
    }

    // Fallback to last known prices
    return lastKnownPrices[assetType] ?? 0.0;
  }

  String _getDisplayName(String assetType) {
    // Önce currency code'dan Türkçe isime çevirmeyi dene
    try {
      final name = assetType.getCurrencyName();
      if (name != 'Bilinmeyen Kod') {
        return name;
      }
    } catch (e) {
      // Extension hata verirse devam et
    }

    // Manuel mapping ile kontrol et
    final manualMapping = {
      'ALTIN': 'Altın',
      'USDTRY': 'ABD Doları/Türk Lirası',
      'EURTRY': 'Euro/Türk Lirası',
      'GBPTRY': 'İngiliz Sterlini/Türk Lirası',
      'AYAR14': '14 Ayar Altın',
      'AYAR22': '22 Ayar Altın',
      'GUMUSTRY': 'Gümüş/Türk Lirası',
      'ONS': 'Ons Altın',
      'PALADYUM': 'Paladyum',
      'PLATIN': 'Platin',
      'XPTUSD': 'Platin (USD)',
      'ATA5_ESKI': "Eski 5'li Ata Altın",
      'ATA5_YENI': "Yeni 5'li Ata Altın",
      'ATA_ESKI': 'Eski Ata Altın',
      'ATA_YENI': 'Yeni Ata Altın',
      'CEYREK_ESKI': 'Eski Çeyrek Altın',
      'CEYREK_YENI': 'Yeni Çeyrek Altın',
      'TEK_ESKI': 'Eski Tam Altın',
      'TEK_YENI': 'Yeni Tam Altın',
      'YARIM_ESKI': 'Eski Yarım Altın',
      'YARIM_YENI': 'Yeni Yarım Altın',
      'GREMESE_ESKI': 'Eski Gremse Altın',
      'GREMESE_YENI': 'Yeni Gremse Altın',
      'KULCEALTIN': 'Külçe Altın',
    };

    return manualMapping[assetType.toUpperCase()] ?? assetType;
  }

  String _getAssetIcon(String assetType) {
    // Currency code'a göre icon döndür
    final codeToCheck = _getCurrencyCode(assetType) ?? assetType.toUpperCase();

    switch (codeToCheck) {
      case 'ALTIN':
        return 'AU';
      case 'USDTRY':
        return '\$';
      case 'EURTRY':
        return '€';
      case 'GBPTRY':
        return '£';
      case 'AYAR14':
        return '14K';
      case 'AYAR22':
        return '22K';
      case 'GUMUSTRY':
        return 'AG';
      case 'ONS':
        return 'OZ';
      case 'PALADYUM':
        return 'PD';
      case 'PLATIN':
      case 'XPTUSD':
        return 'PT';
      case 'ATA5_ESKI':
      case 'ATA5_YENI':
        return '5A';
      case 'ATA_ESKI':
      case 'ATA_YENI':
        return 'AT';
      case 'CEYREK_ESKI':
      case 'CEYREK_YENI':
        return 'ÇE';
      case 'TEK_ESKI':
      case 'TEK_YENI':
        return 'TK';
      case 'YARIM_ESKI':
      case 'YARIM_YENI':
        return 'YR';
      case 'GREMESE_ESKI':
      case 'GREMESE_YENI':
        return 'GR';
      default:
        // Fallback: İlk 2 karakteri kullan
        if (assetType.length >= 2) {
          return assetType.substring(0, 2).toUpperCase();
        } else {
          return assetType.toUpperCase();
        }
    }
  }

  String? _getCurrencyCode(String displayName) {
    // Display name'den currency code'a çevirme mapping'i
    final nameToCodeMap = {
      'Altın': 'ALTIN',
      'ABD Doları/Türk Lirası': 'USDTRY',
      'Euro/Türk Lirası': 'EURTRY',
      'İngiliz Sterlini/Türk Lirası': 'GBPTRY',
      '14 Ayar Altın': 'AYAR14',
      '22 Ayar Altın': 'AYAR22',
      'Gümüş/Türk Lirası': 'GUMUSTRY',
      'Ons': 'ONS',
      'Paladyum': 'PALADYUM',
      'Platin': 'PLATIN',
      "Eski 5'li Ata Altın": 'ATA5_ESKI',
      "Yeni 5'li Ata Altın": 'ATA5_YENI',
      'Eski Ata Altın': 'ATA_ESKI',
      'Yeni Ata Altın': 'ATA_YENI',
      'Eski Çeyrek Altın': 'CEYREK_ESKI',
      'Yeni Çeyrek Altın': 'CEYREK_YENI',
      'Eski Tam Altın': 'TEK_ESKI',
      'Yeni Tam Altın': 'TEK_YENI',
      'Eski Yarım Altın': 'YARIM_ESKI',
      'Yeni Yarım Altın': 'YARIM_YENI',
      'Eski Gremse Altın': 'GREMESE_ESKI',
      'Yeni Gremse Altın': 'GREMESE_YENI',
    };

    return nameToCodeMap[displayName];
  }
}
