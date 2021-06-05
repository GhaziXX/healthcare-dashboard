import 'package:admin/backend/firebase/authentification_services.dart';
import 'package:admin/backend/firebase/firestore_services.dart';
import 'package:admin/backend/notifiers/auth_notifier.dart';
import 'package:admin/main.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/ScreenArgs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
              child: SearchField(
                userUID: userData.id,
                userData: userData,
              ),
            ),
          SizedBox(
            width: 10,
          ),
          CustomDropdown(
            isFullSize: Responsive.isMobile(context) ? false : true,
            headerIconSize: 38,
            itemIcons: [Icons.person_outline, Icons.logout],
            itemTitles: ["Profile", "Logout"],
            itemColor: [Colors.white, Colors.white],
            headerTitle: userData.firstName,
            itemCallbacks: [
              () => Navigator.pushNamed(context, '/profile',
                  arguments:
                      ScreenArguments(isDoctor, userData, null, null, null)),
              () {
                FirestoreServices()
                    .setConnectionStatus(
                        userId: userData.id, isConnected: false)
                    .then((value) {
                  signOut(authNotifier);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                });
              }
            ],
          )
        ],
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({
    Key key,
    @required this.userUID,
    this.userData,
  }) : super(key: key);

  final String userUID;
  final UserData userData;

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  List<UserData> list = [];

  List<UserData> getUsersData(String pattern) {
    widget.userData.otherIds.forEach((element) {
      FirestoreServices().getUserData(uid: element).then((value) {
        setState(() {
          if (!list.map((e) => e.id).toList().contains(value.id)) {
            if ((value.firstName + " " + value.lastName)
                .toLowerCase()
                .startsWith(pattern.toLowerCase())) {
              list.insert(0, value);
            } else {
              list.add(value);
            }
          }
        });
      });
    });
    list.sort(
        (a, b) => pattern.toLowerCase().compareTo(a.firstName.toLowerCase()));
    //print(list.map((e) => e.firstName));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<UserData>(
        hideOnEmpty: true,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          elevation: 0.0,
          shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
          fillColor: secondaryColor,
          hintText: "Search",
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        )),
        suggestionsCallback: (pattern) async {
          if (pattern != null && pattern.isNotEmpty) {
            return getUsersData(pattern);
          }
          return [];
        },
        itemBuilder: (BuildContext context, UserData suggestion) {
          return ListTile(
            leading: CircleAvatar(
                backgroundImage: (suggestion.photoURL != null &&
                        suggestion.photoURL.isNotEmpty)
                    ? NetworkImage(suggestion.photoURL)
                    : AssetImage("assets/images/user.png")),
            title: Text(suggestion.firstName + " " + suggestion.lastName),
            subtitle: Text(
              suggestion.id.substring(0, 4) + suggestion.gid,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.white),
            ),
          );
        },
        onSuggestionSelected: (suggestion) {
          FirestoreServices().getUserData(uid: suggestion.id).then((value) =>
              Navigator.pushNamed(context, '/patientInfo',
                  arguments: ScreenArguments(
                      true, widget.userData, value, null, null)));
        });
  }
}
