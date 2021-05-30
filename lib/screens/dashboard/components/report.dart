import 'package:admin/api/api_services.dart';
import 'package:admin/models/data_models/APIData.dart';
import 'package:admin/models/data_models/GeneralReadingData.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/tldr_filter_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'package:admin/constants/constants.dart';

import 'clear_button.dart';
import 'custom_date_range_selector.dart';
import 'custom_time_range_selector.dart';
import 'month_dropdown.dart';

class Report extends StatefulWidget {
  const Report({
    Key key,
    @required this.userData,
  }) : super(key: key);

  final UserData userData;

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  ValueNotifier<DateTimeRange> _dateRangeNotifier =
      ValueNotifier(DateTimeRange(start: DateTime.now(), end: DateTime.now()));
  ValueNotifier<TimeRange> _timeRangeNotifier = ValueNotifier(
      TimeRange(startTime: TimeOfDay.now(), endTime: TimeOfDay.now()));
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  Future<APIData> responseData;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Report",
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
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Filter(
                        dateRangeNotifier: _dateRangeNotifier,
                        timeRangeNotifier: _timeRangeNotifier,
                        timeController: _timeController,
                        dateController: _dateController,
                        gid: widget.userData.gid,
                        onChanged: (data) {
                          setState(() {
                            responseData = data;
                          });
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        if (responseData != null)
          FutureBuilder<APIData>(
            future: responseData,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("error is ${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Responsive(
                    mobile: GraphTLDRFilterCardGridView(
                      crossAxisCount: _size.width < 650 ? 2 : 4,
                      childAspectRatio: _size.width < 650 ? 1.3 : 1,
                      apiData: snapshot.data,
                    ),
                    tablet: GraphTLDRFilterCardGridView(
                      apiData: snapshot.data,
                    ),
                    desktop: GraphTLDRFilterCardGridView(
                      apiData: snapshot.data,
                      childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
                    ));
              }
              return Responsive(
                  mobile: GraphTLDRFilterCardGridView(
                    crossAxisCount: _size.width < 650 ? 2 : 4,
                    childAspectRatio: _size.width < 650 ? 1.3 : 1,
                    child: Container(
                      padding: EdgeInsets.all(defaultPadding / 2),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  tablet: GraphTLDRFilterCardGridView(
                    child: Container(
                      padding: EdgeInsets.all(defaultPadding / 2),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  desktop: GraphTLDRFilterCardGridView(
                    childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
                    child: Container(
                      padding: EdgeInsets.all(defaultPadding / 2),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ));
            },
          )
      ],
    );
  }
}

class GraphTLDRFilterCardGridView extends StatefulWidget {
  const GraphTLDRFilterCardGridView({
    Key key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.child,
    this.apiData,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final APIData apiData;
  final Widget child;

  @override
  _GraphTLDRFilterCardGridViewState createState() =>
      _GraphTLDRFilterCardGridViewState();
}

class _GraphTLDRFilterCardGridViewState
    extends State<GraphTLDRFilterCardGridView> {
  List<String> filterGraphs = ['Temperature', 'SPO2', 'Stress', 'Heartrate'];
  List<GeneralReadingData> filterData = [];

  @override
  Widget build(BuildContext context) {
    if (widget.child == null)
      filterData = [
        widget.apiData.temperature,
        widget.apiData.spo2,
        widget.apiData.stress,
        widget.apiData.heartrate
      ];
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            crossAxisSpacing: defaultPadding,
            mainAxisSpacing: defaultPadding,
            childAspectRatio: widget.childAspectRatio),
        itemBuilder: (context, index) => widget.child != null
            ? widget.child
            : TLDRFiltercard(
                data: filterData[index],
                title: filterGraphs[index],
              ));
  }
}

class Filter extends StatefulWidget {
  const Filter({
    Key key,
    @required this.dateRangeNotifier,
    @required this.timeRangeNotifier,
    @required this.timeController,
    @required this.dateController,
    @required this.gid,
    @required this.onChanged,
  }) : super(key: key);

  final ValueNotifier<DateTimeRange> dateRangeNotifier;
  final ValueNotifier<TimeRange> timeRangeNotifier;
  final TextEditingController timeController;
  final TextEditingController dateController;
  final String gid;
  final Function(Future<APIData>) onChanged;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String startDate, endDate, startTime, endTime;
  GlobalKey<FormFieldState> dropdownKey;
  @override
  Widget build(BuildContext context) {
    if (!Responsive.isMobile(context))
      return Row(
        children: [
          MonthDropdown(
            onClicked: (start, end, key) {
              startDate = start;
              endDate = end;
              dropdownKey = key;
              widget.timeController.clear();
              widget.dateController.clear();
              final _future = APIServices().fetchData(
                  startDate: startDate,
                  gid: widget.gid,
                  endDate: endDate,
                  startTime: startTime,
                  endTime: endTime);
              widget.onChanged(_future);
            },
          ),
          SizedBox(
            width: defaultPadding,
          ),
          CustomDateRangeSelector(
            dateRangeNotifier: widget.dateRangeNotifier,
            dateController: widget.dateController,
            onClicked: (start, end) async {
              startDate = start;
              endDate = end;
              if (dropdownKey != null) {
                dropdownKey.currentState.reset();
              }
              final _future = APIServices().fetchData(
                  startDate: startDate,
                  gid: widget.gid,
                  endDate: endDate,
                  startTime: startTime,
                  endTime: endTime);
              widget.onChanged(_future);
              //.then((value) => onChanged(value));
            },
          ),
          SizedBox(
            width: defaultPadding,
          ),
          CustomTimeRangeSelector(
            timeRangeNotifier: widget.timeRangeNotifier,
            timeController: widget.timeController,
            onClicked: (start, end) {
              startTime = start;
              endTime = end;
              if (dropdownKey != null) {
                dropdownKey.currentState.reset();
              }

              final _future = APIServices().fetchData(
                  startDate: startDate,
                  gid: widget.gid,
                  endDate: endDate,
                  startTime: startTime,
                  endTime: endTime);
              widget.onChanged(_future);
              //.then((value) => onChanged(value));
            },
          ),
          SizedBox(
            width: defaultPadding / 2,
          ),
          ClearButton(
            press: () {
              if (dropdownKey != null) {
                dropdownKey.currentState.reset();
              }
              widget.timeController.clear();
              widget.dateController.clear();
              widget.onChanged(null);
            },
          ),
        ],
      );
    if (Responsive.isMobile(context))
      return Column(children: [
        Row(
          children: [
            MonthDropdown(
              onClicked: (start, end, key) {
                startDate = start;
                endDate = end;
                dropdownKey = key;
                widget.timeController.clear();
                widget.dateController.clear();
                final _future = APIServices().fetchData(
                    startDate: startDate,
                    gid: widget.gid,
                    endDate: endDate,
                    startTime: startTime,
                    endTime: endTime);
                widget.onChanged(_future);
              },
            ),
            SizedBox(
              width: defaultPadding,
            ),
            CustomDateRangeSelector(
              dateRangeNotifier: widget.dateRangeNotifier,
              dateController: widget.dateController,
              onClicked: (start, end) async {
                startDate = start;
                endDate = end;
                if (dropdownKey != null) {
                  dropdownKey.currentState.reset();
                }
                final _future = APIServices().fetchData(
                    startDate: startDate,
                    gid: widget.gid,
                    endDate: endDate,
                    startTime: startTime,
                    endTime: endTime);
                widget.onChanged(_future);
                //.then((value) => onChanged(value));
              },
            ),
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Row(
          children: [
            CustomTimeRangeSelector(
              timeRangeNotifier: widget.timeRangeNotifier,
              timeController: widget.timeController,
              onClicked: (start, end) {
                startTime = start;
                endTime = end;
                if (dropdownKey != null) {
                  dropdownKey.currentState.reset();
                }
                final _future = APIServices().fetchData(
                    startDate: startDate,
                    gid: widget.gid,
                    endDate: endDate,
                    startTime: startTime,
                    endTime: endTime);
                widget.onChanged(_future);
                //.then((value) => onChanged(value));
              },
            ),
            SizedBox(
              width: defaultPadding,
            ),
            ClearButton(
              press: () {
                widget.timeController.clear();
                widget.dateController.clear();
                if (dropdownKey != null) {
                  dropdownKey.currentState.reset();
                }
                widget.onChanged(null);
              },
            ),
          ],
        )
      ]);
  }
}
