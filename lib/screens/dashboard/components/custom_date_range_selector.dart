import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateRangeSelector extends StatelessWidget {
  const CustomDateRangeSelector({
    Key key,
    @required this.dateRangeNotifier,
    @required this.dateController,
  }) : super(key: key);

  final ValueNotifier<DateTimeRange> dateRangeNotifier;
  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dateRangeNotifier,
        builder: (context, value, child) {
          value = null;
          return Flexible(
            child: TextField(
              controller: dateController,
              decoration: InputDecoration(
                  fillColor: secondaryColor,
                  prefixIcon: Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                  hintText: "Select custom date range",
                  hintStyle:
                      value != null ? TextStyle(color: Colors.white) : null,
                  labelText: "Custom date range",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  filled: true),
              onTap: () async {
                dateRangeNotifier.value = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  useRootNavigator: true,
                );
                if (dateRangeNotifier.value != null) {
                  value = dateRangeNotifier.value;
                  dateController.text = DateFormat.yMd().format(value.start) +
                      " - " +
                      DateFormat.yMd().format(value.end);
                }
              },
              readOnly: true,
            ),
          );
        });
  }
}