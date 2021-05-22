import 'package:admin/backend/firebase/authentification_services.dart';
import 'package:admin/backend/firebase/firestore_services.dart';
import 'package:admin/backend/notifiers/auth_notifier.dart';
import 'package:admin/models/DoctorsCat.dart';
import 'package:admin/models/UserData.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:jiffy/jiffy.dart';
import 'package:the_validator/the_validator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../responsive.dart';
import 'action_button.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key key, this.address, this.password})
      : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
  final String address;
  final String password;
}

class _CompleteProfileState extends State<CompleteProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();

  TextEditingController _doctorBioController = TextEditingController();

  String _age;
  String _doctorType;
  String _gender;
  bool _isDoctor = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: Responsive.isMobile(context)
                ? _size.height
                : _size.height *
                    (_size.height > 770
                        ? 0.7
                        : _size.height > 670
                            ? 0.7
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
                        "Complete your profile",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
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
                      _completeProfileForm(),
                      SizedBox(
                        height: 10,
                      ),
                      ActionButton(
                          title: "Finish",
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              AuthNotifier authNotifier =
                                  context.read<AuthNotifier>();

                              await FirestoreServices().createUser(UserData(
                                  firstName: _nameController.text,
                                  lastName: _lastController.text,
                                  age: _age,
                                  isDoctor: _isDoctor,
                                  description: _isDoctor
                                      ? _doctorBioController.text
                                      : null,
                                  phoneNumber: _phoneController.text,
                                  gender: _gender,
                                  address: _addressController.text,
                                  id: authNotifier.user.uid,
                                  email: authNotifier.user.email,
                                  birthdate: _birthdateController.text,
                                  speciality: _doctorType));
                              notifyUser(authNotifier);
                              //Navigator.of(context).pushNamed("/mainScreen");
                            }
                          }),
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

  Form _completeProfileForm() {
    return Form(
      key: _formKey,
      child: _defaultForm(),
    );
  }

  Column _defaultForm() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.name,
          controller: _nameController,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
          validator:
              FieldValidator.required(message: "Please enter your first name"),
          decoration: const InputDecoration(
            labelText: "First name",
            prefixIcon: Icon(Icons.perm_identity),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        TextFormField(
          keyboardType: TextInputType.name,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
          controller: _lastController,
          validator:
              FieldValidator.required(message: "Please enter your last name"),
          decoration: const InputDecoration(
            labelText: "Last name",
            prefixIcon: Icon(
              Icons.perm_identity,
            ),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        TextFormField(
          controller: _phoneController,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
          keyboardType: TextInputType.phone,
          validator: FieldValidator.phone(
              message: "Please enter a valid phone number"),
          decoration: const InputDecoration(
            labelText: "Phone number",
            prefixIcon: Icon(
              Icons.phone,
            ),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        TextFormField(
          controller: _addressController,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
          keyboardType: TextInputType.streetAddress,
          validator: FieldValidator.required(
              message: "Please enter your street address"),
          decoration: const InputDecoration(
            labelText: "Street address",
            prefixIcon: Icon(
              Icons.location_city,
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        DateTimePicker(
          type: DateTimePickerType.date,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
          firstDate: DateTime(1930),
          lastDate: DateTime.now(),
          controller: _birthdateController,
          decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today),
            hintText: 'Enter your birth date',
            labelText: 'Birth Date',
          ),
          dateLabelText: 'Birth Date',
          validator: (date) =>
              (date == null || _birthdateController.text.isEmpty)
                  ? 'Please enter your birth date'
                  : null,
          onChanged: (val) {
            _age = Jiffy(val).fromNow().split(" ").sublist(0, 2).join(" ");
            //print(_age);
          },
          onSaved: (val) {
            _age = Jiffy(val).fromNow().split(" ").sublist(0, 2).join(" ");
          },
        ),
        SizedBox(
          height: 24,
        ),
        FastDropdown(
          autovalidateMode: AutovalidateMode.disabled,
          id: "1",
          items: ["Male", "Female"],
          dropdownColor: secondaryColor,
          onSaved: (newValue) => _gender = newValue,
          validator: (value) {
            if (value == null) return "Please specify your gender";
            return null;
          },
          onChanged: (newValue) => _gender = newValue,
          decoration: InputDecoration(
            labelText: "Gender",
            hintText: "Select your gender",
            hintStyle: TextStyle(color: Colors.white, fontSize: 10.sp),
            labelStyle: TextStyle(color: Colors.white, fontSize: 10.sp),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        CheckboxListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 1.w),
            value: _isDoctor,
            title: Text(
              "I am a doctor",
              style: TextStyle(color: Colors.white, fontSize: 10.sp),
            ),
            checkColor: secondaryColor,
            onChanged: (value) {
              setState(() {
                _isDoctor = !_isDoctor;
              });
            }),
        SizedBox(
          height: 4,
        ),
        if (_isDoctor)
          FastDropdown(
            autovalidateMode: AutovalidateMode.disabled,
            id: "specialization",
            items: doctorsTypes.map((e) => e.title).toList(),
            dropdownColor: bgColor,
            onSaved: (newValue) => _doctorType = newValue,
            validator: (value) {
              if (value == null) return "Please select your specialization";
              return null;
            },
            onChanged: (newValue) => _doctorType = newValue,
            decoration: InputDecoration(
              labelText: "Specialization",
              hintText: "Select your specialization",
              hintStyle: TextStyle(color: Colors.white, fontSize: 10.sp),
              labelStyle: TextStyle(color: Colors.white, fontSize: 10.sp),
            ),
          ),
        SizedBox(
          height: 10,
        ),
        _isDoctor
            ? SizedBox(
                height: 300,
                child: TextFormField(
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                  keyboardType: TextInputType.multiline,
                  controller: _doctorBioController,
                  maxLines: 99,
                  maxLength: 1000,
                  validator: FieldValidator.required(
                      message: "Please enter a short description"),
                  decoration: const InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
              )
            : SizedBox(
                height: 10,
              ),
      ],
    );
  }
}
