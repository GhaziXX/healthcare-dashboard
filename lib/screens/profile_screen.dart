import 'package:admin/constants/constants.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../responsive.dart';
import 'ScreenArgs.dart';
import 'dashboard/components/header.dart';
import 'measures/all_in_one.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    return Scaffold(
      drawer: SideMenu(
        userData: args.userData,
        isDoctor: args.isDoctor,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(
                  isDoctor: args.isDoctor,
                  userData: args.userData,
                ),
              ),
            Expanded(
                flex: 5,
                child: args.isDoctor
                    ? DoctorProfile(
                        userData: args.userData,
                      )
                    : PatientProfile(
                        userData: args.userData,
                      ))
          ],
        ),
      ),
    );
  }
}

class DoctorProfile extends StatelessWidget {
  const DoctorProfile({
    Key key,
    @required this.userData,
  }) : super(key: key);
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return SafeArea(
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(defaultPadding),
            child: StickyHeader(
                header: Header(
                  isDoctor: true,
                  userData: userData,
                ),
              content: Column(),
                ))));
  }
}

class PatientProfile extends StatelessWidget {
  const PatientProfile({
    Key key,
    @required this.userData,
  }) : super(key: key);
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return SafeArea(
        child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(defaultPadding),
              child: StickyHeader(
                header: Header(
                  isDoctor: false,
                  userData: userData,
                ),
                content: Column(
                ),
              ),
            )));
  }
}

