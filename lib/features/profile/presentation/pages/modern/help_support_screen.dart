import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'dart:math' as math;

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _searchController;
  late AnimationController _pulseController;

  final TextEditingController _searchTextController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _searchController.dispose();
    _pulseController.dispose();
    _searchTextController.dispose();
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
            expandedHeight: 160, // Daha küçük height
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
                ),
              ),
              child: FlexibleSpaceBar(
                title: LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen =
                        MediaQuery.of(context).size.width < 350;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(
                                        0.3 + (_pulseController.value * 0.3)),
                                    blurRadius:
                                        8 + (_pulseController.value * 8),
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.help_center,
                                color: Colors.white,
                                size: isSmallScreen ? 16 : 18,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            isSmallScreen ? "Yardım" : "Yardım & Destek",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    );
                  },
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
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Search Section
          SliverToBoxAdapter(
            child: _buildSearchSection(),
          ),

          // Quick Help Cards
          SliverToBoxAdapter(
            child: _buildQuickHelpSection(),
          ),

          // FAQ Section
          SliverToBoxAdapter(
            child: _buildFAQSection(),
          ),

          // Contact Support
          SliverToBoxAdapter(
            child: _buildContactSection(),
          ),

          // Help Categories
          SliverToBoxAdapter(
            child: _buildHelpCategories(),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: _buildLiveChatButton(),
    );
  }

  Widget _buildSearchSection() {
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
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00B894).withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxWidth < 300;

                    return Row(
                      children: [
                        Container(
                          width: isSmallScreen ? 40 : 45,
                          height: isSmallScreen ? 40 : 45,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00B894).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: isSmallScreen ? 20 : 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSmallScreen
                                    ? "Nasıl yardımcı olabiliriz?"
                                    : "Size nasıl yardımcı olabiliriz?",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF2D3436),
                                      fontSize: isSmallScreen ? 16 : 18,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Aradığınızı hızlıca bulun",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: const Color(0xFF636E72),
                                      fontSize: 12,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF00B894).withOpacity(0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _searchTextController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Sorunuzu yazın...",
                      hintStyle: TextStyle(
                        color: const Color(0xFF636E72).withOpacity(0.7),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: const Color(0xFF00B894),
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchTextController.clear();
                                setState(() => _searchQuery = "");
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Color(0xFF636E72),
                                size: 18,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildSearchResults(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    final results = [
      "Şifremi nasıl değiştirebilirim?",
      "Para yatırma işlemi nasıl yapılır?",
      "Portföy performansı nasıl hesaplanır?",
      "Güvenlik ayarları nerede?",
      "Bildirim ayarları nasıl değiştirilir?",
      "Hesap doğrulama süreci",
      "Komisyon oranları nedir?",
    ]
        .where(
            (item) => item.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF00B894).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Arama Sonuçları (${results.length})",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436),
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 8),
          ...results.map((result) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.faqScreen),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 14,
                          color: const Color(0xFF00B894),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            result,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF2D3436),
                                      fontSize: 12,
                                    ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: const Color(0xFF636E72),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildQuickHelpSection() {
    final quickHelps = [
      {
        'icon': Icons.account_balance_wallet,
        'title': 'Hesap İşlemleri',
        'subtitle': 'Para yatırma/çekme',
        'color': const Color(0xFF1DD1A1),
        'route': RouteNames.faqScreen,
      },
      {
        'icon': Icons.security,
        'title': 'Güvenlik',
        'subtitle': 'Şifre ve 2FA ayarları',
        'color': const Color(0xFF6C5CE7),
        'route': RouteNames.changePassword,
      },
      {
        'icon': Icons.pie_chart,
        'title': 'Portföy Yönetimi',
        'subtitle': 'Varlık takibi',
        'color': const Color(0xFF0984E3),
        'route': RouteNames.portfolio,
      },
      {
        'icon': Icons.support_agent,
        'title': 'Teknik Destek',
        'subtitle': 'Anlık yardım',
        'color': const Color(0xFFE17055),
        'route': RouteNames.contactSupport,
      },
    ];

    return _buildAnimatedSection(
      delay: 0.2,
      title: "Hızlı Yardım",
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final aspectRatio = screenWidth < 400 ? 1.0 : 1.1;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: aspectRatio,
            ),
            itemCount: quickHelps.length,
            itemBuilder: (context, index) {
              final help = quickHelps[index];
              return _buildQuickHelpCard(help);
            },
          );
        },
      ),
    );
  }

  Widget _buildQuickHelpCard(Map<String, dynamic> help) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, help['route'] as String),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              (help['color'] as Color).withOpacity(0.1),
              (help['color'] as Color).withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (help['color'] as Color).withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: (help['color'] as Color).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: help['color'] as Color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (help['color'] as Color).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                help['icon'] as IconData,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              help['title'] as String,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3436),
                    fontSize: 12,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              help['subtitle'] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF636E72),
                    fontSize: 10,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'question': 'Hesabımı nasıl doğrularım?',
        'answer':
            'Hesap doğrulama için kimlik belgenizi ve adres belgenizi yüklemeniz gerekmektedir. Belgeler 24 saat içinde incelenir.',
      },
      {
        'question': 'Para yatırma işlemi ne kadar sürer?',
        'answer':
            'Banka havalesi ile yapılan para yatırma işlemleri genellikle 1-2 iş günü içinde hesabınıza yansır.',
      },
      {
        'question': 'Şifremi unuttum ne yapmalıyım?',
        'answer':
            'Giriş ekranında "Şifremi Unuttum" seçeneğine tıklayarak e-posta adresinize şifre sıfırlama bağlantısı gönderebilirsiniz.',
      },
    ];

    return _buildAnimatedSection(
      delay: 0.4,
      title: "Sık Sorulan Sorular",
      child: Column(
        children: [
          ...faqs.asMap().entries.map((entry) {
            final index = entry.key;
            final faq = entry.value;
            return _buildFAQItem(faq, index);
          }),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.faqScreen),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B894),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                "Tüm SSS'leri Görüntüle",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E8ED)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF00B894).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              "${index + 1}",
              style: const TextStyle(
                color: Color(0xFF00B894),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
        title: Text(
          faq['question'] as String,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
                fontSize: 13,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        iconColor: const Color(0xFF00B894),
        collapsedIconColor: const Color(0xFF636E72),
        children: [
          Text(
            faq['answer'] as String,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF636E72),
                  height: 1.4,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    final contactMethods = [
      {
        'icon': Icons.email,
        'title': 'E-posta Desteği',
        'subtitle': 'destek@assettracker.com',
        'description': '24 saat içinde yanıt',
        'color': const Color(0xFF0984E3),
        'route': RouteNames.contactSupport,
      },
      {
        'icon': Icons.phone,
        'title': 'Telefon Desteği',
        'subtitle': '+90 212 123 45 67',
        'description': 'Pazartesi-Cuma 09:00-18:00',
        'color': const Color(0xFF00B894),
        'route': RouteNames.contactSupport,
      },
      {
        'icon': Icons.chat,
        'title': 'Canlı Destek',
        'subtitle': 'Anlık mesajlaşma',
        'description': '7/24 aktif',
        'color': const Color(0xFFFD79A8),
        'route': RouteNames.contactSupport,
      },
      {
        'icon': Icons.feedback,
        'title': 'Geri Bildirim',
        'subtitle': 'Önerilerinizi paylaşın',
        'description': 'Ürün geliştirme',
        'color': const Color(0xFF6C5CE7),
        'route': RouteNames.feedBack,
      },
    ];

    return _buildAnimatedSection(
      delay: 0.6,
      title: "Bizimle İletişime Geçin",
      child: Column(
        children: contactMethods.map((method) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (method['color'] as Color).withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (method['color'] as Color).withOpacity(0.2),
              ),
            ),
            child: InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, method['route'] as String),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: method['color'] as Color,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (method['color'] as Color).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      method['icon'] as IconData,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method['title'] as String,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2D3436),
                                    fontSize: 14,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          method['subtitle'] as String,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: method['color'] as Color,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          method['description'] as String,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF636E72),
                                    fontSize: 11,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: method['color'] as Color,
                    size: 14,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHelpCategories() {
    final categories = [
      {
        'icon': Icons.school,
        'title': 'Eğitim Merkezi',
        'subtitle': 'Yatırım rehberleri ve eğitimler',
        'color': const Color(0xFFE17055),
        'route': RouteNames.aboutApp,
      },
      {
        'icon': Icons.video_library,
        'title': 'Video Kılavuzlar',
        'subtitle': 'Adım adım görsel anlatımlar',
        'color': const Color(0xFF74B9FF),
        'route': RouteNames.aboutApp,
      },
      {
        'icon': Icons.article,
        'title': 'Blog & Makaleler',
        'subtitle': 'Güncel piyasa analizleri',
        'color': const Color(0xFFA29BFE),
        'route': RouteNames.aboutApp,
      },
      {
        'icon': Icons.privacy_tip,
        'title': 'Gizlilik Politikası',
        'subtitle': 'Veri koruma ve gizlilik',
        'color': const Color(0xFF55A3FF),
        'route': RouteNames.privacyPolicy,
      },
    ];

    return _buildAnimatedSection(
      delay: 0.8,
      title: "Yardım Kategorileri",
      child: Column(
        children: categories.map((category) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () =>
                  Navigator.pushNamed(context, category['route'] as String),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (category['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  category['icon'] as IconData,
                  color: category['color'] as Color,
                  size: 18,
                ),
              ),
              title: Text(
                category['title'] as String,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3436),
                      fontSize: 13,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                category['subtitle'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF636E72),
                      fontSize: 11,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: category['color'] as Color,
                size: 14,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: (category['color'] as Color).withOpacity(0.2),
                ),
              ),
              tileColor: (category['color'] as Color).withOpacity(0.05),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLiveChatButton() {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FloatingActionButton.extended(
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.contactSupport),
            backgroundColor: const Color(0xFF00B894),
            heroTag: "live_chat_btn",
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5 +
                                math.sin(_pulseController.value * 4 * math.pi) *
                                    0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 6),
                const Text(
                  "Destek",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            icon: Transform.scale(
              scale: 0.9 +
                  math.sin(_animationController.value * 4 * math.pi) * 0.05,
              child: const Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 20,
              ),
            ),
          );
        },
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFF00B894).withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3436),
                        fontSize: 16,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                child,
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper Methods for Actions
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _openFAQItem(String question) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF00B894).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: Color(0xFF00B894),
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                question,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                "Bu konuda size nasıl yardımcı olabiliriz?",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF636E72),
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF8F9FA),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Kapat",
                        style: TextStyle(
                          color: Color(0xFF636E72),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RouteNames.contactSupport);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B894),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Canlı Destek",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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

  void _openHelpCategory(String category) {
    _showSnackBar("$category açılıyor...", const Color(0xFF00B894));
  }

  void _sendEmail() {
    _showSnackBar("E-posta uygulaması açılıyor...", const Color(0xFF0984E3));
  }

  void _makeCall() {
    _showSnackBar("Arama başlatılıyor...", const Color(0xFF00B894));
  }

  void _openLiveChat() {
    Navigator.pushNamed(context, RouteNames.contactSupport);
    _showSnackBar(
        "Canlı destek bağlantısı kuruluyor...", const Color(0xFFFD79A8));
  }

  void _openHelpCenter() {
    Navigator.pushNamed(context, RouteNames.aboutApp);
    _showSnackBar("Yardım merkezi açılıyor...", const Color(0xFF6C5CE7));
  }
}
