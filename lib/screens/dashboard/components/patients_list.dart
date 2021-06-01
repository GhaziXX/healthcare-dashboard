import 'package:admin/constants/constants.dart';
import 'package:admin/models/RealtimeGraph.dart';
import 'package:flutter/material.dart';

class PatientList extends StatelessWidget {
  const PatientList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment : CrossAxisAlignment.start,
      children: [
        Text(
          "My patients",
          style: Theme.of(context).textTheme.subtitle1,
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
                    patientsList.length,
                    (index) => realtimeGraphDataRow(patientsList[index], context),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

DataRow realtimeGraphDataRow(Patients graph, BuildContext context) {
  return DataRow(cells: [
    DataCell(
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(graph.title),
          )
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, graph.route);
      },
    ),
    DataCell(Text(graph.details)),
  ]);
}
