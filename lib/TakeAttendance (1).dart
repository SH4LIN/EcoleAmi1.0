import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'CommonAppBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SplashScreen.dart';
import 'package:barcode_scan/barcode_scan.dart';

class TakeAttendance extends StatefulWidget {
  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {


  ScanResult _value;
  String _currentSem;

  SharedPreferences prf;
  String _username;

  @override
  void initState() {
    super.initState();
    user != null ? _username = user : setUser();
    setProfile();
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
  }

  void setProfile() async {
    Firestore.instance
        .collection("student_details")
        .document(_username)
        .get()
        .then((document) {
      _currentSem = document['semester'] /*+ " " + document['division']*/ ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CommonAppBar("Take Attendance"),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Text("No attendance taken"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Attendance",
        onPressed: _scan,
        child: new Icon(Icons.settings_overscan),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  var result;

  Future _scan() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        _value = result;
        String _final = _value.rawContent?.toString() ?? "";

//        shalin firebase

        _final == _currentSem
            ? Fluttertoast.showToast(
            msg: "Attendance taken successfully",
            gravity: ToastGravity.CENTER)
            : Fluttertoast.showToast(
            msg: "Invalid QrCode", gravity: ToastGravity.CENTER);
      });
    } on PlatformException catch (e) {
      result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'Please grant us the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
    } on FormatException {
      print("BACK");
      result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );
      setState(() {
        result.rawContent = 'null (You returned using the "back"-button before scanning anything. Result)';
      });
    }
    setState(() {
      _value = result;
      Fluttertoast.showToast(
          msg: _value.rawContent?.toString() ?? "",
          gravity: ToastGravity.CENTER);
    });
  }
}
