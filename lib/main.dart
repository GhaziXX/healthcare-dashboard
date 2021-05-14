import 'package:admin/constants/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/screens/measures/all_in_one.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'mqtt/mqtt_wrapper.dart';
import 'screens/measures/ecg_screen.dart';
import 'screens/measures/heartrate_screen.dart';
import 'screens/measures/spo2_screen.dart';
import 'screens/measures/temperature_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}
var data;
MQTTWrapper mqttClientWrapper;

class _MyAppState extends State<MyApp> {
  void setup() {
    mqttClientWrapper = MQTTWrapper(
            () => print("Connected"),
            (newDataJson) => setState(() {
          data = newDataJson;
        }),
        false);
    mqttClientWrapper.prepareMqttClient();
  }
  @override
  void initState() {
    super.initState();
    setup();
  }

  Widget build(BuildContext context) {
    bool isDoctor = true;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuController(),
        )
      ],
      child: ResponsiveSizer(builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Healthcare',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: bgColor,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.white),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: secondaryColor,
          ),
          routes: {
            '/mainScreen' : (context) => MainScreen(isDoctor: isDoctor),
            '/spo2': (context) => SPO2Screen(isDoctor: isDoctor),
            '/temperature' : (context) => TempScreen(isDoctor: isDoctor),
            '/heartrate' : (context) => HeartScreen(isDoctor: isDoctor),
            '/ECG' : (context) => ECGScreen(isDoctor: isDoctor),
            '/all' : (context) => AllinOneScreen(isDoctor: isDoctor)
          },
          home: MainScreen(
            isDoctor: isDoctor,
          ),
          //AuthScreen(),
        );
      }),
    );
  }
}
