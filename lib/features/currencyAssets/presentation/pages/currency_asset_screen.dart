import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/sizes/app_icon_size.dart';
import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/reverse_to_currency_code_extension.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_provider.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/all_provider.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class CurrencyAssetScreen extends ConsumerStatefulWidget {
  const CurrencyAssetScreen({super.key});

  @override
  ConsumerState<CurrencyAssetScreen> createState() =>
      _CurrencyAssetScreenState();
}

class _CurrencyAssetScreenState extends ConsumerState<CurrencyAssetScreen> {
  String? userId;
  String? selectedAssetType;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    final getUser =
        await ref.read(userProvider.notifier).getUserFromFirestore();
    userId = getUser;

    if (userId != null && userId!.isNotEmpty) {
      ref.read(currencyAssetProvider.notifier).listenCurrencyAssets(userId!);
    }
  }

  Widget buildPortfolioCard(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currencyAssetProvider);
    final currencyResponses = ref.watch(currencyNotifierProvider);

    if (currencyResponses.isEmpty || state.assets.isEmpty)
      return const SizedBox();

    final currentMap = <String, double>{};
    double totalBuy = 0.0;
    double totalCurrent = 0.0;

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

    final profitRate =
        totalBuy > 0 ? ((totalCurrent - totalBuy) / totalBuy) * 100 : 0.0;
    final profitAmount = totalCurrent - totalBuy;

    final entriesList = currentMap.entries.toList();
    final List<Color> sliceColors = [
      Colors.teal,
      Colors.orange,
      Colors.blueAccent,
      Colors.purple,
      Colors.indigo,
      Colors.deepPurple
    ];

    final sections = entriesList.asMap().entries.map((entry) {
      final index = entry.key;
      final e = entry.value;
      final percent = totalCurrent > 0
          ? (e.value / totalCurrent * 100).toStringAsFixed(1)
          : '0';
      return PieChartSectionData(
        value: e.value,
        title: "$percent%",
        color: sliceColors[index % sliceColors.length],
        radius: selectedAssetType == e.key ? 70 : 55,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        shape: RoundedRectangleBorder(
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
              AspectRatio(
                aspectRatio: 1.4,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        final touchedIndex =
                            response?.touchedSection?.touchedSectionIndex;
                        if (touchedIndex != null &&
                            touchedIndex >= 0 &&
                            touchedIndex < entriesList.length) {
                          setState(() {
                            selectedAssetType = entriesList[touchedIndex].key;
                          });
                          final targetIndex = state.assets.indexWhere(
                              (a) => a?.assetType == selectedAssetType);
                          if (targetIndex != -1) {
                            _scrollController.animateTo(
                              (targetIndex + 1) * 180.0,
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
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: entriesList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final assetName = entry.value.key;
                  return InkWell(
                    onTap: () => setState(() => selectedAssetType = assetName),
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
      appBar: AppBar(title: const Text("Varlıklarım")),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: state.assets.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return buildPortfolioCard(context, ref);
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
