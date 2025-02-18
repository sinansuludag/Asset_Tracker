import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/custom_buying_asset_text_form_field.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/date_picker_button_widget.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/drodown_button_widget.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/elevated_button_widget.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/quantity_text_form_field.dart';
import 'package:flutter/material.dart';

class BuyingAssetsScreen extends StatefulWidget {
  const BuyingAssetsScreen({super.key});

  @override
  _BuyingAssetsScreenState createState() => _BuyingAssetsScreenState();
}

class _BuyingAssetsScreenState extends State<BuyingAssetsScreen> {
  final buyingAssetController = TextEditingController();
  final quantityAssetController = TextEditingController();
  DateTime? selectedDate;

  // Seçilen varlık türü
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
              customBuyingAssetTextFormField(buyingAssetController),
              quantityTextFormField(context, quantityAssetController),
              datePickerButtonWidget(context, selectedDate, (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
              }),
              SizedBox(
                height: MediaQuerySize(context).percent1Height,
              ),
              const elevatedButton(),
            ],
          ),
        ),
      ),
    );
  }
}
