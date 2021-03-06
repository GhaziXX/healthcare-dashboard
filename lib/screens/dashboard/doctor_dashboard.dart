import 'package:admin/backend/firebase/firestore_services.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../constants/constants.dart';
import 'components/header.dart';
import 'components/my_patients.dart';
import 'components/patients_list.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({
    Key key,
    @required this.isDoctor,
    @required this.userData,
  }) : super(key: key);

  final bool isDoctor;
  final UserData userData;

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  List<dynamic> patientsList = [];

  @override
  void initState() {
    super.initState();
    patientsList = widget.userData.otherIds;
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return SafeArea(
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(defaultPadding),
          child: StickyHeader(
            header: Header(
              isDoctor: widget.isDoctor,
              userData: widget.userData,
            ),
            content: Column(
              children: [
                SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          MyPatients(
                            isDoctor: widget.isDoctor,
                            userData: widget.userData,
                            patientsList: patientsList,
                          ),
                          SizedBox(height: defaultPadding),
                          PatientList(
                            userData: widget.userData,
                            patientsList: patientsList,
                            onPressed: (value) {
                              setState(() {
                                if (!patientsList.contains(value))
                                  patientsList.add(value);
                              });
                            },
                            onRemove: (value) {
                              setState(() {
                                patientsList.remove(value);
                                FirestoreServices()
                                    .deleteIdInOthersId(
                                        currentId: widget.userData.id,
                                        otherId: value)
                                    .then((value) => print(value));
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
