import 'package:admin/screens/main/components/side_menu.dart';
import 'package:admin/screens/profile/patient_profile.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';
import '../ScreenArgs.dart';

import 'doctor_profile.dart';
ScreenArguments args;
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
              Flexible(
                child: SideMenu(
                  isDoctor: args.isDoctor,
                  userData: args.userData,
                ),
              ),
            Flexible(
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
