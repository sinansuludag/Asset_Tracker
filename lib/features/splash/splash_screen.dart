import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
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
      setState(() {
        _textColorAnimation = ColorTween(
          begin: context.colorScheme.surface, // Başlangıç rengi
          end: context.colorScheme.onSecondary.withAlpha(150), // Bitiş rengi
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
      });

      _controller.forward(); // Animasyonu başlat
    });

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
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: AppPaddings.allDefaultPadding,
          child: Column(
            children: [
              SizedBox(height: MediaQuerySize(context).percent20Height),

              // Görselin opacity ve slide animasyonlarını ekliyoruz
              buildFadeTransition(context),

              SizedBox(
                height: MediaQuerySize(context).percent5Height,
              ),

              // Animasyonlu metin
              animationText(context),
            ],
          ),
        ),
      ),
    );
  }

  Row animationText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        animationTextSlideTransition(
            _animationLeft, TrStrings.splashTitleText1),
        const SizedBox(width: 8),
        animationTextSlideTransition(_animationRight,
            TrStrings.splashTitleText2), // İki metin arasında boşluk
      ],
    );
  }

  SlideTransition animationTextSlideTransition(
      Animation<Offset> position, String title) {
    return SlideTransition(
      position: position,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return animataTextDecoration(title, context);
        },
      ),
    );
  }

  Text animataTextDecoration(String title, BuildContext context) {
    return Text(
      title,
      style: context.textTheme.headlineLarge?.copyWith(
        color: _textColorAnimation?.value ?? Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  FadeTransition buildFadeTransition(BuildContext context) {
    return FadeTransition(
      opacity: _imageFadeAnimation,
      child: SlideTransition(
        position: _imageSlideAnimation,
        child: Container(
          height: MediaQuerySize(context).percent30Height,
          child: Image.asset(
            'earnings'.png,
          ),
        ),
      ),
    );
  }
}
