import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'general_info_card.dart';

class GeneralDetails extends StatelessWidget {
  const GeneralDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            "General Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          GeneralInfoCard(
            title: "Document",
            details: "1311 Files",
            icon: Icons.description,
            size: "Size",
          ),
          GeneralInfoCard(
            title: "Document",
            details: "1311 Files",
            icon: Icons.description,
            size: "Size",
          ),
          GeneralInfoCard(
            title: "Document",
            details: "1311 Files",
            icon: Icons.description,
            size: "Size",
          )
        ],
      ),
    );
  }
}
