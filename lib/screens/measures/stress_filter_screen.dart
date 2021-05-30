import 'package:admin/constants/constants.dart';
import 'package:admin/models/GraphHolder.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';
import '../ScreenArgs.dart';
import 'filter_card.dart';

class StressFilterScreen extends StatefulWidget {
  @override
  _StressFilterScreenState createState() => _StressFilterScreenState();
}

ScreenArguments args;

class _StressFilterScreenState extends State<StressFilterScreen> {
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as ScreenArguments;

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
                              child: GraphHolder(
                                child: FilterCard(
                                  data: args.oneGraphData,
                                  title: "Stress",
                                  labelFormat: "{value}",
                                  min: 0,
                                  max: 100,
                                  interval: 10,
                                ),
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
