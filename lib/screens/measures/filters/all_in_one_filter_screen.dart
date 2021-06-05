import 'package:admin/constants/constants.dart';
import 'package:admin/models/GraphHolder.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';


import '../../../responsive.dart';
import '../../ScreenArgs.dart';
import 'filter_card.dart';

class AllinOneFilterScreen extends StatefulWidget {
  @override
  _AllinOneFilterScreenState createState() => _AllinOneFilterScreenState();
}

ScreenArguments args;

class _AllinOneFilterScreenState extends State<AllinOneFilterScreen> {
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    Size _size = MediaQuery.of(context).size;
    args = ModalRoute.of(context).settings.arguments as ScreenArguments;
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
                                      crossAxisCount:
                                          _size.width < 1400 ? 3 : 2,
                                      childAspectRatio:
                                          _size.width < 1400 ? 1 : 4,
                                    )),
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
    List<Widget> children = [
      FilterCard(
        data: args.apiData.heartrate,
        title: "Heartrate",
        labelFormat: "{value}bpm",
        min: 40,
        max: 150,
        interval: 10,
      ),
      FilterCard(
        data: args.apiData.spo2,
        title: "SPO2",
        labelFormat: "{value}%",
        min: 40,
        max: 100,
        interval: 10,
      ),
      FilterCard(
        data: args.apiData.stress,
        title: "Stress",
        labelFormat: "{value}",
        min: 0,
        max: 100,
        interval: 10,
      ),
      FilterCard(
        data: args.apiData.temperature,
        title: "Temperature",
        labelFormat: "{value}°C",
        min: 30,
        max: 44,
        interval: 5,
      ),
    ];
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: children.length,
      itemBuilder: (context, index) => GraphHolder(
        child: children[index],
      ),
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: defaultPadding,
        );
      },
    );
  }
}
