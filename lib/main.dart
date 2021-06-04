import 'package:admin/backend/notifiers/auth_notifier.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/screens/Doctor/doctorInfo.dart';
import 'package:admin/screens/Patients/infos.dart';
import 'package:admin/screens/Patients/patientDetails.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/screens/measures/realtime/all_in_one.dart';
import 'package:admin/screens/measures/filters/temperature_filter_screen.dart';
import 'package:admin/screens/measures/realtime/stress_screen.dart';
import 'package:admin/screens/measures/realtime/tempgraph_screen.dart';
import 'package:admin/screens/profile/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'backend/firebase/firestore_services.dart';
import 'models/data_models/UserData.dart';
import 'screens/authentification/auth_screen.dart';
import 'screens/measures/filters/all_in_one_filter_screen.dart';
import 'screens/measures/realtime/ecg_screen.dart';
import 'screens/measures/filters/heartrate_filter_screen.dart';
import 'screens/measures/realtime/heartrate_screen.dart';
import 'screens/measures/filters/spo2_filter_screen.dart';
import 'screens/measures/realtime/spo2_screen.dart';
import 'screens/measures/filters/stress_filter_screen.dart';
import 'screens/measures/realtime/temperature_screen.dart';

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

bool isDoctor = true;
UserData userData;

class _MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthNotifier(),
        ),
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
          '/mainScreen': (context) => MainScreen(
                isDoctor: isDoctor,
                userData: userData,
              ),
          '/spo2': (context) => SPO2Screen(),
          '/temperature': (context) => TempScreen(),
          '/heartrate': (context) => HeartScreen(),
          '/ECG': (context) => ECGScreen(),
          '/tempGraph': (context) => TempGraphScreen(),
          '/stress' : (context) => StressScreen(),
          '/all': (context) => AllinOneScreen(),
          '/auth': (context) => AuthScreen(),
          '/allFilter': (context) => AllinOneFilterScreen(),
          '/filteredTemperature': (context) => TemperatureFilterScreen(),
          '/filteredSpo2': (context) => Spo2FilterScreen(),
          '/filteredStress': (context) => StressFilterScreen(),
          '/filteredHeartrate': (context) => HeartrateFilterScreen(),
          '/profile': (context) => ProfileScreen(),
          '/patientDetails' : (context) => PatientDetails(),
          '/patientInfo' : (context) => PatientInfo(),
          '/doctorInfo' : (context) => DoctorInfo(),

        },
        home:
            //FilterCard(),
            Consumer<AuthNotifier>(
          builder: (context, notifier, child) {
            //print("el notif rahi ${notifier.user}");
            if (notifier.user != null) {
              //print(notifier.user);
              return FutureBuilder(
                future: FirestoreServices().getCurrentUser(notifier.user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    UserData userData = snapshot.data;
                    //print(userData.id);
                    return ResponsiveSizer(
                        builder: (context, orientation, screenType) {
                      return MainScreen(
                        isDoctor: userData.isDoctor,
                        userData: userData,
                      );
                    });
                  } else if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return ResponsiveSizer(
                        builder: (context, orientation, screenType) {
                      return MainScreen(
                        isDoctor: false,
                        userData: UserData(
                            firstName: "Not Specified", id: notifier.user.uid),
                      );
                    });
                  }
                  return Container(color: bgColor);
                },
              );
            }
            return ResponsiveSizer(builder: (context, orientation, screenType) {
              return AuthScreen();
            });
          },
        ),
      ),
    );
  }
}
