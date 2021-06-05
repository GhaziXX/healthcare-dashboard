import 'package:admin/constants/constants.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:flutter/material.dart';

import 'profile_picture_select.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    Key key,
    this.isMobile,
    @required this.userData,
  }) : super(key: key);
  final bool isMobile;
  final UserData userData;
  @override
  Widget build(BuildContext context) {
    return !isMobile
        ? Row(
            crossAxisAlignment: userData.isDoctor
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
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
                    userData.firstName + " " + userData.lastName,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  if (!userData.isDoctor)
                    Row(
                      children: [
                        Text("Gadget ID: ",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    fontSize: 6.sp,
                                    fontWeight: FontWeight.bold)),
                        SelectableText(userData.gid,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    fontSize: 6.sp,
                                    fontWeight: FontWeight.w400)),
                      ],
                    ),
                  if (!userData.isDoctor)
                    Row(
                      children: [
                        Text(
                          "User ID: ",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 6.sp, fontWeight: FontWeight.bold),
                        ),
                        SelectableText(userData.id.substring(0, 4),
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    fontSize: 6.sp,
                                    fontWeight: FontWeight.w400)),
                      ],
                    ),
                ],
              ),
            ],
          )
        : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfilePictureSelect(
                  borderRadius: 60.0,
                  circleRadius: 45.0,
                  isMobile: true,
                ),
                SizedBox(
                  height: defaultPadding * 2,
                ),
                Text(
                  userData.firstName + " " + userData.lastName,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Gadget ID: ",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 6.sp, fontWeight: FontWeight.bold)),
                    SelectableText(userData.gid,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 6.sp, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "User ID: ",
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 6.sp, fontWeight: FontWeight.bold),
                    ),
                    SelectableText(userData.id.substring(0, 4),
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 6.sp, fontWeight: FontWeight.w400)),
                  ],
                ),
              ],
            ),
          );
  }
}
