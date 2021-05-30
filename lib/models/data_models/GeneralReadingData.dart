class GeneralReadingData {
  final double avgValue;
  final List<DateTime> avgDates;
  final double minValue;
  final List<DateTime> minDates;
  final double maxValue;
  final List<DateTime> maxDates;

  GeneralReadingData({
    this.avgValue,
    this.avgDates,
    this.minValue,
    this.minDates,
    this.maxValue,
    this.maxDates,
  });

  factory GeneralReadingData.fromJson(Map<String, dynamic> json) {
    return GeneralReadingData(
      avgValue: json["avg"]["value"] != null
          ? double.parse(json["avg"]["value"].toStringAsFixed(2))
          : 0.0,
      avgDates: toDateTime(json['avg']["dates"]),
      minValue:
          json["min"]["value"] != null ? json["min"]["value"].toDouble() : 0.0,
      minDates: toDateTime(json['min']["dates"]),
      maxValue:
          json["max"]["value"] != null ? json["max"]["value"].toDouble() : 0.0,
      maxDates: toDateTime(json['max']["dates"]),
    );
  }

  static List<DateTime> toDateTime(List<dynamic> timestamps) {
    return timestamps.map((e) => DateTime.parse(e)).toList();
  }
}
