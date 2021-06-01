class Patients {
  final title, details, route;

  Patients({this.title,this.details,this.route});
}

List patientsList = [
  Patients(
      title: "Temperature",
      details: "More Details",
      route: '/tempGraph'),
  Patients(
      title: "ECG",
      details: "More Details",
      route: "/ECG"),
];
