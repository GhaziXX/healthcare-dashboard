import 'package:admin/screens/authentification/auth_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firestore_services.dart';


class AuthenticationWrapper extends StatelessWidget {
  AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return MainScreen(isDoctor: true);
      //return MainScreen(isDoctor: true);
    }
    return AuthScreen();
  }
}
