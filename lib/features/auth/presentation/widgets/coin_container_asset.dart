import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

Widget coinContainerAsset(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: AppBorderRadius.highBorderRadius,
      color: context.colorScheme.onSurface,
    ),
    height: MediaQuerySize(context).percent20Height,
    child: Image.asset('coin'.png),
  );
}
