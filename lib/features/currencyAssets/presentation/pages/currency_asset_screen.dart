import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/reverse_to_currency_code_extension.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_provider.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/all_provider.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class CurrencyAssetScreen extends ConsumerStatefulWidget {
  const CurrencyAssetScreen({super.key});

  @override
  ConsumerState<CurrencyAssetScreen> createState() =>
      _CurrencyAssetScreenState();
}

class _CurrencyAssetScreenState extends ConsumerState<CurrencyAssetScreen> {
  String? userId;
  String?
      selectedAssetType; // Seçilen varlık türü (PieChart'ta büyütülen dilim)
  final ScrollController _scrollController =
      ScrollController(); // Listeyi kaydırmak için

  @override
  void initState() {
    super.initState();
    _initializeStream(); // Sayfa açılınca veri dinlemeyi başlat
  }

  // Kullanıcı bilgisi alınıp ona ait varlıklar dinleniyor
  Future<void> _initializeStream() async {
    final getUser =
        await ref.read(userProvider.notifier).getUserFromFirestore();
    userId = getUser;

    if (userId != null && userId!.isNotEmpty) {
      ref.read(currencyAssetProvider.notifier).listenCurrencyAssets(userId!);
    }
  }

  // PieChart ve toplam değer bilgilerini içeren kart
  Widget buildPortfolioCard(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currencyAssetProvider); // Kullanıcının varlıkları
    final currencyResponses =
        ref.watch(currencyNotifierProvider); // Güncel döviz kurları

    // Veri yoksa boş widget dön
    if (currencyResponses.isEmpty || state.assets.isEmpty) {
      return const SizedBox();
    }

    final currentMap = <String, double>{};
    double totalBuy = 0.0; // Toplam alış değeri
    double totalCurrent = 0.0; // Güncel toplam değer

    // Her bir varlık için alış ve güncel değerler hesaplanıyor
    for (var asset in state.assets) {
      if (asset == null) continue;
      totalBuy += asset.buyingPrice * asset.quantity;
      final code = asset.assetType.getCurrencyCode();
      if (code != null) {
        final price = currencyResponses.last.currencies[code]?.buying ?? 0.0;
        final value = price * asset.quantity;
        currentMap[asset.assetType] = value;
        totalCurrent += value;
      }
    }

    // Kar/zarar oranı ve miktarı hesaplanıyor
    final profitRate =
        totalBuy > 0 ? ((totalCurrent - totalBuy) / totalBuy) * 100 : 0.0;
    final profitAmount = totalCurrent - totalBuy;

    // PieChart için dilimler hazırlanıyor (her bir varlık oranına göre)
    final entriesList = currentMap.entries.toList();
    final List<Color> sliceColors = [
      Colors.teal,
      Colors.orange,
      Colors.blueAccent,
      Colors.purple,
      Colors.indigo,
      Colors.deepPurple
    ];

    // Her bir varlık için PieChart dilimi oluşturuluyor
    final sections = entriesList.asMap().entries.map((entry) {
      final index = entry.key;
      final e = entry.value;
      final percent = totalCurrent > 0
          ? (e.value / totalCurrent * 100)
              .toStringAsFixed(1) // yüzde hesaplanıyor
          : '0';
      return PieChartSectionData(
        value: e.value, // dilimin boyutu (varlığın TL karşılığı)
        title: "$percent%", // ortasında gösterilecek oran
        color:
            sliceColors[index % sliceColors.length], // renk dizisine göre renk
        radius:
            selectedAssetType == e.key ? 70 : 55, // tıklanınca büyüme efekti
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    // Görsel olarak kart dönüyor
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.defaultBorderRadius,
        ),
        elevation: 6,
        color: context.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Toplam Değer", style: context.textTheme.labelMedium),
              Text("₺${totalCurrent.toStringAsFixed(2)}",
                  style: context.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // Alış, K/Z, Oran bilgileri
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Alış", style: context.textTheme.labelSmall),
                      Text("₺${totalBuy.toStringAsFixed(2)}",
                          style: context.textTheme.bodyMedium),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("K/Z", style: context.textTheme.labelSmall),
                      Text("₺${profitAmount.toStringAsFixed(2)}",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color:
                                profitAmount >= 0 ? Colors.green : Colors.red,
                          )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Oran", style: context.textTheme.labelSmall),
                      Text("${profitRate.toStringAsFixed(2)}%",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: profitRate >= 0 ? Colors.green : Colors.red,
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Grafik alanı (PieChart)
              AspectRatio(
                aspectRatio: 1.4, // oranı koru
                child: PieChart(
                  PieChartData(
                    sections: sections, // yukarıda oluşturulan dilimler
                    centerSpaceRadius: 40, // ortası boş görünüm için radius
                    sectionsSpace: 2, // dilimler arası boşluk
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        // Kullanıcı bir dilime tıklarsa
                        final touchedIndex =
                            response?.touchedSection?.touchedSectionIndex;
                        if (touchedIndex != null &&
                            touchedIndex >= 0 &&
                            touchedIndex < entriesList.length) {
                          setState(() {
                            selectedAssetType =
                                entriesList[touchedIndex].key; // seçilen varlık
                          });
                          final targetIndex = state.assets.indexWhere((a) =>
                              a?.assetType ==
                              selectedAssetType); // o varlık listede kaçıncı sırada
                          if (targetIndex != -1) {
                            _scrollController.animateTo(
                              (targetIndex + 1) * 180.0, // ilgili karta kaydır
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // PieChart altında renkli etiketler (legend)
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: entriesList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final assetName = entry.value.key;
                  return InkWell(
                    onTap: () => setState(() => selectedAssetType =
                        assetName), // etikete tıklayınca dilim seçilsin
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: sliceColors[index % sliceColors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(assetName, style: context.textTheme.bodyMedium),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currencyAssetProvider);
    final currencyResponses = ref.watch(currencyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Varlıklarım"),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: state.assets.length +
            1, // İlk öğe grafik kartı, sonra varlık kartları
        itemBuilder: (context, index) {
          if (index == 0)
            return buildPortfolioCard(
                context, ref); // ilk sıraya grafik kartı gelir
          final asset = state.assets[index - 1];
          if (asset == null) return const SizedBox();

          final code = asset.assetType.getCurrencyCode();
          final currentPrice = currencyResponses.isNotEmpty && code != null
              ? currencyResponses.last.currencies[code]?.buying ?? 0.0
              : 0.0;
          final totalValue = asset.buyingPrice * asset.quantity;
          final currentValue = currentPrice * asset.quantity;
          final diff = currentValue - totalValue;
          final diffRate = totalValue > 0 ? (diff / totalValue) * 100 : 0.0;

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.defaultBorderRadius),
              elevation: 3,
              color: context.colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(asset.assetType,
                              style: context.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                              "Miktar: ${asset.quantity}  •  Alış: ₺${asset.buyingPrice}"),
                          Text(
                              "Anlık Değer: ₺${currentValue.toStringAsFixed(2)}"),
                          Text(
                            "K/Z: ₺${diff.toStringAsFixed(2)} (${diffRate.toStringAsFixed(2)}%)",
                            style: TextStyle(
                                color: diff >= 0 ? Colors.green : Colors.red),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(
                                  "Silmek istediğinizden emin misiniz?"),
                              content: const Text("Bu işlem geri alınamaz."),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("İptal"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Sil"),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await ref
                                .read(currencyAssetProvider.notifier)
                                .deleteCurrencyAsset(asset.id);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
