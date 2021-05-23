import 'package:admin/models/TDLRGraph.dart';
import 'package:admin/models/UserData.dart';
import 'package:admin/mqtt/mqtt_model.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../dashboard_screen.dart';
import 'graph_info_card.dart';

class MyGraph extends StatelessWidget {
  const MyGraph({
    @required this.isDoctor,
    @required this.userData,
    Key key,
  }) : super(key: key);
  final bool isDoctor;
  final UserData userData;
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Graphs",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: defaultPadding),
        Responsive(
            mobile: GraphInfoCardGridView(
              isDoctor: isDoctor,
              userData: userData,
              crossAxisCount: _size.width < 650 ? 2 : 4,
              childAspectRatio: _size.width < 650 ? 1.3 : 1,
            ),
            tablet: GraphInfoCardGridView(userData: userData,isDoctor: isDoctor,),
            desktop: GraphInfoCardGridView(
              isDoctor: isDoctor,
              userData: userData,
              childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
            ))
      ],
    );
  }
}

class GraphInfoCardGridView extends StatefulWidget {
  const GraphInfoCardGridView({
    Key key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    @required this.userData,
    @required this.isDoctor,

  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final UserData userData;
  final bool isDoctor;

  @override
  _GraphInfoCardGridViewState createState() => _GraphInfoCardGridViewState();
}

class _GraphInfoCardGridViewState extends State<GraphInfoCardGridView> {
  @override
  Widget build(BuildContext context) {
    List zeros = [
      TDLRGraph(
          title: "Spo2",
          currentValue: 0,
          svgSrc: "assets/icons/oxygen.svg",
          maxValue: "100",
          color: primaryColor,
          percentage: 0,
          route: '/spo2',
          unit: "%",),
      TDLRGraph(
          title: "Heartrate",
          currentValue: 0,
          svgSrc: "assets/icons/heartbeat.svg",
          maxValue: "140",
          color: Color(0xFFFFA113),
          percentage: 0,
          route: '/heartrate',
          unit: 'bpm',
      ),
      TDLRGraph(
          title: "Stress",
          currentValue: 0,
          svgSrc: "assets/icons/stress.svg",
          maxValue: "100",
          color: Color(0xFFA4CDFF),
          percentage: 0,
          route: '/stress',
          unit:'',
           ),
      TDLRGraph(
          title: "Temperature",
          currentValue: 0,
          svgSrc: "assets/icons/temperature.svg",
          maxValue: "41",
          color: Color(0xFF007EE5),
          percentage: 0,
          route: '/temperature',
          unit: '°C',),
    ];
    List myGraphs = [
      TDLRGraph(
          title: "Spo2",
          currentValue: data != null ? data["spo2"] * 1.0 : 0,
          svgSrc: "assets/icons/oxygen.svg",
          maxValue: "100",
          color: primaryColor,
          percentage: data != null ? data["spo2"] * 1.0 : 0,
          route: '/spo2',
          unit: "%",),
      TDLRGraph(
          title: "Heartrate",
          currentValue: data != null ? data["heartrate"] * 1.0 : 0,
          svgSrc: "assets/icons/heartbeat.svg",
          maxValue: "140",
          color: Color(0xFFFFA113),
          percentage: data != null ? data["heartrate"] * 100 / 140 : 0,
          route: '/heartrate',
          unit: 'bpm'),
      TDLRGraph(
          title: "Stress",
          currentValue: 10,
          svgSrc: "assets/icons/stress.svg",
          maxValue: "100",
          color: Color(0xFFA4CDFF),
          percentage: 10,
          route: '/stress',
          unit: '',),
      TDLRGraph(
          title: "Temperature",
          currentValue: data != null ? data["temperature"] * 1.0 : 0,
          svgSrc: "assets/icons/temperature.svg",
          maxValue: "41",
          color: Color(0xFF007EE5),
          percentage: data != null ? data["temperature"] * 100 / 41 : 0,
          route: '/temperature',
          unit: '°C',),
    ];
    return mqttClientWrapper.connectionState ==
            MqttCurrentConnectionState.CONNECTED
        ? GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: myGraphs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
                childAspectRatio: widget.childAspectRatio),
            itemBuilder: (context, index) => GraphInfoCard(isDoctor: widget.isDoctor,userData: widget.userData,
              info: myGraphs[index],
            ),
          )
        : GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: myGraphs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
                childAspectRatio: widget.childAspectRatio),
            itemBuilder: (context, index) => GraphInfoCard(isDoctor: widget.isDoctor,userData: widget.userData,
              info: zeros[index],
            ),
          );
  }
}
