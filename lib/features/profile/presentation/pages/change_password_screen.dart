import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPaddings.horizontalSimetricDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Şifre Değiştir',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: context.colorScheme.onSecondary,
                  )),
              SizedBox(height: MediaQuerySize(context).percent5Height),
              accountInfoTextFormField(
                  context, 'Mevcut Şifre', 'Mevcut Şifrenizi Giriniz'),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              accountInfoTextFormField(
                  context, 'Yeni Şifre', 'Yeni Şifrenizi Girin'),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              accountInfoTextFormField(context, 'Yeni Şifre (Tekrar)',
                  'Yeni Şifrenizi tekrar girin'),
              SizedBox(
                height: MediaQuerySize(context).percent4Height,
              ),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Container accountInfoTextFormField(
      BuildContext context, String labelText, String hintText) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onSecondary.withAlpha(10),
        borderRadius: AppBorderRadius.defaultBorderRadius,
      ),
      child: Padding(
        padding: AppPaddings.allLowPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  labelText,
                  style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSecondary,
                      fontWeight: FontWeight.w500),
                )),
            TextFormField(
              initialValue: hintText,
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.visibility_off),
                  hintText: 'Adınızı girin',
                  border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }
}
