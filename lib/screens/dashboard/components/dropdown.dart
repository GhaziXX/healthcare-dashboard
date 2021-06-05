import 'package:admin/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {Key key,
      @required this.headerTitle,
      this.headerIcon,
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
  final List<AsyncCallback> itemCallbacks;

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
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                width: 2,
                                color: primaryColor.withOpacity(0.15))),
                        child: Column(
                          children: <Widget>[
                            widget.isFullSize
                                ? TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isDropdownOpened) {
                                          floatingDropdown.remove();
                                        }
                                        isDropdownOpened = !isDropdownOpened;
                                      });
                                      widget.itemCallbacks[0]();
                                    },
                                    child: Row(children: <Widget>[
                                      FittedBox(
                                        child: Text(
                                          widget.itemTitles[0],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(fontSize: 6.sp),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(widget.itemIcons[0],
                                          color: widget.itemColor[0],
                                          size: 6.sp),
                                    ]))
                                : TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isDropdownOpened) {
                                          floatingDropdown.remove();
                                        }
                                        isDropdownOpened = !isDropdownOpened;
                                      });
                                      widget.itemCallbacks[0]();
                                    },
                                    child: Row(children: <Widget>[
                                      FittedBox(
                                        child: Text(
                                          widget.itemTitles[0],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(fontSize: 6.sp),
                                        ),
                                      ),
                                    ])),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            widget.isFullSize
                                ? TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isDropdownOpened) {
                                          floatingDropdown.remove();
                                        }
                                        isDropdownOpened = !isDropdownOpened;
                                      });
                                      widget.itemCallbacks[1]();
                                    },
                                    child: Row(children: <Widget>[
                                      FittedBox(
                                        child: Text(
                                          widget.itemTitles[1],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(fontSize: 6.sp),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(widget.itemIcons[1],
                                          color: widget.itemColor[1],
                                          size: 6.sp),
                                    ]))
                                : TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isDropdownOpened) {
                                          floatingDropdown.remove();
                                        }
                                        isDropdownOpened = !isDropdownOpened;
                                      });
                                      widget.itemCallbacks[1]();
                                    },
                                    child: Row(children: <Widget>[
                                      FittedBox(
                                        child: Text(
                                          widget.itemTitles[1],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(fontSize: 6.sp),
                                        ),
                                      ),
                                    ]))
                          ],
                        ),
                      ),
                    ],
                  )
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
                widget.headerIcon == null
                    ? CircleAvatar(
                        // radius: widget.circleRadius,
                        backgroundImage:
                            FirebaseAuth.instance.currentUser.photoURL != null
                                ? NetworkImage(
                                    FirebaseAuth.instance.currentUser.photoURL)
                                : AssetImage("assets/images/user.png"),
                      )
                    : Icon(widget.headerIcon,
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
