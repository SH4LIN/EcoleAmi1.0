import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  File _image;
  String _uploadedFileURL;

  var now = new DateTime.now();
  var nowTime = new DateTime.now();
  DateTime date1;
  List<String> _typelist = ['Event', 'College Schedule', 'Fee Payment'];
  String _selectedType;

  TextEditingController _title = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _date = new TextEditingController();

  bool _titleValidate = false;
  bool _desValidate = false;
  bool _dateValidate = false;
  bool _eventTypeValidate = false;

  void dispose() {
    super.dispose();
    _title.dispose();
    _description.dispose();
  }

  final databaseReference = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CommonAppBar("Add Event"),
      body: new Container(
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Container(
                child: new Form(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new TextField(
                          controller: _title,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              prefixIcon: new Icon(Icons.title),
                              labelText: "Title",
                              errorText: _titleValidate
                                  ? 'Please Enter Title'
                                  : null,
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              hintStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              )),
                        ),
                        new Padding(
                            padding: const EdgeInsets.only(bottom: 15.0)),
                        new TextField(
                          controller: _description,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          maxLength: 100,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                            /*prefixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      bottom: 43.0),
                                  child: new Icon(Icons.description),
                                ),*/
                              prefixIcon: new Icon(Icons.description),
                              labelText: "Description",
                              errorText: _desValidate
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
                        new Padding(
                            padding: const EdgeInsets.only(bottom: 15.0)),
//                        GestureDetector()
                        DateTimePickerFormField(
                          controller: _date,
                          initialDate: now,
                          enabled: true,
                          firstDate: now,
                          lastDate: now.add(new Duration(days: 180)),
                          inputType: InputType.both,
                          format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
                          editable: false,
                          decoration: InputDecoration(
                              prefixIcon: new Icon(Icons.date_range),
                              labelText: 'Expiry Date',
                              errorText:
                              _dateValidate ? 'Please Select Date' : null,
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              hintStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              )),
                          onChanged: (dt) {
                            setState(() => date1 = dt);
                            print('Selected date: $date1');
                          },
                        ),
                        new Padding(
                            padding: const EdgeInsets.only(bottom: 15.0)),
                        Container(
                          padding: const EdgeInsets.only(left: 20.0),
                          decoration: new BoxDecoration(
                            border: Border.all(
                                style: BorderStyle.solid, width: 0.80),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: DropdownButton<String>(
                            underline: SizedBox(),
                            items: _typelist.map((String val) {
                              return new DropdownMenuItem<String>(
                                value: val,
                                child: new Text(val),
                              );
                            }).toList(),
                            hint: Text("Event Type"),
                            onChanged: (String newVal) {
                              setState(() {
                                this._selectedType = newVal;
                              });
                            },
                            value: _selectedType,
                            isExpanded: true,
                          ),
                        ),
                        new Padding(
                            padding: const EdgeInsets.only(bottom: 5.0)),
                        _eventTypeValidate
                            ? new Text("    Please select event type",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w400))
                            : Container(),
                        new Padding(
                            padding: const EdgeInsets.only(bottom: 15.0)),
                        _image != null
                            ? Center(
                          child: Column(
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  /*Image.asset(
                                            _image.path,
                                            height: 150,
                                            fit: BoxFit.fitWidth,
                                            alignment: Alignment.center,
                                          ),*/
                                  Image.file(
                                    _image,
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
                                                _image = null;
                                              });
                                            })
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              RaisedButton(
                                onPressed: _showBottom,
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.add_photo_alternate,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Change Image",
                                        style: TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                color: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20)),
                                padding: EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                    top: 10,
                                    bottom: 10),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    if (_title.text.isEmpty) {
                                      _titleValidate = true;
                                    } else if (_title.text.trim().length == 0){
                                      _titleValidate = true;
                                    } else {
                                      _titleValidate = false;
                                    }
                                    if (_description.text.isEmpty) {
                                      _desValidate = true;
                                    } else if (_description.text.trim().length == 0){
                                      _desValidate = true;
                                    } else {
                                      _desValidate = false;
                                    }
                                   /* if (_date.text.isEmpty) {
                                      _dateValidate = true;
                                    } else {
                                      _dateValidate = false;
                                    }*/
                                    if (_selectedType == null) {
                                      _eventTypeValidate = true;
                                    } else {
                                      _eventTypeValidate = false;
                                    }
                                    if (_titleValidate == false &&
                                        _desValidate == false &&
//                                        _dateValidate == false &&
                                        _eventTypeValidate == false) {
                                      _uploadFile();
                                    }
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20)),
                                color: Colors.redAccent,
                                child: Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        )
                            : Column(
                          children: <Widget>[
                            RaisedButton(
                              onPressed: _showBottom,
                              child: Container(
                                width:
                                MediaQuery.of(context).size.width,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              color: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20)),
                              padding: EdgeInsets.only(
                                  left: 40,
                                  right: 40,
                                  top: 10,
                                  bottom: 10),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  if (_title.text.isEmpty) {
                                    _titleValidate = true;
                                  } else if (_title.text.trim().length == 0){
                                    _titleValidate = true;
                                  } else {
                                    _titleValidate = false;
                                  }
                                  if (_description.text.isEmpty) {
                                    _desValidate = true;
                                  } else if (_description.text.trim().length == 0){
                                    _desValidate = true;
                                  } else {
                                    _desValidate = false;
                                  }
                                  /*if (_date.text.isEmpty) {
                                    _dateValidate = true;
                                  } else {
                                    _dateValidate = false;
                                  }*/
                                  print(_selectedType);
                                  /*if (_selectedType == "Event" || _selectedType == "College Schedule" || _selectedType == "Fee Payment") {
                                            _eventTypeValidate = false;
                                          }
                                          if (_selectedType != "Event" || _selectedType != "College Schedule" || _selectedType != "Fee Payment") {
                                            _eventTypeValidate = true;
                                          }*/
                                  if (_selectedType == null) {
                                    _eventTypeValidate = true;
                                  } else {
                                    _eventTypeValidate = false;
                                  }
                                  print(_eventTypeValidate);
                                  if (_titleValidate == false &&
                                      _desValidate == false &&
//                                      _dateValidate == false &&
                                      _eventTypeValidate == false) {
                                    if (_image == null) {
                                      Fluttertoast.showToast(
                                        msg:
                                        "Please select an image first",
                                        gravity: ToastGravity.CENTER,
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.white,
                                      );
                                      _showBottom();
                                    }
                                  }
                                  if (_titleValidate == false &&
                                      _desValidate == false &&
                                      _dateValidate == false &&
                                      _eventTypeValidate == false &&
                                      _image != null) {
                                    _uploadFile();
                                  }
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20)),
                              color: Colors.redAccent,
                              child: Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
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

  Future _chooseFile() async {
    _image = null;
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future _chooseFileFromCamera() async {
    _image = null;
    await ImagePicker.pickImage(source: ImageSource.camera).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future _uploadFile() async {
    ProgressDialog pr = new ProgressDialog(context,type: ProgressDialogType.Normal,showLogs: true,isDismissible: false);
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
        )
    );
    await pr.show();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('e-board Images/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    if(uploadTask.isSuccessful) {
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
        final snapShot = await Firestore.instance
            .collection("e-notice-board")
            .document(now.toString())
            .get();
        if (snapShot == null || !snapShot.exists) {
          await databaseReference
              .collection("e-notice-board")
              .document(now.toString())
              .setData({
            'title': _title.text,
            'type': _selectedType,
            'description': _description.text,
            'expiry_date': date1,
            'url': _uploadedFileURL,
            'timestamp': DateTime.now()
          });
          pr.hide();
          Fluttertoast.showToast(
              msg: "Event Uploaded",
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_LONG);
          Navigator.pop(context);
        }
      }
    }
    else{
      pr.hide();
      Fluttertoast.showToast(msg: "There Is Some Error Uploading Image Please Try Again");
    }

  }
}