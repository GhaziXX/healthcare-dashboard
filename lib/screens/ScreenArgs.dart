import 'package:admin/models/data_models/UserData.dart';

class ScreenArguments {
  final bool isDoctor;
  final UserData userData;

  ScreenArguments(this.isDoctor, this.userData);
}
