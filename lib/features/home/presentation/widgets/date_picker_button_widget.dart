import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/home/presentation/widgets/show_data_picker.dart';
import 'package:flutter/material.dart';

SizedBox datePickerButtonWidget(BuildContext context, DateTime? selectedDate,
    ValueChanged<DateTime?> onChanged) {
  return SizedBox(
    width: MediaQuerySize(context).percent80Width,
    height: MediaQuerySize(context).percent6Height,
    child: ElevatedButton(
      onPressed: () => showCustomDatePicker(context, selectedDate, onChanged),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.onError,
        foregroundColor: context.colorScheme.onPrimary,
      ),
      child: Row(
        spacing: MediaQuerySize(context).percent1Width,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_outlined),
          Text(
            selectedDate != null
                ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                : TrStrings.dataPickerText,
          ),
        ],
      ),
    ),
  );
}
