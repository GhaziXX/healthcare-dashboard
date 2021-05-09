import 'package:admin/constants.dart';
import 'package:admin/screens/authentification/components/complete_profile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../responsive.dart';
import 'components/login.dart';
import 'components/signup.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Option selectedOption = Option.Login;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    print(_size.width);
    return Scaffold(
      body: Container(
        width: _size.width,
        height: _size.height,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: _size.width / 2,
                  color: bgColor,
                ),
                Container(
                    height: double.infinity,
                    width: _size.width / 2,
                    color: bgColor),
              ],
            ),
            if (_size.width > 914)
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (_size.width > 914)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Let's Get Started !",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Please login to monitor your state,",
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6.sp,
                        ),
                      ),
                      Text(
                        'If you are new register a free account!',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6.sp,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (widget, animation) => RotationTransition(
                turns: animation,
                child: widget,
              ),
              switchOutCurve: Curves.easeInOutCubic,
              switchInCurve: Curves.fastLinearToSlowEaseIn,
              //child: CompleteProfile(),
              child: screen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget screen() {
    if (selectedOption == Option.Login) {
      return Login(
        onSignUpSelected: () {
          setState(() {
            selectedOption = Option.Signup;
          });
        },
      );
    } else if (selectedOption == Option.Signup) {
      return Signup(
        onLoginSelected: () {
          setState(() {
            selectedOption = Option.Login;
          });
        },
        onCompleteProfileSelected: () {
          setState(() {
            selectedOption = Option.CompleteProfile;
          });
        },
      );
    } else {
      return CompleteProfile();
    }
  }
}

enum Option { Login, Signup, CompleteProfile }
