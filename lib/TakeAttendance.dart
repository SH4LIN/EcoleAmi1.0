import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
  String _batch;
  String _div;

  SharedPreferences prf;
  String _username;
  List<String> _subjectsTheory = new List<String>();
  List<String> _subjectsPractical = new List<String>();

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
    await Firestore.instance
        .collection("student_details")
        .document(_username)
        .get()
        .then((document) {
      _currentSem = document['semester'];
      _div = document['division'];
      _batch = document['batch'];
    });
    await Firestore.instance
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
  }

  Map<String, int> totalTheorySubjects = new HashMap<String, int>();
  Map<String, int> totalPracticalSubjects = new HashMap<String, int>();
  Map<String, int> attendedPracticalSubjects = new HashMap<String, int>();
  Map<String, int> attendedTheorySubjects = new HashMap<String, int>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CommonAppBar("Take Attendance"),
      body: ListView(
        children: [
          Container(
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
                            if (element["type"].compareTo("Theory") == 0) {
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
                              if (element1['subject'].compareTo(element) == 0) {
                                count++;
                                i = element1['students'];
                                if (i.contains(_username)) {
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
                              List<Color> _colors = [Colors.red, Colors.green];
                              Map<String, double> pieData =
                                  new HashMap<String, double>();
                              pieData["Absent"] =
                                  (j[index] - attendedTheorySubjects[i[index]])
                                      .toDouble();
                              pieData["Present"] =
                                  attendedTheorySubjects[i[index]].toDouble();
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
                                              padding: const EdgeInsets.only(
                                                  top: 14.0),
                                              child: PieChart(
                                                dataMap: pieData,
                                                colorList: _colors,
                                                animationDuration:
                                                    Duration(milliseconds: 500),
                                                chartRadius: 110,
                                                chartType: ChartType.ring,
                                                showChartValues: true,
                                                showLegends: true,
                                                showChartValuesInPercentage:
                                                    true,
                                                showChartValuesOutside: true,
                                                showChartValueLabel: true,
                                                initialAngle: 90,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Center(
                                                child: Text(
                                                  "No Lecture Taken Yet!",
                                                  style: TextStyle(
                                                      color: Colors.lightGreen),
                                                  textAlign: TextAlign.center,
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
                            if (element["type"].compareTo("Practical") == 0) {
                              if (element["batch"].compareTo(_div + _batch) ==
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
                              if (element1['subject'].compareTo(element) == 0) {
                                count++;
                                i = element1['students'];
                                if (i.contains(_username)) {
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
                              var i = totalPracticalSubjects.keys.toList();
                              var j = totalPracticalSubjects.values.toList();
                              List<Color> _colors = [Colors.red, Colors.green];
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
                                          child: Text("${i[index]} (Practical)",
                                              textAlign: TextAlign.center)),
                                      j[index] != 0
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 14.0),
                                              child: PieChart(
                                                dataMap: pieData,
                                                colorList: _colors,
                                                animationDuration:
                                                    Duration(milliseconds: 500),
                                                chartRadius: 110,
                                                chartType: ChartType.ring,
                                                showChartValues: true,
                                                showLegends: true,
                                                showChartValuesInPercentage:
                                                    true,
                                                showChartValuesOutside: true,
                                                showChartValueLabel: true,
                                                initialAngle: 90,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Center(
                                                child: Text(
                                                  "No Lab Taken Yet!",
                                                  style: TextStyle(
                                                      color: Colors.lightGreen),
                                                  textAlign: TextAlign.center,
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
                        .where('students', arrayContains: _username)
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
                                          padding: const EdgeInsets.all(14.0),
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
                                                              TextAlign.center,
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
          ),
        ],
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
  String _final;
  ProgressDialog pr;

  Future _scan() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        _value = result;
        _final = _value.rawContent?.toString() ?? "";
//        shalin firebase
      });
      print("Outside Builder: $_final");
      if (_final != null || _final != '') {
        await Firestore.instance
            .collection("attendance")
            .document(_final)
            .get()
            .then((document) async {
          String sem = document['semester'];
          if (document['status'].toString().compareTo("0") == 0) {
            if (sem.compareTo(_currentSem) == 0) {
              List<dynamic> students = new List<dynamic>();
              students = document['students'];
              if (students.contains(_username)) {
                Fluttertoast.showToast(msg: "Your Attendance Has Been Taken!");
              } else {
                students.add(_username);
                await Firestore.instance
                    .collection("attendance")
                    .document(_final)
                    .updateData({'students': students});
                Fluttertoast.showToast(
                    msg: "Attendance taken successfully",
                    gravity: ToastGravity.CENTER);
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Invalid QrCode", gravity: ToastGravity.CENTER);
            }
          } else {
            Fluttertoast.showToast(msg: "Attendance Submitting Completed");
          }
        });
      }
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
      Fluttertoast.showToast(
          msg: result.rawContent?.toString() ?? "",
          gravity: ToastGravity.CENTER);
    } on FormatException {
      print("BACK");
      result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );
      setState(() {
        result.rawContent =
            'null (You returned using the "back"-button before scanning anything. Result)';
      });
      Fluttertoast.showToast(
          msg: result.rawContent?.toString() ?? "",
          gravity: ToastGravity.CENTER);
    }
  }
}
