import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/Assignment.dart';
import 'package:ecoleami1_0/ChangePassword.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:ecoleami1_0/Contactus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:compressimage/compressimage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FacultyApplication.dart';
import 'LeaveApplication.dart';
import 'MainScreen.dart';
import 'package:path/path.dart' as Path;
import 'package:carousel_pro/carousel_pro.dart';
import 'ShowImage.dart';
import 'SplashScreen.dart';
import 'TakeAttendance.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'Contactus.dart';

Widget buildError(BuildContext context, FlutterErrorDetails error) {
  return Scaffold(
      body: Center(
    child: Text(
      "Error appeared.",
    ),
  ));
}

class ParentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ParentActivityPage(),
      /*builder: (BuildContext context, Widget widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return buildError(context, errorDetails);
        };
        return widget;
      },*/
    );
  }
}

class ParentActivityPage extends StatefulWidget {
  @override
  _ParentActivityPageState createState() => _ParentActivityPageState();
}

class _ParentActivityPageState extends State<ParentActivityPage>
    with SingleTickerProviderStateMixin {
  var _image;
  SharedPreferences prf;
  String _username;
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
  TextEditingController _fName = new TextEditingController();
  TextEditingController _eMail = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _sem = new TextEditingController();
  TextEditingController _enr = new TextEditingController();
  TextEditingController _fSName = TextEditingController();
  TextEditingController _sPhone = TextEditingController();

  bool _fValidate = false;
  bool _emailValidate = false;
  bool _phoneValidate = false;
  bool _semValidate = false;
  Color backgroundColor;

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
                    .collection("parent_details")
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
                    return Text(username['full_name']);
                  }
                  return Text("Loading...");
                },
              ),
              accountEmail: StreamBuilder(
                stream: Firestore.instance
                    .collection("parent_details")
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
                    return Text(username['phone_number']);
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
                  "J",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              arrowColor: Colors.red,
            ),
            new ListTile(
              title: new Text(
                "Leave Application",
                style: Theme.of(context).textTheme.subhead,
              ),
              trailing: new Icon(Icons.date_range),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new LeaveApplication()));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      body: callPage(selectedIndex),
      backgroundColor: selectedIndex == 0
          ? Colors.grey.shade200
          : selectedIndex == 1
              ? Colors.white
              : selectedIndex == 2
                  ? Colors.greenAccent
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

  List<String> _subjectsTheory = new List<String>();
  List<String> _subjectsPractical = new List<String>();
  void getData() async {}
  Map<String, int> totalTheorySubjects = new HashMap<String, int>();
  Map<String, int> totalPracticalSubjects = new HashMap<String, int>();
  Map<String, int> attendedPracticalSubjects = new HashMap<String, int>();
  Map<String, int> attendedTheorySubjects = new HashMap<String, int>();

  Widget _buildBodyHome() {
    return ListView(
      children: [
        StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection("parent_details")
                .document(_username)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot != null && snapshot.hasData) {
                var data = snapshot.data;
                var _currentSem = data["student_semester"];
                var _div = data["student_division"];
                var _batch = data["student_batch"];
                var _usernameStudent = data["student_phone_number"];
                Firestore.instance
                    .collection("semwise_subjects")
                    .document(_currentSem)
                    .get()
                    .then((value) {
                  List<String> theory = List<String>();
                  List<String> practical = List<String>();
                  value.data.forEach((key, value) {
                    if (value['type'].compareTo("Theory") == 0) {
                      theory.add(key);
                    }
                    practical.add(key);
                  });
                  setState(() {
                    _subjectsTheory = theory;
                    _subjectsPractical = practical;
                  });
                });
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: new Column(
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("attendance")
                              .where("semester", isEqualTo: _currentSem)
                              .snapshots(),
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            try {
                              if (snapshot != null &&
                                  snapshot.hasData &&
                                  _subjectsTheory.isNotEmpty) {
                                var data = snapshot.data.documents;
                                List<DocumentSnapshot> myTheoryData =
                                    new List<DocumentSnapshot>();
                                data.forEach((element) {
                                  if (element["type"].compareTo("Theory") ==
                                      0) {
                                    if (element["batch"].compareTo(_div) == 0 &&
                                        element['status'] == 1) {
                                      myTheoryData.add(element);
                                    }
                                  }
                                });
                                print(_subjectsTheory);
                                _subjectsTheory.forEach((element) {
                                  int count = 0;
                                  int attended = 0;
                                  totalTheorySubjects[element] = count;
                                  attendedTheorySubjects[element] = attended;
                                  myTheoryData.forEach((element1) {
                                    List<dynamic> i = new List<dynamic>();
                                    if (element1['subject']
                                            .compareTo(element) ==
                                        0) {
                                      count++;
                                      i = element1['students'];
                                      print(_usernameStudent);
                                      if (i.contains(_usernameStudent)) {
                                        attended++;
                                      }
                                    }
                                  });
                                  attendedTheorySubjects[element] = attended;
                                  totalTheorySubjects[element] = count;
                                });
                                /*print("PracticalData: ${myPracticalData.length}");
                                print("TheoryData: ${myTheoryData.length}");*/
                                print(totalTheorySubjects.toString());
                                print(attendedTheorySubjects.toString());
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    var i = totalTheorySubjects.keys.toList();
                                    var j = totalTheorySubjects.values.toList();
                                    List<Color> _colors = [
                                      Colors.red,
                                      Colors.green
                                    ];
                                    Map<String, double> pieData =
                                        new HashMap<String, double>();
                                    pieData["Absent"] = (j[index] -
                                            attendedTheorySubjects[i[index]])
                                        .toDouble();
                                    pieData["Present"] =
                                        attendedTheorySubjects[i[index]]
                                            .toDouble();
                                    return Container(
                                      height: 90,
                                      width: 300,
                                      child: Card(
                                        child: Column(
                                          children: <Widget>[
                                            Flexible(
                                                child: Text(
                                              "${i[index]} (Theory)",
                                              textAlign: TextAlign.center,
                                            )),
                                            j[index] != 0
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 14.0),
                                                    child: PieChart(
                                                      dataMap: pieData,
                                                      colorList: _colors,
                                                      animationDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  500),
                                                      chartRadius: 110,
                                                      chartType: ChartType.disc,
                                                      showChartValues: true,
                                                      showLegends: true,
                                                      showChartValuesInPercentage:
                                                          true,
                                                      showChartValuesOutside:
                                                          true,
                                                      showChartValueLabel: true,
                                                      initialAngle: 90,
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            14.0),
                                                    child: Center(
                                                      child: Text(
                                                        "No Lecture Taken Yet!",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .lightGreen),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: totalTheorySubjects.length,
                                );
                              } else {
                                return Center(child: Text("Loading..."));
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("attendance")
                              .where("semester", isEqualTo: _currentSem)
                              .snapshots(),
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            try {
                              if (snapshot != null &&
                                  snapshot.hasData &&
                                  _subjectsPractical.isNotEmpty) {
                                var data = snapshot.data.documents;
                                List<DocumentSnapshot> myPracticalData =
                                    new List<DocumentSnapshot>();
                                data.forEach((element) {
                                  if (element["type"].compareTo("Practical") ==
                                      0) {
                                    if (element["batch"]
                                                .compareTo(_div + _batch) ==
                                            0 &&
                                        element['status'] == 1) {
                                      myPracticalData.add(element);
                                    }
                                  }
                                });
                                print(_subjectsTheory);
                                _subjectsPractical.forEach((element) {
                                  int count = 0;
                                  int attended = 0;
                                  totalPracticalSubjects[element] = count;
                                  attendedPracticalSubjects[element] = attended;
                                  myPracticalData.forEach((element1) {
                                    List<dynamic> i = new List<dynamic>();
                                    if (element1['subject']
                                            .compareTo(element) ==
                                        0) {
                                      count++;
                                      i = element1['students'];
                                      if (i.contains(_usernameStudent)) {
                                        attended++;
                                      }
                                    }
                                  });
                                  attendedPracticalSubjects[element] = attended;
                                  totalPracticalSubjects[element] = count;
                                });
                                /*print("PracticalData: ${myPracticalData.length}");
                                print("TheoryData: ${myTheoryData.length}");*/
                                print(totalPracticalSubjects.toString());
                                print(attendedPracticalSubjects.toString());
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    var i =
                                        totalPracticalSubjects.keys.toList();
                                    var j =
                                        totalPracticalSubjects.values.toList();
                                    List<Color> _colors = [
                                      Colors.red,
                                      Colors.green
                                    ];
                                    Map<String, double> pieData =
                                        new HashMap<String, double>();
                                    pieData["Absent"] = j[index] -
                                        attendedPracticalSubjects[i[index]]
                                            .toDouble();
                                    pieData["Present"] =
                                        attendedPracticalSubjects[i[index]]
                                            .toDouble();
                                    return Container(
                                      height: 150,
                                      width: 300,
                                      child: Card(
                                        child: Column(
                                          children: <Widget>[
                                            Flexible(
                                                child: Text(
                                                    "${i[index]} (Practical)",
                                                    textAlign:
                                                        TextAlign.center)),
                                            j[index] != 0
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 14.0),
                                                    child: PieChart(
                                                      dataMap: pieData,
                                                      colorList: _colors,
                                                      animationDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  500),
                                                      chartRadius: 110,
                                                      chartType: ChartType.disc,
                                                      showChartValues: true,
                                                      showLegends: true,
                                                      showChartValuesInPercentage:
                                                          true,
                                                      showChartValuesOutside:
                                                          true,
                                                      showChartValueLabel: true,
                                                      initialAngle: 90,
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            14.0),
                                                    child: Center(
                                                      child: Text(
                                                        "No Lab Taken Yet!",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .lightGreen),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: totalPracticalSubjects.length,
                                );
                              } else {
                                return Center(child: Text("Loading..."));
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("attendance")
                              .where('students',
                                  arrayContains: _usernameStudent)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot != null && snapshot.hasData) {
                              QuerySnapshot document = snapshot.data;
                              List<DocumentSnapshot> data = document.documents;
                              return data.length == 0
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Text("No Attendance Submitted"))
                                  : Expanded(
                                      child: ListView.builder(
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              margin: EdgeInsets.all(14),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(14.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: Container(
                                                            child: Center(
                                                              child: Text(
                                                                "${data[index]['subject']}(${data[index]["type"]})",
                                                                softWrap: true,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      child: Text(
                                                          "${data[index]['date']}"),
                                                    ),
                                                    Container(
                                                        child: Text(
                                                            "${data[index]['time']}")),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    );
                            } else {
                              return CircularProgressIndicator();
                            }
                          })
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ],
    );
  }

  String cName;

  void setProfile() async {
    Firestore.instance
        .collection("parent_details")
        .document(_username)
        .get()
        .then((document) {
      _fName.text = document['full_name'];
      _name = document['full_name'];
      _phone.text = document['phone_number'];
      _fSName.text = document['student_name'];
      _enr.text = document['student_enrollment'];
      _sPhone.text = document['student_phone_number'];
      _eMail.text = document['student_phone_email'];
      _sem.text = document['student_semester'] +
          " " +
          document['student_division'] +
          document['student_batch'];

      cName = document['full_name'];
    });
    /*StreamBuilder(
      stream: Firestore.instance
          .collection("student_details")
          .document(_username)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Text("Loading...");
        }
        if (snapshot.hasData) {
          while (_username == null || snapshot.data == null) {
            Future.delayed(Duration(seconds: 1));
            print(_username);
          }
          var document = snapshot.data;
          _enrCheck = document['enrollment'];
          _finalEnr.text = document['enrollment'];
          _fName.text = document['first_name'];
          _mName.text = document['middle_name'];
          _lName.text = document['last_name'];
          _eMail.text = document['email'];
          _phone.text = document['phone_number'];
          _sem.text = document['semester'];
        }
        return Text("Loading...");
      },
    );*/
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
            StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection("parent_details")
                    .document(_username)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot != null && snapshot.hasData) {
                    var doc = snapshot.data;
                    var name = doc['full_name'];
                    return CircleAvatar(
                      maxRadius: 40,
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.blue
                              : Colors.cyanAccent,
                      child: Text(
                        '${name[0]}',
                        style: TextStyle(fontSize: 40.0),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            Container(
              margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("parent_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _fName.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _fName.text = document['full_name'];
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
                          .collection("parent_details")
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
                  new Padding(padding: const EdgeInsets.only(bottom: 30.0)),
                  new Text(
                    "Student Details",
                    style: TextStyle(fontSize: 25),
                  ),
                  new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                  /*StreamBuilder(
                      stream: Firestore.instance
                          .collection("parent_details")
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
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.65,
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
                      }),*/
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("parent_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _fSName.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _fSName.text = document['student_name'];
                        }
                        return new TextField(
                          controller: _fSName,
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
                          .collection("parent_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _enr.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _enrCheck = document['student_enrollment'];
                          _enrCheck.compareTo("------------") == 0
                              ? _enr.text =
                                  "(enrollment number is not registered)"
                              : _enr.text = document['student_enrollment'];
                        }
                        return new TextField(
                          controller: _enr,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              hintText: "Loading ...",
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
                          .collection("parent_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _sPhone.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _sPhone.text = document['student_phone_number'];
                        }
                        return new TextField(
                          controller: _sPhone,
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
                          .collection("parent_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _eMail.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _eMail.text = document['student_email'];
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
                          .collection("parent_details")
                          .document(_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          _sem.text = "Loading...!";
                        }
                        if (snapshot.hasData) {
                          var document = snapshot.data;
                          _sem.text = document['student_semester'] +
                              " " +
                              document['student_division'] +
                              document['student_batch'];
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
  String _fullName;
  String _name;
  bool msgEmpty = true;

  Widget _buildBodyQnA() {
    var msgItems;
    //print(DateTime.now().day.toString() +"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString());
    Firestore.instance
        .collection("parent_details")
        .document(_username)
        .get()
        .then((snapshot) {
      setState(() {
        _semester = snapshot["student_semester"];
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
                            .document("parents")
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
                              _fullName = msgItems[index]['full_name'];
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
                                                  : _fullName,
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
                            duration: Duration(seconds: 1),
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
          .collection(_semester)
          .document(DateTime.now().toString())
          .setData({
        'full_name': _name,
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
          .collection(_semester)
          .document(DateTime.now().toString())
          .setData({
        'full_name': _name,
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
          .collection(_semester)
          .document(DateTime.now().toString())
          .setData({
        'full_name': _name,
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
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new ChangePassword()));
              }),
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
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Contactus()));
            },
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
                    // ignore: missing_return
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
