import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainScreen.dart';
import 'ManageVerification.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'SplashScreen.dart';

Widget buildError(BuildContext context, FlutterErrorDetails error) {
  return Scaffold(
      body: Center(
    child: Text(
      "Error appeared.",
    ),
  ));
}

class StudentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new StudentActivityPage(),
      /*builder: (BuildContext context, Widget widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return buildError(context, errorDetails);
        };
        return widget;
      },*/
    );
  }
}

class StudentActivityPage extends StatefulWidget {
  @override
  _StudentActivityPageState createState() => _StudentActivityPageState();
}



class _StudentActivityPageState extends State<StudentActivityPage>
    with SingleTickerProviderStateMixin {
  SharedPreferences prf;
  String _username;
  int selectedIndex = 0;
  List<NavigationItem> items = [
    NavigationItem(Icon(Icons.home), Text("Home"), Colors.deepPurpleAccent),
    NavigationItem(
        Icon(Icons.account_circle), Text("Profile"), Colors.purpleAccent),
    NavigationItem(Icon(Icons.chat), Text("QnA"), Colors.greenAccent),
    NavigationItem(Icon(Icons.settings), Text("Settings"), Colors.black)
  ];
  Color backgroundColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      appBar: CommonAppBar("Ecoleami"),
      drawer: new Drawer(
        elevation: 100.0,
        child: new ListView(
          padding: EdgeInsets.only(top: 25.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(5.0)),
              margin: EdgeInsets.only(bottom: 20.0),
              accountName: StreamBuilder(
                stream: Firestore.instance
                    .collection("student_details")
                    .document(_username)
                    .snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Text("Loading...");
                  }
                  if (snapshot.hasData) {
                    while (_username == null || snapshot.data == null) {
                      Future.delayed(Duration(seconds: 1));
                      print(_username);
                    }
                    var username = snapshot.data;
                    return Text(username['first_name'] +
                        " " +
                        username['middle_name'] +
                        " " +
                        username['last_name']);
                  }
                  return Text("Loading...");
                },
              ),
              accountEmail: StreamBuilder(
                stream: Firestore.instance
                    .collection("student_details")
                    .document(_username)
                    .snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    setUser();
                    return CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    );
                  }
                  if (snapshot.hasData) {
                    while (_username == null) {
                      Future.delayed(Duration(seconds: 1));
                    }
                    var username = snapshot.data;
                    return Text(username['email']);
                  }
                  return CircularProgressIndicator();
                },
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  "S",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              arrowColor: Colors.red,
            ),
            new ListTile(
              title: new Text(
                "Manage Student",
                style: Theme.of(context).textTheme.subhead,
              ),
              trailing: new Icon(Icons.account_circle),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new ManageVerification("Student")));
              },
            ),
            new ListTile(
              title: new Text(
                "Manage Faculty",
                style: Theme.of(context).textTheme.subhead,
              ),
              trailing: new Icon(Icons.account_circle),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new ManageVerification("Faculty")));
              },
            ),
            new ListTile(
              title: new Text(
                "Dummy 1",
                style: Theme.of(context).textTheme.subhead,
              ),
              trailing: new Icon(Icons.cancel),
              onTap: _onItemTapped1,
            ),
            new ListTile(
              title: new Text(
                "Dummy 2",
                style: Theme.of(context).textTheme.subhead,
              ),
              trailing: new Icon(Icons.cancel),
              onTap: _onItemTapped1,
            ),
            new ListTile(
              title: new Text(
                "Dummy 3",
                style: Theme.of(context).textTheme.subhead,
              ),
              trailing: new Icon(Icons.cancel),
              onTap: _onItemTapped1,
            ),
            new ListTile(
                title: new Text(
                  "Logout",
                  style: Theme.of(context).textTheme.subhead,
                ),
                trailing: new Icon(Icons.arrow_back),
                onTap: () async {
                  SharedPreferences prf = await SharedPreferences.getInstance();
                  prf.setBool("isLoggedIn", false);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => new MainScreen()));
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      body: callPage(selectedIndex),
    );
  }
  Widget BottomNavBar() {
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
                  //print(selectedIndex);
                });
              },
              child: _buildItem(item, selectedIndex == itemIndex),
            );
          }).toList()),
    );
  }

  void _onItemTapped1() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Under Construction!"),
            elevation: 20.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: new Text(
                "This Part of Application is Still Under Construction"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Close"))
            ],
          );
        });
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
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
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
  Widget _buildBodyHome() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          height: 200.0,
          width: 300.0,
          child: Carousel(
            boxFit: BoxFit.cover,
            borderRadius: true,
            radius: Radius.circular(50.0),
            autoplayDuration: Duration(seconds: 5),
            autoplay: true,
            animationCurve: Curves.easeIn,
            animationDuration: Duration(milliseconds: 1000),
            dotSize: 6.0,
            dotIncreasedColor: Colors.purple,
            dotBgColor: Colors.transparent,
            dotPosition: DotPosition.bottomCenter,
            dotVerticalPadding: 10.0,
            showIndicator: true,
            indicatorBgPadding: 7.0,
            onImageTap: (index) {
              print(index);
            },
            images: [
              FadeInImage.assetNetwork(
                  placeholder: 'images/loading.gif',
                  image: 'https://wallpapercave.com/wp/wp2071259.jpg'),
              FadeInImage.assetNetwork(
                  placeholder: 'images/loading.gif',
                  image: 'https://wallpapercave.com/wp/wp2071220.jpg'),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBodyProfile() {
    return Text("Profile");
  }

  Widget _buildBodyQnA() {
    return Text("QnA");
  }

  Widget _buildBodySettings() {
    return Text("Settings");
  }

  Widget callPage(index) {
    switch (index) {
      case 0:
        return _buildBodyHome();
        break;
      case 1:
        return _buildBodyProfile();
        break;
      case 2:
        return _buildBodyQnA();
        break;
      case 3:
        return _buildBodySettings();
        break;
    }
  }
  @override
  void initState() {
    super.initState();
    user != null ? _username = user : setUser();
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
    //Fluttertoast.showToast(msg: prf.get("Username"));
  }
}

class NavigationItem {
  final Icon icon;
  final Text title;
  final Color color;

  NavigationItem(this.icon, this.title, this.color);
}
