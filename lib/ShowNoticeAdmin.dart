import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'Home.dart';

class ShowNoticeAdmin extends StatelessWidget {
  DocumentSnapshot _username;

  ShowNoticeAdmin(this._username);

  /*var formatter = new DateFormat('dd-MM-yyyy jms');
  String formatted;*/

  @override
  Widget build(BuildContext context) {
    return Show(_username);
  }
}

class Show extends StatefulWidget {
  DocumentSnapshot _username;

  Show(this._username);

  @override
  _ShowState createState() => _ShowState(_username);
}

class _ShowState extends State<Show> {
  DocumentSnapshot _username;

  _ShowState(this._username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(_username['title']),
        body: new Container(
          child: ListView(
            children: <Widget>[
              new Container(
                child: new Stack(
                  children: <Widget>[
                    new CachedNetworkImage(
                      placeholder: (context, url) => Center(
                          child:
                          CircularProgressIndicator(backgroundColor: Colors.cyan,)),
                      width: (MediaQuery.of(context).size.width),
                      height: (MediaQuery.of(context).size.width),
                      imageUrl: _username['url'],
                      fadeInDuration: Duration(seconds: 1),
                    ),
                    new Positioned(
                      right: 1,
                      bottom: 1,
                      child: new IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: _alertBox),
                    ),
                  ],
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(top: 15),
                child: new Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(15),
                  child: new Column(
                    children: <Widget>[
                      new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          _username['description'],
                          style: TextStyle(
                            fontSize: 21,
                          ),
                        ),
                      ),
                      new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                      new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          _username['type'],
                          style: TextStyle(
                            fontSize: 21,
                          ),
                        ),
                      ),
                      new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                      new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          _username['timestamp'].toDate().toString(),
                          style: TextStyle(
                            fontSize: 21,
                          ),
                        ),
                      ),
                      new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                      new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          _username['expiry_date'].toDate().toString(),
                          style: TextStyle(
                            fontSize: 21,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _alertBox() {
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
                  'Delete Notice?',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                content: Text('Are you sure you want to Delete this Notice?'),
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
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deleteNotice();
                      },

                      child: new Text(
                        "Delete",
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
        pageBuilder: (context, animation1, animation2) {},
        context: context);
  }

  Future _deleteNotice() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        borderRadius: 20.0,
        elevation: 20.0,
        message: "Please Wait...",
        insetAnimCurve: Curves.easeIn,
        backgroundColor: Colors.black,
        messageTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 19.0,
          wordSpacing: 2.0,
        ));
    await pr.show();
    try {
      await Firestore.instance
          .collection('e-notice-board')
          .document(_username.documentID)
          .delete();
      print("Deleted");
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => Home()));
    } catch (e) {
      print(e.toString());
    }
    pr.hide();
    Fluttertoast.showToast(msg: "Notice Deleted");
  }
}

//2020-06-01 09:27:47.931320
