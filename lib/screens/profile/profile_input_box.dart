import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileInputBox extends StatelessWidget {
  const ProfileInputBox({
    Key key,
    this.width = 400,
    this.icon,
    this.value,
    this.label,
    this.hint,
    this.expand,
  }) : super(key: key);

  final double width;
  final IconData icon;
  final TextEditingController value;
  final String label;
  final String hint;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: expand == null
          ? TextFormField(
              controller: value,
              style: TextStyle(color: Colors.white, fontSize: 8.sp),
              decoration: InputDecoration(
                fillColor: secondaryColor,
                prefixIcon: Icon(icon),
                hintText: hint,
                labelText: label,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                //filled: true
              ),
            )
          : SizedBox(
              height: 200,
              child: TextFormField(
                maxLines: 99,
                maxLength: 3000,
                keyboardType: TextInputType.multiline,
                controller: value,
                style: TextStyle(color: Colors.white, fontSize: 8.sp),
                decoration: InputDecoration(
                  fillColor: secondaryColor,
                  prefixIcon: Icon(icon),
                  hintText: hint,
                  labelText: label,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  //filled: true
                ),
              ),
            ),
    );
  }
}
