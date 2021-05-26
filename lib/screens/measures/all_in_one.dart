import 'package:admin/constants/constants.dart';
import 'package:admin/models/graphs/ecg_graph.dart';
import 'package:admin/models/graphs/heartrate.dart';
import 'package:admin/models/graphs/spo2_gauge.dart';
import 'package:admin/models/graphs/temperature_gauge.dart';
import 'package:admin/mqtt/mqtt_model.dart';
import 'package:admin/mqtt/mqtt_wrapper.dart';
import 'package:admin/screens/dashboard/components/header.dart';

import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';
import '../ScreenArgs.dart';

class AllinOneScreen extends StatefulWidget {
  @override
  const AllinOneScreen({
    Key key,
  }) : super(key: key);
  _AllinOneScreenState createState() => _AllinOneScreenState();
}

var data;
MQTTWrapper mqttClientWrapper;
bool shouldInit = true;
ScreenArguments args;

class _AllinOneScreenState extends State<AllinOneScreen> {
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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Header(
                              isDoctor: args.isDoctor,
                              userData: args.userData,
                            ),
                            SizedBox(
                              height: _size.height * 0.1,
                            ),
                            Responsive(
                                mobile: GraphGridView(
                                  crossAxisCount: _size.width < 650 ? 1 : 2,
                                  childAspectRatio: _size.width < 650 ? 1.1 : 1,
                                ),
                                tablet: GraphGridView(),
                                desktop: GraphGridView(
                                  crossAxisCount: _size.width < 1400 ? 3 : 2,
                                  childAspectRatio: _size.width < 1400 ? 1 : 4,
                                )),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            if (!Responsive.isMobile(context))
                              Responsive(
                                  mobile: Container(),
                                  tablet: GraphHolder(
                                      child: ECGGraph(
                                          ecg:
                                              data != null ? data["ecg"] : [])),
                                  desktop: GraphHolder(
                                      child: ECGGraph(
                                          ecg: data != null
                                              ? data["ecg"]
                                              : []))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GraphGridView extends StatefulWidget {
  const GraphGridView(
      {Key key,
      this.crossAxisCount = 3,
      this.childAspectRatio = 1,
      this.isDoctor})
      : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final bool isDoctor;

  @override
  _GraphGridViewState createState() => _GraphGridViewState();
}

class _GraphGridViewState extends State<GraphGridView> {
  @override
  Widget build(BuildContext context) {
    print("data fel all $data");
    List<Widget> children = [
      SPO2Radial(data != null ? data["spo2"] : 0),
      HeartRate(
        data != null ? data["heartrate"] : 0,
      ),
      TempGauge(data != null ? data["temperature"] : 0),
      if (Responsive.isMobile(context))
        ECGGraph(ecg: data != null ? data["ecg"] : [])
    ];
    List<Widget> zeros = [
      SPO2Radial(0),
      HeartRate(0),
      TempGauge(0),
      if (Responsive.isMobile(context)) ECGGraph(ecg: [])
    ];
    return mqttClientWrapper.connectionState ==
            MqttCurrentConnectionState.CONNECTED
        ? GridView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: children.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
                childAspectRatio: widget.childAspectRatio),
            itemBuilder: (context, index) => GraphHolder(
              child: children[index],
            ),
          )
        : GridView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: zeros.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
                childAspectRatio: widget.childAspectRatio),
            itemBuilder: (context, index) => GraphHolder(
              child: zeros[index],
            ),
          );
  }
}

class GraphHolder extends StatelessWidget {
  final Widget child;

  const GraphHolder({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SizedBox(
        child: this.child,
      ),
    );
  }
}
