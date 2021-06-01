import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/backend/mqtt/mqtt_wrapper.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../constants/constants.dart';
import 'components/general_details.dart';
import 'components/header.dart';
import 'components/my_graphs.dart';
import 'components/realtime_graph.dart';
import 'components/report.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key key,
    @required this.isDoctor,
    @required this.userData,
  }) : super(key: key);

  final bool isDoctor;
  final UserData userData;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

var data;
MQTTWrapper mqttClientWrapper;

class _DashboardScreenState extends State<DashboardScreen> {
  void setup() {
    mqttClientWrapper = MQTTWrapper(
        onConnectedCallback: () => print("connected"),
        onDataReceivedCallback: (newDataJson) {
          if (mounted)
            setState(() {
              data = newDataJson;
            });
        },
        isPublish: false,
        user: "Healthcare/" + widget.userData.id + widget.userData.gid);
    mqttClientWrapper.prepareMqttClient();
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return SafeArea(
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(defaultPadding),
          child: StickyHeader(
            header: Header(
              isDoctor: widget.isDoctor,
              userData: widget.userData,
            ),
            content: Column(
              children: [
                SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          if (Responsive.isMobile(context))
                            GeneralDetails(
                              userData: widget.userData,
                            ),
                          if (Responsive.isMobile(context))
                            SizedBox(height: defaultPadding),
                          MyGraph(
                            isDoctor: widget.isDoctor,
                            userData: widget.userData,
                          ),
                          SizedBox(height: defaultPadding),
                          RealtimeGraphs(
                            isDoctor: widget.isDoctor,
                            userData: widget.userData,
                          ),
                          SizedBox(height: defaultPadding),
                          Report(
                            userData: widget.userData,
                            isDoctor: widget.isDoctor,
                          ),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: defaultPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: GeneralDetails(userData: widget.userData),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
