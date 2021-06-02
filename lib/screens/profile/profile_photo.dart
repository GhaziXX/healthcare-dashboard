import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';

import 'profile_picture_select.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    Key key,
    this.isMobile,
  }) : super(key: key);
  final bool isMobile;
  @override
  Widget build(BuildContext context) {
    return !isMobile
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfilePictureSelect(
                isMobile: false,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile Photo",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    "Here is where you can change\nyour awesome photo",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontSize: 12),
                    softWrap: true,
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: Column(
              ///crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfilePictureSelect(
                  borderRadius: 60.0,
                  circleRadius: 45.0,
                  isMobile: true,
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  "Here is where you can change\nyour awesome photo",
                  style: Theme.of(context).textTheme.overline,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
  }
}
