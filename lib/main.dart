import 'package:admin/backend/firebase/authentification_wrapper.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/screens/measures/all_in_one.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'backend/firebase/authentification_services.dart';
import 'mqtt/mqtt_wrapper.dart';
import 'screens/authentification/auth_screen.dart';
import 'screens/measures/ecg_screen.dart';
import 'screens/measures/heartrate_screen.dart';
import 'screens/measures/spo2_screen.dart';
import 'screens/measures/temperature_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

var data;
MQTTWrapper mqttClientWrapper;
bool isDoctor = true;

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
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MultiProvider(
        providers: [
          Provider<AuthenticationServices>(
            create: (_) => AuthenticationServices((FirebaseAuth.instance)),
          ),
          StreamProvider(
            create: (context) =>
                context.read<AuthenticationServices>().authStateChanges,
            initialData: null,
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Healthcare dashboard',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: bgColor,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.white),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: secondaryColor,
          ),
          routes: {
            '/mainScreen': (context) => MainScreen(isDoctor: isDoctor),
            '/spo2': (context) => SPO2Screen(isDoctor: isDoctor),
            '/temperature': (context) => TempScreen(isDoctor: isDoctor),
            '/heartrate': (context) => HeartScreen(isDoctor: isDoctor),
            '/ECG': (context) => ECGScreen(isDoctor: isDoctor),
            '/all': (context) => AllinOneScreen(isDoctor: isDoctor),
            '/auth': (context) => AuthScreen()
          },
          home: AuthenticationWrapper(),
          // home: AuthScreen(),
        ),
      );
    });
  }
}
