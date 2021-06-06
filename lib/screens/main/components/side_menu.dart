import 'package:admin/backend/firebase/authentification_services.dart';
import 'package:admin/backend/notifiers/auth_notifier.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:admin/backend/firebase/firestore_services.dart';
import '../../ScreenArgs.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
    @required this.isDoctor,
    @required this.userData,
  }) : super(key: key);

  final bool isDoctor;
  final UserData userData;
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = context.watch<AuthNotifier>();
    UserData doctorData;
    if (userData.otherIds != null && userData.otherIds.length > 0)
      FirestoreServices()
          .getUserData(uid: userData.otherIds[0])
          .then((value) => doctorData = value);
    return Drawer(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            DrawerHeader(
                child: Image.asset(
              'assets/images/healthcare.png',
            )),
            DrawerListTile(
              title: "Dashboard",
              icon: Icons.dashboard_outlined,
              press: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              usePath: false,
            ),
            if (!isDoctor)
              DrawerListTile(
                  title: "Doctor",
                  icon: FontAwesomeIcons.userMd,
                  press: () {
                    if (userData.otherIds != null &&
                        userData.otherIds.length > 0) {
                      Navigator.pushNamed(context, '/doctorInfo',
                          arguments: ScreenArguments(
                              isDoctor, userData, doctorData, null, null));
                    } else
                      Navigator.pushNamed(context, '/doctorInfo',
                          arguments: ScreenArguments(
                              isDoctor, userData, null, null, null));
                  },
                  usePath: false),
            DrawerListTile(
              title: "Report",
              icon: FontAwesomeIcons.filePrescription,
              
              press: () {},
              usePath: false,
            ),
            DrawerListTile(
              title: "Profile",
              icon: Icons.account_circle_outlined,
              press: () {
                Navigator.pushNamed(context, '/profile',
                    arguments:
                        ScreenArguments(isDoctor, userData, null, null, null));
              },
              usePath: false,
            ),
            DrawerListTile(
              title: "Logout",
              icon: Icons.logout,
              press: () {
                FirestoreServices()
                    .setConnectionStatus(
                        userId: userData.id, isConnected: false)
                    .then((value) {
                  signOut(authNotifier);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                });
              },
              usePath: false,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key key,
    @required this.title,
    this.svgSrc,
    this.icon,
    @required this.press,
    @required this.usePath,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool usePath;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: usePath
          ? SvgPicture.asset(
              svgSrc,
              color: Colors.white54,
              height: 16,
            )
          : Icon(
              icon,
              color: Colors.white54,
              size: 16,
            ),
      title: Text(title, style: TextStyle(color: Colors.white54)),
    );
  }
}
