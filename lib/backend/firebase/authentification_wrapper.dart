// import 'package:admin/backend/firebase/firestore_services.dart';
// import 'package:admin/models/UserData.dart';
// import 'package:admin/screens/authentification/auth_screen.dart';
// import 'package:admin/screens/main/main_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AuthenticationWrapper extends StatefulWidget {
//   AuthenticationWrapper({
//     Key key,
//   }) : super(key: key);

//   @override
//   _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
// }

// class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
//   User firebaseUser;

//   @override
//   void initState() {
//     super.initState();

//     firebaseUser = context.read<User>();
//     print("user fe state $firebaseUser");
//   }

//   @override
//   Widget build(BuildContext context) {
//     firebaseUser = context.watch<User>();
//     print(firebaseUser);
//     if (firebaseUser != null) {
//       return FutureBuilder(
//         future: FirestoreServices().getCurrentUser(firebaseUser.uid),
//         builder: (context, snapshot) {
//           print("ena fel builder");
//           if (snapshot.hasData) {
//             UserData data = snapshot.data;

//             return MainScreen(
//               isDoctor: data.isDoctor,
//               userData: data,
//             );
//           } else {
//             print("famech data");
//           }
//           return AuthScreen();
//         },
//       );
//       //return MainScreen(isDoctor: true);
//     }
//     //print("hna");
//     return AuthScreen();
//   }
// }
