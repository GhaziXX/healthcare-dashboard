import 'package:admin/screens/dashboard/components/dropdown.dart';
import 'package:flutter/material.dart';

class MenuController extends ChangeNotifier {
  final GlobalKey<CustomDropdownState> _globalKey = GlobalKey<CustomDropdownState>();

  GlobalKey<CustomDropdownState> get menuKey => _globalKey;

  void controlMenu() {
    if (_globalKey.currentState.isDropdownOpened) {
      _globalKey.currentState.floatingDropdown.remove();
    }
    else print("ma mchetech");
  }
}
