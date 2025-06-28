import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/ultra_modern_buying_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantumFabWidget extends StatefulWidget {
  const QuantumFabWidget({super.key});

  @override
  State<QuantumFabWidget> createState() => _QuantumFabWidgetState();
}

class _QuantumFabWidgetState extends State<QuantumFabWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
        CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _rotationController.forward();
    } else {
      _rotationController.reverse();
    }

    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Expanded Action Buttons
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            height: _isExpanded ? 180 : 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMiniActionButton(
                    icon: Icons.flash_on,
                    label: "Hızlı Al",
                    gradient: const LinearGradient(
                        colors: [Colors.green, Colors.teal]),
                    onTap: () =>
                        _showQuickMessage("⚡ Hızlı alım özelliği yakında..."),
                  ),
                  const SizedBox(height: 12),
                  _buildMiniActionButton(
                    icon: Icons.trending_up,
                    label: "Analiz",
                    gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.indigo]),
                    onTap: () {
                      _showQuickMessage("📈 Piyasa analizi yakında...");
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMiniActionButton(
                    icon: Icons.alarm_add,
                    label: "Hızlı Alarm",
                    gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange]),
                    onTap: () =>
                        _showQuickMessage("🔔 Hızlı alarm özelliği yakında..."),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Main FAB
          ScaleTransition(
            scale: _pulseAnimation,
            child: RotationTransition(
              turns: _rotationAnimation,
              child: Container(
                width: 64,
                height: 64,
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
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1DD1A1).withOpacity(0.4),
                      offset: const Offset(0, 8),
                      blurRadius: 24,
                    ),
                    BoxShadow(
                      color: const Color(0xFF26D0CE).withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _toggleExpansion,
                    borderRadius: BorderRadius.circular(32),
                    child: Icon(
                      _isExpanded ? Icons.close : Icons.auto_awesome,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniActionButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
        _toggleExpansion(); // Close after action
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
