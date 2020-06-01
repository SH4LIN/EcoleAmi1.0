import 'dart:async';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:compressimage/compressimage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChangePassword.dart';
import 'MainScreen.dart';
import 'package:path/path.dart' as Path;
import 'package:carousel_pro/carousel_pro.dart';
import 'ShowImage.dart';
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
  var _image;
  int selectedIndex = 0;
  String _enrCheck;
  int id;
  List<NavigationItem> items = [
    NavigationItem(Icon(Icons.home), Text("Home"), Colors.deepPurpleAccent),
    NavigationItem(
        Icon(Icons.account_circle), Text("Profile"), Colors.purpleAccent),
    NavigationItem(Icon(Icons.chat), Text("QnA"), Colors.greenAccent),
    NavigationItem(Icon(Icons.settings), Text("Settings"), Colors.black)
  ];

  TextEditingController _mName = new TextEditingController();
  TextEditingController _lName = new TextEditingController();
  TextEditingController _fName = new TextEditingController();
  TextEditingController _eMail = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _sem = new TextEditingController();
  TextEditingController _enr = new TextEditingController();
  TextEditingController _div = new TextEditingController();
  TextEditingController _parent_phone = new TextEditingController();
  TextEditingController _finalEnr = new TextEditingController();

  bool _enrValidate = false;

  bool _mValidate = false;
  bool _lValidate = false;
  bool _fValidate = false;
  bool _emailValidate = false;
  bool _phoneValidate = false;
  bool _semValidate = false;
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      body: callPage(selectedIndex),
      backgroundColor: selectedIndex == 0
          ? Colors.white
          : selectedIndex == 1
              ? Colors.red
              : selectedIndex == 2
                  ? Colors.greenAccent
                  : selectedIndex == 3 ? Colors.black : Colors.white,
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

  List _setCarouselImages(int len) {
    List data = new List<Widget>();
    for (int i = 0; i < len; i++) {
      if (notice_board_data[i]["expiry_date"]
          .toDate()
          .toString()
          .compareTo(DateTime.now().toString()) <
          1) {
        continue;
      }
      data.add(CachedNetworkImage(
          imageUrl: notice_board_data[i]["url"],
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          fit: BoxFit.fill,
          errorWidget: (context, url, error) => new Icon(Icons.error)));
    }
    if (data.isEmpty) {
      for (int i = 0; i < len; i++) {
        data.add(CachedNetworkImage(
            imageUrl: notice_board_data[i]["url"],
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            fit: BoxFit.fill,
            errorWidget: (context, url, error) => new Icon(Icons.error)));
      }
      return data;
    } else {
      return data;
    }
  }

  bool isEmpty = false;
  var notice_board_data;
  Widget _buildBodyHome() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          height: 180.0,
          width: 300.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection("e-notice-board")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot != null && snapshot.hasData) {
                  notice_board_data = snapshot.data.documents;
                  int length = notice_board_data.length == 1
                      ? notice_board_data.length
                      : (notice_board_data.length / 2).toInt();
                  print(length);
                  return Container(
                    child: Carousel(
                      dotColor: Colors.grey,
                      borderRadius: true,
                      radius: Radius.circular(20.0),
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
                      images: _setCarouselImages(length),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
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
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ),
              Container(
                height: 140.0,
                padding: EdgeInsets.all(5.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("e-notice-board")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot != null && snapshot.hasData) {
                        var notice_board = snapshot.data.documents;
                        List events_notice = new List<DocumentSnapshot>();
                        for (int i = 0; i < notice_board.length; i++) {
                          if (notice_board[i]["type"].compareTo("Event") == 0) {
                            if (notice_board[i]["expiry_date"]
                                .toDate()
                                .toString()
                                .compareTo(DateTime.now().toString()) <
                                1) {
                              continue;
                            }else {
                              events_notice.add(notice_board[i]);
                            }
                          }
                        }
                        return events_notice.isEmpty
                            ? Center(
                          child: Text(
                            "No Events Available",
                            style: TextStyle(color: Colors.black45),
                          ),
                        )
                            : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: events_notice.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              semanticContainer: true,
                              borderOnForeground: true,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  CachedNetworkImage(
                                      placeholder: (context, url) => Center(
                                          child:
                                          CircularProgressIndicator()),
                                      width: 170.0,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      imageUrl: events_notice[index]
                                      ['url']),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: Text(
                                        events_notice[index]['title'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                            letterSpacing: 3.0)),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
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
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ),
              Container(
                height: 140.0,
                padding: EdgeInsets.all(5.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("e-notice-board")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot != null && snapshot.hasData) {
                        var notice_board = snapshot.data.documents;
                        List schedule_notice = new List<DocumentSnapshot>();

                        for (int i = 0; i < notice_board.length; i++) {
                          if (notice_board[i]["type"]
                              .compareTo("College Schedule") ==
                              0) {
                            if (notice_board[i]["expiry_date"]
                                .toDate()
                                .toString()
                                .compareTo(DateTime.now().toString()) <
                                1) {
                              continue;
                            }else {
                              schedule_notice.add(notice_board[i]);
                            }
                          }
                        }
                        return schedule_notice.isEmpty
                            ? Center(
                          child: Text(
                            "No Events Available",
                            style: TextStyle(color: Colors.black45),
                          ),
                        )
                            : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: schedule_notice.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              semanticContainer: true,
                              borderOnForeground: true,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  CachedNetworkImage(
                                      placeholder: (context, url) => Center(
                                          child:
                                          CircularProgressIndicator()),
                                      width: 170.0,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      imageUrl: schedule_notice[index]
                                      ['url']),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: Text(
                                        schedule_notice[index]['title'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                            letterSpacing: 3.0)),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
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
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ),
              Container(
                height: 140.0,
                padding: EdgeInsets.all(5.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("e-notice-board")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot != null && snapshot.hasData) {
                        var notice_board = snapshot.data.documents;
                        List fee_notice = new List<DocumentSnapshot>();
                        for (int i = 0; i < notice_board.length; i++) {
                          if (notice_board[i]["type"]
                              .compareTo("Fee Payment") ==
                              0) {
                            if (notice_board[i]["expiry_date"]
                                .toDate()
                                .toString()
                                .compareTo(DateTime.now().toString()) <
                                1) {
                              continue;
                            }else {
                              fee_notice.add(notice_board[i]);
                            }
                          }
                        }
                        return fee_notice.isEmpty
                            ? Center(
                          child: Text(
                            "No Events Available",
                            style: TextStyle(color: Colors.black45),
                          ),
                        )
                            : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: fee_notice.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              semanticContainer: true,
                              borderOnForeground: true,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  CachedNetworkImage(
                                      placeholder: (context, url) => Center(
                                          child:
                                          CircularProgressIndicator()),
                                      width: 170.0,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      imageUrl: fee_notice[index]['url']),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: Text(
                                        fee_notice[index]['title'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                            letterSpacing: 3.0)),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }


  void setProfile() async {
    Firestore.instance
        .collection("student_details")
        .document(_username)
        .get()
        .then((document) {
      _enrCheck = document['enrollment'];
      _finalEnr.text = document['enrollment'];
      _fName.text = document['first_name'];
      _mName.text = document['middle_name'];
      _lName.text = document['last_name'];
      _eMail.text = document['email'];
      _phone.text = document['phone_number'];
      _sem.text = document['semester'];
    });
  }

  Widget _buildBodyProfile() {
    print(_enrCheck);
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
                          .collection("student_details")
                          .document(_username)
                          .snapshots(),
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _fName.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _enrCheck = document['enrollment'];
                          _finalEnr.text = document['enrollment'];
                        }
                        return (_enrCheck.compareTo("------------")) == 0
                            ? Row(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: TextField(
                                      controller: _enr,
                                      keyboardType: TextInputType.number,
                                      cursorColor: Colors.purple,
                                      cursorRadius: Radius.circular(50.0),
                                      cursorWidth: 3.0,
                                      decoration: new InputDecoration(
                                          hintText: "Enrollment",
                                          errorText: _enrValidate
                                              ? 'Please enter valid Enrollment'
                                              : null,
                                          hintStyle: new TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white70,
                                          ),
                                          prefixIcon:
                                              new Icon(Icons.account_circle),
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          )),
                                    ),
                                    margin: EdgeInsets.only(right: 15),
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_enr.text.isEmpty) {
                                          _enrValidate = true;
                                        } else if (_enr.text.length != 12) {
                                          _enrValidate = true;
                                        } else {
                                          _enrValidate = false;
                                          _updateEnr();
                                        }
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    colorBrightness: Brightness.light,
                                    elevation: 24.0,
                                    animationDuration: Duration(seconds: 5),
                                    child: Text("Update"),
                                  )
                                ],
                              )
                            : TextField(
                                controller: _finalEnr,
                                enabled: false,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.purple,
                                cursorRadius: Radius.circular(50.0),
                                cursorWidth: 3.0,
                                decoration: new InputDecoration(
                                    hintText: "Enrollment",
                                    hintStyle: new TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white70,
                                    ),
                                    prefixIcon: new Icon(Icons.account_circle),
                                    border: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )),
                              );
                      }),
                  new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("student_details")
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
                          .collection("student_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _mName.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _mName.text = document['middle_name'];
                        }
                        return new TextField(
                          controller: _mName,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              hintText: "Loading ...",
                              errorText: _mValidate
                                  ? 'Please enter Middle Name'
                                  : null,
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
                          .collection("student_details")
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
                          .collection("student_details")
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
                          .collection("student_details")
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
                  new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("student_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _sem.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _sem.text = document['semester'];
                        }
                        return new TextField(
                          controller: _sem,
                          enabled: false,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              hintText: "Loading ...",
                              errorText:
                                  _semValidate ? 'Please enter Semester' : null,
                              hintStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.white70,
                              ),
                              prefixIcon: new Icon(Icons.format_list_numbered),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        );
                      }),
                  new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("student_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _div.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _div.text = document['division'];
                        }
                        return new TextField(
                          controller: _div,
                          enabled: false,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              hintText: "Loading ...",
                              errorText:
                                  _semValidate ? 'Please enter Semester' : null,
                              hintStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.white70,
                              ),
                              prefixIcon: new Icon(Icons.format_list_numbered),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        );
                      }),
                  new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("student_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _parent_phone.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _parent_phone.text = document['parent_phone_number'];
                          if (document['parent_phone_number'] == null) {
                            _parent_phone.text = "No Data";
                          }
                        }
                        return new TextField(
                          controller: _parent_phone,
                          enabled: false,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              errorText:
                                  _semValidate ? 'Please enter Semester' : null,
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

  TextEditingController _msg = new TextEditingController();
  int _type;
  var _semester;
  Widget _buildBodyQnA() {
    var msgItems;
    //print(DateTime.now().day.toString() +"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString());
    Firestore.instance
        .collection("student_details")
        .document(_username)
        .get()
        .then((snapshot) {
      setState(() {
        _semester = snapshot["semester"];
      });
    });
    return _semester != null
        ? ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('QnA')
                            .document("student")
                            .collection(_semester)
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot != null && snapshot.hasData) {
                            msgItems = snapshot.data.documents;
                          }
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              String senderUsername = msgItems[index]['userid'];
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
                                                  : senderUsername,
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
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _type = 0;
                                  sendMessage(_msg.text);
                                  _msg.clear();
                                });
                              },
                              child: CircleAvatar(
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
          .collection(_semester)
          .document(DateTime.now().toString())
          .setData({
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
          .collection(_semester)
          .document(DateTime.now().toString())
          .setData({
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
                      final curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: AlertDialog(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            title: Text(
                              'Caution!',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            content: Text('Are You Sure You Want To Logout?'),
                            actions: <Widget>[
                              new FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 18),
                                  )),
                              new FlatButton(
                                  onPressed: () async {
                                    SharedPreferences prf =
                                        await SharedPreferences.getInstance();
                                    prf.setBool("isLoggedIn", false);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushReplacement(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new MainScreen()));
                                  },
                                  child: new Text(
                                    "Logout",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18),
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation1, animation2) {});
              })
        ],
      ),
    );
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
    setProfile();
    showEmoji = false;
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
    //Fluttertoast.showToast(msg: prf.get("Username"));
  }

  void _updateEnr() async {
    String _parent;
    Firestore.instance
        .collection("student_details")
        .document(_username)
        .get()
        .then((document) {
      _parent = document['parent_phone_number'];
    });
    try {
      await Firestore.instance
          .collection('student_details')
          .document(_username)
          .updateData({
        'enrollment': _enr.text,
      });
      await Firestore.instance
          .collection('parent_details')
          .document(_parent)
          .updateData({
        'student_enrollment': _enr.text,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

class NavigationItem {
  final Icon icon;
  final Text title;
  final Color color;

  NavigationItem(this.icon, this.title, this.color);
}
