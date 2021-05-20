import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'package:admin/constants/constants.dart';

import 'clear_button.dart';
import 'custom_date_range_selector.dart';
import 'custom_time_range_selector.dart';
import 'month_dropdown.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Report",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        ),
      ],
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
    if (!Responsive.isMobile(context))
      return Row(
        children: [
          MonthDropdown(),
          SizedBox(
            width: defaultPadding,
          ),
          CustomDateRangeSelector(
              dateRangeNotifier: dateRangeNotifier,
              dateController: dateController),
          SizedBox(
            width: defaultPadding,
          ),
          CustomTimeRangeSelector(
              timeRangeNotifier: timeRangeNotifier,
              timeController: timeController),
          SizedBox(
            width: defaultPadding / 2,
          ),
          ClearButton(
            press: () {
              timeController.clear();
              dateController.clear();
            },
          ),
        ],
      );
    if (Responsive.isMobile(context))
      return Column(children: [
        Row(
          children: [
            MonthDropdown(),
            SizedBox(
              width: defaultPadding,
            ),
            CustomDateRangeSelector(
                dateRangeNotifier: dateRangeNotifier,
                dateController: dateController),
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Row(
          children: [
            CustomTimeRangeSelector(
                timeRangeNotifier: timeRangeNotifier,
                timeController: timeController),
            SizedBox(
              width: defaultPadding,
            ),
            ClearButton(
              press: () {
                timeController.clear();
                dateController.clear();
              },
            ),
          ],
        )
      ]);
  }
}
