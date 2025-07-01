import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/markets/presentation/state_management/providers/markets_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: AppBar(
        title: const Text(
          "İzleme Listesi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              // Add new alert functionality
              _showAddAlertDialog(context, ref);
            },
            icon: const Icon(Icons.add_alert),
          ),
        ],
      ),
      body: watchlist.isEmpty
          ? _buildEmptyState(context)
          : _buildWatchlistContent(context, ref, watchlist),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 80,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              "İzleme Listeniz Boş",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              "Takip etmek istediğiniz varlıklar için\nfiyat alarmları kurun",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.add),
              label: const Text("Piyasalara Git"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchlistContent(
      BuildContext context, WidgetRef ref, List<dynamic> watchlist) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: watchlist.length,
      itemBuilder: (context, index) {
        final item = watchlist[index];
        return _buildWatchlistItem(context, ref, item);
      },
    );
  }

  Widget _buildWatchlistItem(
      BuildContext context, WidgetRef ref, dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Alert Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.isActive
                    ? AppColors.primaryGreen.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.notifications_active,
                color: item.isActive ? AppColors.primaryGreen : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Alert Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.marketCode,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Fiyat ${item.alertType == 'above' ? 'üzerine' : 'altına'} çıktığında bildir",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            // Alert Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₺${item.alertPrice.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.isActive ? "Aktif" : "Pasif",
                    style: TextStyle(
                      color: item.isActive ? Colors.green : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),

            // Menu Button
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditAlertDialog(context, ref, item);
                    break;
                  case 'delete':
                    _deleteAlert(ref, item.id);
                    break;
                  case 'toggle':
                    _toggleAlert(ref, item);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text("Düzenle"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'toggle',
                  child: Row(
                    children: [
                      Icon(
                        item.isActive ? Icons.pause : Icons.play_arrow,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(item.isActive ? "Durdur" : "Başlat"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Sil", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              child: const Icon(
                Icons.more_vert,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAlertDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _AlertDialog(
        title: "Yeni Alarm Ekle",
        onSave: (marketCode, price, type) {
          ref
              .read(watchlistProvider.notifier)
              .addToWatchlist(marketCode, price, type);
        },
      ),
    );
  }

  void _showEditAlertDialog(BuildContext context, WidgetRef ref, dynamic item) {
    showDialog(
      context: context,
      builder: (context) => _AlertDialog(
        title: "Alarmı Düzenle",
        initialMarketCode: item.marketCode,
        initialPrice: item.alertPrice,
        initialType: item.alertType,
        onSave: (marketCode, price, type) {
          final updatedItem = item.copyWith(
            marketCode: marketCode,
            alertPrice: price,
            alertType: type,
          );
          ref.read(watchlistProvider.notifier).updateAlert(updatedItem);
        },
      ),
    );
  }

  void _deleteAlert(WidgetRef ref, String alertId) {
    ref.read(watchlistProvider.notifier).removeFromWatchlist(alertId);
  }

  void _toggleAlert(WidgetRef ref, dynamic item) {
    final updatedItem = item.copyWith(isActive: !item.isActive);
    ref.read(watchlistProvider.notifier).updateAlert(updatedItem);
  }
}

// Alert Dialog Widget
class _AlertDialog extends StatefulWidget {
  final String title;
  final String? initialMarketCode;
  final double? initialPrice;
  final String? initialType;
  final Function(String, double, String) onSave;

  const _AlertDialog({
    required this.title,
    required this.onSave,
    this.initialMarketCode,
    this.initialPrice,
    this.initialType,
  });

  @override
  State<_AlertDialog> createState() => _AlertDialogState();
}

class _AlertDialogState extends State<_AlertDialog> {
  late TextEditingController _priceController;
  String _selectedMarket = 'ALTIN';
  String _alertType = 'above';

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.initialPrice?.toString() ?? '',
    );
    _selectedMarket = widget.initialMarketCode ?? 'ALTIN';
    _alertType = widget.initialType ?? 'above';
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedMarket,
            decoration: const InputDecoration(
              labelText: "Varlık",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'ALTIN', child: Text('Altın')),
              DropdownMenuItem(value: 'USDTRY', child: Text('USD/TRY')),
              DropdownMenuItem(value: 'EURTRY', child: Text('EUR/TRY')),
              DropdownMenuItem(value: 'GUMUSTRY', child: Text('Gümüş')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedMarket = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: "Hedef Fiyat",
              border: OutlineInputBorder(),
              prefixText: "₺",
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _alertType,
            decoration: const InputDecoration(
              labelText: "Alarm Türü",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                  value: 'above', child: Text('Fiyat üzerine çıktığında')),
              DropdownMenuItem(
                  value: 'below', child: Text('Fiyat altına indiğinde')),
            ],
            onChanged: (value) {
              setState(() {
                _alertType = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("İptal"),
        ),
        ElevatedButton(
          onPressed: () {
            final price = double.tryParse(_priceController.text);
            if (price != null) {
              widget.onSave(_selectedMarket, price, _alertType);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
          ),
          child: const Text("Kaydet"),
        ),
      ],
    );
  }
}
