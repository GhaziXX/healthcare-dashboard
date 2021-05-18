import 'package:admin/models/RealtimeGraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/constants.dart';

class RealtimeGraphs extends StatelessWidget {
  const RealtimeGraphs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Realtime Graphs",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: defaultPadding),

              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: defaultPadding,
                  horizontalMargin: 0,
                  columns: [
                    DataColumn(
                        label: Text("Graph name", textAlign: TextAlign.center)),
                    // DataColumn(
                    //     label: Text("Details", textAlign: TextAlign.center)),
                  ],
                  rows: List.generate(
                    realtimeGraphs.length,
                    (index) =>
                        realtimeGraphDataRow(realtimeGraphs[index], context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

DataRow realtimeGraphDataRow(RealtimeGraph graph, BuildContext context) {
  return DataRow(cells: [
    DataCell(
      Row(
        children: [
          SvgPicture.asset(
            graph.icon,
            height: 30,
            width: 30,
            color: Colors.white,
          ),
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
    // DataCell(Text(graph.details)),
  ]);
}
