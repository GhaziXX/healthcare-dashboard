import 'package:admin/backend/chat/chat.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/backend/mqtt/mqtt_model.dart';
import 'package:admin/screens/dashboard/components/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants/constants.dart';
import '../dashboard_screen.dart';
import 'general_info_card.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class GeneralDetails extends StatefulWidget {
  const GeneralDetails({
    Key key,
    @required this.userData,
  }) : super(key: key);

  final UserData userData;

  @override
  _GeneralDetailsState createState() => _GeneralDetailsState();
}

class _GeneralDetailsState extends State<GeneralDetails> {
  //Future<types.Room> _future;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.userData.otherIds != null) {
        if (widget.userData.otherIds.length > 1)
          createRoom(
              types.User(
                  id: widget.userData.otherIds[0],
                  firstName: widget.userData.firstName,
                  lastName: widget.userData.lastName),
              context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool connected = mqttClientWrapper.connectionState ==
        MqttCurrentConnectionState.CONNECTED;
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
              SizedBox(height: defaultPadding),
              CustomDropdown(
                isFullSize: true,
                headerTitle: "Power",
                headerIcon: Icons.bolt,
                headerIconSize: 20,
                itemIcons: [Icons.power_settings_new, Icons.refresh],
                itemTitles: ["Turn off", "Reboot"],
                itemColor: [Colors.redAccent, Colors.greenAccent],
                itemCallbacks: [
                  /* mqttClientWrapper.publishMessage(topic:"Healthcare/${widget.userData.id}${widget.userData.gid}/commands",
                      command: "s" ),
                  mqttClientWrapper.publishMessage(topic:"Healthcare/${widget.userData.id}${widget.userData.gid}/commands",
                      command: "r"  ),*/
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: defaultPadding),
        if (widget.userData.otherIds != null)
          SizedBox(
              height: 400,
              child: ChatRoom(
                roomId: id,
              ))
      ],
    );
  }
}
