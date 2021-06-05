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
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../responsive.dart';

class DoctorInfo extends StatefulWidget {
  const DoctorInfo({Key key}) : super(key: key);

  @override
  _DoctorInfoState createState() => _DoctorInfoState();
}

ScreenArguments args;

class _DoctorInfoState extends State<DoctorInfo> {
  String id;
  bool isConnected = false;
  bool updated;
  TextEditingController _addPatient = TextEditingController();
  Future _future1;

  createRoom(types.User otherUser, BuildContext context) async {
    FirebaseChatCore.instance
        .createRoom(otherUser)
        .then((value) => setState(() {
              id = value.id;
              print("id is $id");
            }));
  }

  @override
  void initState() {
    super.initState();
    //args = ModalRoute.of(context).settings.arguments as ScreenArguments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (args.otherData != null) {
        print("otherDataId: ${args.otherData.id}");
        createRoom(
            types.User(
                id: args.otherData.id,
                firstName: args.userData.firstName,
                lastName: args.userData.lastName),
            context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    _future1 = FirestoreServices().getUserData(uid: args.userData.id);

    ScrollController _scrollController = ScrollController();
    Size _size = MediaQuery.of(context).size;

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
                              child: FutureBuilder<UserData>(
                                future: _future1,
                                builder: (context, snapshot) {
                                  print("data ${snapshot.data}");
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Container(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    print("here");
                                    return Center(
                                      child: Column(
                                        children: [
                                          Text(
                                              "You don't have a doctor ! Add one"),
                                          SizedBox(height: defaultPadding),
                                          TextField(
                                            controller: _addPatient,
                                            decoration: InputDecoration(
                                                fillColor: secondaryColor,
                                                hintText: "Add Doctor",
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                suffixIcon: InkWell(
                                                  onTap: () {
                                                    FirestoreServices()
                                                        .addOtherId(
                                                            currentUserId: args
                                                                .userData.id,
                                                            otherID: _addPatient
                                                                .text
                                                                .toString())
                                                        .then((value) =>
                                                            setState(() {
                                                              updated = value;
                                                            }));
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        defaultPadding * 0.5),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                defaultPadding /
                                                                    2,
                                                            vertical:
                                                                defaultPadding /
                                                                    2),
                                                    decoration: BoxDecoration(
                                                      color: primaryColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: Icon(Icons.add),
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    print('snapshot ${snapshot.data.otherIds}');
                                    if (snapshot.data.otherIds.isNotEmpty) {
                                      return FutureBuilder<UserData>(
                                          future: FirestoreServices()
                                              .getUserData(
                                                  uid: snapshot
                                                      .data.otherIds[0]),
                                          builder: (context, snapshot1) {
                                            if (snapshot1.hasData) {
                                              print("behiiiiii");
                                              return Container(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                        height: defaultPadding),
                                                    Stack(children: [
                                                      CircleAvatar(
                                                        radius: 70.0,
                                                        backgroundImage: snapshot1
                                                                    .data
                                                                    .photoURL !=
                                                                null
                                                            ? NetworkImage(
                                                                snapshot1.data
                                                                    .photoURL)
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
                                                    SizedBox(
                                                        height: defaultPadding),
                                                    Text(
                                                        snapshot1.data
                                                                .firstName +
                                                            ' ' +
                                                            snapshot1
                                                                .data.lastName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
                                                            .copyWith(
                                                                fontSize: 30)),
                                                    SizedBox(
                                                        height:
                                                            defaultPadding / 4),
                                                    Text(
                                                        snapshot1
                                                            .data.speciality,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
                                                            .copyWith(
                                                                fontSize: 20)),
                                                    SizedBox(
                                                        height:
                                                            defaultPadding * 2),
                                                    Container(
                                                      child: Center(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            if (Responsive
                                                                .isMobile(
                                                                    context))
                                                              Info(
                                                                  userData:
                                                                      snapshot1
                                                                          .data,
                                                                  isMobile:
                                                                      true),
                                                            if (!Responsive
                                                                .isMobile(
                                                                    context))
                                                              Info(
                                                                  userData:
                                                                      snapshot1
                                                                          .data,
                                                                  isMobile:
                                                                      false),
                                                            SizedBox(
                                                                height:
                                                                    defaultPadding),
                                                            Text("Chat",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1),
                                                            if (Responsive
                                                                .isDesktop(
                                                                    context))
                                                              SizedBox(
                                                                height: 400,
                                                                width: 600,
                                                                child: ChatRoom(
                                                                  roomId: id,
                                                                ),
                                                              ),
                                                            if (Responsive
                                                                .isTablet(
                                                                    context))
                                                              SizedBox(
                                                                height: 400,
                                                                width: 600,
                                                                child: ChatRoom(
                                                                  roomId: id,
                                                                ),
                                                              ),
                                                            if (Responsive
                                                                .isMobile(
                                                                    context))
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
                                              );
                                            }

                                            return Center(
                                                child: Container(
                                                    child:
                                                        CircularProgressIndicator()));
                                          });
                                    } else {
                                      return Center(
                                        child: Column(
                                          children: [
                                            Text(
                                                "You don't have a doctor ! Add one"),
                                            SizedBox(height: defaultPadding),
                                            TextField(
                                              controller: _addPatient,
                                              decoration: InputDecoration(
                                                  fillColor: secondaryColor,
                                                  hintText: "Add Doctor",
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  suffixIcon: InkWell(
                                                    onTap: () {
                                                      FirestoreServices()
                                                          .addOtherId(
                                                              currentUserId:
                                                                  args.userData
                                                                      .id,
                                                              otherID: _addPatient
                                                                  .text
                                                                  .toString())
                                                          .then((value) =>
                                                              setState(() {
                                                                updated = value;
                                                              }));
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          defaultPadding * 0.5),
                                                      margin: EdgeInsets.symmetric(
                                                          horizontal:
                                                              defaultPadding /
                                                                  2,
                                                          vertical:
                                                              defaultPadding /
                                                                  2),
                                                      decoration: BoxDecoration(
                                                        color: primaryColor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: Icon(Icons.add),
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                  return Center(
                                      child: Container(
                                          child: CircularProgressIndicator()));
                                },
                              )),
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
    return Column(
      children: [
        GraphHolder(
          width: isMobile ? 400 : 600,
          child: Center(
              child: Scrollbar(
            child: SingleChildScrollView(
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
            header: Text(
              "Show doctor Bio",
              style: sectionNameStyle,
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
        Column(
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
                      copy: true, selectAll: true, cut: false, paste: false),
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
                      copy: true, selectAll: true, cut: false, paste: false),
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
                      copy: true, selectAll: true, cut: false, paste: false),
                  showCursor: false,
                )
              ],
            )
          ],
        ),
        SizedBox(width: defaultPadding),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        ]),
      ],
    );
  }
}
