import 'package:admin/constants/constants.dart';
import 'package:admin/models/graphs/spo2_gauge.dart';
import 'package:admin/mqtt/mqtt_model.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:admin/main.dart';

import '../../responsive.dart';

class SPO2Screen extends StatefulWidget {
  @override
  const SPO2Screen({
    Key key,
    @required this.isDoctor,
  }) : super(key: key);
  final bool isDoctor;

  _SPO2ScreenState createState() => _SPO2ScreenState();
}


class _SPO2ScreenState extends State<SPO2Screen> {
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: SideMenu(
        isDoctor: widget.isDoctor,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(isDoctor: widget.isDoctor),
              ),

            Expanded(
              flex: 5,
              child: Padding(
                padding:  EdgeInsets.all(defaultPadding),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Header(isDoctor: widget.isDoctor,),
                      SizedBox(height: _size.height*0.1,),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Text("Oxygen Saturation",style:Theme.of(context).textTheme.headline5),
                                  SizedBox(height: _size.height*0.05,),
                                  mqttClientWrapper.connectionState ==
                                          MqttCurrentConnectionState.CONNECTED
                                      ? SPO2Radial(
                                          data != null ? data["spo2"] : 0)
                                      : SPO2Radial(
                                          0
                                        ),
                                ],
                              ),
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
