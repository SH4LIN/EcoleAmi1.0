import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Register.dart';
import 'MainScreen.dart';

class SetParentDetails extends StatefulWidget {
  @override
  _SetParentDetailsState createState() => _SetParentDetailsState();
}

class _SetParentDetailsState extends State<SetParentDetails> {
  TextEditingController _enroll = new TextEditingController();
  TextEditingController _studentFullName = new TextEditingController();
  TextEditingController _fullName = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
  TextEditingController _confirmPass = new TextEditingController();

  String _username;
  String _enrCheck;
  SharedPreferences prf;

  bool _obscureText = true;
  bool _fullNameValidate = false;
  bool _passValidate = false;
  bool _cPassValidate = false;

  void dispose() {
    _fullName.dispose();
    _pass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    registeredUser != null ? _username = registeredUser : setUser();
    print(_username);
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("rUsername");
    //Fluttertoast.showToast(msg: prf.get("Username"));
    print(_username);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white70,
      appBar: CommonAppBar("Register"),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            new Container(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: new Form(
                  child: new Card(
                elevation: 30.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: new Column(
                    children: <Widget>[
                      new ExpansionTile(
                        title: Text("Student Details",
                            style: TextStyle(fontSize: 15)),
                        children: <Widget>[
                          StreamBuilder(
                              stream: Firestore.instance
                                  .collection("parent_details")
                                  .document(_username)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.none) {
                                  _studentFullName.text = "Loading...!";
                                }
                                if (snapshot.hasData) {
                                  var document = snapshot.data;
                                  _studentFullName.text =
                                      document['student_name'];
                                }
                                return new TextField(
                                  controller: _studentFullName,
                                  enabled: false,
                                  decoration: new InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                      hintText: "Student Full Name",
                                      hintStyle: new TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white70,
                                      ),
                                      prefixIcon: new Icon(Icons.person),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                );
                              }),
                          new Padding(
                              padding: const EdgeInsets.only(bottom: 15.0)),
                          StreamBuilder(
                              stream: Firestore.instance
                                  .collection("parent_details")
                                  .document(_username)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.none) {
                                  _enroll.text = "Loading...!";
                                }
                                if (snapshot.hasData) {
                                  var document = snapshot.data;
                                  _enroll.text = document['student_enrollment'];
                                  _enrCheck = document['student_enrollment'];
                                  print(_enrCheck);
                                }
                                return (_enrCheck.compareTo("------------")) ==
                                        0
                                    ? Container(width: 0, height: 0)
                                    : TextField(
                                        controller: _enroll,
                                        enabled: false,
                                        decoration: new InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 5.0),
                                            hintText: "Student Full Name",
                                            hintStyle: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white70,
                                            ),
                                            prefixIcon: new Icon(Icons.person),
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            )),
                                      );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
            ),
            new Container(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              child: new Form(
                  child: new Card(
                elevation: 30.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: new Column(
                    children: <Widget>[
                      new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                      new TextField(
                        controller: _fullName,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.purple,
                        cursorRadius: Radius.circular(50.0),
                        cursorWidth: 3.0,
                        decoration: new InputDecoration(
                            hintText: "Full Name",
                            errorText: _fullNameValidate
                                    ? 'Please enter Full Name'
                                    : null,
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
                        controller: _pass,
                        obscureText: _obscureText,
                        autofocus: true,
                        cursorColor: Colors.purple,
                        cursorRadius: Radius.circular(50.0),
                        cursorWidth: 3.0,
                        decoration: new InputDecoration(
                            hintText: "Set Password",
                            errorText: _passValidate
                                ? 'This field can not be empty'
                                : null,
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
                      new TextField(
                        controller: _confirmPass,
                        cursorColor: Colors.purple,
                        obscureText: _obscureText,
                        cursorRadius: Radius.circular(50.0),
                        cursorWidth: 3.0,
                        decoration: new InputDecoration(
                            hintText: "Confirm Password",
                            errorText: _cPassValidate
                                ? 'This field can not be empty'
                                : null,
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
                      new Padding(padding: const EdgeInsets.only(bottom: 20.0)),
                      new RaisedButton(
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: new Text(
                          "Save",
                          style: new TextStyle(
                              color: Colors.white, fontSize: 15.0),
                        ),
                        onPressed: () {
                          setState(() {
                            if (_fullName.text.isEmpty) {
                              _fullNameValidate = true;
                            } else {
                              _fullNameValidate = false;
                            }
                            if (_pass.text.isEmpty) {
                              _passValidate = true;
                            } else {
                              _passValidate = false;
                            }
                            if (_confirmPass.text.isEmpty) {
                              _cPassValidate = true;
                            } else {
                              _cPassValidate = false;
                            }
                            if (_pass.text != _confirmPass.text) {
                              Fluttertoast.showToast(
                                  msg: "Password does not match",
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.black);
                            }
                            if (_fullNameValidate == false &&
                                _passValidate == false &&
                                _cPassValidate == false) {
                                  saveDetails();
                            }
                          });
                        },
                        splashColor: Colors.red,
                      )
                    ],
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveDetails() async {
    try {
      Firestore.instance
          .collection("login_details")
          .document(_username)
          .updateData({
        'password' : _pass.text,
      });
      Firestore.instance
          .collection("parent_details")
          .document(_username)
          .updateData({
        'full_name' : _fullName.text,
      });
      SharedPreferences prf = await SharedPreferences.getInstance();
      prf.setString("rUsername", "");
      Fluttertoast.showToast(
          msg: "Details Saved",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black
      );
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new MainScreen()));

    } catch(e) {
      print(e.toString());
    }

  }
}
