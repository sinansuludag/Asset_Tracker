import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/theme/color_scheme.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animationLeft;
  late Animation<Offset> _animationRight;
  late Animation<Offset> _imageSlideAnimation; // Görsel için slide animasyonu
  late Animation<double> _imageFadeAnimation; // Görsel için opacity animasyonu
  Animation<Color?>? _textColorAnimation; // Metin rengi animasyonu
  late Animation<double> _shadowBlurAnimation; // Gölgeleme animasyonu
  final int duration = 5;
  @override
  void initState() {
    super.initState();

    // Animasyon controller'ı başlatıyoruz
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // Animasyonlar
    _animationLeft = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _animationRight = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Görselin yavaşça görünmesi için opacity animasyonu
    _imageFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Görselin alt taraftan yukarıya hareket etmesi için slide animasyonu
    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 3), // Başlangıçta ekranın altından
      end: Offset.zero, // Sonraki animasyon yeri
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Metin renginin animasyonu (renk geçişi)
    // `addPostFrameCallback` ile `context` üzerinden renk değerlerini ayarla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final colorScheme = Theme.of(context).colorScheme;
      setState(() {
        _textColorAnimation = ColorTween(
          begin: colorScheme.surface, // Başlangıç rengi
          end: colorScheme.secondary.withOpacity(1), // Bitiş rengi
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
      });

      _controller.forward(); // Animasyonu başlat
    });

    // Gölgeleme animasyonu
    _shadowBlurAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(); // Animasyonu başlat

    Future.delayed(Duration(seconds: duration), () {
      Navigator.pushReplacementNamed(context, RouteNames.login);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Padding(
          padding: AppPaddings.defaultPadding,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),

              // Görselin opacity ve slide animasyonlarını ekliyoruz
              buildFadeTransition(context),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              // Animasyonlu metin
              animationText(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Row animationText(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        animationTextSlideTransition(
            textTheme, _animationLeft, TrStrings.splashTitleText1),
        const SizedBox(width: 8),
        animationTextSlideTransition(textTheme, _animationRight,
            TrStrings.splashTitleText2), // İki metin arasında boşluk
      ],
    );
  }

  SlideTransition animationTextSlideTransition(
      TextTheme textTheme, Animation<Offset> position, String title) {
    return SlideTransition(
      position: position,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return animataTextDecoration(title, textTheme);
        },
      ),
    );
  }

  Text animataTextDecoration(String title, TextTheme textTheme) {
    return Text(
      title,
      style: textTheme.headlineLarge?.copyWith(
        color: _textColorAnimation?.value ?? Colors.black,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: AppColorScheme.lightColorScheme.secondary
                .withOpacity(1), // Parlama rengi
            blurRadius: _shadowBlurAnimation.value, // Gölgeleme yoğunluğu
            offset: const Offset(0, 2), // Gölge yönü
          ),
        ],
      ),
    );
  }

  FadeTransition buildFadeTransition(BuildContext context) {
    return FadeTransition(
      opacity: _imageFadeAnimation,
      child: SlideTransition(
        position: _imageSlideAnimation,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Image.asset(
            'earnings'.png,
          ),
        ),
      ),
    );
  }
}
