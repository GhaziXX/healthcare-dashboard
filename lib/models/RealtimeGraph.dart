class RealtimeGraph {
  final String icon, title, details;

  RealtimeGraph({this.icon, this.title, this.details});
}

List realtimeGraphs = [
  RealtimeGraph(
    icon: "assets/icons/temperature.svg",
    title: "Temperature",
    details: "Details",
  ),
  RealtimeGraph(
    icon: "assets/icons/ecg.svg",
    title: "ECG",
    details: "Details",
  ),
];
