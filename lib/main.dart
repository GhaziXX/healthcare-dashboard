import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'screens/authentification/auth_screen.dart';
import 'screens/authentification/components/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
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
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => MenuController(),
            )
          ],
          // child: AuthScreen(),
          child: MainScreen(
            isDoctor: false,
          ),
        ),
      );
    });
  }
}
