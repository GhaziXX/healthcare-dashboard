import 'package:admin/constants/constants.dart';
import 'package:admin/models/graphs/ecg_graph.dart';
import 'package:admin/mqtt/mqtt_model.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../responsive.dart';

class ECGScreen extends StatefulWidget {
  @override
  const ECGScreen({
    Key key,
    @required this.isDoctor,
  }) : super(key: key);
  final bool isDoctor;

  _ECGScreenState createState() => _ECGScreenState();
}

class _ECGScreenState extends State<ECGScreen> {

  @override
  void initState() {
    super.initState();
  }

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
                child: Column(
                  children: [
                    Header(isDoctor: widget.isDoctor,),
                    SizedBox(height: _size.height*0.1 ,),
                    SingleChildScrollView(
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Text(
                                      "ECG Graph",
                                      style: Theme.of(context).textTheme.headline5
                                  ),
                                  SizedBox(
                                    height: _size.height * 0.05,
                                  ),
                                  mqttClientWrapper.connectionState ==
                                      MqttCurrentConnectionState.CONNECTED
                                      ? ECGGraph(
                                    ecg : data != null ? data["ecg"] : [],
                                  )
                                      : ECGGraph(
                                    ecg :[]
                                  ),
                                ],
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
      ),
    );
  }
}
