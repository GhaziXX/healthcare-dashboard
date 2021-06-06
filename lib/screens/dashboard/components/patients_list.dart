import 'package:admin/backend/firebase/firestore_services.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/ScreenArgs.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientList extends StatefulWidget {
  const PatientList({
    @required this.userData,
    Key key,
    this.onPressed,
    @required this.patientsList,
    @required this.onRemove,
  }) : super(key: key);

  final UserData userData;
  final Function(String) onPressed;
  final List<dynamic> patientsList;
  final Function(String) onRemove;

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _patientId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("My patients", style: Theme.of(context).textTheme.subtitle1),
            Spacer(),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(defaultPadding * 0.5),
                margin: EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2,
                    vertical: defaultPadding / 2),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: !Responsive.isMobile(context)
                    ? Row(
                        children: [Icon(Icons.add), Text('Add Patient')],
                      )
                    : Icon(Icons.add),
              ),
              onTap: () {
                NDialog(
                  dialogStyle:
                      DialogStyle(titleDivider: true, backgroundColor: bgColor),
                  title: Center(child: Text("Add a patient")),
                  content: TextFormField(
                    controller: _patientId,
                    style: TextStyle(color: Colors.white, fontSize: 8.sp),
                    decoration: InputDecoration(
                      fillColor: secondaryColor,
                      prefixIcon: Icon(Icons.fingerprint),
                      hintText: "Please enter your patient ID",
                      labelText: "PatientID",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      //filled: true
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
                      label: Text("Cancel"),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          String id = "";
                          FirestoreServices()
                              .getUserId(
                                  first4: _patientId.text.substring(0, 4),
                                  gid: _patientId.text.substring(4))
                              .then((value) {
                            id = value;
                            FirestoreServices()
                                .addOtherId(
                                    currentUserId: widget.userData.id,
                                    otherID: value)
                                .then((value) {
                              setState(() {
                                widget.onPressed(id);
                              });
                            });
                          });

                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.add_circle,
                        ),
                        label: Text("Add"))
                  ],
                ).show(context, transitionType: DialogTransitionType.Bubble);
              },
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
              width: double.infinity,
              child: widget.patientsList != null
                  ? DataTable(
                      sortColumnIndex: 0,
                      sortAscending: true,
                      columnSpacing: defaultPadding,
                      horizontalMargin: 0,
                      columns: [
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Gadget")),
                      ],
                      rows: widget.patientsList.length == 0
                          ? [
                              DataRow(cells: [
                                DataCell(
                                  Text("No Available patients"),
                                ),
                                DataCell(Container()),
                              ])
                            ]
                          : List.generate(
                              widget.patientsList.length,
                              (index) => patientDataRow(
                                widget.patientsList[index],
                                widget.userData,
                                context,
                                widget.onRemove,
                              ),
                            ),
                    )
                  : DataTable(
                      columnSpacing: defaultPadding,
                      horizontalMargin: 0,
                      columns: [
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Gadget")),
                        ],
                      rows: [
                          DataRow(cells: [
                            DataCell(
                              Text("No Available patients"),
                            ),
                            DataCell(Container()),
                          ])
                        ])),
        ),
      ],
    );
  }
}

DataRow patientDataRow(
  String uid,
  UserData userData,
  BuildContext context,
  Function(String) onRemove,
) {
  UserData patientData;
  FirestoreServices()
      .getUserData(uid: uid)
      .then((value) => patientData = value);
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
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Text("No Available Patients");
            }
            return CircularProgressIndicator();
          }),
      onTap: () {
        Navigator.pushNamed(context, '/patientInfo',
            arguments:
                ScreenArguments(true, userData, patientData, null, null));
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
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Text("No Available Patients");
            }
            return CircularProgressIndicator();
            //return Container();
          }),
      onTap: () {
        Navigator.pushNamed(context, '/patientInfo',
            arguments:
                ScreenArguments(true, userData, patientData, null, null));
      },
      //onLongPress: () {
      //   NDialog(
      //     dialogStyle: DialogStyle(titleDivider: true, backgroundColor: bgColor),
      //     title: Center(child: Text("Remove a patient")),
      //     content: Text("Are you sure?"),
      //     actions: [
      //       ElevatedButton.icon(
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //         icon: Icon(
      //           Icons.cancel,
      //           color: Colors.red,
      //         ),
      //         label: Text("Cancel"),
      //       ),
      //       ElevatedButton(
      //           onPressed: () {
      //             onRemove(patientData.id);
      //             Navigator.pop(context);
      //           },
      //           child: Text("Yes"))
      //     ],
      //   ).show(context, transitionType: DialogTransitionType.Bubble);
      // }
    ),
  ]);
}
