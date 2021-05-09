import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
    @required this.isDoctor,
  }) : super(key: key);

  final bool isDoctor;

  @override
  Widget build(BuildContext context) {
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
              press: () {},
              usePath: false,
            ),
            isDoctor
                ? DrawerListTile(
                    title: "Doctor",
                    svgSrc: "assets/icons/menu_doctor.svg",
                    press: () {},
                    usePath: true,
                  )
                : DrawerListTile(
                    title: "Patients",
                    svgSrc: "assets/icons/menu_patient.svg",
                    press: () {},
                    usePath: true),
            DrawerListTile(
              title: "Report",
              svgSrc: "assets/icons/menu_report.svg",
              press: () {},
              usePath: true,
            ),
            DrawerListTile(
              title: "Documents",
              icon: Icons.description_outlined,
              press: () {},
              usePath: false,
            ),
            DrawerListTile(
              title: "Notifications",
              icon: Icons.notifications_outlined,
              press: () {},
              usePath: false,
            ),
            DrawerListTile(
              title: "Profile",
              icon: Icons.account_circle_outlined,
              press: () {},
              usePath: false,
            ),
            DrawerListTile(
              title: "Settings",
              icon: Icons.settings_outlined,
              press: () {},
              usePath: false,
            ),
            DrawerListTile(
              title: "Logout",
              icon: Icons.logout,
              press: () {},
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
