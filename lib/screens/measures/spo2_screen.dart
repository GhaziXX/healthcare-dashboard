import 'package:admin/constants/constants.dart';
import 'package:admin/models/graphs_models/spo2_gauge.dart';
import 'package:admin/backend/mqtt/mqtt_model.dart';
import 'package:admin/backend/mqtt/mqtt_wrapper.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';
import '../ScreenArgs.dart';

class SPO2Screen extends StatefulWidget {
  @override
  const SPO2Screen({
    Key key,
  }) : super(key: key);

  _SPO2ScreenState createState() => _SPO2ScreenState();
}

var data;
MQTTWrapper mqttClientWrapper;
bool shouldInit = true;
ScreenArguments args;

class _SPO2ScreenState extends State<SPO2Screen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (shouldInit) {
      args = ModalRoute.of(context).settings.arguments as ScreenArguments;
      mqttClientWrapper = MQTTWrapper(
          onDataReceivedCallback: (newDataJson) {
            if (mounted)
              setState(() {
                data = newDataJson;
              });
          },
          isPublish: false,
          onConnectedCallback: () {},
          user: "Healthcare/" + args.userData.id + args.userData.gid);
      mqttClientWrapper.prepareMqttClient();
      shouldInit = false;
    }

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
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Header(isDoctor: args.isDoctor, userData: args.userData),
                      SizedBox(
                        height: _size.height * 0.1,
                      ),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: mqttClientWrapper.connectionState ==
                                      MqttCurrentConnectionState.CONNECTED
                                  ? SPO2Radial(
                                      data != null ? data["spo2"] : 0.0)
                                  : SPO2Radial(0.0),
                            ),
                          ],
                        ),
                      ),
                    ],
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
