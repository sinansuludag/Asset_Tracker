import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/utils/validator/buying_asset_validator/buying_price_validator.dart';
import 'package:asset_tracker/core/utils/validator/buying_asset_validator/quantity_amount_validator.dart';
import 'package:asset_tracker/features/home/presentation/widgets/custom_buying_asset_text_form_field.dart';
import 'package:asset_tracker/features/home/presentation/widgets/date_picker_button_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/drodown_button_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/elevated_button_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/quantity_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showBuyingAssets(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const BuyingAssetDialog(),
  );
}

class BuyingAssetDialog extends ConsumerStatefulWidget {
  const BuyingAssetDialog({super.key});

  @override
  _BuyingAssetDialogState createState() => _BuyingAssetDialogState();
}

class _BuyingAssetDialogState extends ConsumerState<BuyingAssetDialog> {
  final _buyingAssetController = TextEditingController();
  final _quantityAssetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? selectedAsset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24)), // 🔸 Sadece üst kısım oval
        ),
        child: Padding(
          padding: AppPaddings.allNormalPadding,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  dropDownButtonwidget(context, selectedAsset, (String? asset) {
                    setState(() {
                      selectedAsset = asset;
                    });
                  }),
                  SizedBox(height: MediaQuerySize(context).percent1_5Height),
                  customBuyingAssetTextFormField(_buyingAssetController,
                      BuyingPriceValidator.buyingPriceValidate, context),
                  SizedBox(height: MediaQuerySize(context).percent1_5Height),
                  quantityTextFormField(context, _quantityAssetController,
                      QuantityAmountValidator.quantityAmountValidate, ref),
                  SizedBox(height: MediaQuerySize(context).percent1_5Height),
                  datePickerButtonWidget(context, _selectedDate,
                      (DateTime? date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }),
                  SizedBox(height: MediaQuerySize(context).percent1Height),
                  Row(
                    spacing: MediaQuerySize(context).percent2Width,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ref.read(assetAmountProvider.notifier).state = 0.0;
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.secondary,
                          foregroundColor: context.colorScheme.onSecondary,
                          fixedSize: Size(
                            MediaQuerySize(context).percent30Width,
                            MediaQuerySize(context).percent6Height,
                          ),
                        ),
                        child: const Text(TrStrings.cancelButtonText),
                      ),
                      ElevatedButtonWidget(
                        formKey: _formKey,
                        selectedDate: _selectedDate,
                        selectedAsset: selectedAsset,
                        buyingAssetController: _buyingAssetController,
                        quantityAssetController: _quantityAssetController,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
