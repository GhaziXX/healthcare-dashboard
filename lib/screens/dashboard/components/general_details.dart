import 'package:admin/backend/chat/chat.dart';
import 'package:admin/backend/mqtt/mqtt_model.dart';
import 'package:admin/backend/mqtt/mqtt_wrapper.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/responsive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import '../../../constants/constants.dart';
import '../dashboard_screen.dart';
import 'general_info_card.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class GeneralDetails extends StatefulWidget {
  const GeneralDetails({
    Key key,
    @required this.userData,
    this.state,
    @required this.state2,
  }) : super(key: key);

  final UserData userData;
  final MqttCurrentConnectionState state;
  final MqttGettingDataState state2;

  @override
  _GeneralDetailsState createState() => _GeneralDetailsState();
}

class _GeneralDetailsState extends State<GeneralDetails> {
  String id;

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
    if (widget.userData.otherIds != null) if (widget
        .userData.otherIds.isNotEmpty)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        createRoom(
            types.User(
                id: widget.userData.otherIds[0],
                firstName: widget.userData.firstName,
                lastName: widget.userData.lastName),
            context);
      });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    //bool connected = widget.state == MqttCurrentConnectionState.CONNECTED;
    bool connected = widget.state2 == MqttGettingDataState.GETTING;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gadget",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              bottom: defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GeneralInfoCard(
                title: "Connection",
                details: connected ? "Connected" : "Disconnected",
                icon: connected
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                color: connected ? Colors.green : Colors.red,
              ),
              GeneralInfoCard(
                  title: "Battery",
                  details: "charged",
                  icon: Icons.battery_std_rounded,
                  color: Colors.blue),
              GeneralInfoCard(
                  title: 'Temperature',
                  details: data != null
                      ? data["gadget_temperature"].toString() + " °C"
                      : "0°C",
                  icon: FontAwesomeIcons.thermometerHalf,
                  color: Colors.orangeAccent),
              //SizedBox(height: defaultPadding),
              _size.width > 1004
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: defaultPadding / 2),
                            padding: EdgeInsets.all(defaultPadding / 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(defaultPadding),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.power_settings_new),
                                SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                !Responsive.isDesktop(context)
                                    ? Text("Shutdown")
                                    : Text(
                                        "Shutdown",
                                        style: TextStyle(fontSize: 5.sp),
                                      ),
                              ],
                            ),
                          ),
                          onTap: () {
                            NDialog(
                              dialogStyle: DialogStyle(
                                  titleDivider: true, backgroundColor: bgColor),
                              title: Text("Shutdow"),
                              content: Text(
                                "Are you sure?",
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  label: Text("Cancel"),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      MQTTWrapper(
                                              onConnectedCallback: () {},
                                              onDataReceivedCallback: (_) {},
                                              isPublish: true,
                                              user: "")
                                          .publishMessage(
                                        command: "s",
                                        topic:
                                            "Healthcare/${widget.userData.id}${widget.userData.gid}/commands",
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: Text("Yes"))
                              ],
                            ).show(context,
                                transitionType: DialogTransitionType.Bubble);
                          },
                        ),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: defaultPadding / 2),
                            padding: EdgeInsets.all(defaultPadding / 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(defaultPadding),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.refresh),
                                SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                !Responsive.isDesktop(context)
                                    ? Text("Reboot")
                                    : Text(
                                        "Reboot",
                                        style: TextStyle(fontSize: 5.sp),
                                      ),
                              ],
                            ),
                          ),
                          onTap: () {
                            NDialog(
                              dialogStyle: DialogStyle(
                                  titleDivider: true, backgroundColor: bgColor),
                              title: Center(child: Text("Reboot")),
                              content: Text(
                                "Are you sure?",
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  label: Text("Cancel"),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      MQTTWrapper(
                                              onConnectedCallback: () {},
                                              onDataReceivedCallback: (_) {},
                                              isPublish: true,
                                              user: "")
                                          .publishMessage(
                                        command: "r",
                                        topic:
                                            "Healthcare/${widget.userData.id}${widget.userData.gid}/commands",
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: Text("Yes"))
                              ],
                            ).show(context,
                                transitionType: DialogTransitionType.Bubble);
                          },
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: defaultPadding / 2),
                            padding: EdgeInsets.all(defaultPadding / 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(defaultPadding),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.power_settings_new),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Text("Shutdown"),
                              ],
                            ),
                          ),
                          onTap: () {
                            NDialog(
                              dialogStyle: DialogStyle(
                                  titleDivider: true, backgroundColor: bgColor),
                              title: FittedBox(child: Text("Shutdown")),
                              content: Text(
                                "Are you sure?",
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  label: Text("Cancel"),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      MQTTWrapper(
                                              onConnectedCallback: () {},
                                              onDataReceivedCallback: (_) {},
                                              isPublish: true,
                                              user: "")
                                          .publishMessage(
                                        command: "s",
                                        topic:
                                            "Healthcare/${widget.userData.id}${widget.userData.gid}/commands",
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: Text("Yes"))
                              ],
                            ).show(context,
                                transitionType: DialogTransitionType.Bubble);
                          },
                        ),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: defaultPadding / 2),
                            padding: EdgeInsets.all(defaultPadding / 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(defaultPadding),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.refresh),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                FittedBox(child: Text("Reboot")),
                              ],
                            ),
                          ),
                          onTap: () {
                            NDialog(
                              dialogStyle: DialogStyle(
                                  titleDivider: true, backgroundColor: bgColor),
                              title: Center(child: Text("Reboot")),
                              content: Text(
                                "Are you sure?",
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  label: Text("Cancel"),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      MQTTWrapper(
                                              onConnectedCallback: () {},
                                              onDataReceivedCallback: (_) {},
                                              isPublish: true,
                                              user: "")
                                          .publishMessage(
                                        command: "r",
                                        topic:
                                            "Healthcare/${widget.userData.id}${widget.userData.gid}/commands",
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: Text("Yes"))
                              ],
                            ).show(context,
                                transitionType: DialogTransitionType.Bubble);
                          },
                        ),
                      ],
                    )
            ],
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        if (Responsive.isDesktop(context) || _size.width > 850)
          SizedBox(
            height: 400,
            width: 600,
            child: ChatRoom(
              roomId: id,
            ),
          ),
      ],
    );
  }
}
