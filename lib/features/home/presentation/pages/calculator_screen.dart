import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/core/riverpod/all_riverpod.dart';
import 'dart:math' as math;

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Basic Calculator Variables
  String _display = '0';
  String _equation = '';
  double _result = 0;
  String _operation = '';
  double _operand1 = 0;
  double _operand2 = 0;
  bool _shouldResetDisplay = false;

  // Currency Converter Variables
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'TRY';
  String _convertedAmount = '';

  // Unit Converter Variables
  final TextEditingController _unitAmountController = TextEditingController();
  String _fromUnit = 'gram';
  String _toUnit = 'kg';
  String _unitResult = '';

  // Percentage Calculator Variables
  final TextEditingController _percentageBaseController =
      TextEditingController();
  final TextEditingController _percentageRateController =
      TextEditingController();
  String _percentageResult = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _unitAmountController.dispose();
    _percentageBaseController.dispose();
    _percentageRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1DD1A1).withOpacity(0.1),
              Colors.white,
              const Color(0xFF26D0CE).withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBasicCalculator(),
                    _buildCurrencyConverter(),
                    _buildUnitConverter(),
                    _buildPercentageCalculator(),
                  ],
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
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 20.r,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hesaplayıcı & Dönüştürücü',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Günlük hesaplamalar ve dönüştürücüler',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Real-time indicator
          Consumer(
            builder: (context, ref, child) {
              final currencyState = ref.watch(currencyNotifierProvider);
              final isConnected =
                  ref.read(currencyNotifierProvider.notifier).isConnected;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isConnected ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isConnected ? Icons.wifi : Icons.wifi_off,
                      color: Colors.white,
                      size: 12.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isConnected ? 'Canlı' : 'Offline',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)],
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
        isScrollable: true,
        tabs: const [
          Tab(text: 'Hesaplayıcı'),
          Tab(text: 'Döviz'),
          Tab(text: 'Birim'),
          Tab(text: 'Yüzde'),
        ],
      ),
    );
  }

  Widget _buildBasicCalculator() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20.r,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_equation.isNotEmpty)
                  Text(
                    _equation,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                SizedBox(height: 10.h),
                Text(
                  _display,
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Buttons
          Expanded(
            child: Column(
              children: [
                _buildButtonRow(['C', '⌫', '%', '÷']),
                _buildButtonRow(['7', '8', '9', '×']),
                _buildButtonRow(['4', '5', '6', '-']),
                _buildButtonRow(['1', '2', '3', '+']),
                _buildButtonRow(['±', '0', '.', '=']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyConverter() {
    return Consumer(
      builder: (context, ref, child) {
        final currencyState = ref.watch(currencyNotifierProvider);
        final currencies = currencyState.isNotEmpty
            ? currencyState.first.currencies
            : <String, dynamic>{};

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // Live rates header
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1DD1A1).withOpacity(0.1),
                      const Color(0xFF26D0CE).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: const Color(0xFF1DD1A1),
                      size: 20.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Haremaltın Canlı Kurları',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1DD1A1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${currencies.length} Kur',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Amount Input
              _buildInputCard(
                'Miktar',
                '',
                _amountController,
                'Çevrilecek tutarı girin',
              ),
              SizedBox(height: 20.h),

              // Currency Selection
              Row(
                children: [
                  Expanded(
                    child: _buildCurrencyDropdown(
                      'Kaynak',
                      _fromCurrency,
                      currencies,
                      (value) => setState(() => _fromCurrency = value!),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          final temp = _fromCurrency;
                          _fromCurrency = _toCurrency;
                          _toCurrency = temp;
                          if (_amountController.text.isNotEmpty) {
                            _convertCurrency(currencies);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1DD1A1).withOpacity(0.3),
                              blurRadius: 8.r,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.swap_horiz,
                            color: Colors.white, size: 18.r),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildCurrencyDropdown(
                      'Hedef',
                      _toCurrency,
                      currencies,
                      (value) => setState(() => _toCurrency = value!),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Convert Button
              _buildActionButton('Dönüştür', Icons.currency_exchange, () {
                _convertCurrency(currencies);
              }),

              // Result
              if (_convertedAmount.isNotEmpty) ...[
                SizedBox(height: 20.h),
                _buildResultDisplay('Dönüştürme Sonucu', _convertedAmount),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnitConverter() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Unit Amount Input
          _buildInputCard(
            'Dönüştürülecek Miktar',
            '',
            _unitAmountController,
            'Değeri girin',
          ),
          SizedBox(height: 20.h),

          // Unit Selection
          Row(
            children: [
              Expanded(
                  child: _buildUnitDropdown('Kaynak', _fromUnit, (value) {
                setState(() => _fromUnit = value!);
              })),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      final temp = _fromUnit;
                      _fromUnit = _toUnit;
                      _toUnit = temp;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child:
                        Icon(Icons.swap_horiz, color: Colors.white, size: 20.r),
                  ),
                ),
              ),
              Expanded(
                  child: _buildUnitDropdown('Hedef', _toUnit, (value) {
                setState(() => _toUnit = value!);
              })),
            ],
          ),
          SizedBox(height: 20.h),

          // Convert Button
          _buildActionButton('Dönüştür', Icons.straighten, () {
            _convertUnits();
          }),

          // Result
          if (_unitResult.isNotEmpty) ...[
            SizedBox(height: 20.h),
            _buildResultDisplay('Birim Dönüştürme Sonucu', _unitResult),
          ],
        ],
      ),
    );
  }

  Widget _buildPercentageCalculator() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          _buildInputCard(
            'Ana Değer',
            '',
            _percentageBaseController,
            'Temel sayıyı girin',
          ),
          SizedBox(height: 15.h),

          _buildInputCard(
            'Yüzde Oranı',
            '%',
            _percentageRateController,
            'Yüzde değerini girin',
          ),
          SizedBox(height: 20.h),

          // Calculate Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton('Yüzde Hesapla', Icons.percent, () {
                  _calculatePercentage();
                }),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildActionButton('Artır/Azalt', Icons.add_circle, () {
                  _calculatePercentageChange();
                }),
              ),
            ],
          ),

          // Results
          if (_percentageResult.isNotEmpty) ...[
            SizedBox(height: 20.h),
            _buildResultDisplay('Yüzde Hesaplama Sonucu', _percentageResult),
          ],
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children:
            buttons.map((button) => _buildCalculatorButton(button)).toList(),
      ),
    );
  }

  Widget _buildCalculatorButton(String text) {
    bool isOperator = ['+', '-', '×', '÷', '='].contains(text);
    bool isFunction = ['C', '⌫', '%', '±'].contains(text);

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4.w),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onButtonPressed(text),
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                gradient: isOperator
                    ? const LinearGradient(
                        colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)])
                    : isFunction
                        ? LinearGradient(colors: [
                            Colors.orange.shade300,
                            Colors.orange.shade400
                          ])
                        : LinearGradient(colors: [
                            Colors.grey.shade50,
                            Colors.grey.shade100
                          ]),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: isOperator
                        ? const Color(0xFF1DD1A1).withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 10.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: isOperator || isFunction
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown(String label, String value,
      Map<String, dynamic> currencies, ValueChanged<String?> onChanged) {
    final availableCurrencies = currencies.keys.toList();
    if (availableCurrencies.isEmpty) {
      availableCurrencies.addAll(['USD', 'EUR', 'TRY', 'GBP']);
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Bu satırı ekledik
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 6.h),
          DropdownButton<String>(
            value: availableCurrencies.contains(value)
                ? value
                : availableCurrencies.first,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            menuMaxHeight: 200.h, // Dropdown maksimum yüksekliği
            items: availableCurrencies.map((currency) {
              final currencyData = currencies[currency];
              final price = currencyData?.buying ?? 0.0;

              return DropdownMenuItem(
                value: currency,
                child: Container(
                  constraints:
                      BoxConstraints(maxHeight: 40.h), // Item yükseklik sınırı
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currency.getCurrencyName(),
                              style: TextStyle(
                                fontSize: 13.sp, // Font boyutunu küçülttük
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (price > 0)
                              Text(
                                '₺${price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 9.sp, // Font boyutunu küçülttük
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitDropdown(
      String label, String value, ValueChanged<String?> onChanged) {
    final units = {
      // Ağırlık
      'gram': 'Gram',
      'kg': 'Kilogram',
      'ton': 'Ton',
      'miligram': 'Miligram',
      'pound': 'Pound',
      'ons': 'Ons',

      // Uzunluk
      'metre': 'Metre',
      'km': 'Kilometre',
      'cm': 'Santimetre',
      'mm': 'Milimetre',
      'inch': 'İnç',
      'foot': 'Fit',
      'yard': 'Yarda',
      'mil': 'Mil',

      // Alan
      'metrekare': 'Metrekare',
      'dönüm': 'Dönüm',
      'hektar': 'Hektar',

      // Hacim
      'litre': 'Litre',
      'metreküp': 'Metreküp',
      'galon': 'Galon',
    };

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            items: units.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(String title, String suffix,
      TextEditingController controller, String hint) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              suffixText: suffix.isNotEmpty ? suffix : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF1DD1A1)),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1DD1A1).withOpacity(0.3),
            blurRadius: 15.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20.r),
              SizedBox(width: 8.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyResult() {
    // Parse the conversion result for better display
    final lines = _convertedAmount.split('\n');
    final mainConversion = lines.isNotEmpty ? lines[0] : '';

    // Extract numbers and currencies from the main conversion line
    final parts = mainConversion.split(' = ');
    final fromPart = parts.length > 0 ? parts[0] : '';
    final toPart = parts.length > 1 ? parts[1] : '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFF1DD1A1).withOpacity(0.05),
            const Color(0xFF26D0CE).withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFF1DD1A1).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1DD1A1).withOpacity(0.1),
            blurRadius: 25.r,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with improved design
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.currency_exchange,
                    color: Colors.white,
                    size: 20.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: Text(
                    'Dönüştürme Sonucu',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Main content with better spacing
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // From amount with improved card
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Gönderilen',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          fromPart,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // Beautiful arrow with animation effect
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF1DD1A1).withOpacity(0.2),
                              const Color(0xFF26D0CE).withOpacity(0.2),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          color: const Color(0xFF1DD1A1),
                          size: 24.r,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Dönüştürüldü',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xFF1DD1A1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // To amount with special highlight
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1DD1A1).withOpacity(0.1),
                        const Color(0xFF26D0CE).withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: const Color(0xFF1DD1A1).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Alınan',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF1DD1A1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          toPart,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1DD1A1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // Exchange rate info with compact design
                if (lines.length > 2) ...[
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade600,
                              size: 16.r,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Kur Bilgileri',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        ...lines
                            .skip(2)
                            .where((line) => line.trim().isNotEmpty)
                            .map((line) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Text(
                              line.trim(),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.blue.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],

                // Live indicator with better design
                SizedBox(height: 16.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.h,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Canlı Kur',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        DateTime.now().toString().substring(11, 16),
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultDisplay(String title, String content) {
    // Eğer currency converter sonucu ise özel tasarım kullan
    if (title == 'Dönüştürme Sonucu') {
      return _buildCurrencyResult();
    }

    // Diğer sonuçlar için normal tasarım
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1DD1A1).withOpacity(0.1),
            const Color(0xFF26D0CE).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF1DD1A1).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: const Color(0xFF1DD1A1),
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Calculator Logic
  void _onButtonPressed(String buttonText) {
    setState(() {
      switch (buttonText) {
        case 'C':
          _display = '0';
          _equation = '';
          _result = 0;
          _operation = '';
          _operand1 = 0;
          _operand2 = 0;
          _shouldResetDisplay = false;
          break;

        case '⌫':
          if (_display.length > 1) {
            _display = _display.substring(0, _display.length - 1);
          } else {
            _display = '0';
          }
          break;

        case '±':
          if (_display != '0') {
            _display =
                _display.startsWith('-') ? _display.substring(1) : '-$_display';
          }
          break;

        case '%':
          double value = double.parse(_display);
          _display = (value / 100).toString();
          _formatDisplay();
          break;

        case '+':
        case '-':
        case '×':
        case '÷':
          _operand1 = double.parse(_display);
          _operation = buttonText;
          _equation = '$_display $buttonText';
          _shouldResetDisplay = true;
          break;

        case '=':
          if (_operation.isNotEmpty) {
            _operand2 = double.parse(_display);
            _calculate();
            _equation = '';
            _operation = '';
            _shouldResetDisplay = true;
          }
          break;

        case '.':
          if (!_display.contains('.')) {
            _display += '.';
          }
          break;

        default:
          if (_shouldResetDisplay) {
            _display = buttonText;
            _shouldResetDisplay = false;
          } else {
            _display = _display == '0' ? buttonText : _display + buttonText;
          }
      }

      if (buttonText != '=' && buttonText != 'C') {
        _formatDisplay();
      }
    });
  }

  void _calculate() {
    switch (_operation) {
      case '+':
        _result = _operand1 + _operand2;
        break;
      case '-':
        _result = _operand1 - _operand2;
        break;
      case '×':
        _result = _operand1 * _operand2;
        break;
      case '÷':
        _result = _operand2 != 0 ? _operand1 / _operand2 : 0;
        break;
    }

    _display = _result.toString();
    _formatDisplay();
  }

  void _formatDisplay() {
    double value = double.parse(_display);
    if (value == value.roundToDouble()) {
      _display = value.round().toString();
    } else {
      _display = value
          .toStringAsFixed(8)
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
  }

  void _convertCurrency(Map<String, dynamic> currencies) {
    if (_amountController.text.isEmpty) {
      _showErrorSnackBar('Lütfen çevrilecek tutarı girin!');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      _showErrorSnackBar('Geçerli bir sayı girin!');
      return;
    }

    final fromCurrencyData = currencies[_fromCurrency];
    final toCurrencyData = currencies[_toCurrency];

    if (fromCurrencyData == null || toCurrencyData == null) {
      _showErrorSnackBar('Seçilen para birimleri için kur bilgisi bulunamadı!');
      return;
    }

    // Haremaltın verilerinden alış ve satış kurları
    final fromBuyingRate = fromCurrencyData.buying ?? 0.0;
    final fromSellingRate = fromCurrencyData.selling ?? 0.0;
    final toBuyingRate = toCurrencyData.buying ?? 0.0;
    final toSellingRate = toCurrencyData.selling ?? 0.0;

    if (_fromCurrency == 'TRY') {
      // TRY'den diğer para birimine
      final convertedAmount = amount / toBuyingRate;
      setState(() {
        _convertedAmount = '''
${_formatNumber(amount)} TRY = ${_formatNumber(convertedAmount)} ${_toCurrency.getCurrencyName()}

Güncel Alış Kuru: 1 ${_toCurrency.getCurrencyName()} = ₺${toBuyingRate.toStringAsFixed(4)}
Güncel Satış Kuru: 1 ${_toCurrency.getCurrencyName()} = ₺${toSellingRate.toStringAsFixed(4)}
        ''';
      });
    } else if (_toCurrency == 'TRY') {
      // Diğer para biriminden TRY'ye
      final convertedAmount = amount * fromBuyingRate;
      setState(() {
        _convertedAmount = '''
${_formatNumber(amount)} ${_fromCurrency.getCurrencyName()} = ${_formatNumber(convertedAmount)} TRY

Güncel Alış Kuru: 1 ${_fromCurrency.getCurrencyName()} = ₺${fromBuyingRate.toStringAsFixed(4)}
Güncel Satış Kuru: 1 ${_fromCurrency.getCurrencyName()} = ₺${fromSellingRate.toStringAsFixed(4)}
        ''';
      });
    } else {
      // Diğer para birimlerinden diğerine (TRY üzerinden)
      final tryAmount = amount * fromBuyingRate;
      final convertedAmount = tryAmount / toBuyingRate;
      setState(() {
        _convertedAmount = '''
${_formatNumber(amount)} ${_fromCurrency.getCurrencyName()} = ${_formatNumber(convertedAmount)} ${_toCurrency.getCurrencyName()}

${_fromCurrency.getCurrencyName()} → TRY: ₺${fromBuyingRate.toStringAsFixed(4)}
${_toCurrency.getCurrencyName()} → TRY: ₺${toBuyingRate.toStringAsFixed(4)}
Çapraz Kur: 1 ${_fromCurrency.getCurrencyName()} = ${(fromBuyingRate / toBuyingRate).toStringAsFixed(4)} ${_toCurrency.getCurrencyName()}
        ''';
      });
    }
  }

  void _convertUnits() {
    if (_unitAmountController.text.isEmpty) {
      _showErrorSnackBar('Lütfen dönüştürülecek değeri girin!');
      return;
    }

    final amount = double.tryParse(_unitAmountController.text);
    if (amount == null) {
      _showErrorSnackBar('Geçerli bir sayı girin!');
      return;
    }

    // Birim dönüştürme faktörleri (temel birime göre)
    final conversionFactors = {
      // Ağırlık (gram temel)
      'miligram': 0.001,
      'gram': 1.0,
      'kg': 1000.0,
      'ton': 1000000.0,
      'ons': 28.3495,
      'pound': 453.592,

      // Uzunluk (metre temel)
      'mm': 0.001,
      'cm': 0.01,
      'metre': 1.0,
      'km': 1000.0,
      'inch': 0.0254,
      'foot': 0.3048,
      'yard': 0.9144,
      'mil': 1609.34,

      // Alan (metrekare temel)
      'metrekare': 1.0,
      'dönüm': 1000.0,
      'hektar': 10000.0,

      // Hacim (litre temel)
      'litre': 1.0,
      'metreküp': 1000.0,
      'galon': 3.78541,
    };

    final fromFactor = conversionFactors[_fromUnit];
    final toFactor = conversionFactors[_toUnit];

    if (fromFactor == null || toFactor == null) {
      _showErrorSnackBar('Birim dönüştürme hatası!');
      return;
    }

    // Önce temel birime çevir, sonra hedef birime
    final baseValue = amount * fromFactor;
    final convertedValue = baseValue / toFactor;

    final unitNames = {
      'miligram': 'Miligram',
      'gram': 'Gram',
      'kg': 'Kilogram',
      'ton': 'Ton',
      'ons': 'Ons',
      'pound': 'Pound',
      'mm': 'Milimetre',
      'cm': 'Santimetre',
      'metre': 'Metre',
      'km': 'Kilometre',
      'inch': 'İnç',
      'foot': 'Fit',
      'yard': 'Yarda',
      'mil': 'Mil',
      'metrekare': 'Metrekare',
      'dönüm': 'Dönüm',
      'hektar': 'Hektar',
      'litre': 'Litre',
      'metreküp': 'Metreküp',
      'galon': 'Galon',
    };

    setState(() {
      _unitResult = '''
${_formatNumber(amount)} ${unitNames[_fromUnit]} = ${_formatNumber(convertedValue)} ${unitNames[_toUnit]}

Dönüştürme Oranı: 1 ${unitNames[_fromUnit]} = ${_formatNumber(toFactor / fromFactor)} ${unitNames[_toUnit]}
      ''';
    });
  }

  void _calculatePercentage() {
    if (_percentageBaseController.text.isEmpty ||
        _percentageRateController.text.isEmpty) {
      _showErrorSnackBar('Lütfen tüm alanları doldurun!');
      return;
    }

    final baseValue = double.tryParse(_percentageBaseController.text);
    final percentage = double.tryParse(_percentageRateController.text);

    if (baseValue == null || percentage == null) {
      _showErrorSnackBar('Geçerli sayılar girin!');
      return;
    }

    final percentageValue = (baseValue * percentage) / 100;
    final remaining = baseValue - percentageValue;

    setState(() {
      _percentageResult = '''
Ana Değer: ${_formatNumber(baseValue)}
%${_formatNumber(percentage)} = ${_formatNumber(percentageValue)}
Kalan Miktar: ${_formatNumber(remaining)}

Oran: ${_formatNumber(percentageValue)} / ${_formatNumber(baseValue)} = %${percentage.toStringAsFixed(2)}
      ''';
    });
  }

  void _calculatePercentageChange() {
    if (_percentageBaseController.text.isEmpty ||
        _percentageRateController.text.isEmpty) {
      _showErrorSnackBar('Lütfen tüm alanları doldurun!');
      return;
    }

    final baseValue = double.tryParse(_percentageBaseController.text);
    final percentage = double.tryParse(_percentageRateController.text);

    if (baseValue == null || percentage == null) {
      _showErrorSnackBar('Geçerli sayılar girin!');
      return;
    }

    final increaseValue = baseValue + (baseValue * percentage / 100);
    final decreaseValue = baseValue - (baseValue * percentage / 100);
    final changeAmount = (baseValue * percentage) / 100;

    setState(() {
      _percentageResult = '''
Ana Değer: ${_formatNumber(baseValue)}
Değişim Miktarı: ${_formatNumber(changeAmount)}

%${_formatNumber(percentage)} Artış: ${_formatNumber(increaseValue)}
%${_formatNumber(percentage)} Azalış: ${_formatNumber(decreaseValue)}

Artış Oranı: ${((increaseValue - baseValue) / baseValue * 100).toStringAsFixed(2)}%
Azalış Oranı: ${((baseValue - decreaseValue) / baseValue * 100).toStringAsFixed(2)}%
      ''';
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number == number.roundToDouble()) {
      return number.round().toString();
    } else {
      return number
          .toStringAsFixed(6)
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
  }
}
