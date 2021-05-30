import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class GeneralInfoCard extends StatelessWidget {
  const GeneralInfoCard(
      {Key key,
      @required this.title,
      @required this.details,
      @required this.icon,
      @required this.color})
      : super(key: key);

  final String title, details;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding / 2),
      padding: EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
          borderRadius:
              const BorderRadius.all(Radius.circular(defaultPadding))),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Icon(
              icon,
              color: color,
            ),
          ),
          SizedBox(width: defaultPadding),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  details,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Colors.white70),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
