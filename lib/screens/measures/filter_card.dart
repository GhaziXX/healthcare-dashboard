import 'package:admin/constants/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FilterCard extends StatefulWidget {
  @override
  _FilterCardState createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: "Heartrate"),
        legend: Legend(
            isVisible: Responsive.isMobile(context) ? false : true,
            overflowMode: LegendItemOverflowMode.wrap),
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          dateFormat: DateFormat.yMd().add_Hm(),
          labelIntersectAction: AxisLabelIntersectAction.wrap,
          majorTickLines: MajorTickLines(width: 0),

          //intervalType: DateTimeIntervalType.auto,
          majorGridLines:
              MajorGridLines(color: Colors.transparent.withAlpha(100)),
        ),
        primaryYAxis: NumericAxis(
            labelFormat: '{value}bpm',
            minimum: 40,
            maximum: 150,
            axisLine: AxisLine(width: 0),
            interval: 10,
            majorGridLines: MajorGridLines(color: Colors.transparent)),
        series: _getDefaultLineSeries(),
        tooltipBehavior: _tooltipBehavior,
      ),
    );
  }

  List<ChartSeries<ChartData, DateTime>> _getDefaultLineSeries() {
    final List<ChartData> chartData = <ChartData>[
      ChartData(date: DateTime(2021, 5, 3), yValue: 80),
      ChartData(date: DateTime(2021, 5, 6), yValue: 80),
      ChartData(date: DateTime(2021, 5, 10), yValue: 80),
      ChartData(date: DateTime(2021, 5, 15), yValue: 60),
    ];
    return <LineSeries<ChartData, DateTime>>[
      LineSeries<ChartData, DateTime>(
          dashArray: <double>[10, 5],
          animationDuration: 2500,
          dataSource: [
            ChartData(date: DateTime(2021, 5, 1), yValue: 75.0),
            ChartData(date: DateTime.now(), yValue: 75.0)
          ],
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.yValue,
          width: 2,
          name: 'Average',
          markerSettings: MarkerSettings(isVisible: true)),
      LineSeries<ChartData, DateTime>(
          animationDuration: 2500,
          dataSource: chartData,
          width: 2,
          name: 'Max-Min',
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.yValue,
          markerSettings: MarkerSettings(isVisible: true))
    ];
  }
}

class ChartData {
  ChartData({
    this.date,
    this.yValue,
  });

  final DateTime date;

  final double yValue;
}
