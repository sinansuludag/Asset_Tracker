import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/buying_asset/presentation/widgets/show_data_picker.dart';
import 'package:flutter/material.dart';

SizedBox datePickerButtonWidget(BuildContext context, DateTime? selectedDate,
    ValueChanged<DateTime?> onChanged) {
  return SizedBox(
    width: MediaQuerySize(context).percent80Width,
    child: ElevatedButton(
      onPressed: () => showCustomDatePicker(context, selectedDate, onChanged),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.onError.withAlpha(75),
        foregroundColor: context.colorScheme.onPrimary,
      ),
      child: Text(
        selectedDate != null
            ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
            : TrStrings.dataPickerText,
      ),
    ),
  );
}
