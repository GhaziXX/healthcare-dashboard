import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// ignore: must_be_immutable
class StressGauge extends StatefulWidget {
  StressGauge(this.stress);
  double stress;

  @override
  _StressGaugeState createState() => _StressGaugeState();
}

class _StressGaugeState extends State<StressGauge> {
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return FittedBox(
      child: Column(
        children: [
          Text("Stress Level",
              style: Theme.of(context).textTheme.headline5),
          SizedBox(
            height: _size.height * 0.05,
          ),
      SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showTicks: false,
            showLabels: false,
            startAngle: 180,
            endAngle: 180,
            radiusFactor: 0.8,
            axisLineStyle: AxisLineStyle(
              // Dash array not supported in web
                thickness: 30,
                dashArray: <double>[8, 10]),
          ),
          RadialAxis(
              showTicks: false,
              showLabels: false,
              startAngle: 270,
              endAngle: (widget.stress*3.6)-90,
              radiusFactor:  0.8 ,
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    angle: 270,
                    positionFactor: 0,
                    verticalAlignment: GaugeAlignment.far,
                    widget: Container(
                      // added text widget as an annotation.
                        child: Text(widget.stress.toString(),
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Times',
                                fontWeight: FontWeight.bold,
                                fontSize:  18 ))))
              ],
              axisLineStyle: AxisLineStyle(
                  color: const Color(0xFF00A8B5),
                  gradient: widget.stress<50 ? const SweepGradient(
                      colors: <Color>[Color(0xFF06974A), Color(0xFFF2E41F)],
                      stops: <double>[0.25,0.75])
                      :
                  const SweepGradient(
                      colors: <Color>[Color(0xFF06974A), Color(0xFFF2E41F), Color(0xFFFF0A0E)],
                      stops: <double>[0.25, 0.5,0.75])
                  ,
                  thickness: 30,
                  dashArray: <double>[8, 10]))
        ],
      )
        ],
      ),
    );
  }
}
