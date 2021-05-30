import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key key,
    @required this.isDoctor,
    @required this.userData,
  }) : super(key: key);

  final bool isDoctor;
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        userData: userData,
        isDoctor: isDoctor,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(
                  isDoctor: isDoctor,
                  userData: userData,
                ),
              ),
            Expanded(
              flex: 5,
              child: DashboardScreen(
                isDoctor: isDoctor,
                userData: userData,
              ),
            )
          ],
        ),
      ),
    );
  }
}
