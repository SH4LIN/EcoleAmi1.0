import 'package:flutter/material.dart';
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;
  List<NavigationItem> items = [
    NavigationItem(Icon(Icons.home), Text("Home"),Colors.deepPurpleAccent),
    NavigationItem(Icon(Icons.account_circle), Text("Profile"),Colors.purpleAccent),
    NavigationItem(Icon(Icons.chat), Text("QnA"),Colors.greenAccent),
    NavigationItem(Icon(Icons.settings), Text("Settings"),Colors.black)
  ];
  Color backgroundColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.height) * 0.10,
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          color: backgroundColor),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            var itemIndex = items.indexOf(item);
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = itemIndex;
                  print(selectedIndex);
                });
              },
              child: _buildItem(item, selectedIndex == itemIndex),
            );
          }).toList()),
    );
  }
  Widget _buildItem(NavigationItem item, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      padding: EdgeInsets.only(left: 10.0),
      width: isSelected ? 120 : 60,
      height: 45,
      decoration: isSelected
          ? BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(16.0),
      )
          : null,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(
                      size: 25.0,
                      color: isSelected ? backgroundColor : Colors.black),
                  child: item.icon,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: isSelected
                      ? Text(
                    item.title.data,
                    style: TextStyle(color: backgroundColor),
                  )
                      : Container(),
                )
              ],
            ),
          ]),
    );
  }

}
class NavigationItem {
  final Icon icon;
  final Text title;
  final Color color;

  NavigationItem(this.icon, this.title,this.color);
}
