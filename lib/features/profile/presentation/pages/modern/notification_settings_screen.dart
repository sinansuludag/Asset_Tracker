import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _bellController;

  // Notification States
  bool _priceAlertsEnabled = true;
  bool _portfolioUpdatesEnabled = true;
  bool _marketNewsEnabled = false;
  bool _securityAlertsEnabled = true;
  bool _promotionalEnabled = false;
  bool _emailNotificationsEnabled = true;
  bool _pushNotificationsEnabled = true;
  bool _smsNotificationsEnabled = false;

  String _selectedQuietHours = "22:00 - 08:00";
  String _selectedFrequency = "Anlık";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _bellController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animationController.forward();
    _bellController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bellController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Animated Header
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
                  colors: [Color(0xFFFD79A8), Color(0xFFE84393)],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _bellController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: math.sin(_bellController.value * 4 * math.pi) *
                              0.1,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Bildirimler",
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
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: Colors.white),
                  onPressed: () => _showAdvancedSettings(),
                ),
              ),
            ],
          ),

          // Quick Toggle Section
          SliverToBoxAdapter(
            child: _buildQuickToggleSection(),
          ),

          // Notification Categories
          SliverToBoxAdapter(
            child: _buildNotificationCategories(),
          ),

          // Delivery Methods
          SliverToBoxAdapter(
            child: _buildDeliveryMethods(),
          ),

          // Schedule Settings
          SliverToBoxAdapter(
            child: _buildScheduleSettings(),
          ),

          // Recent Notifications
          SliverToBoxAdapter(
            child: _buildRecentNotifications(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildQuickToggleSection() {
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
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFD79A8).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFD79A8), Color(0xFFE84393)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFD79A8).withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.campaign,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bildirim Durumu",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2D3436),
                                ),
                          ),
                          Text(
                            "Tüm bildirimleri yönet",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFF636E72),
                                ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _pushNotificationsEnabled
                            ? const Color(0xFF00B894).withOpacity(0.1)
                            : const Color(0xFFE74C3C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _pushNotificationsEnabled
                                  ? const Color(0xFF00B894)
                                  : const Color(0xFFE74C3C),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _pushNotificationsEnabled ? "Aktif" : "Kapalı",
                            style: TextStyle(
                              color: _pushNotificationsEnabled
                                  ? const Color(0xFF00B894)
                                  : const Color(0xFFE74C3C),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildQuickActions(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.notifications_active,
            label: "Tümünü Aç",
            color: const Color(0xFF00B894),
            onTap: () => _enableAllNotifications(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.notifications_off,
            label: "Tümünü Kapat",
            color: const Color(0xFFE74C3C),
            onTap: () => _disableAllNotifications(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.schedule,
            label: "Sessiz Saatler",
            color: const Color(0xFF6C5CE7),
            onTap: () => _showQuietHoursDialog(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCategories() {
    final categories = [
      {
        'icon': Icons.trending_up,
        'title': 'Fiyat Alarmları',
        'subtitle': 'Varlık fiyat değişimleri',
        'value': _priceAlertsEnabled,
        'color': const Color(0xFF1DD1A1),
        'badge': '5 Aktif',
        'onChanged': (bool value) =>
            setState(() => _priceAlertsEnabled = value),
      },
      {
        'icon': Icons.pie_chart,
        'title': 'Portföy Güncellemeleri',
        'subtitle': 'Günlük performans raporları',
        'value': _portfolioUpdatesEnabled,
        'color': const Color(0xFF0984E3),
        'onChanged': (bool value) =>
            setState(() => _portfolioUpdatesEnabled = value),
      },
      {
        'icon': Icons.newspaper,
        'title': 'Piyasa Haberleri',
        'subtitle': 'Kripto ve finansal haberler',
        'value': _marketNewsEnabled,
        'color': const Color(0xFFE17055),
        'onChanged': (bool value) => setState(() => _marketNewsEnabled = value),
      },
      {
        'icon': Icons.security,
        'title': 'Güvenlik Uyarıları',
        'subtitle': 'Hesap güvenliği bildirimleri',
        'value': _securityAlertsEnabled,
        'color': const Color(0xFFE74C3C),
        'badge': 'Önemli',
        'onChanged': (bool value) =>
            setState(() => _securityAlertsEnabled = value),
      },
      {
        'icon': Icons.local_offer,
        'title': 'Promosyonlar',
        'subtitle': 'Özel teklifler ve kampanyalar',
        'value': _promotionalEnabled,
        'color': const Color(0xFFFD79A8),
        'onChanged': (bool value) =>
            setState(() => _promotionalEnabled = value),
      },
    ];

    return _buildAnimatedSection(
      delay: 0.2,
      title: "Bildirim Kategorileri",
      child: Column(
        children: categories.map((category) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (category['color'] as Color).withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (category['color'] as Color).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: category['color'] as Color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: (category['color'] as Color).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            category['title'] as String,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2D3436),
                                    ),
                          ),
                          if (category['badge'] != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (category['color'] as Color)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                category['badge'] as String,
                                style: TextStyle(
                                  color: category['color'] as Color,
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
                        category['subtitle'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF636E72),
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: category['value'] as bool,
                  onChanged: category['onChanged'] as Function(bool),
                  activeColor: category['color'] as Color,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDeliveryMethods() {
    return _buildAnimatedSection(
      delay: 0.4,
      title: "Bildirim Yöntemleri",
      child: Column(
        children: [
          _buildDeliveryMethodTile(
            icon: Icons.phone_android,
            title: "Push Bildirimleri",
            subtitle: "Anlık cihaz bildirimleri",
            value: _pushNotificationsEnabled,
            color: const Color(0xFF00B894),
            onChanged: (value) =>
                setState(() => _pushNotificationsEnabled = value),
          ),
          const SizedBox(height: 16),
          _buildDeliveryMethodTile(
            icon: Icons.email,
            title: "E-posta Bildirimleri",
            subtitle: "Günlük özet ve önemli güncellemeler",
            value: _emailNotificationsEnabled,
            color: const Color(0xFF0984E3),
            onChanged: (value) =>
                setState(() => _emailNotificationsEnabled = value),
          ),
          const SizedBox(height: 16),
          _buildDeliveryMethodTile(
            icon: Icons.sms,
            title: "SMS Bildirimleri",
            subtitle: "Kritik güvenlik uyarıları",
            value: _smsNotificationsEnabled,
            color: const Color(0xFFE17055),
            onChanged: (value) =>
                setState(() => _smsNotificationsEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3436),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF636E72),
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSettings() {
    return _buildAnimatedSection(
      delay: 0.6,
      title: "Zaman Ayarları",
      child: Column(
        children: [
          // Quiet Hours
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6C5CE7).withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: const Color(0xFF6C5CE7).withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.bedtime,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sessiz Saatler",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2D3436),
                                    ),
                          ),
                          Text(
                            "Bu saatlerde bildirim alamayacaksınız",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF636E72),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _showQuietHoursDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C5CE7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _selectedQuietHours,
                          style: const TextStyle(
                            color: Color(0xFF6C5CE7),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Frequency Settings
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE17055).withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: const Color(0xFFE17055).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE17055),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.schedule, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bildirim Sıklığı",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3436),
                            ),
                      ),
                      Text(
                        "Ne kadar sık bildirim almak istiyorsunuz",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF636E72),
                            ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _showFrequencyDialog,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE17055).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _selectedFrequency,
                      style: const TextStyle(
                        color: Color(0xFFE17055),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
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

  Widget _buildRecentNotifications() {
    final recentNotifications = [
      {
        'icon': Icons.trending_up,
        'title': 'Bitcoin fiyat alarmı',
        'subtitle': 'BTC 45,000 TL seviyesini aştı',
        'time': '2 dakika önce',
        'color': const Color(0xFF00B894),
        'unread': true,
      },
      {
        'icon': Icons.pie_chart,
        'title': 'Günlük portföy raporu',
        'subtitle': 'Bugünkü kazancınız +%2.3',
        'time': '1 saat önce',
        'color': const Color(0xFF0984E3),
        'unread': false,
      },
      {
        'icon': Icons.security,
        'title': 'Güvenlik uyarısı',
        'subtitle': 'Yeni cihazdan giriş tespit edildi',
        'time': '3 saat önce',
        'color': const Color(0xFFE74C3C),
        'unread': true,
      },
      {
        'icon': Icons.newspaper,
        'title': 'Piyasa haberi',
        'subtitle': 'Fed faiz kararı açıklandı',
        'time': '5 saat önce',
        'color': const Color(0xFFE17055),
        'unread': false,
      },
    ];

    return _buildAnimatedSection(
      delay: 0.8,
      title: "Son Bildirimler",
      child: Column(
        children: recentNotifications.map((notification) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (notification['unread'] as bool)
                  ? (notification['color'] as Color).withOpacity(0.05)
                  : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (notification['unread'] as bool)
                    ? (notification['color'] as Color).withOpacity(0.2)
                    : const Color(0xFFE1E8ED),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: notification['color'] as Color,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (notification['color'] as Color).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    notification['icon'] as IconData,
                    color: Colors.white,
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
                          Expanded(
                            child: Text(
                              notification['title'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2D3436),
                                  ),
                            ),
                          ),
                          if (notification['unread'] as bool)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: notification['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['subtitle'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF636E72),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['time'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF95A5A6),
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnimatedSection({
    required double delay,
    required String title,
    required Widget child,
  }) {
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
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3436),
                      ),
                ),
                const SizedBox(height: 20),
                child,
              ],
            ),
          ),
        );
      },
    );
  }

  void _enableAllNotifications() {
    setState(() {
      _priceAlertsEnabled = true;
      _portfolioUpdatesEnabled = true;
      _marketNewsEnabled = true;
      _securityAlertsEnabled = true;
      _promotionalEnabled = true;
      _pushNotificationsEnabled = true;
    });
    _showSnackBar("Tüm bildirimler etkinleştirildi", const Color(0xFF00B894));
  }

  void _disableAllNotifications() {
    setState(() {
      _priceAlertsEnabled = false;
      _portfolioUpdatesEnabled = false;
      _marketNewsEnabled = false;
      _promotionalEnabled = false;
      _pushNotificationsEnabled = false;
    });
    _showSnackBar("Tüm bildirimler kapatıldı", const Color(0xFFE74C3C));
  }

  void _showQuietHoursDialog() {
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
              Text(
                "Sessiz Saatler",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              ...["Kapalı", "22:00 - 08:00", "23:00 - 07:00", "00:00 - 09:00"]
                  .map((option) => _buildTimeOption(option)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("İptal"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C5CE7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Kaydet",
                          style: TextStyle(color: Colors.white)),
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

  Widget _buildTimeOption(String option) {
    return RadioListTile<String>(
      title: Text(option),
      value: option,
      groupValue: _selectedQuietHours,
      onChanged: (value) {
        setState(() {
          _selectedQuietHours = value!;
        });
      },
      activeColor: const Color(0xFF6C5CE7),
    );
  }

  void _showFrequencyDialog() {
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
              Text(
                "Bildirim Sıklığı",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              ...["Anlık", "Günde 1 kez", "Haftada 1 kez", "Ayda 1 kez"]
                  .map((option) => _buildFrequencyOption(option)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("İptal"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE17055),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Kaydet",
                          style: TextStyle(color: Colors.white)),
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

  Widget _buildFrequencyOption(String option) {
    return RadioListTile<String>(
      title: Text(option),
      value: option,
      groupValue: _selectedFrequency,
      onChanged: (value) {
        setState(() {
          _selectedFrequency = value!;
        });
      },
      activeColor: const Color(0xFFE17055),
    );
  }

  void _showAdvancedSettings() {
    // Advanced notification settings implementation
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
