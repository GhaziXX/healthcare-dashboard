import 'package:admin/constants/constants.dart';
import 'package:admin/models/GraphHolder.dart';
import 'package:admin/models/graphs_models/ecg_graph.dart';
import 'package:admin/models/graphs_models/heartrate.dart';
import 'package:admin/models/graphs_models/spo2_gauge.dart';
import 'package:admin/models/graphs_models/stress_gauge.dart';
import 'package:admin/models/graphs_models/temperature_gauge.dart';
import 'package:admin/backend/mqtt/mqtt_model.dart';
import 'package:admin/backend/mqtt/mqtt_wrapper.dart';
import 'package:admin/models/graphs_models/temperature_graph.dart';

import 'package:admin/screens/dashboard/components/header.dart';

import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../../responsive.dart';
import '../../ScreenArgs.dart';

class AllinOneScreen extends StatefulWidget {
  @override
  const AllinOneScreen({
    Key key,
  }) : super(key: key);
  _AllinOneScreenState createState() => _AllinOneScreenState();
}

var data;
MQTTWrapper mqttClientWrapper;
ScreenArguments args;

class _AllinOneScreenState extends State<AllinOneScreen> {
  bool shouldInit = true;

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
                            child: Column(
                              children: [
                                SizedBox(
                                  height: _size.height * 0.1,
                                ),
                                Responsive(
                                    mobile: GraphGridView(
                                      crossAxisCount: _size.width < 650 ? 1 : 2,
                                      childAspectRatio:
                                          _size.width < 650 ? 1.1 : 1,
                                    ),
                                    tablet: GraphGridView(),
                                    desktop: GraphGridView(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2,
                                    )),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                if (!Responsive.isMobile(context))
                                  Responsive(
                                      mobile: Container(),
                                      tablet: GraphHolder(
                                          child: ECGGraph(
                                              ecg: data != null
                                                  ? data["ecg"]
                                                  : [])),
                                      desktop: GraphHolder(
                                          child: ECGGraph(
                                              ecg: data != null
                                                  ? data["ecg"]
                                                  : []))),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                if (!Responsive.isMobile(context))
                                  Responsive(
                                      mobile: Container(),
                                      tablet: GraphHolder(
                                          child: TempGraph(
                                              temp: data != null
                                                  ? data["temperature"]
                                                  : 0)),
                                      desktop: GraphHolder(
                                          child: TempGraph(
                                              temp: data != null
                                                  ? data["temperature"]
                                                  : 0))),
                              ],
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

class GraphGridView extends StatefulWidget {
  const GraphGridView(
      {Key key,
      this.crossAxisCount = 2,
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
    List<Widget> children = [
      SPO2Radial(data != null ? data["spo2"] : 0),
      HeartRate(
        data != null ? data["heartrate"] : 0,
      ),
      TempGauge(data != null ? data["temperature"] : 0),
      StressGauge(data != null ? data["stress"] : 0),
      if (Responsive.isMobile(context))
        ECGGraph(ecg: data != null ? data["ecg"] : []),
      if (Responsive.isMobile(context))
        TempGraph(temp: data != null ? data["temperature"] : 0)
    ];
    List<Widget> zeros = [
      SPO2Radial(0),
      HeartRate(0),
      TempGauge(0),
      StressGauge(0),
      if (Responsive.isMobile(context)) ECGGraph(ecg: []),
      if (Responsive.isMobile(context)) TempGraph(temp: 0)
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
