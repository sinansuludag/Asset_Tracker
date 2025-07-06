import 'package:flutter/material.dart';
import 'dart:math' as math;

class QuickStatsSection extends StatelessWidget {
  final AnimationController mainController;

  const QuickStatsSection({
    super.key,
    required this.mainController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20), // ORİJİNAL AYNI
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              "127",
              "Gün Aktif",
              const Color(0xFF1DD1A1),
              Icons.calendar_today,
              0.0,
            ),
          ),
          const SizedBox(width: 12), // ORİJİNAL AYNI
          Expanded(
            child: _buildStatCard(
              context,
              "15",
              "Varlık",
              const Color(0xFF0984E3),
              Icons.account_balance_wallet,
              0.1,
            ),
          ),
          const SizedBox(width: 12), // ORİJİNAL AYNI
          Expanded(
            child: _buildStatCard(
              context,
              "₺139K",
              "Portföy",
              const Color(0xFF6C5CE7),
              Icons.pie_chart,
              0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    Color color,
    IconData icon,
    double delay,
  ) {
    return AnimatedBuilder(
      animation: mainController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: mainController,
            curve: Interval(
              (0.5 + delay).clamp(0.0, 1.0),
              1.0,
              curve: Curves.elasticOut,
            ),
          )),
          child: Container(
            padding: const EdgeInsets.all(16), // ORİJİNAL AYNI
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(20), // ORİJİNAL AYNI
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: IntrinsicHeight(
              // SADECE BU EKLENDİ - overflow önlemek için
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // SADECE BU EKLENDİ
                children: [
                  // Icon with animated background - ORİJİNAL AYNI
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 12), // ORİJİNAL AYNI

                  // Value - ORİJİNAL AYNI, sadece overflow korunması
                  Flexible(
                    // SADECE BU EKLENDİ
                    child: Text(
                      value,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                      overflow: TextOverflow.ellipsis, // SADECE BU EKLENDİ
                      maxLines: 1, // SADECE BU EKLENDİ
                    ),
                  ),
                  const SizedBox(height: 4), // ORİJİNAL AYNI

                  // Label - ORİJİNAL AYNI, sadece overflow korunması
                  Flexible(
                    // SADECE BU EKLENDİ
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF636E72),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                      overflow: TextOverflow.ellipsis, // SADECE BU EKLENDİ
                      maxLines: 1, // SADECE BU EKLENDİ
                    ),
                  ),
                  const SizedBox(height: 8), // ORİJİNAL AYNI

                  // Progress indicator - ORİJİNAL AYNI
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _getProgressValue(label),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
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
      },
    );
  }

  double _getProgressValue(String label) {
    switch (label) {
      case "Gün Aktif":
        return 0.85; // 85% progress
      case "Varlık":
        return 0.6; // 60% progress
      case "Portföy":
        return 0.92; // 92% progress
      default:
        return 0.5;
    }
  }
}
