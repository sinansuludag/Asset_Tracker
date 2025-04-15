import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

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
              Text('Hesap Bilgileri',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: context.colorScheme.onSecondary,
                  )),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              Center(
                child: Hero(
                  tag: 'AccountInfo',
                  child: Container(
                    width: MediaQuerySize(context).percent35Width,
                    height: MediaQuerySize(context).percent35Width,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'defaultUser'.png,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent3Height),
              accountInfoTextFormField(context, 'Kullanıcı Adı', 'Sinan'),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              accountInfoTextFormField(
                  context, 'E-posta', 'sinan.sldg@gmail.com'),
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
                    shape: RoundedRectangleBorder(
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
                  hintText: 'Adınızı girin', border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }
}
