import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveApplication extends StatefulWidget {
  @override
  _LeaveApplicationState createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {
  TextEditingController _description = new TextEditingController();

  bool _descriptionValidate = false;

  File _file;

  String _username;
  String _name;
  String _studentEnr;
  String _studentName;
  String _sem;

  int len = 0;
  var itemsStudent;

  SharedPreferences prf;

  @override
  void dispose() {
    // TODO: implement dispose
    _description.dispose();
    super.dispose();
  }

  @override
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
        .collection('parent_details')
        .document(_username)
        .get()
        .then((document) {
      _name = document['full_name'];
      _studentName = document['student_name'];
      _studentEnr = document['student_enrollment'];
      _sem = document['student_semester'] +
          " " +
          document['student_division'] +
          document['student_batch'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Leave Application"),
      body: new Container(
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Container(
                child: new Form(
                    child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: new Column(
                    children: <Widget>[
                      new TextField(
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              _descriptionValidate = true;
                            } else {
                              if (value.trim().length == 0) {
                                _descriptionValidate = true;
                              } else {
                                _descriptionValidate = false;
                              }
                            }
                          });
                        },
                        controller: _description,
                        keyboardType: TextInputType.multiline,
                        autofocus: true,
                        maxLines: 3,
                        maxLength: 100,
                        cursorColor: Colors.purple,
                        cursorRadius: Radius.circular(50.0),
                        cursorWidth: 3.0,
                        decoration: new InputDecoration(
                            prefixIcon: new Icon(Icons.description),
                            labelText: "Description",
                            errorText: _descriptionValidate
                                ? 'Please Enter Description'
                                : null,
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            hintStyle: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            )),
                      ),
                      new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                      _file != null
                          ? Center(
                              child: Column(
                                children: <Widget>[
                                  Image.file(
                                    _file,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Colors.tealAccent,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _file = null;
                                        });
                                      }),
                                  RaisedButton(
                                    onPressed: _showBottom,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    color: Colors.redAccent,
                                    child: Text(
                                      "Change Document",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  new Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0)),
                                  _descriptionValidate == true
                                      ? new Container()
                                      : new RaisedButton(
                                          onPressed: () {
                                            _uploadFile();
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          color: Colors.redAccent,
                                          child: Text(
                                            "Upload",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                ],
                              ),
                            )
                          : new RaisedButton(
                              onPressed: _showBottom,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.redAccent,
                              child: Text(
                                "Select Document",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      new Padding(padding: EdgeInsets.only(bottom: 70)),
                      new RaisedButton(
                        onPressed: _uploaded,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.redAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Uploaded Applications",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.cloud,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _uploaded() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return new Container(
            padding: EdgeInsets.all(5.0),
            height: 500,
            child: new Column(
              children: <Widget>[
                new Align(
                  alignment: Alignment.topLeft,
                  child: new IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                new Flexible(
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection("Leave_application")
                            .where('parent_phone', isEqualTo: _username)
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
                                    "No Uploaded Application yet!",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                );
                        }))
              ],
            ),
          );
        });
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
                      .where('parent_phone', isEqualTo: _username)
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    itemsStudent = snap.data.documents;
                    return Text(
                      itemsStudent[index]['parent_name'],
                      style: new TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                new Padding(padding: EdgeInsets.only(bottom: 5.0)),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .where('parent_phone', isEqualTo: _username)
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    itemsStudent = snap.data.documents;
                    return Text(
                      itemsStudent[index]['student_name'],
                      style: new TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                new Padding(padding: EdgeInsets.only(bottom: 5.0)),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .where('parent_phone', isEqualTo: _username)
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
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
                  },
                ),
                new Padding(padding: EdgeInsets.only(bottom: 15.0)),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .where('parent_phone', isEqualTo: _username)
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    itemsStudent = snap.data.documents;
                    int action = itemsStudent[index]['action'];
                    String facName = itemsStudent[index]['faculty_name'];
                    int type = itemsStudent[index]['type'];
                    String date = itemsStudent[index]['date'];
                    return action == 0
                        ? new Text(
                            "No Response yet",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
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
                  },
                ),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Leave_application")
                      .where('parent_phone', isEqualTo: _username)
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    itemsStudent = snap.data.documents;
                    String date = itemsStudent[index]['date'];
                    return new Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      alignment: Alignment.centerRight,
                      child: new Column(
                        children: <Widget>[
                          new Text(date),
                        ],
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future _showBottom() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return new Container(
            padding: const EdgeInsets.all(15.0),
            color: Colors.grey,
            height: 200,
            child: new Center(
              child: new ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.photo,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Gallery",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _chooseFile();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _chooseFileFromCamera();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                    ),
                    title: Text(
                      "PDF",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      getPdf();
                    },
                  ),
                  new RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.blueGrey,
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  int type;

  Future _chooseFile() async {
    _file = null;
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _file = image;
        type = 0;
      });
    });
  }

  Future _chooseFileFromCamera() async {
    _file = null;
    await ImagePicker.pickImage(source: ImageSource.camera).then((image) {
      setState(() {
        _file = image;
        type = 0;
      });
    });
  }

  Future getPdf() async {
    _file = null;
    var file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['pdf', 'doc']);
    if (file != null) {
      setState(() {
        _file = file;
        type = 1;
      });
    }
  }

  String _uploadedFileURL;

  Future _uploadFile() async {
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
    await pr.show();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Leave_Application/${Path.basename(_file.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_file);
    await uploadTask.onComplete;
    if (uploadTask.isSuccessful) {
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
        });
      });
      if (_uploadedFileURL == null) {
        pr.hide();
        Fluttertoast.showToast(
            msg: "There Is Some Error Uploading Image Please Try Again");
      } else {
        await Firestore.instance
            .collection("Leave_application")
            .document(DateTime.now().toString())
            .setData({
          'description': _description.text,
          'timestamp': DateTime.now().toString(),
          'url': _uploadedFileURL,
          'type': type,
          'parent_name': _name,
          'parent_phone': _username,
          'student_name': _studentName,
          'student_enrollment': _studentEnr,
          'action': 0,
          'semester': _sem,
          'date': DateTime.now().day.toString() +
              "/" +
              DateTime.now().month.toString() +
              "/" +
              DateTime.now().year.toString(),
        });
        pr.hide();
        Fluttertoast.showToast(
            msg: "Uploaded",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);
      }
    } else {
      pr.hide();
      Fluttertoast.showToast(
          msg: "There Is Some Error Uploading Image Please Try Again");
    }
  }
}
