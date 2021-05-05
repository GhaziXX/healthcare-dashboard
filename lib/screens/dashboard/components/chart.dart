import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieChartSelectionData = [
      PieChartSectionData(
          color: primaryColor, value: 4, showTitle: false, radius: 10),
      PieChartSectionData(
          color: Colors.deepOrange, value: 6, showTitle: false, radius: 12),
      PieChartSectionData(
          color: Colors.orange, value: 8, showTitle: false, radius: 14),
      PieChartSectionData(
          color: Colors.deepPurple, value: 15, showTitle: false, radius: 16),
    ];
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 70,
              sections: pieChartSelectionData,
            ),
          ),
          Positioned.fill(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: defaultPadding,
              ),
              Text("50",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 0.5)),
              Text("of haja"),
            ],
          ))
        ],
      ),
    );
  }
}
