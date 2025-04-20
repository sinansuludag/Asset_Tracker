import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/show_dialog_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_provider.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/buying_asset_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElevatedButtonWidget extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController buyingAssetController;
  final TextEditingController quantityAssetController;
  DateTime? selectedDate;
  String? selectedAsset;

  ElevatedButtonWidget({
    super.key,
    required this.formKey,
    required this.buyingAssetController,
    required this.quantityAssetController,
    this.selectedDate,
    this.selectedAsset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyingAssetNotifier = ref.read(buyingAssetProvider.notifier);

    return ElevatedButton(
      onPressed: ref.watch(buyingAssetProvider) == BuyingAssetState.loading
          ? null
          : () async {
              if (!formKey.currentState!.validate()) return;

              if (selectedAsset == null) {
                context.showDialogFonk(context, TrStrings.chooseAssetType);
                return;
              }

              if (selectedDate == null) {
                context.showDialogFonk(context, TrStrings.dataPickerText);
                return;
              }

              final userId =
                  await ref.read(userProvider.notifier).getUserFromFirestore();

              if (userId.isEmpty) {
                context.showDialogFonk(context, TrStrings.userNotFound);
                return;
              }

              final assetEntityModel = BuyingAssetModel(
                id: '',
                assetType: selectedAsset!,
                buyingPrice: double.parse(buyingAssetController.text),
                quantity: double.parse(quantityAssetController.text),
                buyingDate: selectedDate!,
                userId: userId,
              );

              await buyingAssetNotifier.saveBuyingAsset(assetEntityModel);

              if (ref.watch(buyingAssetProvider) == BuyingAssetState.loaded) {
                context.showSnackBar(TrStrings.succesBuyingAsset);
                buyingAssetController.clear();
                quantityAssetController.clear();
                selectedAsset = '';
                selectedDate = null;
                ref.read(assetAmountProvider.notifier).state = 0.0;
                Navigator.pop(context);
              } else if (ref.watch(buyingAssetProvider) ==
                  BuyingAssetState.error) {
                context.showSnackBar(TrStrings.errorBuyingAsset);
                ref.read(assetAmountProvider.notifier).state = 0.0;
              } else {
                context.showSnackBar(TrStrings.unknownError);
                ref.read(assetAmountProvider.notifier).state = 0.0;
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        fixedSize: Size(
          MediaQuerySize(context).percent40Width,
          MediaQuerySize(context).percent6Height,
        ),
      ),
      child: ref.watch(buyingAssetProvider) == BuyingAssetState.loading
          ? const CircularProgressIndicator()
          : const Text(TrStrings.buyingScreenButtonText),
    );
  }
}
