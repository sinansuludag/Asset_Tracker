import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_provider.dart';
import 'package:asset_tracker/features/buying_asset/domain/entities/asset_model.dart';
import 'package:asset_tracker/features/buying_asset/presentation/state_management/buying_asset_notifier.dart';
import 'package:asset_tracker/features/buying_asset/presentation/state_management/buying_asset_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class elevatedButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController buyingAssetController;
  final TextEditingController quantityAssetController;
  final DateTime? selectedDate;
  final String? selectedAsset;
  elevatedButton(this.buyingAssetController, this.quantityAssetController,
      this.selectedDate, this.selectedAsset,
      {super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _buyingAssetNotifier = ref.read(buyingAssetProvider.notifier);
    final _userProviderNotifier = ref.read(userProvider.notifier);
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          final userId = _userProviderNotifier.user!.id;
          final assetEntityModel = AssetEntity(
            id: '',
            assetType: selectedAsset ?? '',
            buyingPrice: double.parse(buyingAssetController.text),
            quantity: int.parse(quantityAssetController.text),
            buyingDate: selectedDate ?? DateTime.now(),
            userId: userId,
          );

          final result =
              await _buyingAssetNotifier.saveBuyingAsset(assetEntityModel);

          if (ref.watch(buyingAssetProvider) == BuyingAssetState.loaded) {
            context.showSnackBar(TrStrings.succesBuyingAsset);
            Navigator.pushNamed(context, RouteNames.currencyAssets);
          } else {
            context.showSnackBar(TrStrings.errorBuyingAsset);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        fixedSize: Size(MediaQuerySize(context).percent60Width,
            MediaQuerySize(context).percent6Height),
      ),
      child: ref.watch(buyingAssetProvider) != BuyingAssetState.loaded
          ? const CircularProgressIndicator()
          : const Text(TrStrings.buyingScreenButtonText),
    );
  }
}
