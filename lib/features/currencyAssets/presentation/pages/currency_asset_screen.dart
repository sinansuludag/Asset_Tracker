import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/sizes/app_icon_size.dart';
import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/all_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyAssetScreen extends ConsumerStatefulWidget {
  const CurrencyAssetScreen({super.key});

  @override
  ConsumerState<CurrencyAssetScreen> createState() =>
      _CurrencyAssetScreenState();
}

class _CurrencyAssetScreenState extends ConsumerState<CurrencyAssetScreen> {
  Future<void>? _initFuture;
  String? userId;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? ''; // userId alınıyor

    if (userId!.isNotEmpty) {
      await ref.read(currencyAssetProvider.notifier).getCurrencyAsset(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Varlıklarım'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return currencyAssetListViewBuilder();
            }
          }),
    );
  }

  Widget currencyAssetListViewBuilder() {
    final currencyAssets =
        ref.read(currencyAssetProvider.notifier); // Listenin güncel halini al

    return (currencyAssets.currencyAssetList.isNotEmpty)
        ? ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 4, // Daha yüksek gölge efekti
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        AppBorderRadius.defaultBorderRadius, // Yuvarlak köşeler
                  ),
                  color: context.colorScheme.secondary,
                  child: ListTile(
                    contentPadding: AppPaddings
                        .allDefaultPadding, // İçeriğe padding ekleniyor
                    leading: CircleAvatar(
                      child: Image.asset('chart'.png),
                    ),
                    title: Text(
                      currencyAssets.currencyAssetList[index]!.assetType,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(
                          currencyAssets.currencyAssetList[index]!.buyingDate),
                      style: context.textTheme.bodyMedium?.copyWith(
                          color:
                              context.colorScheme.onSecondary.withAlpha(100)),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final assetId = currencyAssets.currencyAssetList[index]!
                            .id; // Silinecek varlığın ID'si
                        await ref
                            .read(currencyAssetProvider.notifier)
                            .deleteCurrencyAsset(assetId);
                      },
                      icon: Icon(
                        Icons.delete,
                        size: AppIconSize.listTileTrailingIconSize,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: currencyAssets.currencyAssetList.length,
          )
        : Center(
            child: Text('Varlık bulunamadı'),
          );
  }
}
