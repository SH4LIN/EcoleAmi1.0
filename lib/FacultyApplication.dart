//import 'dart:html';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ShowLeave.dart';
import 'SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FacultyApplication extends StatefulWidget {
  @override
  _FacultyApplicationState createState() => _FacultyApplicationState();
}

class _FacultyApplicationState extends State<FacultyApplication> {
  int len = 0;
  var itemsStudent;

  SharedPreferences prf;
  String _username;

  String _name;

  void initState() {
    // TODO: implement initState
    super.initState();
    user != null ? _username = user : setUser();
    setProfile();
    print(_username);
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
    print(_username);
  }

  Future setProfile() async {
    Firestore.instance
        .collection("faculty_details")
        .document(_username)
        .get()
        .then((document) {
      _name = document['first_name'] + " " + document['last_name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Leave Application"),
      body: new Container(
        padding: EdgeInsets.all(5.0),
        child: new Column(
          children: <Widget>[
            new Flexible(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("Leave_application")
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snap) {
                      len = snap.data.documents.length;
                      return len > 0
                          ? ListView.builder(
                              itemBuilder: _getItems,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: len,
                            )
                          : new Align(
                              alignment: Alignment.center,
                              child: new Text(
                                "No Application yet!",
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                    }))
          ],
        ),
      ),
    );
  }

  Widget _getItems(BuildContext context, int index) {
    return new Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      borderOnForeground: true,
      child: new Container(
        padding: EdgeInsets.all(15),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap != null && snap.hasData) {
                      itemsStudent = snap.data.documents;
                      return Text(
                        itemsStudent[index]['parent_name'],
                        style: new TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      );
                    } else {
                      return Text("");
                    }
                  },
                ),
                new Padding(padding: EdgeInsets.only(bottom: 5.0)),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap != null && snap.hasData) {
                      itemsStudent = snap.data.documents;
                      return Text(
                        itemsStudent[index]['student_name'],
                        style: new TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      );
                    } else {
                      return Text("");
                    }
                  },
                ),
                new Padding(padding: EdgeInsets.only(bottom: 5.0)),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap != null && snap.hasData) {
                      itemsStudent = snap.data.documents;
                      return Text(
                        itemsStudent[index]['student_enrollment'],
                        style: new TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      );
                    } else {
                      return Text("");
                    }
                  },
                ),
                new Padding(padding: EdgeInsets.only(bottom: 5.0)),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap != null && snap.hasData) {
                      itemsStudent = snap.data.documents;
                      return Text(
                        itemsStudent[index]['semester'],
                        style: new TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      );
                    } else {
                      return Text("");
                    }
                  },
                ),
                new Padding(padding: EdgeInsets.only(bottom: 5.0)),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap != null && snap.hasData) {
                      itemsStudent = snap.data.documents;
                      return new Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        alignment: Alignment.centerLeft,
                        child: new Column(
                          children: <Widget>[
                            new Text(
                              itemsStudent[index]['description'],
                              style: new TextStyle(
                                  fontSize: 10.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text("");
                    }
                  },
                ),
                new Padding(padding: EdgeInsets.only(bottom: 15.0)),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap != null && snap.hasData) {
                      itemsStudent = snap.data.documents;
                      int action = itemsStudent[index]['action'];
                      String facName = itemsStudent[index]['faculty_name'];
                      int type = itemsStudent[index]['type'];
                      String fileUrl;
                      return action == 0
                          ? new Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                ),
                                new OutlineButton(
                                  onPressed: () => _accept(index),
                                  child: new Text("Accept",
                                      style:
                                          new TextStyle(color: Colors.green)),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                ),
                                new OutlineButton(
                                  onPressed: () => {
                                    type == 0
                                        ? Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new ShowLeave(
                                                            itemsStudent[index]
                                                                ['url'])))
                                        : null
                                  },
                                  child: new Text("View",
                                      style: new TextStyle(color: Colors.cyan)),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                ),
                                new OutlineButton(
                                  onPressed: () => _decline(index),
                                  child: new Text("Decline",
                                      style: new TextStyle(color: Colors.red)),
                                )
                              ],
                            )
                          : (action == 1
                              ? new Text(
                                  "Leave Report accepted by " + facName,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )
                              : new Text(
                                  "Leave Report Rejected " + facName,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ));
                    } else {
                      return Text("");
                    }
                  },
                ),
                new Padding(padding: EdgeInsets.only(bottom: 10)),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap != null && snap.hasData) {
                      itemsStudent = snap.data.documents;
                      String date = itemsStudent[index]['date'];
                      return new Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        alignment: Alignment.centerRight,
                        child: new Column(
                          children: <Widget>[
                            new Text(
                              date,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text("");
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /*Future<String> downloadPdf(String url, String name) async {
    var directory = await getApplicationDocumentsDirectory();
    var filepath = '${directory.path}/' + name;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var file = File(filepath);
      print(filepath);
      await file.writeAsBytes(response.bodyBytes);
      return filepath;
    }
    return '';
  }*/

  void _accept(int id) async {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  'Accept?',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                content: Text(
                    'Are you sure you want to accept this leave Application?'),
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
                        Navigator.of(context).pop();
                        var _document = itemsStudent[id].documentID;
                        try {
                          await Firestore.instance
                              .collection("Leave_application")
                              .document(_document)
                              .updateData({'action': 1, 'faculty_name': _name});
                        } catch (e) {
                          print(e.toString());
                        }
                        Fluttertoast.showToast(msg: "Accepted");
                      },
                      child: new Text(
                        "Accept",
                        style: TextStyle(color: Colors.green, fontSize: 18),
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
  }

  void _decline(int id) async {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  'Decline?',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                content: Text(
                    'Are you sure you want to decline this leave application?'),
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
                        Navigator.of(context).pop();
                        var _document = itemsStudent[id].documentID;
                        try {
                          await Firestore.instance
                              .collection("Leave_application")
                              .document(_document)
                              .updateData(
                                  {'action': -1, 'faculty_name': _name});
                        } catch (e) {
                          print(e.toString());
                        }
                        Fluttertoast.showToast(msg: "Declined");
                      },
                      child: new Text(
                        "Decline",
                        style: TextStyle(color: Colors.red, fontSize: 18),
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
  }
}
