import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/ManageStudent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'CommonAppBar.dart';

 // ignore: must_be_immutable
 class UpdateStudent extends StatelessWidget {
   int id;
   UpdateStudent(this.id);
   @override
   Widget build(BuildContext context) {
     return Scaffold(
      body: UpdateStudentData(this.id),
     );
   }
 }

// ignore: must_be_immutable
class UpdateStudentData extends StatefulWidget {
   int id;
   UpdateStudentData(this.id);
  @override
  _UpdateStudentState createState() {
    return new _UpdateStudentState(id);
  }
}

class _UpdateStudentState extends State<UpdateStudentData> {
   int id;
   _UpdateStudentState(this.id);

   bool _obscureText = true;

   final databaseReference = Firestore.instance;

//    TextEditingController _enr;


  bool _fValidate = false;
  bool _mValidate = false;
  bool _lValidate = false;
  bool _emailValidate = false;
  bool _phoneValidate = false;
  bool _semValidate = false;

  void dispose() {
    super.dispose();
    _fName.dispose();
    _mName.dispose();
    _lName.dispose();
    _eMail.dispose();
    _phone.dispose();
  }
  TextEditingController _fName = new TextEditingController();
  TextEditingController _mName = new TextEditingController();
  TextEditingController _lName = new TextEditingController();
  TextEditingController _eMail = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _sem = new TextEditingController();
  TextEditingController _enr = new TextEditingController();
  @override
  void initState() {
    super.initState();
    print(id);
    _fName.text = itemsStudent[id]['first_name'];
    _mName.text = itemsStudent[id]['middle_name'];
    _lName.text = itemsStudent[id]['last_name'];
    _eMail.text = itemsStudent[id]['email'];
    _phone.text = itemsStudent[id]['phone_number'];
    _sem.text = itemsStudent[id]['semester'];
    if(itemsStudent[id]['enrollment'] != null || itemsStudent[id]['enrollment'] != "null") {
      _enr.text = itemsStudent[id]['enrollment'];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Update Student Details"),
      backgroundColor: Colors.grey,
      body: BodyUpdate(context),
    );
  }
  // ignore: non_constant_identifier_names
  Widget BodyUpdate(BuildContext context){
    return new ListView(
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new Form(
            child: new Card(
              elevation: 30.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      controller: _enr,
                      enabled: true,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Enrollment",
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.account_circle),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
                      controller: _fName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "First Name",
                          errorText:
                          _fValidate ? 'Please enter First Name' : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.person),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
                      controller: _mName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Middle Name",
                          errorText:
                          _mValidate ? 'Please enter Middle Name' : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.person),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
                      controller: _lName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Last Name",
                          errorText:
                          _lValidate ? 'Please enter Last Name' : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.person),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextFormField(
                      controller: _eMail,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Email Address",
                          errorText: _emailValidate
                              ? 'Please enter Email Address'
                              : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.email),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      maxLength: 10,
                      decoration: new InputDecoration(
                          hintText: "Phone Number",
                          errorText: _phoneValidate
                              ? 'Please enter Phone Number'
                              : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.phone),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
                      controller: _sem,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Semester",
                          errorText:
                          _semValidate ? 'Please enter Semester' : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.format_list_numbered),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
//                      controller: _pass,
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText,
                      enabled: false,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Password",
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.lock),
                          suffixIcon: new IconButton(
                            icon: new Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new Padding(padding: const EdgeInsets.only(bottom: 20.0)),
                    new RaisedButton(
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: new Text(
                        "Update",
                        style:
                        new TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_fName.text.isEmpty) {
                            _fValidate = true;
                          } else {
                            _fValidate = false;
                          }
                          if (_mName.text.isEmpty) {
                            _mValidate = true;
                          } else {
                            _mValidate = false;
                          }
                          if (_lName.text.isEmpty) {
                            _lValidate = true;
                          } else {
                            _lValidate = false;
                          }
                          if (_eMail.text.isEmpty) {
                            _emailValidate = true;
                          } else {
                            _emailValidate = false;
                          }
                          if (_phone.text.isEmpty) {
                            _phoneValidate = true;
                          } else {
                            _phoneValidate = false;
                          }
                          if (_sem.text.isEmpty) {
                            _semValidate = true;
                          } else {
                            _semValidate = false;
                          }
                          if (_fValidate == false &&
                              _mValidate == false &&
                              _lValidate == false &&
                              _emailValidate == false &&
                              _phoneValidate == false &&
                              _semValidate == false) {
                            _onClick();
                          }
                        });
                      },
                      splashColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
    /*return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            color: Colors.white,
            child: Text("Hello"),
          ),
        ],
      ),
    );*/
  }
  void _onClick() async{
    ProgressDialog pr = new ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
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
      await Firestore.instance.collection('student_details').document(
          itemsStudent[id].documentID).updateData({
        'enrollment': _enr.text,
        'email': _eMail.text,
        'first_name': _fName.text,
        'last_name': _lName.text,
        'middle_name': _mName.text,
        'phone_number': _phone.text,
        'semester': _sem.text
      });
    }catch(e){
      pr.hide();
      print(e.toString());
    }
    pr.hide();
    Fluttertoast.showToast(msg: "Record Updated");
    Navigator.of(context).pop();
  }
}
