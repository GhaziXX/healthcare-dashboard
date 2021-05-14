import 'dart:ui';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class TempGauge extends StatefulWidget {
  final double temp;
  const TempGauge(this.temp);

  @override
  _TempGaugeState createState() => _TempGaugeState();
}

class _TempGaugeState extends State<TempGauge> {
  void _onValueChanged(double value){
    setState(() {
      value = widget.temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size=MediaQuery.of(context).size;
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
            startAngle: 130,
            endAngle: 50,
            minimum: 36,
            maximum: 41,
            interval:  1  ,
            minorTicksPerInterval: 9,
            showAxisLine: false,
            radiusFactor:  0.9,
            labelOffset: Responsive.isMobile(context) ?_size.height*0.06 : -_size.height*0.06,
            axisLabelStyle:  GaugeTextStyle(fontSize: 14,fontStyle: FontStyle.italic),
            majorTickStyle: MajorTickStyle(length: 10,thickness: 2,color: Colors.white70),
            minorTickStyle: MinorTickStyle(color : Colors.white70),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 90,
                  positionFactor: 1,
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(widget.temp.toString() + "°C",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize:  30 )),
                    ],
                  )),
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 36,
                  endValue: 37.5,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  gradient: SweepGradient(colors : [Color.fromRGBO(0, 200, 34, 0.75),Color.fromRGBO(123, 255, 34, 0.75)]) ),
              GaugeRange(
                  startValue: 37.5,
                  endValue: 38.5,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  gradient: SweepGradient(colors : [Color.fromRGBO(123, 255, 34, 0.75),Color.fromRGBO(255, 225, 0, 0.75)]) ),
              GaugeRange(
                  startValue: 38.5,
                  endValue: 41,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  gradient: SweepGradient(colors : [Color.fromRGBO(255, 225, 0, 0.75),Color.fromRGBO(255,30, 30, 0.75)])),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                  value: widget.temp,
                  onValueChanged: _onValueChanged,
                  needleLength: 0.6,
                  lengthUnit: GaugeSizeUnit.factor,
                  needleStartWidth: 0,
                  needleEndWidth:  3,
                  animationType: AnimationType.easeOutBack,
                  enableAnimation: true,
                  animationDuration: 800,
                  knobStyle: KnobStyle(
                      sizeUnit: GaugeSizeUnit.factor,
                      color: Colors.white,
                      knobRadius: 0.05)),
            ]),
      ],
    );

  }
}
