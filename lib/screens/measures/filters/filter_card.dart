import 'package:admin/constants/constants.dart';
import 'package:admin/models/data_models/GeneralReadingData.dart';
import 'package:admin/responsive.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FilterCard extends StatefulWidget {
  const FilterCard(
      {Key key,
      this.title,
      this.data,
      this.labelFormat,
      this.min,
      this.max,
      this.interval})
      : super(key: key);

  @override
  _FilterCardState createState() => _FilterCardState();
  final String title;
  final GeneralReadingData data;
  final String labelFormat;
  final double min, max;
  final double interval;
}

class _FilterCardState extends State<FilterCard> {
  TooltipBehavior _tooltipBehavior;
  ZoomMode _zoomModeType = ZoomMode.x;
  GlobalKey<State> chartKey = GlobalKey<State>();
  num left = 0, top = 0;
  @override
  void initState() {
    _zoomModeType = ZoomMode.x;
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.data.avgValue == 0 &&
            widget.data.maxValue == 0 &&
            widget.data.minValue == 0)
        ? Center(
            child: Text(
              "No data for the selected period.",
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          )
        : SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                zoomMode: _zoomModeType,
                enablePanning: true,
                enableMouseWheelZooming:
                    Responsive.isDesktop(context) ? true : false),
            plotAreaBorderWidth: 0,
            title: ChartTitle(text: widget.title),
            legend: Legend(
                isVisible: Responsive.isMobile(context) ? false : true,
                overflowMode: LegendItemOverflowMode.wrap),
            primaryXAxis: DateTimeAxis(
              //desiredIntervals: 4,
              enableAutoIntervalOnZooming: true,
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              dateFormat: DateFormat.yMd().add_Hm(),
              labelIntersectAction: AxisLabelIntersectAction.wrap,
              majorTickLines: MajorTickLines(width: 0),
              majorGridLines:
                  MajorGridLines(color: Colors.transparent.withAlpha(100)),
            ),
            primaryYAxis: NumericAxis(
                labelFormat: widget.labelFormat,
                minimum: widget.min,
                maximum: widget.max,
                axisLine: AxisLine(width: 0),
                interval: widget.interval,
                majorGridLines: MajorGridLines(color: Colors.transparent)),
            series: _getDefaultLineSeries(),
            tooltipBehavior: _tooltipBehavior,
          );
  }

  List<ChartSeries<ChartData, DateTime>> _getDefaultLineSeries() {
    List<ChartData> chartData = List<ChartData>.generate(
        widget.data.maxDates.length,
        (index) => ChartData(
            date: widget.data.maxDates[index], yValue: widget.data.maxValue));
    chartData.addAll(List<ChartData>.generate(
        widget.data.minDates.length,
        (index) => ChartData(
            date: widget.data.minDates[index], yValue: widget.data.minValue)));
    chartData.sort((a, b) => a.date.compareTo(b.date));
    return <LineSeries<ChartData, DateTime>>[
      LineSeries<ChartData, DateTime>(
          dashArray: <double>[10, 5],
          animationDuration: 2500,
          dataSource: [
            ChartData(
                date: chartData
                    .reduce((a, b) => a.date.isBefore(b.date) ? a : b)
                    .date,
                yValue: widget.data.avgValue),
            ChartData(
                date: chartData
                    .reduce((a, b) => a.date.isAfter(b.date) ? a : b)
                    .date,
                yValue: widget.data.avgValue)
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
