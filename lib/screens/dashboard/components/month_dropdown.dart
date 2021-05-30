import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthDropdown extends StatefulWidget {
  const MonthDropdown({
    Key key,
    @required this.onClicked,
  }) : super(key: key);
  final Function(String, String, GlobalKey<FormFieldState>) onClicked;

  @override
  _MonthDropdownState createState() => _MonthDropdownState();
}

class _MonthDropdownState extends State<MonthDropdown> {
  int getDaysInMonth(int year, int month) {
    final bool isLeapYear =
        (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
    if (isLeapYear) return 29;
    return 28;
  }

  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DropdownButtonFormField(
        key: _dropdownKey,
        items: months.keys.map((item) {
          return DropdownMenuItem<String>(
            value: item.toString(),
            child: Text(item.toString()),
          );
        }).toList(),
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
        onChanged: (value) {
          final startDate =
              DateTime.now().year.toString() + '-' + months[value][0];
          String endDate =
              DateTime.now().year.toString() + '-' + months[value][1];
          if (value == "Feb") {
            endDate = DateTime.now().year.toString() +
                '-' +
                months[value][1] +
                getDaysInMonth(DateTime.now().year, 2).toString();
          }

          widget.onClicked(
            startDate,
            endDate,
            _dropdownKey,
          );
        },
      ),
    );
  }
}
