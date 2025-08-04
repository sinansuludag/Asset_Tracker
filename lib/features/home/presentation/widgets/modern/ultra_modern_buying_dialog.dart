import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/allowed_assets_provider.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/asset_definition_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_type_enum.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/buying_asset_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Orta düzey tasarım varlık ekleme dialog'u
void showUltraModernBuyingDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(125),
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
    extends ConsumerState<UltraModernBuyingDialog>
    with TickerProviderStateMixin {
  // Form controller'ları
  final _buyingPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _gramWeightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Seçim durumları
  DateTime? _selectedDate;
  String? selectedAssetId;
  bool isBraceletSelected = false;
  String? selectedAyar;

  // Animasyon controller'ları
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _slideController, curve: Curves.elasticOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _buyingPriceController.dispose();
    _quantityController.dispose();
    _gramWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<AssetDefinitionModel> selectableAssets =
        ref.watch(selectableAssetsProvider);
    final BuyingAssetState buyingAssetState = ref.watch(buyingAssetProvider);

    // ✅ ref.listen'i build metodu içine taşı
    ref.listen(buyingAssetProvider, (previous, next) {
      if (next == BuyingAssetState.loaded) {
        Navigator.pop(context);
        _showSuccessMessage("Varlık başarıyla eklendi!");
        ref.read(enhancedPortfolioProvider.notifier).refreshPortfolio();
      } else if (next == BuyingAssetState.error) {
        final error = ref.read(buyingAssetProvider.notifier).lastError;
        _showErrorMessage("Hata: ${error ?? 'Bilinmeyen hata'}");
      }
    });

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.r),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildAssetSelector(selectableAssets),
                        SizedBox(height: 24.h),

                        // Bilezik özel alanları
                        if (isBraceletSelected) ...[
                          _buildAyarSelector(),
                          SizedBox(height: 24.h),
                          _buildGramWeightField(),
                          SizedBox(height: 24.h),
                        ],

                        _buildPriceField(),
                        SizedBox(height: 24.h),

                        // Normal varlıklar için miktar
                        if (!isBraceletSelected) _buildQuantityField(),
                        SizedBox(height: 24.h),

                        _buildDatePicker(),
                        SizedBox(height: 32.h),
                        _buildActionButtons(buyingAssetState),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1DD1A1),
            Color(0xFF26D0CE),
            Color(0xFF00E5FF),
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1DD1A1).withAlpha(80),
            offset: const Offset(0, 4),
            blurRadius: 20.r,
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag indicator
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(200),
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),

          // Header content
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 28.h),
            child: Row(
              children: [
                // Icon container with glow effect
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(90),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withAlpha(60),
                        offset: const Offset(0, 2),
                        blurRadius: 8.r,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: const Color(0xFF1DD1A1),
                    size: 26.r,
                  ),
                ),
                SizedBox(width: 18.w),

                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Yeni Varlık Ekle",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.sp,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Portföyünüze yeni varlık ekleyin",
                        style: TextStyle(
                          color: Colors.white.withAlpha(220),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Close button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(80),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded,
                        color: Colors.white, size: 22.r),
                    padding: EdgeInsets.all(8.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetSelector(List<AssetDefinitionModel> selectableAssets) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1DD1A1).withAlpha(40),
            const Color(0xFF1DD1A1).withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF1DD1A1).withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 16.h, right: 16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DD1A1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.currency_exchange,
                      color: Colors.white, size: 18.r),
                ),
                SizedBox(width: 12.w),
                Text(
                  "Varlık Seç",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: DropdownButtonFormField<String>(
              value: selectedAssetId,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              hint: const Text("Varlık seçin"),
              isExpanded: true,
              items: selectableAssets
                  .map<DropdownMenuItem<String>>((AssetDefinitionModel asset) {
                return DropdownMenuItem<String>(
                  value: asset.id,
                  child: Row(
                    children: [
                      _getAssetTypeIcon(asset.type),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          asset.displayName,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                      Text(
                        asset.symbol,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1DD1A1),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedAssetId = value;
                  isBraceletSelected = value == 'AYAR14' || value == 'AYAR22';
                  if (isBraceletSelected) {
                    selectedAyar = value == 'AYAR14' ? '14' : '22';
                  }
                });
                HapticFeedback.lightImpact();
              },
              validator: (String? value) {
                if (value == null) return "Lütfen bir varlık seçin";
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyarSelector() {
    final List<String> ayarOptions = ref.watch(braceletAyarOptionsProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withAlpha(40),
            Colors.purple.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.indigo.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 16.h, right: 16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.star, color: Colors.white, size: 18.r),
                ),
                SizedBox(width: 12.w),
                Text(
                  "Bilezik Ayarı",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: ayarOptions.map<Widget>((String ayar) {
                final isSelected = selectedAyar == ayar;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAyar = ayar;
                      });
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF1DD1A1) : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1DD1A1)
                              : Colors.grey[300]!,
                          width: 2.w,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "$ayar Ayar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            ayar == '14' ? 'Takı için' : 'Bilezik için',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isSelected
                                  ? Colors.white.withAlpha(200)
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGramWeightField() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.withAlpha(40),
            Colors.red.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.pink.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 16.h, right: 16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.scale, color: Colors.white, size: 18.r),
                ),
                SizedBox(width: 12.w),
                Text(
                  "Gram Ağırlığı",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: TextFormField(
              controller: _gramWeightController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                hintText: "Bilezik ağırlığı (gram)",
                suffixText: "gram",
                suffixStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) => HapticFeedback.selectionClick(),
              validator: (String? value) {
                if (isBraceletSelected) {
                  if (value == null || value.isEmpty) {
                    return "Gram ağırlığı gerekli";
                  }
                  if (double.tryParse(value) == null) {
                    return "Geçerli bir ağırlık giriniz";
                  }
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceField() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withAlpha(40),
            Colors.deepOrange.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.orange.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 16.h, right: 16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child:
                      Icon(Icons.attach_money, color: Colors.white, size: 18.r),
                ),
                SizedBox(width: 12.w),
                Text(
                  "Alış Fiyatı",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: TextFormField(
              controller: _buyingPriceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                hintText: "Alış fiyatını giriniz",
                suffixText: "₺",
                suffixStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) => HapticFeedback.selectionClick(),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Alış fiyatı gerekli";
                }
                if (double.tryParse(value) == null) {
                  return "Geçerli bir fiyat giriniz";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityField() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withAlpha(40),
            Colors.indigo.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.purple.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 16.h, right: 16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.inventory, color: Colors.white, size: 18.r),
                ),
                SizedBox(width: 12.w),
                Text(
                  "Miktar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                hintText: "Miktar giriniz",
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) => HapticFeedback.selectionClick(),
              validator: (String? value) {
                if (!isBraceletSelected) {
                  if (value == null || value.isEmpty) {
                    return "Miktar gerekli";
                  }
                  if (double.tryParse(value) == null) {
                    return "Geçerli bir miktar giriniz";
                  }
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.withAlpha(40),
            Colors.blue.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.cyan.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 16.h, right: 16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.schedule, color: Colors.white, size: 18.r),
                ),
                SizedBox(width: 12.w),
                Text(
                  "Alış Tarihi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: GestureDetector(
              onTap: () async {
                HapticFeedback.mediumImpact();
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                  HapticFeedback.lightImpact();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 12.w),
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(Icons.event, color: Colors.white, size: 16.r),
                    ),
                    Expanded(
                      child: Text(
                        _selectedDate != null
                            ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                            : "Tarih seçin",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: _selectedDate != null
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.cyan, size: 20.r),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuyingAssetState buyingAssetState) {
    final isLoading = buyingAssetState == BuyingAssetState.loading;

    return Row(
      children: [
        // Cancel button
        Expanded(
          child: Container(
            height: 54.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.grey[300]!, width: 1.5.w),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(14.r),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close_rounded,
                          color: Colors.grey[600], size: 20.r),
                      SizedBox(width: 8.w),
                      Text(
                        "İptal",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),

        // Save button
        Expanded(
          flex: 2,
          child: Container(
            height: 54.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1DD1A1),
                  Color(0xFF26D0CE),
                  Color(0xFF00E5FF)
                ],
              ),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1DD1A1).withAlpha(100),
                  offset: const Offset(0, 6),
                  blurRadius: 20.r,
                ),
                BoxShadow(
                  color: Colors.white.withAlpha(80),
                  offset: const Offset(0, 1),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : _handleAssetSave,
                borderRadius: BorderRadius.circular(14.r),
                child: Center(
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22.w,
                              height: 22.h,
                              child: const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Ekleniyor...",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline,
                                color: Colors.white, size: 22.r),
                            SizedBox(width: 10.w),
                            Text(
                              "Varlık Ekle",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ _handleAssetSave metodunu basitleştir - ref.listen artık build metodunda
  void _handleAssetSave() {
    HapticFeedback.heavyImpact();

    if (!_formKey.currentState!.validate() ||
        selectedAssetId == null ||
        _selectedDate == null) {
      _showErrorMessage("Lütfen tüm alanları doldurun");
      return;
    }

    if (isBraceletSelected &&
        (selectedAyar == null || _gramWeightController.text.isEmpty)) {
      _showErrorMessage("Bilezik için ayar ve gram ağırlığı gerekli");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorMessage("Kullanıcı oturumu bulunamadı");
      return;
    }

    final asset = BuyingAssetModel(
      id: '',
      assetType: selectedAssetId!,
      buyingDate: _selectedDate!,
      buyingPrice: double.parse(_buyingPriceController.text),
      quantity:
          isBraceletSelected ? 1.0 : double.parse(_quantityController.text),
      userId: user.uid,
      assetSubType: isBraceletSelected ? 'bracelet' : 'normal',
      ayarType: selectedAyar,
      gramWeight: isBraceletSelected
          ? double.tryParse(_gramWeightController.text)
          : null,
    );

    // ✅ Sadece save işlemini yap, listen build metodunda
    ref.read(buyingAssetProvider.notifier).saveBuyingAsset(asset);
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12.w),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            SizedBox(width: 12.w),
            Text(message),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  Widget _getAssetTypeIcon(AssetType type) {
    Color color;
    IconData icon;

    switch (type) {
      case AssetType.gold:
        color = Colors.amber;
        icon = Icons.star;
        break;
      case AssetType.currency:
        color = Colors.green;
        icon = Icons.attach_money;
        break;
      case AssetType.platinum:
        color = Colors.grey;
        icon = Icons.diamond;
        break;
      case AssetType.silver:
        color = Colors.blueGrey;
        icon = Icons.circle;
        break;
    }

    return Container(
      width: 28.w,
      height: 28.h,
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Icon(icon, color: color, size: 16.r),
    );
  }
}
