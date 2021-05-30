import 'package:admin/backend/firebase/authentification_services.dart';
import 'package:admin/backend/notifiers/auth_notifier.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import 'package:provider/provider.dart';

import 'dropdown.dart';

class Header extends StatelessWidget {
  const Header({
    @required this.isDoctor,
    @required this.userData,
    Key key,
  }) : super(key: key);
  final bool isDoctor;
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = context.watch<AuthNotifier>();
    return Container(
      color: bgColor.withOpacity(0.9),
      padding:
          EdgeInsets.only(top: defaultPadding / 2, bottom: defaultPadding / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
                splashRadius: 0.1,
                icon: Icon(Icons.menu),
                onPressed: () {
                  context
                      .findRootAncestorStateOfType<ScaffoldState>()
                      .openDrawer();
                }),
          if (!Responsive.isMobile(context))
            Text(
              "Dashboard",
              style: Theme.of(context).textTheme.headline6,
            ),
          SizedBox(
            width: 10,
          ),
          if (!Responsive.isMobile(context))
            Spacer(
              flex: Responsive.isDesktop(context) ? 2 : 1,
            ),
          if (this.isDoctor)
            Expanded(
              child: SearchField(),
            ),
          SizedBox(
            width: 10,
          ),
          CustomDropdown(
            isFullSize: Responsive.isMobile(context) ? false : true,
            headerIcon: Icons.face,
            headerIconSize: 38,
            itemIcons: [Icons.person_outline, Icons.logout],
            itemTitles: ["Profile", "Logout"],
            itemColor: [Colors.white, Colors.white],
            headerTitle: userData.firstName,
            itemCallbacks: [() => signOut(authNotifier), () => print('second')],
          )
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          fillColor: secondaryColor,
          hintText: "Search",
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(defaultPadding * 0.5),
              margin: EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Icon(Icons.search),
            ),
          )),
    );
  }
}
