import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {Key key,
      @required this.headerTitle,
      @required this.headerIcon,
      @required this.headerIconSize,
      @required this.itemIcons,
      @required this.itemTitles,
      @required this.itemColor,
      @required this.isFullSize,
      @required this.itemCallbacks})
      : super(key: key);
  final String headerTitle;
  final IconData headerIcon;
  final double headerIconSize;
  final List<IconData> itemIcons;
  final List<String> itemTitles;
  final List<Color> itemColor;
  final bool isFullSize;
  final List<VoidCallback> itemCallbacks;

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

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () {
          setStateIfMounted(() {
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
                    icons: widget.itemIcons,
                    titles: widget.itemTitles,
                    colors: widget.itemColor,
                    isFullSize: widget.isFullSize,
                    callbacks: widget.itemCallbacks,
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
            setStateIfMounted(() {
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
                border: Border.all(
                    width: 2, color: primaryColor.withOpacity(0.15))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(widget.headerIcon,
                    size: widget.headerIconSize, color: Colors.white),
                if (widget.isFullSize)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    child: Text(widget.headerTitle,
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
  final List<IconData> icons;
  final List<String> titles;
  final List<Color> colors;
  final bool isFullSize;
  final List<VoidCallback> callbacks;

  const DropDown(
      {Key key,
      this.itemHeight,
      @required this.icons,
      @required this.titles,
      @required this.colors,
      @required this.isFullSize,
      @required this.callbacks})
      : super(key: key);

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
              border:
                  Border.all(width: 2, color: primaryColor.withOpacity(0.15))),
          child: Column(
            children: <Widget>[
              DropDownItem(
                  text: widget.titles[0],
                  iconData: widget.icons[0],
                  color: widget.colors[0],
                  isFullSize: widget.isFullSize,
                  callback: widget.callbacks[0]),
              SizedBox(
                height: defaultPadding,
              ),
              DropDownItem(
                  text: widget.titles[1],
                  iconData: widget.icons[1],
                  color: widget.colors[1],
                  isFullSize: widget.isFullSize,
                  callback: widget.callbacks[1]),
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
  final Color color;
  final bool isFullSize;
  final VoidCallback callback;

  const DropDownItem(
      {Key key,
      @required this.text,
      @required this.iconData,
      @required this.color,
      @required this.isFullSize,
      @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.isFullSize
        ? TextButton(
            onPressed: callback,
            child: Row(children: <Widget>[
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontSize: 10.sp),
              ),
              Spacer(),
              Icon(iconData, color: this.color, size: 18),
            ]))
        : TextButton(
            onPressed: callback,
            child: Row(children: <Widget>[
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontSize: 10.sp),
              ),
            ]));
  }
}
