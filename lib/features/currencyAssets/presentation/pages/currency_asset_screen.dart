import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_provider.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/all_provider.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/app_bar_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/list_view_builder_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/text_and_floating_button_column_widget.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/presentation/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // 🔥 Son bilinen fiyatlar burada tutuluyor
  final Map<String, double> _lastKnownPrices = {};

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

  // 🔁 Her yeni kur geldiğinde bu fonksiyon ile son bilinen değerler güncelleniyor
  void _updateLastKnownPrices(Map<String, CurrencyData> currencies) {
    for (final entry in currencies.entries) {
      _lastKnownPrices[entry.key] = entry.value.buying ?? 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currencyAssetProvider);
    final currencyNotifier = ref.watch(currencyNotifierProvider.notifier);
    final fullCurrencyResponse = currencyNotifier.fullCurrencyResponse;

// Güvenli null kontrolü ve isNotEmpty kontrolü
    final isDataReady = state.assets.isNotEmpty &&
        fullCurrencyResponse != null &&
        fullCurrencyResponse.currencies.isNotEmpty;

    if (isDataReady) {
      _updateLastKnownPrices(fullCurrencyResponse.currencies);
    }

    return Scaffold(
      appBar: currencyAppBarWidget(),
      body: isDataReady
          ? listviewBuilderWidget(
              state,
              fullCurrencyResponse.currencies,
              _scrollController,
              selectedAssetType,
              _lastKnownPrices,
              _updateLastKnownPrices,
              ref, (assetName) {
              setState(() {
                selectedAssetType = assetName;
              });
            })
          : textAndFloatingButtonColumnWidget(context),
    );
  }
}
