import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SplashScreen.dart';

var Msg;

class StudentNotify extends StatefulWidget {
  @override
  _StudentNotifyState createState() => _StudentNotifyState();
}

class _StudentNotifyState extends State<StudentNotify> {
  @override
  SharedPreferences prf, notification;
  String _username;
  String todayDate;

  var _semester;
  var _division;
  var msgItems;

  String _sharedMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user != null ? _username = user : setUser();
//    setProfile();
    print(_username);
    String todayDate = DateTime.now().day.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        DateTime.now().year.toString();
    print(todayDate);
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
    print(_username);
  }

  /* Future setProfile() async {
    Firestore.instance
        .collection("student_details")
        .document(_username)
        .get()
        .then((document) {
      _semester = document['semester'];
      _division = document['division'];
      print(_semester.toString());
    });
  }*/

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Notification"),
      backgroundColor: Colors.white,
      body: _studentNotification(),
    );
  }

  Widget _studentNotification() {
    var msgItems;
    Firestore.instance
        .collection("student_details")
        .document(_username)
        .get()
        .then((document) {
      setState(() {
        _semester = document['semester'];
        _division = document['division'];
      });
    });
    return _semester != null
        ? new ListView(
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection("Notify_student")
                          .document(_semester.toString())
                          .collection(_division.toString())
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot != null && snapshot.hasData) {
                          msgItems = snapshot.data.documents;
                        } else {
                          print("No notification");
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: new Text(
                              "No Notification yet",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  backgroundColor: Colors.white),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            String fullName = msgItems[index]['full_name'];
                            _sharedMessage = msgItems[0]['description'];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  alignment: Alignment.topRight,
                                  child: Wrap(
                                    children: <Widget>[
                                      Bubble(
                                        padding: BubbleEdges.only(left: 8),
                                        elevation: 10.0,
                                        shadowColor: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              fullName,
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 12),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              msgItems[index]['description'],
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(height: 3),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  msgItems[index]['date'],
                                                  style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 10),
                                                ),
                                              ],
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
                                        nip: BubbleNip.leftTop,
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.only(top: 10.0, left: 8),
                                )
                              ],
                            );
                          },
                          reverse: true,
                          itemCount: msgItems != null ? msgItems.length : 0,
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}
