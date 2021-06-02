import 'package:admin/backend/firebase/authentification_services.dart';
import 'package:admin/backend/firebase/firestore_services.dart';
import 'package:admin/backend/notifiers/auth_notifier.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/models/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:the_validator/the_validator.dart';

import 'profile_input_box.dart';
import 'package:provider/provider.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    Key key,
    @required this.isMobile,
    this.controllers,
    this.labels,
    this.hints,
    this.icons,
    @required this.userData,
  }) : super(key: key);

  final bool isMobile;
  final controllers;
  final labels;
  final hints;
  final icons;
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          !isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (isMobile) SizedBox(height: defaultPadding * 2),
        Text(
          "Profile Info",
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: defaultPadding * 2),
        Center(
            child: buildForm(
          context,
          controllers: controllers,
          labels: labels,
          hints: hints,
          icons: icons,
          isMobile: isMobile,
        )),
      ],
    );
  }

  Form buildForm(BuildContext context,
      {List<TextEditingController> controllers,
      List<String> labels,
      List<String> hints,
      List<IconData> icons,
      bool isMobile}) {
    TextEditingController password = TextEditingController();
    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();
    TextEditingController confirmNewPassword = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Form(
        child: Column(
      mainAxisAlignment:
          !isMobile ? MainAxisAlignment.end : MainAxisAlignment.center,
      crossAxisAlignment:
          !isMobile ? CrossAxisAlignment.end : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 400,
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: labels.length,
            itemBuilder: (BuildContext context, int index) {
              return index != labels.length - 1
                  ? ProfileInputBox(
                      icon: icons[index],
                      value: controllers[index],
                      label: labels[index],
                      hint: hints[index])
                  : ProfileInputBox(
                      icon: icons[index],
                      value: controllers[index],
                      label: labels[index],
                      hint: hints[index],
                      expand: true);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: defaultPadding,
              );
            },
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        !isMobile
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        ResetPasswordForm(
                                formKey: _formKey,
                                oldPassword: oldPassword,
                                newPassword: newPassword,
                                confirmNewPassword: confirmNewPassword,
                                userData: userData)
                            .show(context);
                      },
                      child: Text("Reset password")),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (controllers.length == 7) {
                        NDialog(
                          dialogStyle: DialogStyle(
                              titleDivider: true, backgroundColor: bgColor),
                          title: Text("Please confirm your password"),
                          content: TextFormField(
                            controller: password,
                            validator: FieldValidator.required(),
                            obscureText: true,
                            style:
                                TextStyle(color: Colors.white, fontSize: 8.sp),
                            decoration: InputDecoration(
                              fillColor: secondaryColor,
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Confirm your password",
                              labelText: "Password",
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                          actions: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.save),
                              label: Text("Save"),
                              onPressed: () async {
                                await FirestoreServices().createUser(UserData(
                                    firstName: controllers[0].text,
                                    lastName: controllers[1].text,
                                    age: userData.age,
                                    isDoctor: userData.isDoctor,
                                    description: controllers[6].text,
                                    phoneNumber: controllers[3].text,
                                    gender: userData.gender,
                                    address: controllers[5].text,
                                    id: userData.id,
                                    email: controllers[2].text,
                                    birthdate: userData.birthdate,
                                    speciality: userData.speciality,
                                    gid: userData.gid,
                                    isConnected: true,
                                    emergencyPhoneNumber: controllers[4].text,
                                    officeAddress: "",
                                    officePhoneNumber: "",
                                    otherIds: userData.otherIds));
                                AuthNotifier authNotifier =
                                    context.read<AuthNotifier>();
                                signIn(
                                        email: userData.email,
                                        password: password.text,
                                        authNotifier: authNotifier)
                                    .then((value) {
                                  if (value != 'Signed in') {
                                    SnackbarMessage(
                                      message: value,
                                      icon:
                                          Icon(Icons.error, color: Colors.red),
                                    ).showMessage(
                                      context,
                                    );
                                  } else {
                                    updateEmail(email: controllers[2].text);
                                    Navigator.pop(context);
                                  }
                                });
                              },
                            ),
                            ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                label: Text("Cancel"))
                          ],
                        ).show(context,
                            transitionType: DialogTransitionType.Bubble);
                      } else {
                        NDialog(
                          dialogStyle: DialogStyle(
                              titleDivider: true, backgroundColor: bgColor),
                          title: Text("Please confirm your password"),
                          content: TextFormField(
                            controller: password,
                            validator: FieldValidator.required(),
                            obscureText: true,
                            style:
                                TextStyle(color: Colors.white, fontSize: 8.sp),
                            decoration: InputDecoration(
                              fillColor: secondaryColor,
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Confirm your password",
                              labelText: "Password",
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              //filled: true
                            ),
                          ),
                          actions: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.save),
                              label: Text("Save"),
                              onPressed: () async {
                                await FirestoreServices().createUser(UserData(
                                    firstName: controllers[0].text,
                                    lastName: controllers[1].text,
                                    age: userData.age,
                                    isDoctor: userData.isDoctor,
                                    description: controllers[8].text,
                                    phoneNumber: controllers[3].text,
                                    gender: userData.gender,
                                    address: controllers[6].text,
                                    id: userData.id,
                                    email: controllers[2].text,
                                    birthdate: userData.birthdate,
                                    speciality: userData.speciality,
                                    gid: userData.gid,
                                    isConnected: true,
                                    emergencyPhoneNumber: controllers[4].text,
                                    officeAddress: controllers[7].text,
                                    officePhoneNumber: controllers[6].text,
                                    otherIds: userData.otherIds));
                                AuthNotifier authNotifier =
                                    context.read<AuthNotifier>();
                                signIn(
                                        email: userData.email,
                                        password: password.text,
                                        authNotifier: authNotifier)
                                    .then((value) {
                                  if (value != 'Signed in') {
                                    SnackbarMessage(
                                      message: value,
                                      icon:
                                          Icon(Icons.error, color: Colors.red),
                                    ).showMessage(
                                      context,
                                    );
                                  } else {
                                    updateEmail(email: controllers[2].text);
                                    Navigator.pop(context);
                                  }
                                });
                              },
                            ),
                            ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                label: Text("Cancel"))
                          ],
                        ).show(context,
                            transitionType: DialogTransitionType.Bubble);
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Center(
                      widthFactor: 0.4.w,
                      heightFactor: 0.15.h,
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      elevation: 4,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        ResetPasswordForm(
                                formKey: _formKey,
                                oldPassword: oldPassword,
                                newPassword: newPassword,
                                confirmNewPassword: confirmNewPassword,
                                userData: userData)
                            .show(context);
                      },
                      child: Text("Reset password")),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (controllers.length == 7) {
                        NDialog(
                          dialogStyle: DialogStyle(
                              titleDivider: true, backgroundColor: bgColor),
                          title: Text("Please confirm your password"),
                          content: TextFormField(
                            controller: password,
                            validator: FieldValidator.required(),
                            obscureText: true,
                            style:
                                TextStyle(color: Colors.white, fontSize: 8.sp),
                            decoration: InputDecoration(
                              fillColor: secondaryColor,
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Confirm your password",
                              labelText: "Password",
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              //filled: true
                            ),
                          ),
                          actions: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.save),
                              label: Text("Save"),
                              onPressed: () async {
                                await FirestoreServices().createUser(UserData(
                                    firstName: controllers[0].text,
                                    lastName: controllers[1].text,
                                    age: userData.age,
                                    isDoctor: userData.isDoctor,
                                    description: controllers[6].text,
                                    phoneNumber: controllers[3].text,
                                    gender: userData.gender,
                                    address: controllers[5].text,
                                    id: userData.id,
                                    email: controllers[2].text,
                                    birthdate: userData.birthdate,
                                    speciality: userData.speciality,
                                    gid: userData.gid,
                                    isConnected: true,
                                    emergencyPhoneNumber: controllers[4].text,
                                    officeAddress: "",
                                    officePhoneNumber: "",
                                    otherIds: userData.otherIds));
                                AuthNotifier authNotifier =
                                    context.read<AuthNotifier>();
                                signIn(
                                        email: userData.email,
                                        password: password.text,
                                        authNotifier: authNotifier)
                                    .then((value) {
                                  if (value != 'Signed in') {
                                    SnackbarMessage(
                                      message: value,
                                      icon:
                                          Icon(Icons.error, color: Colors.red),
                                    ).showMessage(
                                      context,
                                    );
                                  } else {
                                    updateEmail(email: controllers[2].text);
                                    Navigator.pop(context);
                                  }
                                });
                              },
                            ),
                            ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                label: Text("Cancel"))
                          ],
                        ).show(context,
                            transitionType: DialogTransitionType.Bubble);
                      } else {
                        NDialog(
                          dialogStyle: DialogStyle(
                              titleDivider: true, backgroundColor: bgColor),
                          title: Text("Please confirm your password"),
                          content: TextFormField(
                            controller: password,
                            validator: FieldValidator.required(),
                            obscureText: true,
                            style:
                                TextStyle(color: Colors.white, fontSize: 8.sp),
                            decoration: InputDecoration(
                              fillColor: secondaryColor,
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Confirm your password",
                              labelText: "Password",
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              //filled: true
                            ),
                          ),
                          actions: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.save),
                              label: Text("Save"),
                              onPressed: () async {
                                await FirestoreServices().createUser(UserData(
                                    firstName: controllers[0].text,
                                    lastName: controllers[1].text,
                                    age: userData.age,
                                    isDoctor: userData.isDoctor,
                                    description: controllers[8].text,
                                    phoneNumber: controllers[3].text,
                                    gender: userData.gender,
                                    address: controllers[6].text,
                                    id: userData.id,
                                    email: controllers[2].text,
                                    birthdate: userData.birthdate,
                                    speciality: userData.speciality,
                                    gid: userData.gid,
                                    isConnected: true,
                                    emergencyPhoneNumber: controllers[4].text,
                                    officeAddress: controllers[7].text,
                                    officePhoneNumber: controllers[6].text,
                                    otherIds: userData.otherIds));
                                AuthNotifier authNotifier =
                                    context.read<AuthNotifier>();
                                signIn(
                                        email: userData.email,
                                        password: password.text,
                                        authNotifier: authNotifier)
                                    .then((value) {
                                  if (value != 'Signed in') {
                                    SnackbarMessage(
                                      message: value,
                                      icon:
                                          Icon(Icons.error, color: Colors.red),
                                    ).showMessage(
                                      context,
                                    );
                                  } else {
                                    updateEmail(email: controllers[2].text);
                                    Navigator.pop(context);
                                  }
                                });
                              },
                            ),
                            ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                label: Text("Cancel"))
                          ],
                        ).show(context,
                            transitionType: DialogTransitionType.Bubble);
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Center(
                      widthFactor: 0.4.w,
                      heightFactor: 0.15.h,
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
      ],
    ));
  }
}

class ResetPasswordForm extends StatelessWidget {
  const ResetPasswordForm({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.oldPassword,
    @required this.newPassword,
    @required this.confirmNewPassword,
    @required this.userData,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController oldPassword;
  final TextEditingController newPassword;
  final TextEditingController confirmNewPassword;
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    show(context);
  }

  void show(BuildContext context) {
    NDialog(
      dialogStyle: DialogStyle(titleDivider: true, backgroundColor: bgColor),
      title: Center(child: Text("Password reset")),
      content: SizedBox(
        height: 200,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: oldPassword,
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
                  obscureText: true,
                  style: TextStyle(color: Colors.white, fontSize: 8.sp),
                  decoration: InputDecoration(
                    fillColor: secondaryColor,
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Enter your current password",
                    labelText: "Current password",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    //filled: true
                  ),
                ),
                SizedBox(height: defaultPadding / 2),
                TextFormField(
                  controller: newPassword,
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
                  obscureText: true,
                  style: TextStyle(color: Colors.white, fontSize: 8.sp),
                  decoration: InputDecoration(
                    fillColor: secondaryColor,
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Enter your new password",
                    labelText: "New password",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    //filled: true
                  ),
                ),
                SizedBox(height: defaultPadding / 2),
                TextFormField(
                  controller: confirmNewPassword,
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
                  obscureText: true,
                  style: TextStyle(color: Colors.white, fontSize: 8.sp),
                  decoration: InputDecoration(
                    fillColor: secondaryColor,
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Please confirm your passeword",
                    labelText: "Confirm password",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    //filled: true
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            label: FittedBox(child: Text("Cancel"))),
        ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                checkSignIn(
                  email: userData.email,
                  password: oldPassword.text,
                ).then((value) {
                  if (value == false) {
                    SnackbarMessage(
                      message: 'Please check your current password',
                      icon: Icon(Icons.error, color: Colors.red),
                    ).showMessage(
                      context,
                    );
                  } else {
                    resetPassword(newPassword.text);
                    Navigator.pop(context);
                  }
                });
              }

              //Navigator.pop(context);
            },
            icon: Icon(
              Icons.refresh,
            ),
            label: FittedBox(child: Text("Reset")))
      ],
    ).show(context, transitionType: DialogTransitionType.Bubble);
    ;
  }
}
