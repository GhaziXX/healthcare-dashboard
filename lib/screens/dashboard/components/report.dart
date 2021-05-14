import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:admin/constants/constants.dart';

class Report extends StatelessWidget {
  const Report({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<DateTimeRange> _dateRangeNotifier = ValueNotifier(
        DateTimeRange(start: DateTime.now(), end: DateTime.now()));
    ValueNotifier<TimeRange> _timeRangeNotifier = ValueNotifier(
        TimeRange(startTime: TimeOfDay.now(), endTime: TimeOfDay.now()));

    TextEditingController _timeController = TextEditingController();
    TextEditingController _dateController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Report",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Filter(
                    dateRangeNotifier: _dateRangeNotifier,
                    timeRangeNotifier: _timeRangeNotifier,
                    timeController: _timeController,
                    dateController: _dateController,
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class Filter extends StatelessWidget {
  const Filter({
    Key key,
    @required this.dateRangeNotifier,
    @required this.timeRangeNotifier,
    @required this.timeController,
    @required this.dateController,
  }) : super(key: key);

  final ValueNotifier<DateTimeRange> dateRangeNotifier;
  final ValueNotifier<TimeRange> timeRangeNotifier;
  final TextEditingController timeController;
  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: FastDropdown(
            id: "range",
            decoration: InputDecoration(
                fillColor: secondaryColor,
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                hintText: DateFormat.MMMM().format(DateTime.now()),
                labelText: "Month",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                filled: true),
            items: months,
            label: "Period",
            contentPadding: EdgeInsets.all(defaultPadding),
          ),
        ),
        SizedBox(
          width: defaultPadding,
        ),
        ValueListenableBuilder(
            valueListenable: dateRangeNotifier,
            builder: (context, value, child) {
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
                      // If i ever wanted to crop the view
                      // builder: (context, child) {
                      //   return Center(
                      //     child: Card(
                      //       elevation: 4,
                      //       child: Container(
                      //         width: 80.w,
                      //         height: 80.w,
                      //         child: child,
                      //       ),
                      //     ),
                      //   );
                      // },
                    );
                    if (value != null) {
                      dateController.text =
                          DateFormat.yMd().format(value.start) +
                              " - " +
                              DateFormat.yMd().format(value.end);
                    }
                  },
                  readOnly: true,
                ),
              );
            }),
        SizedBox(
          width: defaultPadding,
        ),
        ValueListenableBuilder(
            valueListenable: timeRangeNotifier,
            builder: (context, value, child) {
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
                      hideButtons: true,
                    );
                    if (value != null) {
                      timeController.text = value.startTime.format(context) +
                          " - " +
                          value.endTime.format(context);
                    }
                  },
                  readOnly: true,
                ),
              );
            }),
      ],
    );
  }
}
