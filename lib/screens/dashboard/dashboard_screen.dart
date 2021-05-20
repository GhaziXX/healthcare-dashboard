import 'package:admin/models/UserData.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../constants/constants.dart';
import 'components/general_details.dart';
import 'components/header.dart';
import 'components/my_graphs.dart';
import 'components/realtime_graph.dart';
import 'components/report.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    Key key,
    @required this.isDoctor,
    @required this.userData,
  }) : super(key: key);
  final bool isDoctor;
  final UserData userData;

  @override
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
              isDoctor: isDoctor,
              userData: userData,
            ),
            content: Column(
              children: [
                //Header(),
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
                          MyGraph(),
                          SizedBox(height: defaultPadding),
                          RealtimeGraphs(),
                          SizedBox(height: defaultPadding),
                          Report(),
                          if (Responsive.isMobile(context))
                            SizedBox(height: defaultPadding),
                          if (Responsive.isMobile(context))
                            GeneralDetails(
                              connected: true,
                            )
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
                        child: GeneralDetails(
                          connected: true,
                        ),
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
