import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';

class GraphHolder extends StatelessWidget {
  final Widget child;
  final double width;

  const GraphHolder({Key key, this.child, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      width: width,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SizedBox(
        child: this.child,
      ),
    );
  }
}
