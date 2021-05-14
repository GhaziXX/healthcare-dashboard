import 'package:flutter/material.dart';

class TDLRGraph {
  final String svgSrc, title, maxValue, route,unit;
  final double percentage, currentValue;
  final Color color;

  TDLRGraph(
      {this.svgSrc,
      this.title,
      this.maxValue,
      this.currentValue,
      this.percentage,
      this.color,
      this.route,
      this.unit});
}
