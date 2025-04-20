import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool isPriceAlertEnabled = false;
  bool isMonthlySummaryEnabled = true;
  bool isSilentHoursEnabled = false;

  List<Map<String, dynamic>> priceAlerts = [];

  TimeOfDay silentStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay silentEnd = const TimeOfDay(hour: 7, minute: 0);

  final List<String> availableSymbols = [
    'USD/TRY',
    'EUR/TRY',
    'GBP/TRY',
    'BTC/TRY'
  ];

  void _addPriceAlert() async {
    String selectedSymbol = availableSymbols.first;
    final priceController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Yeni Fiyat Uyarısı"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedSymbol,
              items: availableSymbols
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                if (val != null) selectedSymbol = val;
              },
              decoration: const InputDecoration(labelText: "Varlık"),
            ),
            SizedBox(height: MediaQuerySize(context).percent1Height),
            TextField(
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Uyarı Fiyatı (₺)",
                hintText: "Örn: 35.00",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final price = double.tryParse(priceController.text.trim());
              if (price != null) {
                setState(() {
                  priceAlerts.add({'symbol': selectedSymbol, 'price': price});
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Ekle"),
          ),
        ],
      ),
    );
  }

  void _removePriceAlert(int index) {
    setState(() => priceAlerts.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final color = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gelişmiş Bildirim Ayarları"),
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// 🔔 Fiyat Uyarısı
          Container(
            decoration: BoxDecoration(
              color: color.onSecondary.withAlpha(10),
              borderRadius: AppBorderRadius.defaultBorderRadius,
            ),
            child: SwitchListTile(
              value: isPriceAlertEnabled,
              onChanged: (val) => setState(() => isPriceAlertEnabled = val),
              title: Text("Fiyat Uyarısı", style: textTheme.bodyLarge),
              subtitle: Text(
                "Belirli kur seviyelerine ulaşıldığında uyarı al",
                style: textTheme.bodySmall,
              ),
            ),
          ),
          if (isPriceAlertEnabled) ...[
            SizedBox(height: MediaQuerySize(context).percent1Height),
            Text("Uyarı Seviyeleri", style: textTheme.bodyMedium),
            SizedBox(height: MediaQuerySize(context).percent1Height),
            if (priceAlerts.isEmpty)
              Text("Henüz bir uyarı eklenmedi.", style: textTheme.bodySmall),
            if (priceAlerts.isNotEmpty)
              Column(
                children: List.generate(priceAlerts.length, (index) {
                  final alert = priceAlerts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: color.onSecondary.withAlpha(10),
                      borderRadius: AppBorderRadius.defaultBorderRadius,
                    ),
                    child: ListTile(
                      title: Text(
                        "${alert['symbol']} ≥ ₺${(alert['price'] as double).toStringAsFixed(2)}",
                        style: textTheme.bodyMedium,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: color.onSecondary,
                        ),
                        onPressed: () => _removePriceAlert(index),
                      ),
                    ),
                  );
                }),
              ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _addPriceAlert,
                icon: const Icon(Icons.add),
                label: const Text("Yeni Fiyat Ekle"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: color.onPrimary,
                  backgroundColor: color.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.defaultBorderRadius,
                  ),
                  side: BorderSide.none,
                ),
              ),
            ),
          ],

          SizedBox(height: MediaQuerySize(context).percent2Height),

          /// 🌙 Sessiz Saatler
          Container(
            decoration: BoxDecoration(
              color: color.onSecondary.withAlpha(10),
              borderRadius: AppBorderRadius.defaultBorderRadius,
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: isSilentHoursEnabled,
                  onChanged: (val) =>
                      setState(() => isSilentHoursEnabled = val),
                  title: Text("Sessiz Saatler", style: textTheme.bodyLarge),
                  subtitle: Text(
                    "Belirttiğiniz saatler arasında bildirim gönderilmez",
                    style: textTheme.bodySmall,
                  ),
                ),
                if (isSilentHoursEnabled) ...[
                  ListTile(
                    title: Text("Başlangıç Saati", style: textTheme.bodyMedium),
                    subtitle: Text(silentStart.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: silentStart,
                      );
                      if (time != null) setState(() => silentStart = time);
                    },
                  ),
                  ListTile(
                    title: Text("Bitiş Saati", style: textTheme.bodyMedium),
                    subtitle: Text(silentEnd.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: silentEnd,
                      );
                      if (time != null) setState(() => silentEnd = time);
                    },
                  ),
                ]
              ],
            ),
          ),

          SizedBox(height: MediaQuerySize(context).percent2Height),

          /// 📊 Aylık Rapor
          Container(
            decoration: BoxDecoration(
              color: color.onSecondary.withAlpha(10),
              borderRadius: AppBorderRadius.defaultBorderRadius,
            ),
            child: SwitchListTile(
              value: isMonthlySummaryEnabled,
              onChanged: (val) => setState(() => isMonthlySummaryEnabled = val),
              title: const Text("Aylık Rapor Bildirimi"),
              subtitle: Text(
                "Ay sonunda portföy performansına dair özet al",
                style: textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
