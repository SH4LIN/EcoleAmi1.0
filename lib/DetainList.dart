import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DetainList extends StatefulWidget {
  @override
  _DetainListState createState() => _DetainListState();
}

class _DetainListState extends State<DetainList> {
  var _selectedSemester;
  var _selectedSubject;
  var _selectedPT;
  var _selectedBatch;

  TextEditingController __criteria = new TextEditingController();

  bool _validate = false;
  String errormsg = "Please enter criteria";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Generate Detain List"),
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
            _selectedBatch != null
                ? Center(
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: __criteria,
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              hintText: "Criteria",
                              errorText: _validate ? errormsg : null,
                              hintStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                              prefixIcon: new Icon(Icons.assessment),
                              suffixText: "%",
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        )),
                  )
                : Center(),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                width: MediaQuery.of(context).size.width * 0.5,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.redAccent,
                  onPressed: () {
                    setState(() {
                      if (__criteria.text.isEmpty) {
                        _validate = true;
                      } else {
                        if (int.parse(__criteria.text) > 100) {
                          _validate = true;
                          errormsg = "Please enter number less then \'100\'";
                        } else {
                          _validate = false;
                        }
                      }
                      if (_selectedSemester != null &&
                          _selectedSubject != null &&
                          _selectedPT != null &&
                          _selectedBatch != null &&
                          _validate != true) {
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (BuildContext context) => new Detain(
                                    _selectedSubject.toString(),
                                    _selectedPT.toString(),
                                    _selectedSemester.toString(),
                                    _selectedBatch.toString(),
                                    __criteria.text)));
                      }
                    });
                  },
                  child: Text(
                    "Generate Detain List",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                width: MediaQuery.of(context).size.width * 0.5,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new ShowDetain()));
                  },
                  child: Text(
                    "Show detain list",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Detain extends StatelessWidget {
  final _subject, _type, _sem, _batch, _criteria;

  Detain(this._subject, this._type, this._sem, this._batch, this._criteria);

  @override
  Widget build(BuildContext context) {
    return new FinalDetain(_subject, _type, _sem, _batch, _criteria);
  }
}

class FinalDetain extends StatefulWidget {
  final _subject, _type, _sem, _batch, _criteria;

  FinalDetain(
      this._subject, this._type, this._sem, this._batch, this._criteria);

  @override
  _FinalDetainState createState() =>
      _FinalDetainState(_subject, _type, _sem, _batch, _criteria);
}

class _FinalDetainState extends State<FinalDetain> {
  final _subject, _type, _sem, _batch, _criteria;

  _FinalDetainState(
      this._subject, this._type, this._sem, this._batch, this._criteria);

  List<dynamic> detainedstudent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: _submit,
        child: new Icon(Icons.add),
        tooltip: "Submit",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: CommonAppBar("Detain List"),
      body: new ListView(
//        scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height,
              child: new Column(
                children: <Widget>[
                  // get total lecture
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  new Container(child: Center(child: Text(_subject))),
                  new Container(
                      child: Center(
                          child: detainedstudent != null
                              ? Text(
                                  detainedstudent.length.toString() +
                                      " student(s) detained",
                                  style: TextStyle(color: Colors.red),
                                )
                              : Container())),

                  new Expanded(
                      child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('attendance')
                        .where('subject', isEqualTo: _subject)
                        .snapshots(),
                    // ignore: missing_return
                    builder: (context, snap) {
                      try {
                        if (snap != null && snap.hasData) {
                          var data = snap.data.documents;
                          List<DocumentSnapshot> myData =
                              new List<DocumentSnapshot>();
                          data.forEach((element) {
                            if (element["type"].compareTo(_type) == 0) {
                              if (element['batch'].compareTo(_batch) == 0 &&
                                  element['status'] == 1) {
                                myData.add(element);
                              }
                            }
                          });

                          Map<String, int> studentData = new HashMap();
                          myData.forEach((element) {
                            List<dynamic> students = element["students"];
                            int count = 0;
                            students.forEach((element) {
                              count = studentData[element];
                              print(count);
                              if (count == 0 || count == null) {
                                count = 1;
                              } else {
                                count++;
                              }
                              studentData[element] = count;
                            });
                          });
                          List<dynamic> studentKeys = studentData.keys.toList();
                          detainedstudent = new List<dynamic>();
                          Map<dynamic, int> Criteria = HashMap();
                          studentKeys.forEach((element) {
                            Criteria[element] =
                                ((studentData[element] / myData.length) * 100)
                                    .toInt();
                            if (Criteria[element] < int.parse(_criteria)) {
                              detainedstudent.add(element);
                            }
                          });
                          print(detainedstudent.toString());
                          print(Criteria.toString());
                          print("Total");
                          print(studentData.toString());
                          return detainedstudent.length != 0
                              ? Container(
                                  height: 200,
                                  child: ListView.builder(
                                    itemCount: detainedstudent.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
//                            index += 1;
                                      return StreamBuilder<DocumentSnapshot>(
                                          stream: Firestore.instance
                                              .collection("student_details")
                                              .document(detainedstudent[index])
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot != null &&
                                                snapshot.hasData) {
                                              var data = snapshot.data;
                                              return Container(
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 10),
                                                  child: Card(
                                                    child: ListTile(
                                                      leading: Text(
                                                        index.toString(),
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      trailing: Text(
                                                          data['division'] +
                                                              data['batch']),
                                                      title: Text(
                                                          data['enrollment']),
                                                      subtitle: Text(data[
                                                              'first_name'] +
                                                          " " +
                                                          data['middle_name'] +
                                                          " " +
                                                          data['last_name']),
                                                    ),
                                                  ));
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          });
                                    },
                                  ),
                                )
                              : Center(
                                  child: new Container(
                                    child: Text("No Students are detained"),
                                  ),
                                );
                        } else {
                          return new Text("");
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                      return new Text("");
                    },
                  )),
                ],
              ),
            ),
          ]),
    );
  }

  Future _submit() async {
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
          .collection('detain_list')
          .document(_sem.toString() +
              _batch.toString() +
              _subject.toString() +
              DateTime.now().toString())
          .setData({
        'semester': _sem.toString(),
        'batch': _batch.toString(),
        'type': _type.toString(),
        'criteria': _criteria.toString(),
        'subject': _subject.toString(),
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
        'detain_student': detainedstudent,
      });
      Fluttertoast.showToast(msg: "Submitted", gravity: ToastGravity.BOTTOM);
      pr.hide();
      Navigator.pop(context);
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ShowDetain()));
    } catch (e) {
      print(e.toString());
    }
  }
}

class ShowDetain extends StatefulWidget {
  @override
  _ShowDetainState createState() => _ShowDetainState();
}

class _ShowDetainState extends State<ShowDetain> {
  List<dynamic> detainedList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Detain List"),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('detain_list')
            .orderBy('semester', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.hasData) {
            var data = snapshot.data.documents;
            return data.length > 0
                ? ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new StudentDetainList(
                                        data[index]['detain_student'])));
                          },
                          leading: Text(
                            index.toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                          trailing: Text(data[index]['semester'] +
                              " " +
                              data[index]['batch']),
                          title: Text(
                            data[index]['subject'] +
                                " \n" +
                                data[index]['type'],
                            style: TextStyle(fontSize: 13),
                          ),
                          subtitle: Text(data[index]['date']),
                        ),
                      );
                    })
                : Center(
                    child:
                        Container(child: new Text("No detain list generated")));
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class StudentDetainList extends StatelessWidget {
  final List<dynamic> student;

  StudentDetainList(this.student);

  @override
  Widget build(BuildContext context) {
    return StudentList(student);
  }
}

class StudentList extends StatefulWidget {
  final List<dynamic> student;

  StudentList(this.student);

  @override
  _StudentListState createState() => _StudentListState(student);
}

class _StudentListState extends State<StudentList> {
  final List<dynamic> student;

  _StudentListState(this.student);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Detain List"),
      body: Container(
        child: new ListView(
          children: <Widget>[
            student.length > 0
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      Center(
                        child: Text(
                          student.length.toString() +
                              " student(s) were detained",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      ListView.builder(
                          itemCount: student.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance
                                    .collection("student_details")
                                    .document(student[index])
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot != null && snapshot.hasData) {
                                    var data = snapshot.data;
                                    return Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20, top: 10),
                                        child: Card(
                                          child: ListTile(
                                            leading: Text(
                                              index.toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            trailing: Text(data['division'] +
                                                data['batch']),
                                            title: Text(data['enrollment']),
                                            subtitle: Text(data['first_name'] +
                                                " " +
                                                data['middle_name'] +
                                                " " +
                                                data['last_name']),
                                          ),
                                        ));
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                });
                          }),
                    ],
                  )
                : Container(
                    child:
                        Center(child: new Text("No Student(s) were detained")))
          ],
        ),
      ),
    );
  }
}
