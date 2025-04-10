import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/all_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Align deleteIconButonWidget(
    BuildContext context, CurrencyAssetEntity asset, WidgetRef ref) {
  return Align(
    alignment: Alignment.center,
    child: IconButton(
      icon: const Icon(Icons.delete, color: Colors.redAccent),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Silmek istediğinizden emin misiniz?"),
            content: const Text("Bu işlem geri alınamaz."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("İptal"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
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
  );
}
