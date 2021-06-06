import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:ecoleami1_0/ManageFaculty.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:email_validator/email_validator.dart';

class FacultyAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new AddInfo(),
    );
  }
}

class AddInfo extends StatefulWidget {
  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar("Faculty Details"),
      body: new Container(
        child: new Center(
          child: new Add(),
        ),
      ),
    );
  }
}

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final databaseReference = Firestore.instance;

//    TextEditingController _enr;
  TextEditingController _fName = new TextEditingController();
  TextEditingController _lName = new TextEditingController();
  TextEditingController _eMail = new TextEditingController();
  TextEditingController _phone = new TextEditingController();

  bool _fValidate = false;
  bool _lValidate = false;
  bool _emailValidate = false;
  bool _phoneValidate = false;

  void dispose() {
    super.dispose();
    _fName.dispose();
    _lName.dispose();
    _eMail.dispose();
    _phone.dispose();
  }

  String fNameErrorText = 'Please enter First Name';
  String lNameErrorText = 'Please enter Last Name';

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new Form(

              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: new Column(
                  children: <Widget>[
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
                      onChanged: (String str) {
                        RegExp fnameregex = RegExp(r"^[a-zA-Z]*$");
                        setState(() {
                          if (fnameregex.hasMatch(str)) {
                            _fValidate = false;
                          } else {
                            fNameErrorText =
                            "Name Should Contain Only Characters";
                            _fValidate = true;
                          }
                        });
                      },
                      controller: _fName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "First Name",
                          errorText:
                              _fValidate ? fNameErrorText : null,
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
                      onChanged: (String str) {
                        RegExp fnameregex = RegExp(r"^[a-zA-Z]*$");
                        setState(() {
                          if (fnameregex.hasMatch(str)) {
                            _lValidate = false;
                          } else {
                            lNameErrorText =
                            "Name Should Contain Only Characters";
                            _lValidate = true;
                          }
                        });
                      },
                      controller: _lName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Last Name",
                          errorText:
                              _lValidate ? lNameErrorText : null,
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
                      onChanged: (String str) {
                        setState(() {
                          if (EmailValidator.validate(str)) {
                            _emailValidate = false;
                          } else {
                            _emailValidate = true;
                          }
                        });
                      },
                      controller: _eMail,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Email Address",
                          errorText: _emailValidate
                              ? 'Please enter valid Email Address'
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
                      onChanged: (String str) {
                        RegExp regexp = new RegExp(r'^[6789]\d{9}$');
                        setState(() {
                          if (regexp.hasMatch(str)) {
                            _phoneValidate = false;
                          } else {
                            _phoneValidate = true;
                          }
                        });
                      },
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      maxLength: 10,
                      decoration: new InputDecoration(
                          hintText: "Phone Number",
                          errorText: _phoneValidate
                              ? 'Please Enter Valid Phone Number'
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
                        "Add",
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
                          if (_fName.text.isNotEmpty &&
                              _lName.text.isNotEmpty &&
                              _eMail.text.isNotEmpty &&
                              _phone.text.isNotEmpty) {
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
      ],
    );
  }

  void _onClick() async {
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
    pr.show();
    final snapShot = await Firestore.instance
        .collection("faculty_details")
        .document(_phone.text)
        .get();
    if (snapShot == null || !snapShot.exists) {
      await databaseReference
          .collection("faculty_details")
          .document(_phone.text)
          .setData({
        'first_name': _fName.text,
        'last_name': _lName.text,
        'email': _eMail.text,
        'phone_number': _phone.text,
      });
      final snapShot = await databaseReference
          .collection("login_details")
          .document(_phone.text)
          .get();
      print(snapShot.exists.toString());
      print(_phone.text);
      print(snapShot!=null);
      if (snapShot == null || snapShot.exists) {

      }
      else{
        await databaseReference
            .collection("login_details")
            .document(_phone.text)
            .setData({'password': null, 'role': "faculty"});
      }
      final snap = await databaseReference
          .collection("verification_details")
          .document(_phone.text)
          .get();
      if (snap == null || snap.exists) {

      }
      else{
        await databaseReference
            .collection("verification_details")
            .document(_phone.text)
            .setData({'password': null, 'role': "faculty"});
      }
      pr.hide();
      Fluttertoast.showToast(
          msg: "Record Added Successfully", gravity: ToastGravity.BOTTOM);
      pr.hide();
      Navigator.pop(context);
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ManageFaculty()));
    }
    else{
      Fluttertoast.showToast(
          msg: "Record Exist",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black);
      pr.hide();
    }
  }

//print(ref.documentID);
}
