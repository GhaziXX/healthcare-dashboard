import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({
    Key key,
    @required this.press,
  }) : super(key: key);

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(defaultPadding * 0.5),
        margin: EdgeInsets.symmetric(
            horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Icon(Icons.clear_all),
      ),
    );
  }
}
