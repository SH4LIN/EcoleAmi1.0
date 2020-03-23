import 'package:flutter/material.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  String appBarTitle;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  CommonAppBar(this.appBarTitle);
  @override
  _CommonAppBarState createState(){
    return _CommonAppBarState(this.appBarTitle);
  }


}

class _CommonAppBarState extends State<CommonAppBar>{
  String appBarTitle;

  _CommonAppBarState(this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 10.0,
      title: Text(appBarTitle,style: TextStyle(color: Colors.black)),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Colors.white,
      primary: true,
    );
  }
}
