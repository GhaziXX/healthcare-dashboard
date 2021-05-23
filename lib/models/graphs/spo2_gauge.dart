import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// ignore: must_be_immutable
class SPO2Radial extends StatefulWidget {
  SPO2Radial(this.spo2);
  double spo2;


  @override
  _SPO2RadialState createState() => _SPO2RadialState();
}

class _SPO2RadialState extends State<SPO2Radial> {
  void _onValueChanged(double value) {
    setState(() {
      value = widget.spo2;
    });
  }

  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _markerValue = widget.spo2;
    return FittedBox(
      child: Column(
        children: [
          Text("Oxygen Saturation",style:Theme.of(context).textTheme.headline5),
          SizedBox(height: _size.height*0.05,),
          SfRadialGauge(
            enableLoadingAnimation: true,
            axes: <RadialAxis>[
              RadialAxis(
                  showLabels: false,
                  showTicks: false,
                  radiusFactor: 0.8,
                  minimum: 0,
                  maximum: 100,
                  axisLineStyle: AxisLineStyle(
                      cornerStyle: CornerStyle.startCurve, thickness: 5),
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        angle: 90,
                        positionFactor: 0,
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(widget.spo2.toString() + "%",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 30)),
                          ],
                        )),
                    GaugeAnnotation(
                        angle: 124,
                        positionFactor: 1.1,
                        widget: Container(
                          child: Text('0', style: TextStyle(fontSize: 14)),
                        )),
                    GaugeAnnotation(
                        angle: 54,
                        positionFactor: 1.1,
                        widget: Container(
                          child: Text('100', style: TextStyle(fontSize: 14)),
                        )),
                  ],
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: widget.spo2,
                      onValueChanged: _onValueChanged,
                      width: 18,
                      pointerOffset: -6,
                      cornerStyle: CornerStyle.bothCurve,
                      color: Colors.indigo,
                      gradient: SweepGradient(colors: <Color>[
                        Colors.blueAccent,
                        Colors.indigo.shade700
                      ], stops: <double>[
                        0.25,
                        0.75
                      ]),
                    ),
                    MarkerPointer(
                      value: _markerValue - 1.5,
                      onValueChanged: _onValueChanged,
                      color: Colors.white,
                      markerType: MarkerType.circle,
                    ),
                  ]),
            ],
          ),
        ],
      ),
    );
  }
}
