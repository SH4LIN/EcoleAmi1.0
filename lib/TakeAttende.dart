import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'FacultyActivity.dart';

class TakeAttende extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Attendence(),
    );
  }
}

String qrdata1;

class Attendence extends StatefulWidget {
  @override
  _AttendenceState createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  var _selectedSemester;
  var _selectedSubject;
  var _selectedPT;
  var _selectedBatch;

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
                            qrdata1 = _selectedSemester;
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
                child: RaisedButton(
                  onPressed: () {
                    if (_selectedSemester != null &&
                        _selectedSubject != null &&
                        _selectedPT != null &&
                        _selectedBatch != null) {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new QRGenerate()));
                    } else {
                      Fluttertoast.showToast(msg: "Select appropriate data.");
                    }
                  },
                  child: Text("Generate QR Code"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CommonAppBar("QR Code"),
      body: Center(
        child: Column(
          children: <Widget>[
            QrImage(
              data: qrdata1,
              size: 300,
            ),
            SizedBox(height: 10),
            Text("Scan Above QR Code for Attendance"),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => new FacultyActivity()));
              },
              child: Text("Done"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ),
      ),
    );
  }
}
