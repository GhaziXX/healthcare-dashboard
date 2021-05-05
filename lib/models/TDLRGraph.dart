import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class TDLRGraph {
  final String svgSrc, title, maxValue;
  final double percentage, currentValue;
  final Color color;

  TDLRGraph(
      {this.svgSrc,
      this.title,
      this.maxValue,
      this.currentValue,
      this.percentage,
      this.color});
}

List myGraphs = [
  TDLRGraph(
    title: "Spo2",
    currentValue: 99,
    svgSrc: "assets/icons/oxygen.svg",
    maxValue: "100",
    color: primaryColor,
    percentage: 99,
  ),
  TDLRGraph(
    title: "Heartbeat",
    currentValue: 75,
    svgSrc: "assets/icons/heartbeat.svg",
    maxValue: "135",
    color: Color(0xFFFFA113),
    percentage: 51.2,
  ),
  TDLRGraph(
    title: "Stress",
    currentValue: 10,
    svgSrc: "assets/icons/stress.svg",
    maxValue: "100",
    color: Color(0xFFA4CDFF),
    percentage: 10,
  ),
  TDLRGraph(
    title: "Temperature",
    currentValue: 37.5,
    svgSrc: "assets/icons/temperature.svg",
    maxValue: "42",
    color: Color(0xFF007EE5),
    percentage: 75,
  ),
];
