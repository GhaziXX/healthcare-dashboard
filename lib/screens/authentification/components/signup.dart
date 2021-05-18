import 'package:admin/backend/firebase/authentification_services.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/models/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_validator/the_validator.dart';
import '../../../responsive.dart';
import 'action_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  final Function onLoginSelected;
  final Function onCompleteProfileSelected;

  Signup(
      {@required this.onLoginSelected,
      @required this.onCompleteProfileSelected});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordEmpty = true;
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordEmpty = true;
  bool _isConfirmPasswordObscure = true;

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
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
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
                        "Signup",
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
                          press: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              context
                                  .read<AuthenticationServices>()
                                  .signUp(
                                      email: _emailController.text,
                                      password: _passwordController.text)
                                  .then((value) {
                                if (value == 'Signed Up') {
                                  widget.onCompleteProfileSelected();
                                } else {
                                  SnackbarMessage(
                                    message: value,
                                    icon: Icon(Icons.error, color: Colors.red),
                                  ).showMessage(
                                    context,
                                  );
                                }
                                context.read<User>();
                              });
                            }
                          },
                          title: 'Register'),
                      SizedBox(
                        height: 32,
                      ),
                      Responsive(
                        desktop: GoToLogin(
                          widget: widget,
                          textSize: 7,
                        ),
                        mobile: GoToLogin(
                          widget: widget,
                          textSize: _size.width < 500 ? 9 : 7,
                        ),
                        tablet: GoToLogin(
                          widget: widget,
                          textSize: 7,
                        ),
                      ),
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
            keyboardType: TextInputType.emailAddress,
            validator: FieldValidator.email(),
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
            decoration: const InputDecoration(
              //filled: true,
              labelText: "Email",
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          TextFormField(
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
            controller: _passwordController,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _isPasswordEmpty = false;
                });
              } else {
                setState(() {
                  _isPasswordEmpty = true;
                });
              }
            },
            obscureText: _isPasswordObscure,
            validator: FieldValidator.password(
                minLength: 6,
                shouldContainNumber: true,
                shouldContainCapitalLetter: true,
                shouldContainSmallLetter: true,
                shouldContainSpecialChars: true,
                errorMessage: "Password must match the required format",
                onNumberNotPresent: () {
                  return "Password must contain number";
                },
                onSpecialCharsNotPresent: () {
                  return "Password must contain special characters";
                },
                onCapitalLetterNotPresent: () {
                  return "Password must contain capital letters";
                }),
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock_outline),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: !_isPasswordEmpty
                  ? IconButton(
                      icon: _isPasswordObscure
                          ? Icon(
                              Icons.visibility,
                            )
                          : Icon(Icons.visibility_off),
                      splashRadius: 0.2,
                      color: Colors.grey,
                      onPressed: () {
                        setState(() {
                          _isPasswordObscure = !_isPasswordObscure;
                        });
                      },
                    )
                  : null,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          TextFormField(
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _isConfirmPasswordEmpty = false;
                });
              } else {
                setState(() {
                  _isConfirmPasswordEmpty = true;
                });
              }
            },
            controller: _confirmPasswordController,
            obscureText: _isConfirmPasswordObscure,
            validator: FieldValidator.equalTo(_passwordController,
                message: "Password Mismatch"),
            decoration: InputDecoration(
              labelText: "Re-enter password",
              prefixIcon: Icon(Icons.lock_outline),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: !_isConfirmPasswordEmpty
                  ? IconButton(
                      icon: _isConfirmPasswordObscure
                          ? Icon(
                              Icons.visibility,
                            )
                          : Icon(Icons.visibility_off),
                      splashRadius: 0.2,
                      color: Colors.grey,
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordObscure =
                              !_isConfirmPasswordObscure;
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

class GoToLogin extends StatelessWidget {
  const GoToLogin({Key key, @required this.widget, @required this.textSize})
      : super(key: key);

  final Signup widget;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(
            color: Colors.white,
            fontSize: textSize.sp,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: () {
            widget.onLoginSelected();
          },
          child: Row(
            children: [
              Text(
                "Login",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: textSize.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.arrow_forward,
                color: primaryColor,
                size: 10.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
