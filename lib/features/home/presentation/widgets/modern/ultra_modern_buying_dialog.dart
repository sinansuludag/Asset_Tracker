import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/allowed_assets_provider.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/asset_definition_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_type_enum.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/asset_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  bool isGoldAsset = false; // ➕ Yeni: 14 veya 22 ayar altın mı?
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

  String _getQuantityUnit() {
    if (isBraceletSelected) {
      return 'adet'; // Bilezik için adet
    }

    switch ((selectedAssetId ?? '').toUpperCase()) {
      case 'ALTIN':
      case 'KULCEALTIN':
      case 'AYAR14':
      case 'AYAR22':
        return 'gram';
      case 'USDTRY':
        return 'USD';
      case 'EURTRY':
        return 'EUR';
      case 'GBPTRY':
        return 'GBP';
      default:
        return 'adet';
    }
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
    final buyingAssetState = ref.watch(assetNotifierProvider).status;

    ref.listen(assetNotifierProvider, (previous, next) {
      if (next.status == BuyingAssetState.loaded) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
        _showSuccessMessage("Varlık başarıyla eklendi!");
      } else if (next.status == BuyingAssetState.error) {
        _showErrorMessage("Hata: ${next.lastError ?? 'Bilinmeyen hata'}");
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

                        // ✅ 14 veya 22 ayar seçildiyse kullanım türü sor
                        if (isGoldAsset) ...[
                          _buildUsageTypeSelector(),
                          SizedBox(height: 24.h),
                        ],

                        // Bilezik özel alanları
                        if (isBraceletSelected) ...[
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
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(200),
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 28.h),
            child: Row(
              children: [
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
                      if (asset.symbol.isNotEmpty)
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

                  // 14 veya 22 ayar altın mı kontrol et
                  isGoldAsset = value == 'AYAR14' || value == 'AYAR22';

                  if (isGoldAsset) {
                    selectedAyar = value == 'AYAR14' ? '14' : '22';
                    isBraceletSelected = false; // Başlangıçta gram altın seçili
                  } else {
                    selectedAyar = null;
                    isBraceletSelected = false;
                    isGoldAsset = false;
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

  // ✅ YENİ: Kullanım türü seçici (Gram mı Bilezik mi?)
  Widget _buildUsageTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withAlpha(40),
            Colors.orange.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.amber.withAlpha(100)),
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
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.category, color: Colors.white, size: 18.r),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kullanım Şekli",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      "$selectedAyar Ayar Altın için",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                // Gram Altın Seçeneği
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isBraceletSelected = false;
                      });
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color:
                            !isBraceletSelected ? Colors.amber : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: !isBraceletSelected
                              ? Colors.amber
                              : Colors.grey[300]!,
                          width: 2.w,
                        ),
                        boxShadow: !isBraceletSelected
                            ? [
                                BoxShadow(
                                  color: Colors.amber.withAlpha(100),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.scatter_plot,
                            color: !isBraceletSelected
                                ? Colors.white
                                : Colors.grey[600],
                            size: 24.r,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Gram Altın",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: !isBraceletSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            selectedAyar == '14'
                                ? '%58 Saf Altın'
                                : '%92 Saf Altın',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: !isBraceletSelected
                                  ? Colors.white.withAlpha(220)
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // İşçiliksiz Bilezik Seçeneği
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isBraceletSelected = true;
                      });
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: isBraceletSelected ? Colors.amber : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isBraceletSelected
                              ? Colors.amber
                              : Colors.grey[300]!,
                          width: 2.w,
                        ),
                        boxShadow: isBraceletSelected
                            ? [
                                BoxShadow(
                                  color: Colors.amber.withAlpha(100),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            color: isBraceletSelected
                                ? Colors.white
                                : Colors.grey[600],
                            size: 24.r,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "İşçiliksiz Bilezik",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: isBraceletSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Sadece altın değeri",
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isBraceletSelected
                                  ? Colors.white.withAlpha(220)
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                  "Bilezik Ağırlığı",
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
                hintText: "Bileziğin gram ağırlığı",
                helperText: "Örneğin: 30 gram",
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
    String label = "Alış Fiyatı";
    String hint = "Alış fiyatını giriniz";
    String suffix = "₺";

    if (isBraceletSelected) {
      label = "Alış Fiyatı (Gram Başına)";
      hint = "Gramı kaç TL'den aldınız?";
      suffix = "₺/gram";
    } else if (isGoldAsset) {
      label = "Alış Fiyatı (Gram Başına)";
      suffix = "₺/gram";
    }

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
                  label,
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
                hintText: hint,
                suffixText: suffix,
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
                suffixText: _getQuantityUnit(),
                suffixStyle: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.purple),
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

  // ✅ GÜNCELLENEN SAVE METODu
  void _handleAssetSave() {
    HapticFeedback.heavyImpact();

    if (!_formKey.currentState!.validate() ||
        selectedAssetId == null ||
        _selectedDate == null) {
      _showErrorMessage("Lütfen tüm alanları doldurun");
      return;
    }

    // Bilezik seçildiyse gram kontrolü
    if (isBraceletSelected && _gramWeightController.text.isEmpty) {
      _showErrorMessage("Bilezik için gram ağırlığı gerekli");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorMessage("Kullanıcı oturumu bulunamadı");
      return;
    }

    // Miktar hesaplama
    double quantity;
    double totalInvestment;

    if (isBraceletSelected) {
      // Bilezik için miktar 1, gram ağırlığı ayrı tutulur
      quantity = 1.0;
      final gramWeight = double.parse(_gramWeightController.text);
      final pricePerGram = double.parse(_buyingPriceController.text);
      totalInvestment = gramWeight * pricePerGram;
    } else {
      // Normal varlıklar için
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
      ayarType: selectedAyar, // 14 veya 22
      gramWeight:
          isBraceletSelected ? double.parse(_gramWeightController.text) : null,
    );

    // Save işlemini yap
    ref.read(assetNotifierProvider.notifier).saveBuyingAsset(asset);
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return;
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
    if (!mounted) return;
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            SizedBox(width: 12.w),
            Expanded(child: Text(message)),
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
