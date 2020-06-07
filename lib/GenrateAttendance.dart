import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'FacultyActivity.dart';

class GenerateAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Attendance(),
    );
  }
}

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  var _selectedSemester;
  var _selectedSubject;
  var _selectedPT;
  var _selectedBatch;
  var _randomNumber;
  String documentID;
  List<String> students = new List<String>();
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new CommonAppBar("Take Attendence"),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: new BoxDecoration(
                border: Border.all(style: BorderStyle.solid, width: 0.80),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("semwise_subjects")
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<String> _semesters = new List<String>();
                    if (snapshot != null && snapshot.hasData) {
                      List<DocumentSnapshot> document = snapshot.data.documents;
                      document.forEach((element) async {
                        await _semesters.add(element.documentID);
                      });
                      return DropdownButton<String>(
                        underline: SizedBox(),
                        items: _semesters.map((String val) {
                          return new DropdownMenuItem<String>(
                            value: val,
                            child: new Text(val),
                          );
                        }).toList(),
                        hint: Text("Semester"),
                        onChanged: (String newVal) {
                          setState(() {
                            this._selectedSemester = newVal;
                            this._selectedSubject = null;
                          });
                        },
                        value: _selectedSemester,
                        isExpanded: true,
                      );
                    } else {
                      return DropdownButton<String>(
                        underline: Container(),
                        hint: Text("Semester"),
                        isExpanded: true,
                      );
                    }
                  }),
            ),
            _selectedSemester != null
                ? Column(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: new BoxDecoration(
                          border:
                              Border.all(style: BorderStyle.solid, width: 0.80),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection("semwise_subjects")
                                .document(_selectedSemester)
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<String> _subjects = new List<String>();
                              if (snapshot != null && snapshot.hasData) {
                                DocumentSnapshot document = snapshot.data;
                                _subjects =
                                    document.data.keys.toList(growable: false);
                                return DropdownButton<String>(
                                  underline: SizedBox(),
                                  items: _subjects.map((String key) {
                                    return new DropdownMenuItem<String>(
                                      value: key,
                                      child: new Text(key),
                                    );
                                  }).toList(),
                                  hint: Text("Subject"),
                                  onChanged: (String newVal) {
                                    setState(() {
                                      this._selectedSubject = newVal;
                                      this._selectedPT = null;
                                    });
                                  },
                                  value: _selectedSubject,
                                  isExpanded: true,
                                );
                              } else {
                                return DropdownButton<String>(
                                  underline: Container(),
                                  hint: Text("Semester"),
                                  isExpanded: true,
                                );
                              }
                            }),
                      ),
                    ],
                  )
                : Center(),
            _selectedSubject != null
                ? Column(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: new BoxDecoration(
                          border:
                              Border.all(style: BorderStyle.solid, width: 0.80),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection("semwise_batches")
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<String> _pt = new List<String>();
                              if (snapshot != null && snapshot.hasData) {
                                List<DocumentSnapshot> document =
                                    snapshot.data.documents;
                                document.forEach((element) async {
                                  await _pt.add(element.documentID);
                                });
                                return DropdownButton<String>(
                                  underline: SizedBox(),
                                  items: _pt.map((String val) {
                                    return new DropdownMenuItem<String>(
                                      value: val,
                                      child: new Text(val),
                                    );
                                  }).toList(),
                                  hint: Text("PT"),
                                  onChanged: (String newVal) {
                                    setState(() {
                                      this._selectedPT = newVal;
                                      this._selectedBatch = null;
                                    });
                                  },
                                  value: _selectedPT,
                                  isExpanded: true,
                                );
                              } else {
                                return DropdownButton<String>(
                                  underline: Container(),
                                  hint: Text("PT"),
                                  isExpanded: true,
                                );
                              }
                            }),
                      ),
                    ],
                  )
                : Center(),
            _selectedPT != null
                ? Column(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: new BoxDecoration(
                          border:
                              Border.all(style: BorderStyle.solid, width: 0.80),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection("semwise_batches")
                                .document(_selectedPT)
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<String> _batch = new List<String>();
                              if (snapshot != null && snapshot.hasData) {
                                DocumentSnapshot document = snapshot.data;
                                _batch =
                                    document.data.keys.toList(growable: false);
                                return DropdownButton<String>(
                                  underline: SizedBox(),
                                  items: _batch.map((String key) {
                                    return new DropdownMenuItem<String>(
                                      value: key,
                                      child: new Text(key),
                                    );
                                  }).toList(),
                                  hint: Text("Batches"),
                                  onChanged: (String newVal) {
                                    setState(() {
                                      this._selectedBatch = newVal;
                                    });
                                  },
                                  value: _selectedBatch,
                                  isExpanded: true,
                                );
                              } else {
                                return DropdownButton<String>(
                                  underline: Container(),
                                  hint: Text("Semester"),
                                  isExpanded: true,
                                );
                              }
                            }),
                      )
                    ],
                  )
                : Center(),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                width: MediaQuery.of(context).size.width * 0.5,
                /*         RaisedButton(
                    onPressed: _showBottom,

                    child: Text(
                      "Change Document",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),*/
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.redAccent,
                  onPressed: () {
                    if (_selectedSemester != null &&
                        _selectedSubject != null &&
                        _selectedPT != null &&
                        _selectedBatch != null) {
                      _randomNumber = random.nextInt(999999);
                      documentID = _selectedSemester.toString() +
                          _selectedBatch.toString() +
                          _selectedSubject.toString() +
                          _randomNumber.toString();
                      Firestore.instance
                          .collection("attendance")
                          .document(documentID)
                          .setData({
                        'semester': _selectedSemester,
                        'subject': _selectedSubject,
                        'batch': _selectedBatch,
                        'type': _selectedPT,
                        'code': _randomNumber,
                        'students': students,
                        'status': "0",
                        'date':
                            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        'time':
                            "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}"
                      });
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) => new QRGenerate(
                                  documentID,
                                  _selectedSemester.toString(),
                                  _selectedBatch,
                                  _selectedPT)));
                    } else {
                      Fluttertoast.showToast(msg: "Select appropriate data.");
                    }
                  },
                  child: Text(
                    "Generate QR Code",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QRGenerate extends StatelessWidget {
  final String documentID, _semester, _batch, _type;
  QRGenerate(this.documentID, this._semester, this._batch, this._type);
  @override
  Widget build(BuildContext context) {
    print(documentID);
    return new Scaffold(
        appBar: CommonAppBar("QR Code"),
        body: WillPopScope(
          onWillPop: () async {
            return (await showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: new Text('Are you sure?'),
                    content: new Text('Do you want to finish attendance'),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: new Text('No'),
                      ),
                      new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          Firestore.instance
                              .collection("attendance")
                              .document(documentID)
                              .updateData({"status": 1});
                        },
                        child: new Text('Yes'),
                      ),
                    ],
                  ),
                )) ??
                false;
          },
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                ),
                QrImage(
                  data: documentID,
                  size: 300,
                ),
                SizedBox(height: 10),
                Text("Scan Above QR Code for Attendance"),
                SizedBox(height: 10),
                new ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonAlignedDropdown: true,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: () {
                        Firestore.instance
                            .collection("attendance")
                            .document(documentID)
                            .updateData({"status": 1});
                        Navigator.of(context).pop();
                      },
                      splashColor: Colors.redAccent,
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: new Text(
                        "All Absent",
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.white,
                          wordSpacing: 2.0,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    new RaisedButton(
                      onPressed: () {
                        Firestore.instance
                            .collection("student_details")
                            .where("semester", isEqualTo: _semester.toString())
                            .getDocuments()
                            .then((document) {
                          var sem_student = document.documents;
                          List documents = new List();
                          sem_student.forEach((element) {
                            if (_type.compareTo("Theory") == 0) {
                              if (_batch.compareTo(element['division']) == 0) {
                                documents.add(element.documentID);
                              }
                            } else if (_type.compareTo("Practical") == 0) {
                              if (_batch.compareTo(
                                      element['division'] + element['batch']) ==
                                  0) {
                                documents.add(element.documentID);
                              }
                            }
                          });
                          Firestore.instance
                              .collection("attendance")
                              .document(documentID)
                              .updateData({'students': documents});
                        });
                      },
                      splashColor: Colors.redAccent,
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: new Text(
                        "All Present",
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.white,
                          wordSpacing: 2.0,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    Firestore.instance
                        .collection("attendance")
                        .document(documentID)
                        .updateData({"status": 1});
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.redAccent,
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: new Text(
                    "Submit",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: Colors.white,
                      wordSpacing: 2.0,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: StreamBuilder<Object>(
                        stream: Firestore.instance
                            .collection("attendance")
                            .document(documentID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot != null && snapshot.hasData) {
                            List<dynamic> students = new List<dynamic>();
                            DocumentSnapshot document = snapshot.data;
                            students = document['students'];
                            return Column(
                              children: <Widget>[
                                Text("Present Student: ${students.length}"),
                                students.length == 0
                                    ? Text("No Students")
                                    : Expanded(
                                        child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text("${students[index]}"),
                                            );
                                          },
                                          itemCount: students.length,
                                        ),
                                      )
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ),
                )

                /* RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20)),
              color: Colors.redAccent,
              onPressed: null,
              child: Text("All Present", style: TextStyle(color: Colors.white),),
            ),*/
              ],
            ),
          ),
        ));
  }
}
