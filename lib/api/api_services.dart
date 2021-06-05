import 'dart:convert';

import 'package:admin/models/data_models/APIData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIServices {
  Future<APIData> fetchData({
    String startDate,
    String endDate,
    String startTime,
    String endTime,
    String gid,
  }) async {
    http.Response response;
    if (startDate != null && startTime != null) {
      response = await http
          .get(Uri.https('healthcare-api-server.herokuapp.com', '/users/$gid', {
        "start_date": startDate,
        "end_date": endDate,
        "start_time": startTime,
        "end_time": endTime
      }));
    } else if (startDate == null && startTime != null) {
      response = await http.get(Uri.https('healthcare-api-server.herokuapp.com',
          '/users/$gid', {"start_time": startTime, "end_time": endTime}));
    } else if (startDate != null && startTime == null) {
      response = await http
          .get(Uri.https('healthcare-api-server.herokuapp.com', '/users/$gid', {
        "start_date": startDate,
        "end_date": endDate,
      }));
    }

    if (response.statusCode == 200) {
      return APIData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
