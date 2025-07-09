import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/allowed_assets_provider.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_type_enum.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/buying_asset_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Gelişmiş varlık ekleme dialog'u
/// Issue gereksinimi: Sadece izinli varlıklar + bilezik özel durumu
void showUltraModernBuyingDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
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
  final _buyingAssetController = TextEditingController();
  final _quantityAssetController = TextEditingController();
  final _gramWeightController = TextEditingController(); // Bilezik için
  final _formKey = GlobalKey<FormState>();

  // Seçim durumları
  DateTime? _selectedDate;
  String? selectedAssetId;
  bool isBraceletSelected = false;
  String? selectedAyar; // 14 veya 22 ayar (bilezik için)

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
    _buyingAssetController.dispose();
    _quantityAssetController.dispose();
    _gramWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectableAssets = ref.watch(selectableAssetsProvider);
    final buyingAssetState = ref.watch(buyingAssetProvider);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, const Color(0xFFF8FFFE), Colors.white],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, -10),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDynamicHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildAssetSelector(selectableAssets),
                        const SizedBox(height: 24),

                        // Issue gereksinimi: Bilezik özel alanları
                        if (isBraceletSelected) ...[
                          _buildAyarSelector(),
                          const SizedBox(height: 24),
                          _buildGramWeightField(),
                          const SizedBox(height: 24),
                        ],

                        _buildNeonPriceField(),
                        const SizedBox(height: 24),

                        // Normal varlıklar için miktar alanı
                        if (!isBraceletSelected) _buildCyberQuantityField(),
                        const SizedBox(height: 24),

                        _buildHolographicDatePicker(),
                        const SizedBox(height: 32),
                        _buildQuantumActionButtons(buyingAssetState),
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

  /// Header kısmı - animasyonlu ve modern
  Widget _buildDynamicHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1DD1A1).withOpacity(0.3),
            offset: const Offset(0, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 2),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Container(
                width: 50 * value,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Ana header içeriği
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "✨ Yeni Varlık Ekle",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    ),
                    Text(
                      "Sadece izinli varlıkları ekleyebilirsiniz",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Varlık seçici - sadece izinli varlıklar
  Widget _buildAssetSelector(selectableAssets) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.currency_exchange,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  "💎 İzinli Varlık Seç",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: DropdownButtonFormField<String>(
              value: selectedAssetId,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.account_balance_wallet,
                      color: Colors.white, size: 20),
                ),
              ),
              hint: const Text("🚀 İzinli varlık seçin"),
              isExpanded: true,
              items: selectableAssets.map((asset) {
                return DropdownMenuItem(
                  value: asset.id,
                  child: Row(
                    children: [
                      _getAssetTypeIcon(asset.type),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              asset.displayName,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            if (asset.description != null)
                              Text(
                                asset.description!,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey[600]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Text(
                        asset.symbol,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1DD1A1),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAssetId = value;
                  // Issue gereksinimi: Bilezik kontrolü
                  // Bilezik seçenekleri AYAR14 ve AYAR22 olabilir
                  isBraceletSelected = value == 'AYAR14' || value == 'AYAR22';
                });
                HapticFeedback.lightImpact();
              },
              validator: (value) {
                if (value == null) return "✋ Lütfen bir varlık seçin";
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Issue gereksinimi: Ayar seçici (bilezik için)
  Widget _buildAyarSelector() {
    final ayarOptions = ref.watch(braceletAyarOptionsProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withOpacity(0.1),
            Colors.purple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigo.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.indigo, Colors.purple],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  "⭐ Bilezik Ayarı",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: ayarOptions.map((ayar) {
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
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1DD1A1).withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1DD1A1)
                              : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${ayar} Ayar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? const Color(0xFF1DD1A1)
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ayar == '14' ? 'Takı için' : 'Bilezik için',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
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

  /// Issue gereksinimi: Gram ağırlığı alanı (bilezik için)
  Widget _buildGramWeightField() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.withOpacity(0.1),
            Colors.red.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.pink, Colors.red],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.scale, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  "⚖️ Gram Ağırlığı",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: _gramWeightController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                hintText: "📏 Bilezik ağırlığı (gram)",
                suffixText: "gram",
                suffixStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) => HapticFeedback.selectionClick(),
              validator: (value) {
                if (isBraceletSelected) {
                  if (value == null || value.isEmpty)
                    return "⚖️ Gram ağırlığı gerekli";
                  if (double.tryParse(value) == null)
                    return "🔢 Geçerli bir ağırlık giriniz";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Fiyat input alanı
  Widget _buildNeonPriceField() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.deepOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.attach_money,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  "💰 Alış Fiyatı",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: _buyingAssetController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                hintText: "🎯 Alış fiyatını giriniz",
                suffixText: "₺",
                suffixStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) => HapticFeedback.selectionClick(),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "💸 Alış fiyatı gerekli";
                if (double.tryParse(value) == null)
                  return "🔢 Geçerli bir fiyat giriniz";
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Miktar alanı (normal varlıklar için)
  Widget _buildCyberQuantityField() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.indigo.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.indigo],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.inventory,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  "⚡ Miktar",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: _quantityAssetController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                hintText: "🎲 Miktar giriniz",
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) => HapticFeedback.selectionClick(),
              validator: (value) {
                if (!isBraceletSelected) {
                  if (value == null || value.isEmpty)
                    return "📊 Miktar gerekli";
                  if (double.tryParse(value) == null)
                    return "🔢 Geçerli bir miktar giriniz";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Tarih seçici
  Widget _buildHolographicDatePicker() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.cyan, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Icon(Icons.schedule, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  "📅 Alış Tarihi",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () async {
                HapticFeedback.mediumImpact();
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF1DD1A1),
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                  HapticFeedback.lightImpact();
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.cyan, Colors.blue],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.event,
                          color: Colors.white, size: 20),
                    ),
                    Expanded(
                      child: Text(
                        _selectedDate != null
                            ? "📆 ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                            : "🗓️ Tarih seçin",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _selectedDate != null
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.cyan),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Alt aksiyon butonları
  Widget _buildQuantumActionButtons(BuyingAssetState buyingAssetState) {
    final isLoading = buyingAssetState == BuyingAssetState.loading;

    return Row(
      children: [
        // İptal butonu
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(16),
                child: const Center(
                  child: Text(
                    "❌ İptal",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Varlık ekle butonu
        Expanded(
          flex: 2,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1DD1A1),
                  Color(0xFF26D0CE),
                  Color(0xFF00E5FF),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1DD1A1).withOpacity(0.4),
                  offset: const Offset(0, 8),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : _handleAssetSave,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "✨ Varlık Ekle",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Varlık kaydetme işlemi
  void _handleAssetSave() {
    HapticFeedback.heavyImpact();

    // Form validation kontrolü
    if (!_formKey.currentState!.validate() ||
        selectedAssetId == null ||
        _selectedDate == null) {
      _showErrorMessage("⚠️ Lütfen tüm alanları doldurun");
      return;
    }

    // Bilezik özel kontrolü
    if (isBraceletSelected &&
        (selectedAyar == null || _gramWeightController.text.isEmpty)) {
      _showErrorMessage("⚠️ Bilezik için ayar ve gram ağırlığı gerekli");
      return;
    }

    // Asset oluştur
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorMessage("❌ Kullanıcı oturumu bulunamadı");
      return;
    }

    final asset = BuyingAssetModel(
      id: '', // Firestore tarafından oluşturulacak
      assetType: selectedAssetId!,
      buyingDate: _selectedDate!,
      buyingPrice: double.parse(_buyingAssetController.text),
      quantity: isBraceletSelected
          ? 1.0
          : double.parse(_quantityAssetController.text),
      userId: user.uid,
      // Issue gereksinimi: Bilezik özel alanları
      assetSubType: isBraceletSelected ? 'bracelet' : 'normal',
      ayarType: selectedAyar,
      gramWeight: isBraceletSelected
          ? double.tryParse(_gramWeightController.text)
          : null,
    );

    // Asset'i kaydet
    ref.read(buyingAssetProvider.notifier).saveBuyingAsset(asset);

    // Listen for state changes
    ref.listen(buyingAssetProvider, (previous, next) {
      if (next == BuyingAssetState.loaded) {
        Navigator.pop(context);
        _showSuccessMessage("🎉 Varlık başarıyla eklendi!");
        // Portföyü yenile
        ref.read(userPortfolioProvider.notifier).refreshPortfolio();
      } else if (next == BuyingAssetState.error) {
        final error = ref.read(buyingAssetProvider.notifier).lastError;
        _showErrorMessage("❌ Hata: ${error ?? 'Bilinmeyen hata'}");
      }
    });
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Varlık türü ikonu
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
      case AssetType.bracelet:
        color = Colors.purple;
        icon = Icons.watch; // Changed from Icons.jewelry to Icons.watch
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
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
