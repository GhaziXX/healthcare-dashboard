import 'package:admin/models/data_models/GeneralReadingData.dart';

class APIData {
  final GeneralReadingData temperature;
  final GeneralReadingData spo2;
  final GeneralReadingData heartrate;
  final GeneralReadingData stress;

  APIData({
    this.temperature,
    this.spo2,
    this.heartrate,
    this.stress,
  });

  factory APIData.fromJson(Map<String, dynamic> json) {
    return APIData(
        temperature: GeneralReadingData.fromJson(json["temperature"]),
        spo2: GeneralReadingData.fromJson(json["spo2"]),
        heartrate: GeneralReadingData.fromJson(json["heartrate"]),
        stress: GeneralReadingData.fromJson(json["stress"]));
  }
}
