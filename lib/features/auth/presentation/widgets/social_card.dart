import 'package:asset_tracker/common/widgets/social_card.dart';
import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
import 'package:flutter/material.dart';

Widget socialCardsRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SocialCard(
        icon: Image.asset(
          'search'.png,
          fit: BoxFit.cover,
        ),
        press: () {
          print("Google login");
        },
      ),
      SocialCard(
        icon: Image.asset(
          'facebook'.png,
          fit: BoxFit.cover,
        ),
        press: () {
          print("Facebook login");
        },
      ),
    ],
  );
}
