import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

class CustomTimeRangeSelector extends StatelessWidget {
  const CustomTimeRangeSelector({
    Key key,
    @required this.timeRangeNotifier,
    @required this.timeController,
    @required this.onClicked,
  }) : super(key: key);

  final ValueNotifier<TimeRange> timeRangeNotifier;
  final TextEditingController timeController;
  final Function(String, String) onClicked;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: timeRangeNotifier,
        builder: (context, value, child) {
          value = null;
          return Flexible(
            child: TextField(
              controller: timeController,
              decoration: InputDecoration(
                  fillColor: secondaryColor,
                  prefixIcon: Icon(
                    Icons.timeline,
                    color: Colors.white,
                  ),
                  hintText: "Select custom time range",
                  hintStyle:
                      value != null ? TextStyle(color: Colors.white) : null,
                  labelText: "Custom time range",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  filled: true),
              onTap: () async {
                timeRangeNotifier.value = await showTimeRangePicker(
                  context: context,
                  start: TimeOfDay.now(),
                  interval: Duration(minutes: 5),
                  use24HourFormat: false,
                  padding: 50,
                  strokeWidth: 10,
                  handlerRadius: 10,
                  strokeColor: primaryColor,
                  handlerColor: primaryColor.withAlpha(150),
                  selectedColor: primaryColor,
                  ticks: 24,
                  ticksColor: Colors.white,
                  snap: false,
                  labels: [
                    "12 PM",
                    "3 AM",
                    "6 AM",
                    "9 AM",
                    "12 AM",
                    "3 PM",
                    "6 PM",
                    "9 PM"
                  ].asMap().entries.map((e) {
                    return ClockLabel.fromIndex(
                        idx: e.key, length: 8, text: e.value);
                  }).toList(),
                  labelOffset: -30,
                  hideButtons: false,
                  builder: (context, child) {
                    return Center(
                      child: Card(
                        elevation: 4,
                        child: Container(
                          child: child,
                        ),
                      ),
                    );
                  },
                );
                if (timeRangeNotifier.value != null) {
                  value = timeRangeNotifier.value;

                  timeController.text = value.startTime.format(context) +
                      " - " +
                      value.endTime.format(context);
                  final first = timeController.text.split("-")[0].trim();
                  final second = timeController.text.split("-")[1].trim();
                  onClicked(
                      DateFormat("HH:mm:ss:S")
                          .format(DateFormat.jm().parse(first)),
                      DateFormat("HH:mm:ss:S")
                          .format(DateFormat.jm().parse(second)));
                }
              },
              readOnly: true,
            ),
          );
        });
  }
}
