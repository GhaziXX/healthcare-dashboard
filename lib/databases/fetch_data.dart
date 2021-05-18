import 'dart:convert';

import 'package:admin/models/Data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Data> fetchData() async {
  final response = await http.get(Uri.http(
      'healthcare-api-server.herokuapp.com',
      '/users/ghazi',
      {"start_date": "2021-5-3"}));

  if (response.statusCode == 200) {
    return Data.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Data> data;

  @override
  void initState() {
    super.initState();
    data = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    data = fetchData();
                  },
                  child: Text("Reload")),
              FutureBuilder<Data>(
                future: data,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
