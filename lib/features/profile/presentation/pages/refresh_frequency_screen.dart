import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';

class RefreshFrequencyScreen extends StatefulWidget {
  const RefreshFrequencyScreen({super.key});

  @override
  State<RefreshFrequencyScreen> createState() => _RefreshFrequencyScreenState();
}

class _RefreshFrequencyScreenState extends State<RefreshFrequencyScreen> {
  String selectedOption = '1 Dakika';

  final List<String> refreshOptions = [
    'Anlık (5 saniye)',
    '30 Saniye',
    '1 Dakika',
    '5 Dakika',
    'Yalnızca Manuel',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final color = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Yenileme Sıklığı"),
        scrolledUnderElevation: 0,
      ),
      body: ListView.builder(
        padding: AppPaddings.allDefaultPadding,
        itemCount: refreshOptions.length,
        itemBuilder: (context, index) {
          final option = refreshOptions[index];
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
                onChanged: (val) => setState(() => selectedOption = val!),
              ),
              onTap: () => setState(() => selectedOption = option),
            ),
          );
        },
      ),
    );
  }
}
