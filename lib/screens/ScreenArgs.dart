import 'package:admin/models/data_models/APIData.dart';
import 'package:admin/models/data_models/GeneralReadingData.dart';
import 'package:admin/models/data_models/UserData.dart';
import 'package:admin/screens/dashboard/components/general_details.dart';

class ScreenArguments {
  final bool isDoctor;
  final UserData userData;
  final UserData otherData;
  final APIData apiData;
  final GeneralReadingData oneGraphData;

  ScreenArguments(
      this.isDoctor, this.userData,this.otherData, this.apiData, this.oneGraphData);
}
