import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class elevatedButton extends StatelessWidget {
  const elevatedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        fixedSize: Size(MediaQuerySize(context).percent60Width,
            MediaQuerySize(context).percent6Height),
      ),
      child: const Text(TrStrings.buyingScreenButtonText),
    );
  }
}
