import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/riverpod/all_riverpod.dart'; // refreshIntervalProvider burada tanımlı olmalı
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshFrequencyScreen extends ConsumerStatefulWidget {
  const RefreshFrequencyScreen({super.key});

  @override
  ConsumerState<RefreshFrequencyScreen> createState() =>
      _RefreshFrequencyScreenState();
}

class _RefreshFrequencyScreenState
    extends ConsumerState<RefreshFrequencyScreen> {
  late String selectedOption;

  final Map<String, Duration> optionsMap = {
    'Anlık (5 saniye)': const Duration(seconds: 5),
    '30 Saniye': const Duration(seconds: 30),
    '1 Dakika': const Duration(minutes: 1),
    '5 Dakika': const Duration(minutes: 5),
    'Yalnızca Manuel': Duration.zero, // özel anlam: elle tetiklenecek
  };

  @override
  void initState() {
    super.initState();
    final current = ref.read(refreshIntervalProvider);
    selectedOption = optionsMap.entries
        .firstWhere((entry) => entry.value == current,
            orElse: () => const MapEntry('1 Dakika', Duration(minutes: 1)))
        .key;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final color = context.colorScheme;

    final isManualSelected = optionsMap[selectedOption] == Duration.zero;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Yenileme Sıklığı"),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: AppPaddings.allDefaultPadding,
              itemCount: optionsMap.length,
              itemBuilder: (context, index) {
                final option = optionsMap.keys.elementAt(index);
                final isSelected = option == selectedOption;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: color.onSecondary.withAlpha(10),
                    borderRadius: AppBorderRadius.defaultBorderRadius,
                  ),
                  child: ListTile(
                    title: Text(option, style: textTheme.bodyMedium),
                    leading: Radio<String>(
                      value: option,
                      groupValue: selectedOption,
                      onChanged: (val) => _onOptionSelected(val!),
                    ),
                    onTap: () => _onOptionSelected(option),
                  ),
                );
              },
            ),
          ),
          if (isManualSelected)
            Padding(
              padding: AppPaddings.verticalAndHorizontal_24_16,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: AppBorderRadius.defaultBorderRadius,
                  onTap: () async {
                    ref.read(currencyNotifierProvider.notifier).manualRefresh();

                    if (context.mounted) {
                      context.showSnackBar("Veriler başarıyla yenilendi.",
                          Icons.refresh, AppColors.success);
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: AppBorderRadius.defaultBorderRadius,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "Verileri Yenile",
                            style: context.textTheme.labelLarge?.copyWith(
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        ],
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

  void _onOptionSelected(String option) {
    setState(() => selectedOption = option);
    ref
        .read(refreshIntervalProvider.notifier)
        .updateInterval(optionsMap[option]!);
  }
}
