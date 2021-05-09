import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:the_validator/the_validator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../responsive.dart';
import 'action_button.dart';

class Login extends StatefulWidget {
  final Function onSignUpSelected;

  Login({@required this.onSignUpSelected});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPassEmpty = true;
  bool _isObscurePass = true;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(_size.height > 770
          ? 64
          : _size.height > 670
              ? 24
              : 16),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: Responsive.isMobile(context)
                ? _size.height *
                    (_size.height > 770
                        ? 0.7
                        : _size.height > 670
                            ? 0.7
                            : 0.9)
                : _size.height *
                    (_size.height > 770
                        ? 0.7
                        : _size.height > 670
                            ? 0.8
                            : 0.9),
            width: Responsive.isMobile(context) && _size.width < 500
                ? _size.width
                : 60.w,
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login",
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: Colors.white, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 30,
                        child: Divider(
                          color: primaryColor,
                          thickness: 2,
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      _loginForm(),
                      SizedBox(
                        height: 32,
                      ),
                      ActionButton(
                          title: "Login",
                          press: () {
                            _formKey.currentState.validate();
                          }),
                      SizedBox(height: 32),
                      Responsive(
                          mobile: GoToRegister(
                            widget: widget,
                            textSize: _size.width < 500 ? 9 : 7,
                          ),
                          desktop: GoToRegister(
                            widget: widget,
                            textSize: 7,
                          ),
                          tablet: GoToRegister(
                            widget: widget,
                            textSize: 7,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: FieldValidator.email(),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
            decoration: const InputDecoration(
              // filled: true,
              labelText: "Email",
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          TextFormField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _isPassEmpty = false;
                });
              } else {
                setState(() {
                  _isPassEmpty = true;
                });
              }
            },
            controller: _passwordController,
            obscureText: _isObscurePass,
            validator: FieldValidator.password(
              minLength: 6,
              maxLength: 12,
              shouldContainNumber: true,
              shouldContainCapitalLetter: true,
              shouldContainSmallLetter: true,
              shouldContainSpecialChars: true,
            ),
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock_outline),
              //filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: !_isPassEmpty
                  ? IconButton(
                      icon: _isObscurePass
                          ? Icon(
                              Icons.visibility,
                            )
                          : Icon(Icons.visibility_off),
                      splashRadius: 0.2,
                      color: Colors.grey,
                      onPressed: () {
                        setState(() {
                          _isObscurePass = !_isObscurePass;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class GoToRegister extends StatelessWidget {
  const GoToRegister({
    Key key,
    @required this.widget,
    @required this.textSize,
  }) : super(key: key);

  final Login widget;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account yet?",
          style: TextStyle(color: Colors.white, fontSize: textSize.sp),
        ),
        SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: () {
            widget.onSignUpSelected();
          },
          child: Row(
            children: [
              Text(
                "Signup",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: textSize.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.arrow_forward,
                color: primaryColor,
                size: 10.sp,
              )
            ],
          ),
        )
      ],
    );
  }
}
