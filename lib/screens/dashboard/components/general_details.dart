import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/screens/dashboard/components/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants/constants.dart';
import '../dashboard_screen.dart';
import 'general_info_card.dart';

class GeneralDetails extends StatefulWidget {
  const GeneralDetails({
    Key key,
    @required this.userData,
    @required this.connected
  }) : super(key: key);

  final UserData userData;
  final bool connected;

  @override
  _GeneralDetailsState createState() => _GeneralDetailsState();
}

class _GeneralDetailsState extends State<GeneralDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                details: widget.connected ? "Connected" : "Disconnected",
                icon: widget.connected
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                color: widget.connected ? Colors.green : Colors.red,
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
      ],
    );
  }
}
