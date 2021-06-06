import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

Future<void> main() {
  runApp(Assignment());
}

class Assignment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Assignment"),
      body: Assignment_Home(),
    );
  }
}

class Assignment_Home extends StatefulWidget {
  @override
  _Assignment_HomeState createState() => _Assignment_HomeState();
}

class _Assignment_HomeState extends State<Assignment_Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              index += 1;
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  trailing: Icon(Icons.navigate_next),
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? Colors.blue
                            : Colors.black12,
                    child: Text(
                      index.toString(),
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ),
                  title: Text("Semester " + index.toString()),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Student_Semester_Assignments(index.toString())));
                  },
                ),
              );
            },
            itemCount: 6,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.redAccent,
              splashColor: Colors.red,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => UploadAssignment()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Upload Assignment"),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.cloud_upload)
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}

class Student_Semester_Assignments extends StatelessWidget {
  final sem;

  Student_Semester_Assignments(this.sem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Assignments Semester $sem "),
      body: Semwise_Assignment(sem),
    );
  }
}

class Semwise_Assignment extends StatefulWidget {
  final sem;

  Semwise_Assignment(this.sem);

  @override
  _Semwise_AssignmentState createState() => _Semwise_AssignmentState(sem);
}

class _Semwise_AssignmentState extends State<Semwise_Assignment> {
  final sem;
  var totalData = -1;

  _Semwise_AssignmentState(this.sem);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("assignments")
              .where("semester", isEqualTo: sem)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot != null && snapshot.hasData) {
              QuerySnapshot data = snapshot.data;
              var allData = data.documents;
              if (data.documents.length != null) {
                totalData = data.documents.length;
                print("Data $totalData");
              }
              if (totalData == -1) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (totalData == 0) {
                return Center(
                  child: Text("No Assignments Are Given"),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    print("Index $index");
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                      child: GestureDetector(
                        onTap: () {
                          String fileUrl;
                          downloadPdf(allData[index]["url"],
                                  allData[index]['assignment name'])
                              .then((String url) {
                            fileUrl = url;
                            if (fileUrl == '') {
                              Fluttertoast.showToast(
                                  msg: "File Could Not be Downloaded");
                            } else {
                              OpenFile.open(fileUrl, type: 'pdf');
                            }
                          });
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.picture_as_pdf),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.cloud_download,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                String fileUrl;
                                downloadPdf(allData[index]["url"],
                                        allData[index]['assignment name'])
                                    .then((String url) {
                                  fileUrl = url;
                                  if (fileUrl == '') {
                                    Fluttertoast.showToast(
                                        msg: "File Could Not be Downloaded");
                                  } else {
                                    OpenFile.open(fileUrl);
                                  }
                                });
                              },
                            ),
                            title: Text(allData[index]['assignment name']),
                            subtitle: Text(
                              allData[index]['subject'],
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        onLongPress: () {
                          showGeneralDialog(
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionBuilder: (context, a1, a2, widget) {
                                final curvedValue =
                                    Curves.easeInOutBack.transform(a1.value) -
                                        1.0;
                                return Transform(
                                  transform: Matrix4.translationValues(
                                      0.0, curvedValue * 200, 0.0),
                                  child: Opacity(
                                    opacity: a1.value,
                                    child: AlertDialog(
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      title: Text(
                                        'Warning!',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                      content: Text(
                                          'Are You Sure You Want To Delete This Assignment?'),
                                      actions: <Widget>[
                                        new FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: new Text(
                                              "No",
                                              style: TextStyle(fontSize: 18),
                                            )),
                                        new FlatButton(
                                            onPressed: () async {
                                              var documentid =
                                                  allData[index].documentID;
                                              Firestore.instance
                                                  .collection("assignments")
                                                  .document(documentid)
                                                  .delete();
                                              Navigator.of(context).pop();
                                            },
                                            child: new Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 18),
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
                              pageBuilder:
                                  (context, animation1, animation2) {});
                        },
                      ),
                    );
                  },
                  itemCount: totalData,
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<String> downloadPdf(String url, String name) async {
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
  }
}

class UploadAssignment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Upload Assignment"),
      body: Upload_Assignment_Page(),
    );
  }
}

class Upload_Assignment_Page extends StatefulWidget {
  @override
  _Upload_Assignment_PageState createState() => _Upload_Assignment_PageState();
}

class _Upload_Assignment_PageState extends State<Upload_Assignment_Page> {
  TextEditingController _assignmentName = new TextEditingController();
  var _selectedSemester;
  var _selectedSubject;

  bool _validate = false;
  bool _semValidate = false;
  bool _subjectValidate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    _validate = true;
                  } else {
                    if (value.trim().length == 0) {
                      _validate = true;
                    } else {
                      _validate = false;
                    }
                  }
                });
              },
              controller: _assignmentName,
              keyboardType: TextInputType.text,
              cursorColor: Colors.purple,
              cursorRadius: Radius.circular(50.0),
              cursorWidth: 3.0,
              decoration: new InputDecoration(
                  hintText: "Assignment Name",
                  errorText: _validate ? 'Enter Assignment Name' : null,
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
            ),
          ),
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
          _semValidate
              ? Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Please select semester",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w400)),
                  ),
                )
              : Container(),
          _selectedSemester != null
              ? Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                    _subjectValidate
                        ? Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Please select subject",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                            ),
                          )
                        : Container(),
                    _file == null
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: RaisedButton(
                              onPressed: () => getPdf(),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.redAccent,
                              splashColor: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Choose File"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(Icons.attach_file)
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: RaisedButton(
                                  onPressed: () => getPdf(),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.redAccent,
                                  splashColor: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Change File"),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Icon(Icons.attach_file)
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 14),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.pinkAccent,
                                    borderRadius: BorderRadius.circular(20)),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                        child: Text(
                                      _file.path,
                                      style: TextStyle(color: Colors.white),
                                    ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                )
              : _file == null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: RaisedButton(
                        onPressed: () => getPdf(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.redAccent,
                        splashColor: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Choose File"),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(Icons.attach_file)
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: RaisedButton(
                            onPressed: () => getPdf(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.redAccent,
                            splashColor: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Change File"),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(Icons.attach_file)
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(20)),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                  child: Text(
                                _file.path,
                                style: TextStyle(color: Colors.white),
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: MediaQuery.of(context).size.width * 0.5,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    if (_selectedSemester == null) {
                      _semValidate = true;
                    } else {
                      _semValidate = false;
                      if (_selectedSubject == null) {
                        _subjectValidate = true;
                      } else {
                        _subjectValidate = false;
                      }
                    }
                    if (_validate == false &&
                        _semValidate == false &&
                        _subjectValidate == false) {
                      uploadPdf();
                    }
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.redAccent,
                splashColor: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Upload"),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.cloud_upload)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  StorageReference storageReference;
  File _file;

  Future getPdf() async {
    _file = null;
    try {
      var file = await FilePicker.getFile(
          type: FileType.custom, allowedExtensions: ['pdf', 'doc']);
      print("Test");
      print(file);
      if (file != null) {
        setState(() {
          _file = file;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadPdf() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, showLogs: true, isDismissible: false);
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
    storageReference = FirebaseStorage.instance
        .ref()
        .child('Assignments/${Path.basename(_assignmentName.text)}');
    if (_file != null) {
      var uploadTask = storageReference.putFile(_file);
      await pr.show();
      String url = await (await uploadTask.onComplete).ref.getDownloadURL();
      print(url);
      await Firestore.instance.collection("assignments").add({
        "assignment name": _assignmentName.text,
        "subject": _selectedSubject,
        "url": url,
        "semester": _selectedSemester
      });
      if (uploadTask.isComplete) {
        pr.hide();
        Fluttertoast.showToast(msg: "Assignment Uploaded");
        Navigator.pop(context);
        _file = null;
      } else if (!uploadTask.isSuccessful) {
        pr.hide();
        Fluttertoast.showToast(msg: "Error Uploading Assignment");
      }
    } else {
      Fluttertoast.showToast(msg: "Please choose a file first", gravity: ToastGravity.CENTER);
    }
  }
}
