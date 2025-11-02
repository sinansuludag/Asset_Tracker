import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/allowed_assets_provider.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/asset_definition_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_type_enum.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/asset_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showUltraModernBuyingDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(100),
    builder: (context) => const UltraModernBuyingDialog(),
  );
}

class UltraModernBuyingDialog extends ConsumerStatefulWidget {
  const UltraModernBuyingDialog({super.key});

  @override
  ConsumerState<UltraModernBuyingDialog> createState() =>
      _UltraModernBuyingDialogState();
}

class _UltraModernBuyingDialogState
    extends ConsumerState<UltraModernBuyingDialog> {
  final _buyingPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _gramWeightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  String? selectedAssetId;
  bool isBraceletSelected = false;
  bool isGoldAsset = false;
  String? selectedAyar;
  bool _isSaving = false;

  @override
  void dispose() {
    _buyingPriceController.dispose();
    _quantityController.dispose();
    _gramWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<AssetDefinitionModel> selectableAssets =
        ref.watch(selectableAssetsProvider);
    final buyingAssetState = ref.watch(assetNotifierProvider).status;

    ref.listen(assetNotifierProvider, (previous, next) {
      if (_isSaving) {
        if (next.status == BuyingAssetState.loaded) {
          _isSaving = false;
          _showSuccessMessage("Varlık başarıyla eklendi!");
          // Otomatik kapat
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) Navigator.pop(context);
          });
        } else if (next.status == BuyingAssetState.error) {
          _isSaving = false;
          _showErrorMessage("Hata: ${next.lastError ?? 'Bilinmeyen hata'}");
        }
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FFFE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        children: [
          _buildDragHandle(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildHeader(),
                    SizedBox(height: 28.h),
                    _buildAssetField(selectableAssets),
                    SizedBox(height: 16.h),
                    if (isGoldAsset) ...[
                      _buildTypeField(),
                      SizedBox(height: 16.h),
                    ],
                    if (isBraceletSelected) ...[
                      _buildInputField(
                        'Ağırlık (gram)',
                        _gramWeightController,
                        Icons.scale,
                        (v) {
                          if (v == null || v.isEmpty) return "Gerekli";
                          if (double.tryParse(v) == null)
                            return "Geçerli değer";
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                    ],
                    _buildInputField(
                      'Alış Fiyatı (₺)',
                      _buyingPriceController,
                      Icons.attach_money,
                      (v) {
                        if (v == null || v.isEmpty) return "Gerekli";
                        if (double.tryParse(v) == null) return "Geçerli değer";
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      'Miktar',
                      _quantityController,
                      Icons.inventory_2,
                      (v) {
                        if (!isBraceletSelected) {
                          if (v == null || v.isEmpty) return "Gerekli";
                          if (double.tryParse(v) == null)
                            return "Geçerli değer";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    _buildDateField(),
                    SizedBox(height: 28.h),
                    _buildActionButtons(buyingAssetState),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade500,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 60.r,
          height: 60.r,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal.shade400,
                Colors.teal.shade600,
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            Icons.add_circle_outline,
            color: Colors.white,
            size: 32.r,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Varlık Ekle',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Portföyünüze yeni varlık ekleyin',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildAssetField(List<AssetDefinitionModel> selectableAssets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Varlık Türü',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: selectedAssetId,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  BorderSide(color: Colors.teal.withAlpha(80), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  BorderSide(color: Colors.teal.withAlpha(80), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            prefixIcon: Icon(Icons.currency_exchange,
                color: Colors.teal.shade600, size: 20.r),
            hintText: "Varlık seçin",
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
          isExpanded: true,
          items: selectableAssets
              .map<DropdownMenuItem<String>>((AssetDefinitionModel asset) {
            return DropdownMenuItem<String>(
              value: asset.id,
              child: Text(
                asset.displayName,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 13.sp),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedAssetId = value;
              isGoldAsset = value == 'AYAR14' || value == 'AYAR22';
              if (isGoldAsset) {
                selectedAyar = value == 'AYAR14' ? '14' : '22';
                isBraceletSelected = false;
              }
            });
          },
          validator: (String? value) {
            if (value == null) return "Varlık seçin";
            return null;
          },
          dropdownColor: Colors.white,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13.sp),
        ),
      ],
    );
  }

  Widget _buildTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Türü',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => isBraceletSelected = false),
                child: _buildTypeButton('Gram Altın', !isBraceletSelected),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => isBraceletSelected = true),
                child: _buildTypeButton('Bilezik', isBraceletSelected),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade600],
              )
            : null,
        color: isSelected ? null : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
        border: isSelected
            ? null
            : Border.all(color: Colors.teal.withAlpha(60), width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: isSelected ? Colors.white : AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon,
    String? Function(String?) validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  BorderSide(color: Colors.teal.withAlpha(80), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  BorderSide(color: Colors.teal.withAlpha(80), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            prefixIcon: Icon(icon, color: Colors.teal.shade600, size: 18.r),
            hintText: "0.00",
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13.sp),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alış Tarihi',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (date != null) setState(() => _selectedDate = date);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.teal.withAlpha(80),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.teal.shade600, size: 18.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                        : "Tarih seçin",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: _selectedDate != null
                          ? AppColors.textPrimary
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuyingAssetState buyingAssetState) {
    final isLoading = buyingAssetState == BuyingAssetState.loading;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              side: BorderSide(color: Colors.teal.shade600, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'İptal',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade600,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleAssetSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade600,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
                    height: 18.h,
                    width: 18.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Ekle',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _handleAssetSave() {
    if (!_formKey.currentState!.validate() ||
        selectedAssetId == null ||
        _selectedDate == null) {
      _showErrorMessage("Lütfen tüm alanları doldurun");
      return;
    }

    if (isBraceletSelected && _gramWeightController.text.isEmpty) {
      _showErrorMessage("Bilezik için gram ağırlığı gerekli");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorMessage("Kullanıcı oturumu bulunamadı");
      return;
    }

    double quantity;
    double totalInvestment;

    if (isBraceletSelected) {
      quantity = double.parse(
          _quantityController.text.isNotEmpty ? _quantityController.text : "1");
      final gramWeight = double.parse(_gramWeightController.text);
      final pricePerGram = double.parse(_buyingPriceController.text);
      totalInvestment = gramWeight * pricePerGram;
    } else {
      quantity = double.parse(_quantityController.text);
      final unitPrice = double.parse(_buyingPriceController.text);
      totalInvestment = quantity * unitPrice;
    }

    final asset = BuyingAssetModel(
      id: '',
      assetType: selectedAssetId!,
      buyingDate: _selectedDate!,
      buyingPrice: double.parse(_buyingPriceController.text),
      quantity: quantity,
      userId: user.uid,
      assetSubType: isBraceletSelected ? 'bracelet' : 'normal',
      totalInvestment: totalInvestment,
      ayarType: selectedAyar,
      gramWeight:
          isBraceletSelected ? double.parse(_gramWeightController.text) : null,
    );

    _isSaving = true;
    ref.read(assetNotifierProvider.notifier).saveBuyingAsset(asset);
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
