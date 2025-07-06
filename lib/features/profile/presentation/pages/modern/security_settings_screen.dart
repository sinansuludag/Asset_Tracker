import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;

  bool _isTwoFactorEnabled = true;
  bool _isBiometricEnabled = false;
  bool _isDeviceTrackingEnabled = true;
  bool _isLoginAlertsEnabled = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animationController.forward();
    _pulseController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Security Header
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6C5CE7), Color(0xFDA085FE)],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(
                                    0.3 + (_pulseController.value * 0.3)),
                                blurRadius: 10 + (_pulseController.value * 10),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.security,
                            color: Colors.white,
                            size: 20,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Güvenlik",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Security Status Card
          SliverToBoxAdapter(
            child: _buildSecurityStatusCard(),
          ),

          // Password Section
          SliverToBoxAdapter(
            child: _buildPasswordSection(),
          ),

          // Two-Factor Authentication
          SliverToBoxAdapter(
            child: _buildTwoFactorSection(),
          ),

          // Biometric Settings
          SliverToBoxAdapter(
            child: _buildBiometricSection(),
          ),

          // Device & Session Management
          SliverToBoxAdapter(
            child: _buildDeviceManagement(),
          ),

          // Security Alerts
          SliverToBoxAdapter(
            child: _buildSecurityAlerts(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSecurityStatusCard() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
          )),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00B894).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(
                                    0.2 + (_pulseController.value * 0.3)),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Güvenlik Durumu",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Hesabınız güvende",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "95%",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSecurityMetrics(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecurityMetrics() {
    final metrics = [
      {"label": "Şifre Gücü", "value": 0.9, "color": Colors.white},
      {"label": "2FA", "value": 1.0, "color": Colors.white},
      {"label": "Cihaz Güvenliği", "value": 0.8, "color": Colors.white},
    ];

    return Column(
      children: metrics.map((metric) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  metric["label"] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: metric["value"] as double,
                    child: Container(
                      decoration: BoxDecoration(
                        color: metric["color"] as Color,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: (metric["color"] as Color).withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${((metric["value"] as double) * 100).toInt()}%",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPasswordSection() {
    return _buildAnimatedSection(
      delay: 0.2,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE74C3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFFE74C3C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Şifre Yönetimi",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2D3436),
                            ),
                      ),
                      Text(
                        "Şifrenizi güncelleyin ve güçlendirin",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF636E72),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildPasswordOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordOptions() {
    final options = [
      {
        'title': 'Şifre Değiştir',
        'subtitle': 'Mevcut şifrenizi güncelleyin',
        'icon': Icons.edit,
        'action': () => _showChangePasswordDialog(),
      },
      {
        'title': 'Şifre Gücü Kontrolü',
        'subtitle': 'Son kontrol: 2 gün önce',
        'icon': Icons.security,
        'trailing': 'Güçlü',
        'action': () {},
      },
      {
        'title': 'Şifre Geçmişi',
        'subtitle': 'Son kullanılan şifreler',
        'icon': Icons.history,
        'action': () {},
      },
    ];

    return Column(
      children: options.map((option) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFE74C3C).withOpacity(0.1),
            ),
          ),
          child: ListTile(
            onTap: option['action'] as VoidCallback,
            leading: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFFE74C3C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                option['icon'] as IconData,
                color: const Color(0xFFE74C3C),
                size: 18,
              ),
            ),
            title: Text(
              option['title'] as String,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3436),
                  ),
            ),
            subtitle: Text(
              option['subtitle'] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF636E72),
                  ),
            ),
            trailing: option['trailing'] != null
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B894).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      option['trailing'] as String,
                      style: const TextStyle(
                        color: Color(0xFF00B894),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF636E72),
                  ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTwoFactorSection() {
    return _buildAnimatedSection(
      delay: 0.4,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0984E3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.verified_user,
                    color: Color(0xFF0984E3),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "İki Faktörlü Doğrulama",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2D3436),
                            ),
                      ),
                      Text(
                        "Ekstra güvenlik katmanı",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF636E72),
                            ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Switch(
                    value: _isTwoFactorEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isTwoFactorEnabled = value;
                      });
                    },
                    activeColor: const Color(0xFF0984E3),
                  ),
                ),
              ],
            ),
            if (_isTwoFactorEnabled) ...[
              const SizedBox(height: 20),
              _buildTwoFactorOptions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTwoFactorOptions() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0984E3).withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF0984E3).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.smartphone,
                color: Color(0xFF0984E3),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "SMS Doğrulama",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3436),
                      ),
                ),
              ),
              Text(
                "Aktif",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF00B894),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.qr_code,
                color: Color(0xFF0984E3),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Authenticator Uygulaması",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3436),
                      ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Kur"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricSection() {
    return _buildAnimatedSection(
      delay: 0.6,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.fingerprint,
                color: Color(0xFF6C5CE7),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Biyometrik Giriş",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3436),
                        ),
                  ),
                  Text(
                    "Parmak izi veya yüz tanıma",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF636E72),
                        ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isBiometricEnabled,
              onChanged: (value) {
                setState(() {
                  _isBiometricEnabled = value;
                });
              },
              activeColor: const Color(0xFF6C5CE7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceManagement() {
    return _buildAnimatedSection(
      delay: 0.8,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE17055).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.devices,
                    color: Color(0xFFE17055),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cihaz Yönetimi",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2D3436),
                            ),
                      ),
                      Text(
                        "Giriş yapan cihazları kontrol edin",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF636E72),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildActiveDevices(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cihaz Takibi",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3436),
                            ),
                      ),
                      Text(
                        "Yeni cihaz girişlerini takip et",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF636E72),
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isDeviceTrackingEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isDeviceTrackingEnabled = value;
                    });
                  },
                  activeColor: const Color(0xFFE17055),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveDevices() {
    final devices = [
      {
        'name': 'iPhone 15 Pro',
        'location': 'İstanbul, Türkiye',
        'lastActive': 'Şimdi aktif',
        'icon': Icons.phone_iphone,
        'isCurrentDevice': true,
      },
      {
        'name': 'MacBook Pro',
        'location': 'İstanbul, Türkiye',
        'lastActive': '2 saat önce',
        'icon': Icons.laptop_mac,
        'isCurrentDevice': false,
      },
      {
        'name': 'Chrome - Windows',
        'location': 'Ankara, Türkiye',
        'lastActive': '1 gün önce',
        'icon': Icons.computer,
        'isCurrentDevice': false,
      },
    ];

    return Column(
      children: devices.map((device) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: device['isCurrentDevice'] as bool
                ? const Color(0xFF00B894).withOpacity(0.1)
                : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: device['isCurrentDevice'] as bool
                  ? const Color(0xFF00B894).withOpacity(0.3)
                  : const Color(0xFFE1E8ED),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: device['isCurrentDevice'] as bool
                      ? const Color(0xFF00B894).withOpacity(0.2)
                      : const Color(0xFF636E72).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  device['icon'] as IconData,
                  color: device['isCurrentDevice'] as bool
                      ? const Color(0xFF00B894)
                      : const Color(0xFF636E72),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          device['name'] as String,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2D3436),
                                  ),
                        ),
                        if (device['isCurrentDevice'] as bool) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00B894),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Bu Cihaz",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${device['location']} • ${device['lastActive']}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF636E72),
                          ),
                    ),
                  ],
                ),
              ),
              if (!(device['isCurrentDevice'] as bool))
                IconButton(
                  onPressed: () =>
                      _showLogoutDeviceDialog(device['name'] as String),
                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xFFE74C3C),
                    size: 20,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSecurityAlerts() {
    return _buildAnimatedSection(
      delay: 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFD79A8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Color(0xFFFD79A8),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Güvenlik Uyarıları",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2D3436),
                            ),
                      ),
                      Text(
                        "Şüpheli aktivitelerde bildirim al",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF636E72),
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isLoginAlertsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isLoginAlertsEnabled = value;
                    });
                  },
                  activeColor: const Color(0xFFFD79A8),
                ),
              ],
            ),
            if (_isLoginAlertsEnabled) ...[
              const SizedBox(height: 20),
              _buildAlertOptions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAlertOptions() {
    final alertTypes = [
      {
        'title': 'Yeni Cihaz Girişi',
        'enabled': true,
        'subtitle': 'Bilinmeyen cihazlardan giriş',
      },
      {
        'title': 'Şüpheli Lokasyon',
        'enabled': true,
        'subtitle': 'Farklı ülkelerden erişim',
      },
      {
        'title': 'Başarısız Giriş Denemeleri',
        'enabled': false,
        'subtitle': 'Çoklu hatalı şifre girişi',
      },
      {
        'title': 'Hesap Değişiklikleri',
        'enabled': true,
        'subtitle': 'Profil ve güvenlik ayarları',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFD79A8).withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFFD79A8).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: alertTypes.map((alert) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3436),
                            ),
                      ),
                      Text(
                        alert['subtitle'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF636E72),
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: alert['enabled'] as bool,
                  onChanged: (value) {
                    // Handle alert toggle
                  },
                  activeColor: const Color(0xFFFD79A8),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnimatedSection({required double delay, required Widget child}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(delay, 1.0, curve: Curves.easeOut),
          )),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              parent: _animationController,
              curve: Interval(delay, 1.0, curve: Curves.easeOut),
            )),
            child: child,
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFFE74C3C),
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Şifre Değiştir",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3436),
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                "Güvenliğiniz için güçlü bir şifre seçin",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF636E72),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF8F9FA),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "İptal",
                        style: TextStyle(
                          color: Color(0xFF636E72),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to change password screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE74C3C),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Devam Et",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDeviceDialog(String deviceName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  color: Color(0xFFE74C3C),
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Cihazdan Çıkış Yap",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3436),
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                "$deviceName cihazından çıkış yapmak istediğinizden emin misiniz?",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF636E72),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF8F9FA),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "İptal",
                        style: TextStyle(
                          color: Color(0xFF636E72),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("$deviceName cihazından çıkış yapıldı"),
                            backgroundColor: const Color(0xFF00B894),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE74C3C),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Çıkış Yap",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
