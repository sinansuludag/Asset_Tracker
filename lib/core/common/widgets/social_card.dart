import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/sizes/app_icon_size.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: AppPaddings.allDefaultPadding,
        height: AppIconSize.socialIconsSize,
        width: AppIconSize.socialIconsSize,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}
