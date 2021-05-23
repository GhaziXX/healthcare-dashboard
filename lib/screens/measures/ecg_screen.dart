import 'package:admin/constants/constants.dart';
import 'package:admin/models/graphs/ecg_graph.dart';
import 'package:admin/mqtt/mqtt_model.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';
import '../ScreenArgs.dart';

class ECGScreen extends StatefulWidget {
  @override
  const ECGScreen({
    Key key,

  }) : super(key: key);


  _ECGScreenState createState() => _ECGScreenState();
}

class _ECGScreenState extends State<ECGScreen> {

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
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
                child: SideMenu(isDoctor: args.isDoctor,userData: args.userData,),
              ),

            Expanded(
              flex: 5,
              child: Padding(
                padding:  EdgeInsets.all(defaultPadding),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Header(isDoctor: args.isDoctor,userData: args.userData,),
                      SizedBox(height: _size.height*0.1 ,),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: mqttClientWrapper.connectionState ==
                                  MqttCurrentConnectionState.CONNECTED
                                  ? ECGGraph(
                                ecg : data != null ? data["ecg"] : [],
                              )
                                  : ECGGraph(
                                ecg :[]
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
