import 'package:admin/models/RealtimeGraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class RealtimeGraphs extends StatelessWidget {
  const RealtimeGraphs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Realtime Graphs",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              horizontalMargin: 0,
              columns: [
                DataColumn(label: Text("Graph name")),
                DataColumn(label: Text("Details")),
              ],
              rows: List.generate(
                realtimeGraphs.length,
                (index) => realtimeGraphDataRow(realtimeGraphs[index]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

DataRow realtimeGraphDataRow(RealtimeGraph graph) {
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
    ),
    DataCell(Text(graph.details)),
  ]);
}
