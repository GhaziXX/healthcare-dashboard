import 'package:admin/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

import 'dropdown.dart';

class Header extends StatelessWidget {
  const Header({
    @required this.isDoctor,
    Key key,
  }) : super(key: key);
  final bool isDoctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor.withOpacity(0.9),
      padding: EdgeInsets.only(top:defaultPadding/2,bottom: defaultPadding/2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  context
                      .findRootAncestorStateOfType<ScaffoldState>()
                      .openDrawer();
                }),
          if (!Responsive.isMobile(context))
            Text(
              "Dashboard",
              style: Theme.of(context).textTheme.headline6,
            ),
          SizedBox(width: 10,),
          if (!Responsive.isMobile(context))
            Spacer(
              flex: Responsive.isDesktop(context) ? 2 : 1,
            ),
          if (this.isDoctor)
            Expanded(
              child: SearchField(),
            ),
          SizedBox(width: 10,),
          CustomDropdown()
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          fillColor: secondaryColor,
          hintText: "Search",
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(defaultPadding * 0.5),
              margin: EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Icon(Icons.search),
            ),
          )),
    );
  }
}




