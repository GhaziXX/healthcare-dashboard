import 'package:admin/backend/firebase/firestore_services.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/screens/ScreenArgs.dart';
import 'package:flutter/material.dart';

class PatientList extends StatefulWidget {
  const PatientList({
    @required this.userData,
    Key key,
  }) : super(key: key);

  final UserData userData;

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  @override
  Widget build(BuildContext context) {
    List list = widget.userData.otherIds;
    TextEditingController _addPatient = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("My patients", style: Theme.of(context).textTheme.subtitle1),
            Spacer(),
            Expanded(
              child: TextField(
                controller: _addPatient,
                decoration: InputDecoration(
                    fillColor: secondaryColor,
                    hintText: "Add Patient",
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        FirestoreServices()
                            .addOtherId(
                                currentUserId: widget.userData.id,
                                otherID: _addPatient.text.toString())
                            .then((value) => print("result is $value"));
                      },
                      child: Container(
                        padding: EdgeInsets.all(defaultPadding * 0.5),
                        margin: EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2,
                            vertical: defaultPadding / 2),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Icon(Icons.add),
                      ),
                    )),
              ),
            )
          ],
        ),
        SizedBox(height: defaultPadding),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: double.infinity,
                  child: DataTable(
                      columnSpacing: defaultPadding,
                      horizontalMargin: 0,
                      columns: [
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Gadget")),
                      ],
                      rows: List.generate(
                        list.length,
                        (index) => realtimeGraphDataRow(list[index], widget.userData,context),
                      )))
            ],
          ),
        ),
      ],
    );
  }
}

DataRow realtimeGraphDataRow(String uid,UserData userData,BuildContext context) {
  UserData patientData;
  FirestoreServices().getUserData(uid :uid).then((value) => patientData = value);
  return DataRow(cells: [
    DataCell(
      FutureBuilder(
          future: FirestoreServices().getUserData(uid: uid),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Text(
                        snapshot.data.firstName + ' ' + snapshot.data.lastName),
                  )
                ],
              );
            }
            return Text("No Available Patients");
          }),
      onTap: () {
        Navigator.pushNamed(context, '/patientInfo',
            arguments: ScreenArguments(true, userData, patientData,null, null));
      },
    ),
    DataCell(
      FutureBuilder(
          future: FirestoreServices().getUserData(uid: uid),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Text(snapshot.data.gid);
            }
            return Container();
          }),
    )
  ]);
}