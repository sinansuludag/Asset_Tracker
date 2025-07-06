import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/utils/currency_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Gelişmiş varlık ekleme dialog'u
void showUltraModernBuyingDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Tam ekran kontrolü
    isDismissible: true, // Dışarı tıklayınca kapanır
    enableDrag: true, // Sürükleyerek kapatılabilir
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
  final _buyingAssetController = TextEditingController(); // Fiyat
  final _quantityAssetController = TextEditingController(); // Miktar
  final _formKey = GlobalKey<FormState>(); // Form validation
  DateTime? _selectedDate; // Seçilen tarih
  String? selectedAsset; // Seçilen varlık

  // Animasyon controller'ları
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Animasyon setup'ı
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Animasyon tanımları
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _slideController, curve: Curves.elasticOut));

    // Animasyonları başlat
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _buyingAssetController.dispose();
    _quantityAssetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              colors: [
                Colors.white,
                const Color(0xFFF8FFFE),
                Colors.white,
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, -10),
                blurRadius: 30,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDynamicHeader(), // Üst kısım
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildGlassmorphicAssetSelector(), // Varlık seçici
                        const SizedBox(height: 24),
                        _buildNeonPriceField(), // Fiyat alanı
                        const SizedBox(height: 24),
                        _buildCyberQuantityField(), // Miktar alanı
                        const SizedBox(height: 24),
                        _buildHolographicDatePicker(), // Tarih seçici
                        const SizedBox(height: 32),
                        _buildQuantumActionButtons(), // Aksiyon butonları
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

  // Widget _buildQuickBuyButton(String title, String price) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("🎉 $title satın alındı!"),
  //           backgroundColor: const Color(0xFF1DD1A1),
  //           behavior: SnackBarBehavior.floating,
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: Colors.white.withOpacity(0.2),
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: Colors.white.withOpacity(0.3)),
  //       ),
  //       child: Column(
  //         children: [
  //           Text(
  //             title,
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontSize: 12,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           Text(
  //             price,
  //             style: const TextStyle(
  //               color: Colors.white70,
  //               fontSize: 10,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // // Hızlı alarm dialog'u
  // void _showQuickAlarmDialog() {
  //   showDialog(
  //     context: context,
  //     barrierColor: Colors.black54,
  //     builder: (context) => Dialog(
  //       backgroundColor: Colors.transparent,
  //       child: Container(
  //         padding: const EdgeInsets.all(24),
  //         decoration: BoxDecoration(
  //           gradient: const LinearGradient(
  //             colors: [Colors.orange, Colors.deepOrange],
  //           ),
  //           borderRadius: BorderRadius.circular(20),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.orange.withOpacity(0.4),
  //               blurRadius: 20,
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Icon(Icons.alarm_add, color: Colors.white, size: 48),
  //             const SizedBox(height: 16),
  //             const Text(
  //               "⏰ Hızlı Alarm",
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 24,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             const Text(
  //               "Popüler fiyat seviyelerinde\nalarm kurun",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: Colors.white70,
  //                 fontSize: 14,
  //               ),
  //             ),
  //             const SizedBox(height: 24),
  //             Wrap(
  //               spacing: 12,
  //               runSpacing: 12,
  //               children: [
  //                 _buildQuickAlarmButton("📈 Altın +%5", "₺4.480"),
  //                 _buildQuickAlarmButton("📉 Altın -%5", "₺4.054"),
  //                 _buildQuickAlarmButton("💵 USD ₺110", "₺110.00"),
  //                 _buildQuickAlarmButton("🎯 Özel Fiyat", "Manuel"),
  //               ],
  //             ),
  //             const SizedBox(height: 20),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: TextButton(
  //                     onPressed: () => Navigator.pop(context),
  //                     child: const Text(
  //                       "İptal",
  //                       style: TextStyle(color: Colors.white70),
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                       _showQuickMessage(
  //                           "🔔 Detaylı alarm sistemi yakında...");
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.white,
  //                       foregroundColor: Colors.orange,
  //                     ),
  //                     child: const Text("Detaylı Alarm"),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildQuickAlarmButton(String title, String target) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("⏰ $title alarmı kuruldu!"),
  //           backgroundColor: Colors.orange,
  //           behavior: SnackBarBehavior.floating,
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: Colors.white.withOpacity(0.2),
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: Colors.white.withOpacity(0.3)),
  //       ),
  //       child: Column(
  //         children: [
  //           Text(
  //             title,
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontSize: 12,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           Text(
  //             target,
  //             style: const TextStyle(
  //               color: Colors.white70,
  //               fontSize: 10,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _showQuickMessage(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }

  // Header kısmı - animasyonlu ve modern
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
          // Drag handle (sürükleme çubuğu)
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
              // Sol taraf - İkon
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              // Orta - Başlık ve açıklama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Colors.white70],
                      ).createShader(bounds),
                      child: Text(
                        "✨ Yeni Varlık Ekle",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                      ),
                    ),
                    Text(
                      "Portföyünüze premium yatırım ekleyin",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
              // Sağ - Kapatma butonu
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

  // Varlık seçici widget'ı
  Widget _buildGlassmorphicAssetSelector() {
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1DD1A1).withOpacity(0.1),
            offset: const Offset(0, 8),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık kısmı
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
                  "💎 Varlık Türü",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
          // Dropdown alanı
          Padding(
            padding: const EdgeInsets.all(20),
            child: DropdownButtonFormField<String>(
              value: selectedAsset,
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
              hint: const Text("🚀 Premium varlık seçin"),
              isExpanded: true,
              items: Currency.currencyNames.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Row(
                    children: [
                      _getCurrencyIcon(currency),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          currency,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAsset = value;
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

  // Fiyat input alanı
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
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            offset: const Offset(0, 8),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
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
          // Input alanı
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
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.trending_up,
                      color: Colors.white, size: 20),
                ),
              ),
              keyboardType: TextInputType.number,
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

  // Miktar alanı (artırma/azaltma butonlarıyla)
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
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            offset: const Offset(0, 8),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
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
          // Miktar kontrolü
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildQuantityButton(
                    icon: Icons.remove,
                    gradient:
                        const LinearGradient(colors: [Colors.red, Colors.pink]),
                    onPressed: () {
                      final currentValue =
                          double.tryParse(_quantityAssetController.text) ?? 0;
                      if (currentValue > 0) {
                        _quantityAssetController.text =
                            (currentValue - 1).toString();
                        HapticFeedback.lightImpact();
                      }
                    },
                  ),
                  // Miktar input'u
                  Expanded(
                    child: TextFormField(
                      controller: _quantityAssetController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "🎲 Miktar",
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) => HapticFeedback.selectionClick(),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "📊 Miktar gerekli";
                        if (double.tryParse(value) == null)
                          return "🔢 Geçerli bir miktar giriniz";
                        return null;
                      },
                    ),
                  ),
                  // Artırma butonu
                  _buildQuantityButton(
                    icon: Icons.add,
                    gradient: const LinearGradient(
                        colors: [Colors.green, Colors.teal]),
                    onPressed: () {
                      final currentValue =
                          double.tryParse(_quantityAssetController.text) ?? 0;
                      _quantityAssetController.text =
                          (currentValue + 1).toString();
                      HapticFeedback.lightImpact();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Miktar butonları
  Widget _buildQuantityButton({
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }

  // Tarih seçici
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
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.2),
            offset: const Offset(0, 8),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
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
          // Tarih seçici buton
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

  // Alt aksiyon butonları
  Widget _buildQuantumActionButtons() {
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
                onTap: () {
                  HapticFeedback.heavyImpact();
                  // Form validation kontrolü
                  if (_formKey.currentState!.validate() &&
                      selectedAsset != null &&
                      _selectedDate != null) {
                    // Başarılı - varlık ekle
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text("🎉 Varlık başarıyla eklendi!"),
                          ],
                        ),
                        backgroundColor: AppColors.primaryGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  } else {
                    // Hata - eksik bilgi
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.white),
                            SizedBox(width: 12),
                            Text("⚠️ Lütfen tüm alanları doldurun"),
                          ],
                        ),
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: const Center(
                  child: Text(
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

  // Varlık ikonları oluşturucu
  Widget _getCurrencyIcon(String currency) {
    final colors = <LinearGradient>[
      const LinearGradient(colors: [Colors.amber, Colors.orange]),
      const LinearGradient(colors: [Colors.green, Colors.teal]),
      const LinearGradient(colors: [Colors.blue, Colors.indigo]),
      const LinearGradient(colors: [Colors.purple, Colors.pink]),
      const LinearGradient(colors: [Colors.red, Colors.deepOrange]),
    ];

    final gradientIndex = currency.hashCode % colors.length;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: colors[gradientIndex],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors[gradientIndex].colors.first.withOpacity(0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Icon(
        Icons.monetization_on,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}
