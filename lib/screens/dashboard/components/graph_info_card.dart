import 'package:admin/models/TDLRGraph.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/ScreenArgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/constants.dart';

class GraphInfoCard extends StatelessWidget {
  const GraphInfoCard({
    @required this.info,
    @required this.isDoctor,
    @required this.userData,
    Key key,
  }) : super(key: key);

  final TDLRGraph info;
  final bool isDoctor;
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Responsive.isMobile(context)) {
          Navigator.of(context).pushNamed(info.route,
              arguments: ScreenArguments(isDoctor, userData, null, null));
        } else
          Navigator.pushNamed(context, '/all',
              arguments: ScreenArguments(isDoctor, userData, null,null));
        //Navigator.push(context, MaterialPageRoute(builder: (context) => AllinOneScreen(isDoctor: isDoctor,userData: userData,)));
      },
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(defaultPadding * 0.5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: info.color.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SvgPicture.asset(
                      info.svgSrc,
                      color: info.color,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              info.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            ProgressLine(
              color: info.color,
              percentage: info.percentage,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.currentValue} ${info.unit}",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Colors.white70),
                ),
                Text(
                  info.maxValue,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key key,
    this.color = primaryColor,
    @required this.percentage,
  }) : super(key: key);

  final Color color;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage / 100.0),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
