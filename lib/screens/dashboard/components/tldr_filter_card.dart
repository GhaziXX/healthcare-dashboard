import 'package:admin/constants/constants.dart';
import 'package:admin/models/data_models/GeneralReadingData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TLDRFiltercard extends StatefulWidget {
  @override
  _TLDRFiltercardState createState() => _TLDRFiltercardState();
  const TLDRFiltercard({Key key, @required this.title, this.data})
      : super(key: key);
  final String title;
  final GeneralReadingData data;
}

class _TLDRFiltercardState extends State<TLDRFiltercard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: (widget.data.avgValue == 0 &&
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
                plotAreaBorderWidth: 0,
                title: ChartTitle(
                  text: widget.title,
                  textStyle: TextStyle().copyWith(fontSize: 10),
                ),
                primaryXAxis:
                    CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(width: 0),
                  minimum: 0,
                  maximum: widget.data.maxValue,
                ),
                series: _getTrackerBarSeries(),
              ),
      ),
    );
  }

  List<BarSeries<ChartData, String>> _getTrackerBarSeries() {
    final List<ChartData> chartData = <ChartData>[
      ChartData(property: 'Min', xValue: widget.data.minValue),
      ChartData(property: 'Average', xValue: widget.data.avgValue),
      ChartData(property: 'Max', xValue: widget.data.maxValue),
    ];
    return <BarSeries<ChartData, String>>[
      BarSeries<ChartData, String>(
        width: 0.7,
        spacing: 0.1,
        dataSource: chartData,
        borderRadius: BorderRadius.circular(8),
        trackColor: bgColor,
        borderColor: primaryColor.withOpacity(0.15),
        color: primaryColor,
        isTrackVisible: true,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.auto),
        xValueMapper: (ChartData data, _) => data.property,
        yValueMapper: (ChartData data, _) => data.xValue,
      ),
    ];
  }
}

class ChartData {
  ChartData({
    this.property,
    this.xValue,
  });

  final String property;

  final double xValue;
}
