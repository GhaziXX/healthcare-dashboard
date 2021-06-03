import 'package:admin/backend/firebase/firestore_services.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/models/data_models/UserData.dart';import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class MyPatients extends StatelessWidget {
  const MyPatients({
    @required this.isDoctor,
    @required this.userData,
    Key key,
  }) : super(key: key);
  final bool isDoctor;
  final UserData userData;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "General",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: defaultPadding),
        Responsive(
            mobile: PatientInfoCardGridView(
              isDoctor: isDoctor,
              userData: userData,
              childAspectRatio: 2,
            ),
            tablet: PatientInfoCardGridView(
                userData: userData, isDoctor: isDoctor, childAspectRatio: 3),
            desktop: PatientInfoCardGridView(
              isDoctor: isDoctor,
              userData: userData,
              childAspectRatio: 4,
            ))
      ],
    );
  }
}

class PatientInfoCardGridView extends StatefulWidget {
  const PatientInfoCardGridView({
    Key key,
    this.childAspectRatio = 1,
    @required this.userData,
    @required this.isDoctor,
  }) : super(key: key);

  final double childAspectRatio;
  final UserData userData;
  final bool isDoctor;

  @override
  _PatientInfoCardGridViewState createState() =>
      _PatientInfoCardGridViewState();
}

class _PatientInfoCardGridViewState extends State<PatientInfoCardGridView> {

  List patientsList(UserData userData) {
    List list = [];
    if (userData.otherIds != null){
      userData.otherIds.forEach((user) {
        list.add(FirestoreServices().getUserData(uid: user));
      });
    }
    return list;
  }
  int onlinePatient(UserData userData) {
    List<UserData> list = [];
    int onlineNbre =0;
    if (userData.otherIds != null){
      FirestoreServices().getUsersData(uid: userData.otherIds).then((value) => list = value);
      list.forEach((element) {
        if (element.isConnected) onlineNbre++;
      });
    }
    return onlineNbre;
  }
  @override
  Widget build(BuildContext context) {
    List list = patientsList(widget.userData);
    return GridView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: defaultPadding,
            mainAxisSpacing: defaultPadding,
            childAspectRatio: widget.childAspectRatio),
        children: [
          Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(defaultPadding * 0.5),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/patient.svg",
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FittedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: !Responsive.isMobile(context) ?
                        Text(
                          "Total Patients",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ):
                        Text(
                          "Total\nPatients",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      list.isNotEmpty ? Text(list.length.toString(),style :TextStyle(fontSize: 20))
                          :Text("0",style :TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(defaultPadding * 0.5),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/communication.svg",
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FittedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: !Responsive.isMobile(context)? Text(
                          "Online Patients",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis
                        ):
                        Text(
                            "Online\nPatients",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                      Text("0",style :TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]);
  }
}
