import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void showCustomDatePicker(BuildContext context, DateTime? selectedDate,
    ValueChanged<DateTime?> onChanged) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(TrStrings.showDialogTitleText),
        backgroundColor: context.colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius:
              AppBorderRadius.defaultBorderRadius, // Dialog köşeleri yuvarlak
        ),
        content: SizedBox(
          height: MediaQuerySize(context).percent40Height,
          width: MediaQuerySize(context).percent70Width,
          child: ClipRRect(
            borderRadius: AppBorderRadius.defaultBorderRadius,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  onChanged(args.value);
                }
              },
              selectionMode: DateRangePickerSelectionMode.single,
              maxDate: DateTime.now(),
              selectionColor: context.colorScheme.primary,
              todayHighlightColor: context.colorScheme.primary,
              backgroundColor: context.colorScheme.secondary.withAlpha(50),
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: context.colorScheme.secondary.withAlpha(50),
                textStyle: context.textTheme.bodySmall
                    ?.copyWith(color: context.colorScheme.onSecondary),
              ),
              selectionShape: DateRangePickerSelectionShape.circle,
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle: TextStyle(
                    color: context.colorScheme.onSecondary), // Günlerin rengi
                todayTextStyle: TextStyle(color: context.colorScheme.primary),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(TrStrings.showDialogButtonText),
          ),
        ],
      );
    },
  );
}
