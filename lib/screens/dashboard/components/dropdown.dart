import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../../responsive.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({Key key}) : super(key: key);

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    actionKey = GlobalKey();
    super.initState();
  }

  void findDropdownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () {
          setState(() {
            if (isDropdownOpened) {
              floatingDropdown.remove();
            }
            isDropdownOpened = !isDropdownOpened;
          });
        },
        behavior: HitTestBehavior.translucent,
        child: Align(
          alignment: Alignment.center,
          child: CompositedTransformFollower(
            link: this._layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, height),
            child: Container(
              width: width,
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  DropDown(
                    itemHeight: height,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          key: actionKey,
          onTap: () {
            setState(() {
              if (isDropdownOpened) {
                floatingDropdown.remove();
              } else {
                findDropdownData();
                floatingDropdown = _createFloatingDropdown();
                Overlay.of(context).insert(floatingDropdown);
              }
              isDropdownOpened = !isDropdownOpened;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white10)),
            child: Row(
              children: [
                Icon(Icons.face, size: 38, color: Colors.white),
                if (!Responsive.isMobile(context))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    child: Text("Ghazi Tounsi",
                        style: TextStyle(color: Colors.white)),
                  ),
                !isDropdownOpened
                    ? Icon(Icons.keyboard_arrow_down, color: Colors.white)
                    : Icon(Icons.keyboard_arrow_up, color: Colors.white),
              ],
            ),
          )),
    );
  }
}

class DropDown extends StatefulWidget {
  final double itemHeight;
  const DropDown({Key key, this.itemHeight}) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white10)),
          child: Column(
            children: <Widget>[
              DropDownItem.first(
                text: "Profile",
                iconData: Icons.person_outline,
                isSelected: false,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              DropDownItem.last(
                text: "Logout",
                iconData: Icons.exit_to_app,
                isSelected: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final IconData iconData;
  final bool isSelected;
  final bool isFirstItem;
  final bool isLastItem;

  const DropDownItem({
    Key key,
    this.text,
    this.iconData,
    this.isSelected = false,
    this.isFirstItem = false,
    this.isLastItem = false,
  }) : super(key: key);

  factory DropDownItem.first(
      {String text, IconData iconData, bool isSelected, route}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      isSelected: isSelected,
      isFirstItem: true,
    );
  }

  factory DropDownItem.last(
      {String text, IconData iconData, bool isSelected, route}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      isSelected: isSelected,
      isLastItem: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 16),
          ),
          if (!Responsive.isMobile(context)) Spacer(),
          if (!Responsive.isMobile(context))
            Icon(iconData, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}
