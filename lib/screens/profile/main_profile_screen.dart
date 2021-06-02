import 'package:admin/constants/constants.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:flutter/material.dart';

import 'profile_info.dart';
import 'profile_photo.dart';

class MainProfileScreen extends StatelessWidget {
  const MainProfileScreen(
      {Key key,
      this.isMobile,
      this.controllers,
      this.labels,
      this.hints,
      this.icons,
      @required this.userData})
      : super(key: key);

  final bool isMobile;
  final controllers;
  final labels;
  final hints;
  final icons;
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile)
          Text("Edit Profile",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.left),
        if (!isMobile)
          Text(
            "You can edit your profile here",
            style: Theme.of(context).textTheme.subtitle2,
            textAlign: TextAlign.left,
          ),
        if (!isMobile)
          SizedBox(
            height: defaultPadding * 2,
          ),
        if (!isMobile)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfilePhoto(
                isMobile: false,
              ),
              SizedBox(width: 7 * defaultPadding),
              ProfileInfo(
                controllers: controllers,
                labels: labels,
                hints: hints,
                icons: icons,
                isMobile: false,
                userData: userData,
              ),
            ],
          ),
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfilePhoto(
                isMobile: true,
              ),
              SizedBox(width: 7 * defaultPadding),
              ProfileInfo(
                controllers: controllers,
                labels: labels,
                hints: hints,
                icons: icons,
                isMobile: true,
                userData: userData,
              ),
            ],
          )
      ],
    );
  }
}
