import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/colors/app_colors.dart';

class ModernAuthBackground extends StatelessWidget {
  final Widget child;

  const ModernAuthBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Stack(
        children: [
          // Custom pattern overlay
          _buildPatternOverlay(),

          // Floating elements
          _buildFloatingElements(),

          // Main content
          SafeArea(child: child),
        ],
      ),
    );
  }

  Widget _buildPatternOverlay() {
    return Positioned.fill(
      child: CustomPaint(
        painter: PatternPainter(),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Stack(
      children: [
        // Floating coins with different animations
        Positioned(
          top: 100,
          left: -20,
          child: FadeInLeft(
            delay: const Duration(seconds: 1),
            child: _FloatingCoin(size: 80, delay: 0),
          ),
        ),
        Positioned(
          top: 200,
          right: -30,
          child: FadeInRight(
            delay: const Duration(seconds: 2),
            child: _FloatingCoin(size: 60, delay: 2),
          ),
        ),
        Positioned(
          bottom: 150,
          left: -25,
          child: FadeInLeft(
            delay: const Duration(seconds: 3),
            child: _FloatingCoin(size: 70, delay: 4),
          ),
        ),
      ],
    );
  }
}

// Custom pattern painter
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw dots pattern
    for (double x = 0; x < size.width; x += 40) {
      for (double y = 0; y < size.height; y += 40) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Animated floating coin widget
class _FloatingCoin extends StatefulWidget {
  final double size;
  final int delay;

  const _FloatingCoin({required this.size, required this.delay});

  @override
  State<_FloatingCoin> createState() => _FloatingCoinState();
}

class _FloatingCoinState extends State<_FloatingCoin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: -30,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Future.delayed(Duration(seconds: widget.delay), () {
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.monetization_on,
                color: Colors.white.withOpacity(0.3),
                size: widget.size * 0.6,
              ),
            ),
          ),
        );
      },
    );
  }
}
