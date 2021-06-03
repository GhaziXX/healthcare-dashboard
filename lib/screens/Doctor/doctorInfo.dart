import 'package:admin/backend/chat/chat.dart';
import 'package:admin/backend/firebase/firestore_services.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/screens/ScreenArgs.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  createRoom(types.User otherUser, BuildContext context) async {
    FirebaseChatCore.instance
        .createRoom(otherUser)
        .then((value) =>
        setState(() {
          id = value.id;
        }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createRoom(
          types.User(
              id: args.userData.otherIds[0],
              firstName: args.userData.firstName,
              lastName: args.userData.lastName),
          context);
    });
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    ScrollController _scrollController = ScrollController();
    Size _size = MediaQuery.of(context).size;
    TextEditingController _addPatient = TextEditingController();

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
                            child: args.otherData == null ?
                                Center(
                                  child: Column(
                                    children: [
                                      Text("You don't have a doctor ! Add one"),
                                      SizedBox(height: defaultPadding),
                                      TextField(
                                        controller: _addPatient,
                                        decoration: InputDecoration(
                                            fillColor: secondaryColor,
                                            hintText: "Add Doctor",
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            ),
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                FirestoreServices()
                                                    .addOtherId(
                                                    currentUserId: args.userData.id,
                                                    otherID: _addPatient.text.toString()
                                                );
                                                setState(() {
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(defaultPadding * 0.5),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: defaultPadding / 2,
                                                    vertical: defaultPadding / 2),
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                  const BorderRadius.all(Radius.circular(10)),
                                                ),
                                                child: Icon(Icons.add),
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                )
                                :
                            Container(
                              child: Column(
                                children: [
                                  SizedBox(height: _size.height * 0.1),
                                  if (Responsive.isMobile(context)) CircleAvatar(
                                    radius: 70.0,
                                    backgroundImage: FirebaseAuth.instance.currentUser.photoURL!=null?
                                    NetworkImage(FirebaseAuth.instance.currentUser.photoURL):
                                    AssetImage("asests/images/user.png"),
                                  ),
                                  if (Responsive.isMobile(context)) SizedBox(height: defaultPadding*2),
                                  if (Responsive.isMobile(context)) Text(
                                      args.otherData.firstName + ' ' + args.otherData.lastName,
                                      style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 30)
                                  ),
                                  if (Responsive.isMobile(context)) SizedBox(height: defaultPadding*2),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment: Responsive.isMobile(context) ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                                      children: [
                                        if (!Responsive.isMobile(context)) CircleAvatar(
                                          radius: 70.0,
                                          backgroundImage: FirebaseAuth.instance.currentUser.photoURL!=null?
                                          NetworkImage(FirebaseAuth.instance.currentUser.photoURL):
                                          AssetImage("asests/images/user.png"),
                                        ),
                                        if (!Responsive.isMobile(context)) SizedBox(width: 3 * defaultPadding),
                                        Column(
                                          children: [
                                            Info(userData: args.otherData),
                                            SizedBox(height: defaultPadding),
                                          ],
                                        ),
                                        Spacer(),
                                        if (args.userData.otherIds != null && !Responsive.isMobile(context))
                                          SizedBox(
                                              height: 400,
                                              width: Responsive.isMobile(context) ? _size.width*0.8 : 400,
                                              child: ChatRoom(
                                                roomId: id,
                                              )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: defaultPadding,),
                                  if (args.userData.otherIds != null && Responsive.isMobile(context))
                                    Column(
                                      crossAxisAlignment : CrossAxisAlignment.start,
                                      children: [
                                        Text("Talk with your Patient", style: Theme.of(context).textTheme.subtitle1),
                                        SizedBox(height: defaultPadding),
                                        SizedBox(
                                            height: 400,
                                            width: Responsive.isMobile(context) ? _size.width*0.8:400,
                                            child: ChatRoom(
                                              roomId: id,
                                            )),
                                      ],
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
    Key key,
  }) : super(key: key);
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!Responsive.isMobile(context)) Text(
            userData.firstName + ' ' +
                userData.lastName,
            style: Theme
                .of(context)
                .textTheme
                .headline5.copyWith(fontSize: 30)
        ),
        if (!Responsive.isMobile(context)) SizedBox(height: defaultPadding),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start,
              children: [
                Text("Age : " + userData.age),
                SizedBox(height: defaultPadding),
                Text("Address : " + userData.address),
                SizedBox(height: defaultPadding),
              ],
            ),
            SizedBox(width: defaultPadding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phone number : " + userData.phoneNumber),
                SizedBox(height: defaultPadding),
                Text("Email : " + userData.email),
                SizedBox(height: defaultPadding),
              ],
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}
