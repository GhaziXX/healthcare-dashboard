import 'package:admin/backend/chat/chat.dart';
import 'package:admin/backend/firebase/firestore_services.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/models/GraphHolder.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/screens/ScreenArgs.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/rendering.dart';
import 'package:jiffy/jiffy.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../responsive.dart';

class PatientInfo extends StatefulWidget {
  const PatientInfo({Key key}) : super(key: key);

  @override
  _PatientInfoState createState() => _PatientInfoState();
}

ScreenArguments args;

class _PatientInfoState extends State<PatientInfo> {
  String id;
  bool isConnected = false;

  createRoom(types.User otherUser, BuildContext context) async {
    FirebaseChatCore.instance
        .createRoom(otherUser)
        .then((value) => setState(() {
              id = value.id;
            }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createRoom(
          types.User(
              id: args.otherData.id,
              firstName: args.userData.firstName,
              lastName: args.userData.lastName),
          context);
    });
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    ScrollController _scrollController = ScrollController();

    FirestoreServices().isUserConnected(uid: args.otherData.id).then((value) {
      if (mounted)
        setState(() {
          isConnected = value;
        });
    });

    return Scaffold(
      drawer: SideMenu(
        isDoctor: args.isDoctor,
        userData: args.userData,
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
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(defaultPadding),
                  child: StickyHeader(
                    header: Header(
                      isDoctor: args.isDoctor,
                      userData: args.userData,
                    ),
                    content: Column(children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: Column(
                                children: [
                                  SizedBox(height: defaultPadding),
                                  Stack(
                                      //alignment: AlignmentDirectional.bottomEnd,
                                      children: [
                                        CircleAvatar(
                                          radius: 70.0,
                                          backgroundImage:
                                              args.otherData.photoURL != null
                                                  ? NetworkImage(
                                                      args.otherData.photoURL)
                                                  : AssetImage(
                                                      "assets/images/user.png"),
                                        ),
                                        Positioned(
                                          right: 10,
                                          bottom: 10,
                                          child: Icon(
                                            Icons.circle,
                                            color: isConnected
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ]),
                                  SizedBox(height: defaultPadding),
                                  Text(
                                      args.otherData.firstName +
                                          ' ' +
                                          args.otherData.lastName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(fontSize: 30)),
                                  SizedBox(height: defaultPadding * 2),
                                  Container(
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (Responsive.isMobile(context))
                                            Info(
                                                userData: args.otherData,
                                                isMobile: true),
                                          if (!Responsive.isMobile(context))
                                            Info(
                                                userData: args.otherData,
                                                isMobile: false),
                                          SizedBox(height: defaultPadding),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/patientDetails',
                                                  arguments: ScreenArguments(
                                                      args.isDoctor,
                                                      args.userData,
                                                      args.otherData,
                                                      null,
                                                      null));
                                            },
                                            icon: Icon(
                                                Icons.remove_red_eye_outlined),
                                            label: Text("Monitor"),
                                          ),
                                          SizedBox(height: defaultPadding),
                                          Text("Chat",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1),
                                          if (args.userData.otherIds != null &&
                                              Responsive.isDesktop(context))
                                            SizedBox(
                                              height: 400,
                                              width: 600,
                                              child: ChatRoom(
                                                roomId: id,
                                              ),
                                            ),
                                          if (args.userData.otherIds != null &&
                                              Responsive.isTablet(context))
                                            SizedBox(
                                              height: 400,
                                              width: 600,
                                              child: ChatRoom(
                                                roomId: id,
                                              ),
                                            ),
                                          if (args.userData.otherIds != null &&
                                              Responsive.isMobile(context))
                                            SizedBox(
                                              height: 400,
                                              width: 400,
                                              child: ChatRoom(
                                                roomId: id,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    @required this.userData,
    @required this.isMobile,
    Key key,
  }) : super(key: key);
  final UserData userData;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    TextStyle sectionNameStyle = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(fontSize: 6.sp, fontWeight: FontWeight.bold);
    TextStyle sectionValueStyle = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(fontSize: 6.sp, fontWeight: FontWeight.w400);
    ScrollController _scrollController;
    return Column(
      children: [
        GraphHolder(
          width: isMobile ? 400 : 600,
          child: Center(
              child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: MobileDetailsView(
                  sectionNameStyle: sectionNameStyle,
                  sectionValueStyle: sectionValueStyle,
                  userData: userData),
            ),
          )),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        GraphHolder(
          width: isMobile ? 400 : 600,
          child: Center(
              child: ExpandablePanel(
            header: Row(
              children: [
                Text(
                  "Age: ",
                  style: sectionNameStyle,
                ),
                Text(
                  Jiffy(userData.birthdate)
                      .fromNow()
                      .split(" ")
                      .sublist(0, 2)
                      .join(" "),
                  style: sectionValueStyle,
                )
              ],
            ),
            collapsed: Text(
              "Bio",
              softWrap: true,
            ),
            expanded: Text(
              (userData.description == null || userData.description.isEmpty)
                  ? 'No Bio available'
                  : userData.description,
              softWrap: true,
              style: sectionValueStyle,
            ),
          )),
        ),
      ],
    );
  }
}

class MobileDetailsView extends StatelessWidget {
  const MobileDetailsView({
    Key key,
    @required this.sectionNameStyle,
    @required this.sectionValueStyle,
    this.userData,
  }) : super(key: key);

  final TextStyle sectionNameStyle;
  final TextStyle sectionValueStyle;
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userData.isDoctor
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Primary phone number:",
                        style: sectionNameStyle,
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      SelectableText(
                        userData.phoneNumber,
                        style: sectionValueStyle,
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false),
                        showCursor: false,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("Home address:", style: sectionNameStyle),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      SelectableText(
                        userData.address,
                        style: sectionValueStyle,
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false),
                        showCursor: false,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("Email:", style: sectionNameStyle),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      SelectableText(
                        userData.email,
                        style: sectionValueStyle,
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false),
                        showCursor: false,
                      )
                    ],
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Primary phone number:",
                        style: sectionNameStyle,
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      SelectableText(
                        userData.phoneNumber,
                        style: sectionValueStyle,
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false),
                        showCursor: false,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("Home address:", style: sectionNameStyle),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      SelectableText(
                        userData.address,
                        style: sectionValueStyle,
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false),
                        showCursor: false,
                      )
                    ],
                  ),
                ],
              ),
        SizedBox(width: defaultPadding),
        userData.isDoctor
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Text(
                      "Office phone number:",
                      style: sectionNameStyle,
                    ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    (userData.officePhoneNumber != null &&
                            userData.officePhoneNumber.isNotEmpty)
                        ? SelectableText(
                            userData.officePhoneNumber,
                            style: sectionValueStyle,
                            toolbarOptions: ToolbarOptions(
                                copy: true,
                                selectAll: true,
                                cut: false,
                                paste: false),
                            showCursor: false,
                          )
                        : Text("Not available", style: sectionValueStyle)
                  ],
                ),
                Row(
                  children: [
                    Text("Office address:", style: sectionNameStyle),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    (userData.officeAddress != null &&
                            userData.officeAddress.isNotEmpty)
                        ? SelectableText(
                            userData.officeAddress,
                            style: sectionValueStyle,
                            toolbarOptions: ToolbarOptions(
                                copy: true,
                                selectAll: true,
                                cut: false,
                                paste: false),
                            showCursor: false,
                          )
                        : Text("Not available", style: sectionValueStyle)
                  ],
                ),
              ])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Email:", style: sectionNameStyle),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      SelectableText(
                        userData.email,
                        style: sectionValueStyle,
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false),
                        showCursor: false,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Emergency phone number:",
                        style: sectionNameStyle,
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      (userData.emergencyPhoneNumber != null &&
                              userData.emergencyPhoneNumber.isNotEmpty)
                          ? SelectableText(
                              userData.emergencyPhoneNumber,
                              style: sectionValueStyle,
                              toolbarOptions: ToolbarOptions(
                                  copy: true,
                                  selectAll: true,
                                  cut: false,
                                  paste: false),
                              showCursor: false,
                            )
                          : Text("Not available", style: sectionValueStyle)
                    ],
                  ),
                ],
              ),
      ],
    );
  }
}
