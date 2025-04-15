import 'package:flutter/material.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'tr'; // Varsayılan dil

  final Map<String, String> languages = {
    'tr': 'Türkçe',
    'en': 'English',
    'de': 'Deutsch',
    'fr': 'Français',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: AppPaddings.horizontalSimetricDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dil Ayarları',
              style: context.textTheme.headlineMedium?.copyWith(
                color: context.colorScheme.onSecondary,
              ),
            ),
            SizedBox(height: MediaQuerySize(context).percent2Height),
            Text(
              'Uygulamanın dilini seçin',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSecondary,
              ),
            ),
            SizedBox(height: MediaQuerySize(context).percent1Height),
            Container(
              decoration: BoxDecoration(
                color: context.colorScheme.onSecondary.withAlpha(10),
                borderRadius: AppBorderRadius.defaultBorderRadius,
              ),
              child: Column(
                children: languages.entries.map((entry) {
                  return RadioListTile<String>(
                    value: entry.key,
                    groupValue: _selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                    title: Text(entry.value,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onSecondary,
                        )),
                    activeColor: context.colorScheme.primary,
                  );
                }).toList(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: MediaQuerySize(context).percent7Height,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.primary,
                  foregroundColor: context.colorScheme.onPrimary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.defaultBorderRadius,
                  ),
                ),
                onPressed: () {},
                child: const Text('Kaydet'),
              ),
            ),
            SizedBox(height: MediaQuerySize(context).percent2Height),
          ],
        ),
      ),
    );
  }
}
