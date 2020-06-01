import 'dart:async';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compressimage/compressimage.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddEvent.dart';
import 'ChangePassword.dart';
import 'MainScreen.dart';
import 'ManageVerification.dart';
import 'ShowImage.dart';
import 'SplashScreen.dart';
//import 'TakeAttendance.dart';

Widget buildError(BuildContext context, FlutterErrorDetails error) {
  return Scaffold(
      body: Center(
        child: Text(
          "Error appeared.",
        ),
      ));
}


class FacultyActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new FacultyActivityPage(),
      /*builder: (BuildContext context, Widget widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return buildError(context, errorDetails);
        };
        return widget;
      },*/
    );
  }
}

class FacultyActivityPage extends StatefulWidget {
  @override
  _FacultyActivityPageState createState() => _FacultyActivityPageState();
}

class _FacultyActivityPageState extends State<FacultyActivityPage>
    with TickerProviderStateMixin {
  SharedPreferences prf;
  String _username;
  int selectedIndex = 0;
  int id;
  List<NavigationItem> items = [
    NavigationItem(Icon(Icons.home), Text("Home"), Colors.deepPurpleAccent),
    NavigationItem(
        Icon(Icons.account_circle), Text("Profile"), Colors.purpleAccent),
    NavigationItem(Icon(Icons.chat), Text("QnA"), Colors.greenAccent),
    NavigationItem(Icon(Icons.settings), Text("Settings"), Colors.black)
  ];
  TextEditingController _fName = new TextEditingController();
  TextEditingController _lName = new TextEditingController();
  TextEditingController _eMail = new TextEditingController();
  TextEditingController _phone = new TextEditingController();


  bool _fValidate = false;
  bool _lValidate = false;
  bool _emailValidate = false;
  bool _phoneValidate = false;
  Color backgroundColor;
  bool showEmoji;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                    .collection("faculty_details")
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
                        username['last_name']);
                  }
                  return Text("Loading...");
                },
              ),
              accountEmail: StreamBuilder(
                stream: Firestore.instance
                    .collection("faculty_details")
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
                  "F",
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
                "Attendance",
                style: Theme.of(context).textTheme.subhead,
              ),
              trailing: new Icon(Icons.arrow_forward_ios),
              onTap: (){
//                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => TakeAttendance()));
              },
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new AddEvent()));
        },
      )
          : null,
      body: callPage(selectedIndex),
      backgroundColor: selectedIndex == 0
          ? Colors.grey
          : selectedIndex == 1
          ? Colors.red
          : selectedIndex == 2
          ? Colors.white
          : selectedIndex == 3 ? Colors.black : Colors.grey,
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

  // ignore: non_constant_identifier_names
  Widget BottomNavBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.height) * 0.10,
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          color: Colors.white),
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
                  color: isSelected
                      ? item.title.data.compareTo("Settings") == 0
                      ? Colors.white
                      : backgroundColor
                      : Colors.black),
              child: item.icon,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: isSelected
                  ? Text(
                item.title.data,
                style: TextStyle(
                    color: item.title.data.compareTo("Settings") == 0
                        ? Colors.white
                        : backgroundColor),
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
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          height: 180.0,
          width: 300.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
          child: Carousel(
            dotColor: Colors.grey,
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
                  fit: BoxFit.fill,
                  image:
                  'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
              FadeInImage.assetNetwork(
                  placeholder: 'images/loading.gif',
                  fit: BoxFit.fill,
                  image:
                  "https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg"),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 15.0),
          height: 175.0,
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Events",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ),
              Container(
                height: 140.0,
                padding: EdgeInsets.all(5.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      semanticContainer: true,
                      borderOnForeground: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FadeInImage.assetNetwork(
                              placeholder: 'images/loading.gif',
                              width: 170.0,
                              height: 100,
                              fit: BoxFit.cover,
                              image:
                              'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text("Maisaie",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 3.0)),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 175.0,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "College Schedule",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ),
              Container(
                height: 140.0,
                padding: EdgeInsets.all(5.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      semanticContainer: true,
                      borderOnForeground: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FadeInImage.assetNetwork(
                              placeholder: 'images/loading.gif',
                              width: 170.0,
                              height: 100,
                              fit: BoxFit.cover,
                              image:
                              'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text("Maisaie",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 3.0)),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 175.0,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Fee Payment",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ),
              Container(
                height: 140.0,
                padding: EdgeInsets.all(5.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      semanticContainer: true,
                      borderOnForeground: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FadeInImage.assetNetwork(
                              placeholder: 'images/loading.gif',
                              width: 170.0,
                              height: 100,
                              fit: BoxFit.cover,
                              image:
                              'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text("Maisaie",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 3.0)),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void setProfile() async {
    Firestore.instance
        .collection("faculty_details")
        .document(_username)
        .get()
        .then((document) {
      _fName.text = document['first_name'];
      _lName.text = document['last_name'];
      _eMail.text = document['email'];
      _phone.text = document['phone_number'];
    });
  }

  Widget _buildBodyProfile() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage.assetNetwork(
                  placeholder: 'images/loading.gif',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  image:
                  'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("faculty_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _fName.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _fName.text = document['first_name'];
                        }
                        return new TextField(
                          controller: _fName,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              hintText: "Loading ...",
                              errorText:
                              _fValidate ? 'Please enter First Name' : null,
                              hintStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.white70,
                              ),
                              prefixIcon: new Icon(Icons.person),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        );
                      }),
                  new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("faculty_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _lName.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _lName.text = document['last_name'];
                        }
                        return new TextField(
                          controller: _lName,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              hintText: "Loading ...",
                              errorText:
                              _lValidate ? 'Please enter Last Name' : null,
                              hintStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.white70,
                              ),
                              prefixIcon: new Icon(Icons.person),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        );
                      }),
                  new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("faculty_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _eMail.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _eMail.text = document['email'];
                        }
                        return new TextFormField(
                          controller: _eMail,
                          enabled: false,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              hintText: "Loading ...",
                              errorText: _emailValidate
                                  ? 'Please enter Email Address'
                                  : null,
                              hintStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.white70,
                              ),
                              prefixIcon: new Icon(Icons.email),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        );
                      }),
                  new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("faculty_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _phone.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _phone.text = document['phone_number'];
                        }
                        return new TextField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          enabled: false,
                          maxLength: 10,
                          decoration: new InputDecoration(
                              hintText: "Loading ...",
                              errorText: _phoneValidate
                                  ? 'Please enter Phone Number'
                                  : null,
                              hintStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.white70,
                              ),
                              prefixIcon: new Icon(Icons.phone),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        );
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBodySettings() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: <Widget>[
          ListTile(
              leading: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              title: Text(
                "Change Password",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.of(context).push (new MaterialPageRoute(
                    builder: (BuildContext context) => new ChangePassword()));
              }
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            title: Text(
              "About Us",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
          ListTile(
            leading: Icon(
              Icons.call,
              color: Colors.white,
            ),
            title: Text(
              "Contact Us",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
          ListTile(
              title: new Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              trailing: new Icon(Icons.arrow_forward_ios, color: Colors.white),
              leading: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onTap: () async {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
                      return Transform(
                        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: AlertDialog(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            title: Text('Caution!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 25),),
                            content: Text('Are You Sure You Want To Logout?'),
                            actions: <Widget>[
                              new FlatButton(
                                  onPressed:  () {
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text("Cancel", style: TextStyle(fontSize: 18),)),
                              new FlatButton(
                                  onPressed: () async {
                                    SharedPreferences prf = await SharedPreferences.getInstance();
                                    prf.setBool("isLoggedIn", false);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                        builder: (BuildContext context) => new MainScreen()));
                                  },
                                  child: new Text("Logout", style: TextStyle(color: Colors.red, fontSize: 18),))
                            ],
                          ),
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    // ignore: missing_return
                    pageBuilder: (context, animation1, animation2) {});
              })
        ],
      ),
    );
  }

  // ignore: missing_return
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
    setProfile();
    showEmoji = false;
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
  }

}

class _buildBodyQnA extends StatefulWidget {
  @override
  __buildBodyQnAState createState() => __buildBodyQnAState();
}

class __buildBodyQnAState extends State<_buildBodyQnA>
    with SingleTickerProviderStateMixin {

  TabController _tabController;
  var _image;
  int index;
  String fullName;
  var msgItems;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    user != null ? _username = user : setUser();
    _setProfile();
    super.initState();
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
  }

  Future _setProfile() async {
    Firestore.instance.collection("faculty_details").document(_username)
        .get()
        .then((document) {
      print(document['first_name'] + " " + document['last_name']);
      fullName = document['first_name'] + " " + document['last_name'];
    });
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: TabBar(
          controller: _tabController,
          labelColor: Colors.redAccent,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
         /* indicator: ShapeDecoration(
            color: Colors.white,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.redAccent,
                )),
          ),*/
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white),
          tabs: [
            Text("Students", style: TextStyle(fontSize: 19)),
            Text("Parents", style: TextStyle(fontSize: 19))
          ],
        ),
      ),
      body: TabBarView(
        children: [Students(), Parents()],
        controller: _tabController,
      ),
    );
  }

  Widget Students() {
    return ListView.builder(
      itemBuilder: (context, index) {
        index += 1;
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.black12,
              child: Text(
                index.toString(),
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            ),
            trailing: new IconButton(
              icon: new Icon(Icons.add_a_photo),
              onPressed: () {
                _showBottom(index.toString(), "student");
              },
            ),
            title: Text("Semester " + index.toString()),
            subtitle: StreamBuilder(
                stream: Firestore.instance
                    .collection('QnA')
                    .document("student")
                    .collection(index.toString())
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot != null && snapshot.hasData) {
                    msgItems = snapshot.data.documents;
                  }
                  String name = msgItems[0]['full_name'] == fullName ? "" : msgItems[0]['full_name'] + ": ";
                  String message = msgItems[0]['message'];
                  return msgItems[0]['type'] == 0
                      ? Text(name + message,
                      style: TextStyle(fontSize: 15))
                      : RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.body1,
                      children: [
                        TextSpan(
                            text: name + 'Photo',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3.0),
                            child: Icon(Icons.photo_camera, size: 20),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Student_Semester(index.toString())));
            },
          ),
        );
      },
      itemCount: 6,
    );
  }

  Widget Parents() {
    return ListView.builder(
      itemBuilder: (context, index) {
        index = index + 1;
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.black12,
              child: Text(
                index.toString(),
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            ),
            trailing: new IconButton(
              icon: new Icon(Icons.add_a_photo),
              onPressed: () {
                _showBottom(index.toString(), "parents");
              },
            ),
            title: Text("Semester " + index.toString()),
            subtitle: StreamBuilder(
                stream: Firestore.instance
                    .collection('QnA')
                    .document("parents")
                    .collection(index.toString())
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot != null && snapshot.hasData) {
                    msgItems = snapshot.data.documents;
                  }
                  String name = msgItems[0]['full_name'] == fullName ? "" : msgItems[0]['full_name'] + ": ";
                  String message = msgItems[0]['message'];
                  return msgItems[0]['type'] == 0
                      ? Text(name + message,
                      style: TextStyle(fontSize: 15))
                      : RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.body1,
                      children: [
                        TextSpan(
                            text: name  + 'Photo',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3.0),
                            child: Icon(Icons.photo_camera, size: 20),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Parents_Semester(index.toString())));
            },
          ),
        );
      },
      itemCount: 6,
    );
  }

  Future _showBottom(String index, String role) async {
    String sem = index;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return new Container(
            padding: const EdgeInsets.all(15.0),
            color: Colors.grey,
            height: 150,
            child: new Center(
              child: new ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.photo,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Gallery",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _chooseFile(sem, role);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _chooseFileFromCamera(sem, role);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  var _uploadedFileURL;
  int _type;
  SharedPreferences prf;
  String _username;

  Future _chooseFile(String sem, String role) async {
    _image = null;
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = null;
        _image = image;
        _type = 1;
      });
    });
    if (_image != null) {
      print("FILE SIZE BEFORE: " + _image.lengthSync().toString());
      await CompressImage.compress(
          imageSrc: _image.path,
          desiredQuality: 50); //desiredQuality ranges from 0 to 100
      print("FILE SIZE  AFTER: " + _image.lengthSync().toString());
      print(_image.path);
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('QnA Images/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              Student_Semester(sem)));
      await storageReference.getDownloadURL().then((fileURL) {
        print(fileURL);
        if (fileURL == null) {
          throw Exception("URL Null");
        }
        _uploadedFileURL = fileURL;
      });
      if (_uploadedFileURL == null) {
        throw Exception("URL Null..");
      }
      print("URL: " + _uploadedFileURL);
      await Firestore.instance
          .collection('QnA')
          .document(role)
          .collection(sem)
          .document(DateTime.now().toString())
          .setData({
        'full_name': fullName,
        'userid': _username,
        'message': _uploadedFileURL,
        'timestamp': DateTime.now(),
        'date': DateTime
            .now()
            .day
            .toString() +
            "/" +
            DateTime
                .now()
                .month
                .toString() +
            "/" +
            DateTime
                .now()
                .year
                .toString(),
        'time': DateTime
            .now()
            .hour
            .toString() +
            ":" +
            DateTime
                .now()
                .minute
                .toString() +
            ":" +
            DateTime
                .now()
                .second
                .toString(),
        'type': _type
      });
    }
  }

  Future _chooseFileFromCamera(String sem, String role) async {
    _image = null;
    await ImagePicker.pickImage(source: ImageSource.camera).then((image) {
      setState(() {
        _image = null;
        _image = image;
        _type = 1;
      });
    });
    if (_image != null) {

      print("FILE SIZE BEFORE: " + _image.lengthSync().toString());
      await CompressImage.compress(
          imageSrc: _image.path,
          desiredQuality: 50); //desiredQuality ranges from 0 to 100
      print("FILE SIZE  AFTER: " + _image.lengthSync().toString());
      print(_image.path);
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('QnA Images/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      if (role == "student") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                Student_Semester(sem)));
      } else if (role == "parents") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                Parents_Semester(sem)));
      }
      await storageReference.getDownloadURL().then((fileURL) {
        print(fileURL);
        if (fileURL == null) {
          throw Exception("URL Null");
        }
        _uploadedFileURL = fileURL;
      });
      if (_uploadedFileURL == null) {
        throw Exception("URL Null..");
      }
      print("URL: " + _uploadedFileURL);
      await Firestore.instance
          .collection('QnA')
          .document(role)
          .collection(sem)
          .document(DateTime.now().toString())
          .setData({
        'full_name': fullName,
        'userid': _username,
        'message': _uploadedFileURL,
        'timestamp': DateTime.now(),
        'date': DateTime.now().day.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().year.toString(),
        'time': DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString() +
            ":" +
            DateTime.now().second.toString(),
        'type': _type
      });
    }
  }
}


class Student_Semester extends StatefulWidget {
  final String sem;

  Student_Semester(this.sem);

  @override
  _Student_SemesterState createState() => _Student_SemesterState(sem);
}

class _Student_SemesterState extends State<Student_Semester> {
  final sem;
  SharedPreferences prf;

  _Student_SemesterState(this.sem);

  String _username;
  String fullName;

  @override
  void initState() {
    user != null ? _username = user : setUser();
    _setProfile();
    super.initState();
  }

  Future _setProfile() async {
    Firestore.instance.collection("faculty_details").document(_username)
        .get()
        .then((document) {
      print(document['first_name'] + " " + document['last_name']);
      fullName = document['first_name'] + " " + document['last_name'];
    });
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Student QnA Semester: " + sem.toString()),
      backgroundColor: Colors.white70,
      body: Student_QnA(),
    );
  }

  TextEditingController _msg = new TextEditingController();

  int _type;
  var _image;
  bool msgEmpty = true;

  Widget Student_QnA() {
    var msgItems;
    return sem != null
        ? ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.76,
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('QnA')
                      .document("student")
                      .collection(sem.toString())
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot != null && snapshot.hasData) {
                      msgItems = snapshot.data.documents;
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        String senderUsername = msgItems[index]['userid'];
                        String senderFullName = msgItems[index]['full_name'];
                        int type = msgItems[index]['type'];
                        return Column(
                          crossAxisAlignment:
                          (senderUsername.compareTo(_username)) == 0
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width:
                              MediaQuery.of(context).size.width * 0.5,
                              alignment:
                              (senderUsername.compareTo(_username)) ==
                                  0
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Wrap(children: <Widget>[
                                Bubble(
                                  padding: BubbleEdges.only(left: 8),
                                  elevation: 10.0,
                                  shadowColor: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        (senderUsername.compareTo(
                                            _username)) ==
                                            0
                                            ? "You"
                                            : senderFullName,
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                      ),
                                      SizedBox(height: 8),
                                      type == 0
                                          ? Text(
                                        msgItems[index]['message'],
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black),
                                      )
                                          : GestureDetector(
                                        onTap: () {
                                          print(index);
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext
                                                  context) =>
                                                      ShowImage(msgItems[
                                                      index]
                                                      [
                                                      'message'])));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: msgItems[index]
                                          ['message'],
                                          placeholder: (context,
                                              url) =>
                                              Center(
                                                  child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context,
                                              url, error) {
                                            return Center(
                                                child: Icon(
                                                    Icons.error));
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            msgItems[index]['time'],
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  nip: (senderUsername
                                      .compareTo(_username)) ==
                                      0
                                      ? BubbleNip.rightTop
                                      : BubbleNip.leftTop,
                                ),
                              ]),
                              padding:
                              EdgeInsets.only(top: 10.0, left: 8),
                              margin: EdgeInsets.only(bottom: 8),
                            ),
                          ],
                        );
                      },
                      reverse: true,
                      itemCount: msgItems != null ? msgItems.length : 0,
                    );
                  }),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 16),
                                Expanded(
                                    child: TextFormField(
                                      autofocus: true,
                                      onChanged: (value) {
                                        if (value.toString().isEmpty) {
                                          setState(() {
                                            msgEmpty = true;
                                          });
                                        } else {
                                          if (value
                                              .toString()
                                              .trim()
                                              .length ==
                                              0) {
                                            setState(() {
                                              print("Space");
                                              msgEmpty = true;
                                            });
                                          } else if (value.isNotEmpty) {
                                            setState(() {
                                              msgEmpty = false;
                                            });
                                          }
                                        }
                                      },
                                      controller: _msg,
                                      keyboardType: TextInputType.multiline,
                                      minLines: 1,
                                      maxLines: 100,
                                      decoration: InputDecoration(
                                        hintText: 'Type a message',
                                        border: InputBorder.none,
                                        alignLabelWithHint: true,
                                      ),
                                    )),
                                GestureDetector(
                                  onTap: ()=> sendCameraImage(),
                                  child: Icon(Icons.camera_alt,
                                      color: Theme.of(context).hintColor),
                                ),
                                SizedBox(width: 8.0),
                                GestureDetector(
                                  onTap: () => sendImage(),
                                  child: Icon(Icons.image,
                                      color: Theme.of(context).hintColor),
                                ),
                                SizedBox(width: 8.0),
                                SizedBox(width: 8.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    AnimatedContainer(
                      duration:  Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      margin: EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _type = 0;
                            sendMessage(_msg.text);
                            _msg.clear();
                          });
                        },

                        child: msgEmpty
                            ? Container()
                            : CircleAvatar(
                          child: Icon(Icons.send),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ],
    )
        : Center(child: CircularProgressIndicator());
  }

  var _uploadedFileURL;

  void sendCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = null;
      _image = image;
      _type = 1;
    });
    if (_image != null) {
      print("FILE SIZE BEFORE: " + _image.lengthSync().toString());
      await CompressImage.compress(
          imageSrc: _image.path,
          desiredQuality: 50); //desiredQuality ranges from 0 to 100
      print("FILE SIZE  AFTER: " + _image.lengthSync().toString());
      print(_image.path);
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('QnA Images/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);

      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        print(fileURL);
        if (fileURL == null) {
          throw Exception("URL Null");
        }
        _uploadedFileURL = fileURL;
      });
      if (_uploadedFileURL == null) {
        throw Exception("URL Null..");
      }
      print("URL: " + _uploadedFileURL);
      await Firestore.instance
          .collection('QnA')
          .document('student')
          .collection(sem)
          .document(DateTime.now().toString())
          .setData({
        'full_name': fullName,
        'userid': _username,
        'message': _uploadedFileURL,
        'timestamp': DateTime.now(),
        'date': DateTime.now().day.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().year.toString(),
        'time': DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString() +
            ":" +
            DateTime.now().second.toString(),
        'type': _type
      });
    }
  }


  void sendImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = null;
      _image = image;
      _type = 1;
    });
    if (_image != null) {
      print("FILE SIZE BEFORE: " + _image.lengthSync().toString());
      await CompressImage.compress(
          imageSrc: _image.path,
          desiredQuality: 50); //desiredQuality ranges from 0 to 100
      print("FILE SIZE  AFTER: " + _image.lengthSync().toString());
      print(_image.path);
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('QnA Images/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);

      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        print(fileURL);
        if (fileURL == null) {
          throw Exception("URL Null");
        }
        _uploadedFileURL = fileURL;
      });
      if (_uploadedFileURL == null) {
        throw Exception("URL Null..");
      }
      print("URL: " + _uploadedFileURL);
      await Firestore.instance
          .collection('QnA')
          .document('student')
          .collection(sem)
          .document(DateTime.now().toString())
          .setData({
        'full_name': fullName,
        'userid': _username,
        'message': _uploadedFileURL,
        'timestamp': DateTime.now(),
        'date': DateTime.now().day.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().year.toString(),
        'time': DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString() +
            ":" +
            DateTime.now().second.toString(),
        'type': _type
      });
    }
  }

  void sendMessage(String msg) async {
    if (msg.isNotEmpty) {
      await Firestore.instance
          .collection('QnA')
          .document('student')
          .collection(sem.toString())
          .document(DateTime.now().toString())
          .setData({
        'full_name': fullName,
        'userid': _username,
        'message': msg,
        'timestamp': DateTime.now(),
        'date': DateTime.now().day.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().year.toString(),
        'time': DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString() +
            ":" +
            DateTime.now().second.toString(),
        'type': _type
      });
    } else {
      Fluttertoast.showToast(
          msg: "Nothing To Send", gravity: ToastGravity.CENTER);
    }
  }
}

class Parents_Semester extends StatefulWidget {
  final sem;

  Parents_Semester(this.sem);

  @override
  _Parents_SemesterState createState() => _Parents_SemesterState(sem);
}

class _Parents_SemesterState extends State<Parents_Semester> {
  final sem;

  _Parents_SemesterState(this.sem);

  SharedPreferences prf;
  String _username;
  String fullName;

  @override
  void initState() {
    user != null ? _username = user : setUser();
    _setProfile();
    super.initState();
  }

  Future _setProfile() async {
    Firestore.instance.collection("faculty_details").document(_username)
        .get()
        .then((document) {
      print(document['first_name'] + " " + document['last_name']);
      fullName = document['first_name'] + " " + document['last_name'];
    });
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
    //Fluttertoast.showToast(msg: prf.get("Username"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Parents QnA Semester: " + sem.toString()),
      backgroundColor: Colors.white70,
      body: Parents_QnA(),
    );
  }

  TextEditingController _msg = new TextEditingController();
  int _type;
  var _image;
  bool msgEmpty = true;

  Widget Parents_QnA() {
    var msgItems;
    return sem != null
        ? ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.76,
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('QnA')
                      .document("parents")
                      .collection(sem.toString())
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot != null && snapshot.hasData) {
                      msgItems = snapshot.data.documents;
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        String senderUsername = msgItems[index]['userid'];
                        String senderFullName = msgItems[index]['full_name'];
                        int type = msgItems[index]['type'];
                        return Column(
                          crossAxisAlignment:
                          (senderUsername.compareTo(_username)) == 0
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width:
                              MediaQuery.of(context).size.width * 0.5,
                              alignment:
                              (senderUsername.compareTo(_username)) ==
                                  0
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Wrap(children: <Widget>[
                                Bubble(
                                  padding: BubbleEdges.only(left: 8),
                                  elevation: 10.0,
                                  shadowColor: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        (senderUsername.compareTo(
                                            _username)) ==
                                            0
                                            ? "You"
                                            : senderFullName,
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                      ),
                                      SizedBox(height: 8),
                                      type == 0
                                          ? Text(
                                        msgItems[index]['message'],
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black),
                                      )
                                          : GestureDetector(
                                        onTap: () {
                                          print(index);
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext
                                                  context) =>
                                                      ShowImage(msgItems[
                                                      index]
                                                      [
                                                      'message'])));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: msgItems[index]
                                          ['message'],
                                          placeholder: (context,
                                              url) =>
                                              Center(
                                                  child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context,
                                              url, error) =>
                                          new Icon(Icons.error),
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            msgItems[index]['time'],
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  nip: (senderUsername
                                      .compareTo(_username)) ==
                                      0
                                      ? BubbleNip.rightTop
                                      : BubbleNip.leftTop,
                                ),
                              ]),
                              padding:
                              EdgeInsets.only(top: 10.0, left: 8),
                              margin: EdgeInsets.only(bottom: 8),
                            ),
                          ],
                        );
                      },
                      reverse: true,
                      itemCount: msgItems != null ? msgItems.length : 0,
                    );
                  }),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 16),
                                Expanded(
                                    child: TextFormField(
                                      autofocus: true,
                                      onChanged: (value) {
                                        if (value.toString().isEmpty) {
                                          setState(() {
                                            msgEmpty = true;
                                          });
                                        } else {
                                          if (value
                                              .toString()
                                              .trim()
                                              .length ==
                                              0) {
                                            setState(() {
                                              print("Space");
                                              msgEmpty = true;
                                            });
                                          } else if (value.isNotEmpty) {
                                            setState(() {
                                              msgEmpty = false;
                                            });
                                          }
                                        }
                                      },
                                      controller: _msg,
                                      keyboardType: TextInputType.multiline,
                                      minLines: 1,
                                      maxLines: 100,
                                      decoration: InputDecoration(
                                        hintText: 'Type a message',
                                        border: InputBorder.none,
                                        alignLabelWithHint: true,
                                      ),
                                    )),
                                GestureDetector(
                                  onTap: () => sendCameraImage(),
                                  child: Icon(Icons.camera_alt,
                                      color: Theme.of(context).hintColor),
                                ),
                                SizedBox(width: 8.0),
                                GestureDetector(
                                  onTap: () => sendImage(),
                                  child: Icon(Icons.image,
                                      color: Theme.of(context).hintColor),
                                ),
                                SizedBox(width: 8.0),
                                SizedBox(width: 8.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    AnimatedContainer(
                      duration:  Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      margin: EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _type = 0;
                            sendMessage(_msg.text);
                            _msg.clear();
                          });
                        },

                        child: msgEmpty
                            ? Container()
                            : CircleAvatar(
                          child: Icon(Icons.send),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ],
    )
        : Center(child: CircularProgressIndicator());
  }

  var _uploadedFileURL;

  void sendCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = null;
      _image = image;
      _type = 1;
    });
    if (_image != null) {
      print("FILE SIZE BEFORE: " + _image.lengthSync().toString());
      await CompressImage.compress(
          imageSrc: _image.path,
          desiredQuality: 50); //desiredQuality ranges from 0 to 100
      print("FILE SIZE  AFTER: " + _image.lengthSync().toString());
      print(_image.path);
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('QnA Images/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);

      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        print(fileURL);
        if (fileURL == null) {
          throw Exception("URL Null");
        }
        _uploadedFileURL = fileURL;
      });
      if (_uploadedFileURL == null) {
        throw Exception("URL Null..");
      }
      print("URL: " + _uploadedFileURL);
      await Firestore.instance
          .collection('QnA')
          .document('parents')
          .collection(sem)
          .document(DateTime.now().toString())
          .setData({
        'full_name': fullName,
        'userid': _username,
        'message': _uploadedFileURL,
        'timestamp': DateTime.now(),
        'date': DateTime.now().day.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().year.toString(),
        'time': DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString() +
            ":" +
            DateTime.now().second.toString(),
        'type': _type
      });
    }
  }


  void sendImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = null;
      _image = image;
      _type = 1;
    });
    if (_image != null) {
      print("FILE SIZE BEFORE: " + _image.lengthSync().toString());
      await CompressImage.compress(
          imageSrc: _image.path,
          desiredQuality: 50); //desiredQuality ranges from 0 to 100
      print("FILE SIZE  AFTER: " + _image.lengthSync().toString());
      print(_image.path);
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('QnA Images/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);

      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        print(fileURL);
        if (fileURL == null) {
          throw Exception("URL Null");
        }
        _uploadedFileURL = fileURL;
      });
      if (_uploadedFileURL == null) {
        throw Exception("URL Null..");
      }
      print("URL: " + _uploadedFileURL);
      await Firestore.instance
          .collection('QnA')
          .document('parents')
          .collection(sem)
          .document(DateTime.now().toString())
          .setData({
        'full_name': fullName,
        'userid': _username,
        'message': _uploadedFileURL,
        'timestamp': DateTime.now(),
        'date': DateTime.now().day.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().year.toString(),
        'time': DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString() +
            ":" +
            DateTime.now().second.toString(),
        'type': _type
      });
    }
  }

  void sendMessage(String msg) async {
    if (msg.isNotEmpty) {
      await Firestore.instance
          .collection('QnA')
          .document('parents')
          .collection(sem.toString())
          .document(DateTime.now().toString())
          .setData({
        'full_name': fullName,
        'userid': _username,
        'message': msg,
        'timestamp': DateTime.now(),
        'date': DateTime.now().day.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().year.toString(),
        'time': DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString() +
            ":" +
            DateTime.now().second.toString(),
        'type': _type
      });
    } else {
      Fluttertoast.showToast(
          msg: "Nothing To Send", gravity: ToastGravity.CENTER);
    }
  }
}


class NavigationItem {
  final Icon icon;
  final Text title;
  final Color color;

  NavigationItem(this.icon, this.title, this.color);
}
