import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

class TempGraph extends StatefulWidget {
  final double temp;

  TempGraph({Key key, this.temp}) : super(key: key);

  @override
  _TempGraphState createState() => _TempGraphState();
}

class _TempGraphState extends State<TempGraph> {
  _TempGraphState() {
    timer = Timer.periodic(const Duration(seconds: 1), _updateDataSource);
  }

  Timer timer;

  List<_ChartData> chartData = <_ChartData>[];
  ChartSeriesController _chartSeriesController;
  int count = 0;
  bool pause = false;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Text("Temperature", style: Theme.of(context).textTheme.headline5),
        SizedBox(
          height: _size.height * 0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.download_rounded),
              onPressed: () {},
              color: Colors.blue,
              splashRadius: 0.5,
            ),
            IconButton(
              icon: !pause ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () {
                setState(() {
                  pause = !pause;
                });
              },
              color: Colors.blue,
              splashRadius: 0.5,
            ),
          ],
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: DateTimeAxis(
            majorGridLines: MajorGridLines(width: 0),
            dateFormat: DateFormat.Hms(),
            intervalType: DateTimeIntervalType.seconds,
          ),
          primaryYAxis: NumericAxis(
              minimum: 30,
              maximum: 44,
              axisLine: AxisLine(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              labelFormat: '{value}°C',
              majorTickLines: MajorTickLines(size: 0)),
          series: <SplineSeries<_ChartData, DateTime>>[
            SplineSeries<_ChartData, DateTime>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: chartData,
              color: Colors.red,
              xValueMapper: (_ChartData temp, _) => temp.x,
              yValueMapper: (_ChartData temp, _) => temp.y,
              animationDuration: 0,
              name: 'Temperature',
            )
          ],
          tooltipBehavior: TooltipBehavior(enable: true),
        ),
      ]),
    );
  }

  void _updateDataSource(Timer timer) {
    if (mounted) {
      if (!pause) {
        if (chartData.length > 1) {
          if (chartData.last.y != widget.temp) {
            setState(() {
              if (chartData.length > 30) {
                chartData.removeAt(0);
                chartData.add(_ChartData(DateTime.now(), widget.temp));
                _chartSeriesController.updateDataSource(
                    addedDataIndexes: <int>[count++],
                    removedDataIndexes: <int>[0]);
              } else {
                chartData.add(_ChartData(DateTime.now(), widget.temp));
                _chartSeriesController.updateDataSource(
                  addedDataIndexes: <int>[count++],
                );
              }
            });
          }
        } else {
          setState(() {
            if (chartData.length > 30) {
              chartData.removeAt(0);
              chartData.add(_ChartData(DateTime.now(), widget.temp));
              _chartSeriesController.updateDataSource(
                  addedDataIndexes: <int>[count++],
                  removedDataIndexes: <int>[0]);
            } else {
              chartData.add(_ChartData(DateTime.now(), widget.temp));
              _chartSeriesController.updateDataSource(
                addedDataIndexes: <int>[count++],
              );
            }
          });
        }
      }
    }
  }
}

class _ChartData {
  final DateTime x;
  final double y;

  _ChartData(this.x, this.y);
}
