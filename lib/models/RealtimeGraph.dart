class RealtimeGraph {
  final String icon, title, details,route;

  RealtimeGraph({this.icon, this.title, this.details,this.route});
}

List realtimeGraphs = [
  RealtimeGraph(
    icon: "assets/icons/temperature.svg",
    title: "Temperature",
    details: "Details",
    route: '/tempGraph'
  ),
  RealtimeGraph(
    icon: "assets/icons/ecg.svg",
    title: "ECG",
    details: "Details",
    route: "/ECG"
  ),
];
