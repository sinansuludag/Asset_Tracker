import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:flutter/material.dart';

class PortfolioQuickActionsWidget extends StatelessWidget {
  const PortfolioQuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      transform: Matrix4.translationValues(0, -15, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.95),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 10),
            blurRadius: 30,
          ),
          BoxShadow(
            color: const Color(0xFF1DD1A1).withOpacity(0.1),
            offset: const Offset(0, -5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionItem(
              context,
              icon: Icons.add_circle_outline,
              label: "Varlık Ekle",
              gradient: const LinearGradient(
                  colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)]),
              onTap: () {
                // Navigate to add asset
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("🚀 Varlık ekleme sayfası yakında..."),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
            ),
            _buildActionItem(
              context,
              icon: Icons.analytics_outlined,
              label: "Analiz",
              gradient:
                  const LinearGradient(colors: [Colors.blue, Colors.indigo]),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("📊 Detaylı analiz yakında..."),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            _buildActionItem(
              context,
              icon: Icons.file_download_outlined,
              label: "Rapor",
              gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.deepPurple]),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("📄 Rapor indirme yakında..."),
                    backgroundColor: Colors.purple,
                  ),
                );
              },
            ),
            _buildActionItem(
              context,
              icon: Icons.settings_outlined,
              label: "Ayarlar",
              gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange]),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("⚙️ Portföy ayarları yakında..."),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.4),
                    offset: const Offset(0, 8),
                    blurRadius: 20,
                  ),
                  BoxShadow(
                    color: gradient.colors.last.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
