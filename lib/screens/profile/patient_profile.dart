import 'package:admin/constants/constants.dart';
import 'package:admin/main.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../responsive.dart';
import 'main_profile_screen.dart';

class PatientProfile extends StatelessWidget {
  const PatientProfile({
    Key key,
    @required this.userData,
  }) : super(key: key);
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.badge,
      Icons.badge,
      Icons.email,
      Icons.phone,
      Icons.phone,
      Icons.place,
      Icons.description,
    ];
    List<TextEditingController> controllers = [
      TextEditingController(text: userData.firstName),
      TextEditingController(text: userData.lastName),
      TextEditingController(text: userData.email),
      TextEditingController(text: userData.phoneNumber),
      TextEditingController(text: userData.emergencyPhoneNumber),
      TextEditingController(text: userData.address),
      TextEditingController(text: userData.description),
    ];
    List<String> labels = [
      "First name",
      "Last name",
      "Email",
      "Primarly phone number",
      "Emergency Phone number",
      "Home address",
      "Biography",
    ];
    List<String> hints = [
      "Enter your first name",
      "Enter your last name",
      "Enter your new email",
      "Enter your primarly phone number",
      "Enter your emergency phone number",
      "Enter your home address",
      "Enter your detailed bio\n(If you have any illnesses,Special needs...etc)",
    ];

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
              isDoctor: userData.isDoctor,
              userData: userData,
            ),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: defaultPadding,
                ),
                Responsive(
                    mobile: MainProfileScreen(
                      isMobile: true,
                      controllers: controllers,
                      labels: labels,
                      hints: hints,
                      icons: icons,
                      userData: userData,
                    ),
                    desktop: MainProfileScreen(
                      isMobile: false,
                      controllers: controllers,
                      labels: labels,
                      hints: hints,
                      icons: icons,
                      userData: userData,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
