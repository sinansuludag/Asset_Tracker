import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/utils/validator/buying_asset_validator/buying_price_validator.dart';
import 'package:asset_tracker/core/utils/validator/buying_asset_validator/quantity_amount_validator.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/custom_buying_asset_text_form_field.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/date_picker_button_widget.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/drodown_button_widget.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/elevated_button_widget.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/quantity_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyingAssetsScreen extends ConsumerStatefulWidget {
  const BuyingAssetsScreen({super.key});

  @override
  ConsumerState<BuyingAssetsScreen> createState() => _BuyingAssetsScreenState();
}

//Şu an asset type ve tarih kısmı için validator yapılmadı .

class _BuyingAssetsScreenState extends ConsumerState<BuyingAssetsScreen> {
  final _buyingAssetController = TextEditingController();
  final _quantityAssetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? selectedAsset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TrStrings.buyingAssetScreenTitle),
        centerTitle: true,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Tüm alanı algılar
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: AppPaddings.allLowPadding,
          child: Column(
            spacing: MediaQuerySize(context).percent1_5Height,
            children: [
              dropDownButtonwidget(context, selectedAsset, (String? asset) {
                setState(() {
                  selectedAsset = asset;
                });
              }),
              customBuyingAssetTextFormField(
                _buyingAssetController,
                BuyingPriceValidator.buyingPriceValidate,
              ),
              quantityTextFormField(context, _quantityAssetController,
                  QuantityAmountValidator.quantityAmountValidate),
              datePickerButtonWidget(context, _selectedDate, (DateTime? date) {
                setState(() {
                  _selectedDate = date;
                });
              }),
              SizedBox(
                height: MediaQuerySize(context).percent1Height,
              ),
              elevatedButton(
                  formKey: _formKey,
                  _buyingAssetController,
                  _quantityAssetController,
                  _selectedDate,
                  selectedAsset),
            ],
          ),
        ),
      ),
    );
  }
}
