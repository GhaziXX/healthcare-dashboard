import 'package:flutter/cupertino.dart';

class Data {
  final List<DateTime> date;
  final List data;

  Data({
    @required this.date,
    @required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    //print(json["datas"]);

    return Data(
      date: Foreach(json),
      data: json['datas'],
    );
  }

  static List<DateTime> Foreach(Map<String, dynamic> json) {
    List<DateTime> temp = [];
    for (var elem in json["timestamps"]) {
      temp.add(DateTime.parse(elem));
    }
    return temp;
  }

  T printFirst<T>(List<T> lst) {
    //List of generic type taken as function argument
    T first = lst[0]; //Generic type as local variable
    print(first);
    return first; //Generic type as return value
  }
}
