import 'package:asset_tracker/common/widgets/social_card.dart';
import 'package:flutter/material.dart';

Widget socialCardsRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SocialCard(
        icon: Image.asset(
          'assets/png/search.png',
          fit: BoxFit.cover,
        ),
        press: () {
          print("Google login");
        },
      ),
      SocialCard(
        icon: Image.asset(
          'assets/png/facebook.png',
          fit: BoxFit.cover,
        ),
        press: () {
          print("Facebook login");
        },
      ),
    ],
  );
}
