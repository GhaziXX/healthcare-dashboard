import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import 'general_info_card.dart';

class GeneralDetails extends StatelessWidget {
  const GeneralDetails({
    this.connected,
    Key key,
  }) : super(key: key);
  final bool connected;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gadget Status",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: defaultPadding,),
        Container(
          padding: EdgeInsets.only(left: defaultPadding,right: defaultPadding,bottom: defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GeneralInfoCard(
                title: "Connection",
                details: connected ? "Connected": "Disconnected",
                icon: connected ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: connected ? Colors.green : Colors.red,
              ),
              GeneralInfoCard(
                title: "Battery",
                details: "charged",
                icon: Icons.battery_std_rounded,
                color : Colors.blue
              ),
            ],
          ),
        ),
      ],
    );
  }
}
