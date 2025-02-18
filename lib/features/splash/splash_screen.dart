import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/media_query_sizes/media_query_size.dart';
import '../../core/constants/paddings/paddings.dart';
import '../../core/constants/strings/locale/tr_strings.dart';
import '../../core/extensions/assets_path_extension.dart';
import '../../core/extensions/build_context_extension.dart';
import '../../core/routing/route_names.dart';
import '../auth/presentation/state_management/auth_state_manager.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animationLeft;
  late Animation<Offset> _animationRight;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<double> _imageFadeAnimation;
  Animation<Color?>? _textColorAnimation;

  final int duration = 5;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

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

    _imageFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _textColorAnimation = ColorTween(
          begin: context.colorScheme.surface,
          end: context.colorScheme.onSecondary.withAlpha(150),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
      });

      _controller.forward();
    });

    _controller.forward();

    Future.delayed(Duration(seconds: duration), () {
      ref.read(authProvider.notifier).checkLoginStatus().then((_) {
        final authState = ref.read(authProvider);
        if (authState == AuthState.authenticated) {
          Navigator.pushReplacementNamed(context, RouteNames.home);
        } else {
          Navigator.pushReplacementNamed(context, RouteNames.login);
        }
      });
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
              buildFadeTransition(context),
              SizedBox(height: MediaQuerySize(context).percent5Height),
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
        animationTextSlideTransition(
            _animationRight, TrStrings.splashTitleText2),
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
        child: SizedBox(
          height: MediaQuerySize(context).percent30Height,
          child: Image.asset(
            'earnings'.png,
          ),
        ),
      ),
    );
  }
}
