import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/constants.dart';
import '../../ScreenArgs.dart';

class RealtimeGraphs extends StatelessWidget {
  const RealtimeGraphs({
    @required this.isDoctor,
    @required this.userData,
    Key key,
  }) : super(key: key);
  final bool isDoctor;
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Realtime Graphs",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Responsive(
          mobile: RealtimeGraphGridView(
            childAspectRatio: 3.5,
            isDoctor: isDoctor,
            userData: userData,
          ),
          tablet: RealtimeGraphGridView(
            childAspectRatio: 3,
            isDoctor: isDoctor,
            userData: userData,
          ),
          desktop: RealtimeGraphGridView(
            childAspectRatio: 4,
            isDoctor: isDoctor,
            userData: userData,
          ),
        ),
      ],
    );
  }
}

class RealtimeGraphGridView extends StatelessWidget {
  final double childAspectRatio;
  const RealtimeGraphGridView(
      {Key key,
      this.childAspectRatio,
      @required this.isDoctor,
      @required this.userData,
      this.data})
      : super(key: key);
  final bool isDoctor;
  final UserData userData;
  final data;

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: this.childAspectRatio),
      children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/ECG',
                  arguments: ScreenArguments(isDoctor, userData));
            },
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(defaultPadding * 0.5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/ecg.svg",
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FittedBox(
                    child: Container(
                      child: Text(
                        "ECG",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/tempGraph',
                  arguments: ScreenArguments(isDoctor, userData));
            },
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(defaultPadding * 0.5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/temperature.svg",
                      color: Colors.yellowAccent,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: FittedBox(
                      child: Text(
                        "Temperature",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
