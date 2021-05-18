import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:intl/intl.dart';

class MonthDropdown extends StatelessWidget {
  const MonthDropdown({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
    );
  }
}
