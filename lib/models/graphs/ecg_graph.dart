import 'dart:async';
import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ECGGraph extends StatefulWidget {
  final List<dynamic> ecg;

  ECGGraph({Key key, this.ecg}) : super(key: key);

  @override
  _ECGGraphState createState() => _ECGGraphState();
}

class _ECGGraphState extends State<ECGGraph> {
  _ECGGraphState() {
    timer = Timer.periodic(const Duration(seconds: 1), _updateDataSource);
  }

  Timer timer;

  List<_ChartData> chartData = <_ChartData>[];
  ChartSeriesController _chartSeriesController;
  int count = 0;
  bool pause = false;
  int start = 0;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
            "ECG",
            style: Theme.of(context).textTheme.headline5
        ),
        SizedBox(
          height: _size.height * 0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.download_rounded),
              onPressed: () {},
              color: primaryColor,
              splashRadius: 0.5,
            ),
            IconButton(
              icon: !pause ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () {
                setState(() {
                  pause = !pause;
                });
              },
              color: primaryColor,
              splashRadius: 0.5,
            ),
          ],
        ),
        SizedBox(
          height: _size.height * 0.03,
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            majorGridLines: MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
              minimum: -1,
              maximum: 2,
              axisLine: AxisLine(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              majorTickLines: MajorTickLines(size: 0)),
          series: <SplineSeries<_ChartData, double>>[
            SplineSeries<_ChartData, double>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: chartData,
              color: primaryColor,
              xValueMapper: (_ChartData ecg, _) => ecg.x,
              yValueMapper: (_ChartData ecg, _) => ecg.y,
              animationDuration: 0,
              //markerSettings: MarkerSettings(isVisible: true),
              name: 'ECG',
            )
          ],
          tooltipBehavior: TooltipBehavior(enable: true),
        ),
      ],
    );
  }

  void _updateDataSource(Timer timer) {
    if (widget.ecg != null) {
      if (!pause) {
        if (mounted) {
          //print(chartData.length);
          int l = widget.ecg.length;
          setState(() {
            if (chartData.length > 80) {
              chartData.removeRange(0, l);
              for (int i = 0; i <= l - 1; i++) {
                chartData.add(_ChartData(start + (i / l), widget.ecg[i]));
              }
              _chartSeriesController.updateDataSource(
                addedDataIndexes: List<int>.generate(
                    l, (index) => chartData.length - 1 + index),
                removedDataIndexes: List<int>.generate(l, (index) => index),
              );
            } else {
              for (int i = 0; i <= l - 1; i++) {
                chartData.add(_ChartData(start + (i / l), widget.ecg[i]));
              }
              _chartSeriesController.updateDataSource(
                addedDataIndexes: List<int>.generate(
                    l, (index) => chartData.length - 1 + index),
              );
            }
            //count += 199;
            start++;
          });
        }
      }
    }
  }
}

class _ChartData {
  final double x;
  final dynamic y;
  _ChartData(this.x, this.y);
}
