import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ecoleami1_0/FacultyActivity.dart';
import 'package:ecoleami1_0/Home.dart';
import 'package:ecoleami1_0/StudentActivity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'CommonAppBar.dart';
import 'StudentActivity.dart';
import 'Home.dart';
import 'FacultyActivity.dart';
import 'SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  SharedPreferences prf;

  TextEditingController _currentPass = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
  TextEditingController _confirmPass = new TextEditingController();

  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _currentPassValidate = false;
  bool _passValidate = false;
  bool _cPassValidate = false;
  bool _passConfirm = false;

  String _username;
  String _current;
  String _role;
  String errorMessage;
  String errorMessage2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user != null ? _username = user : setUser();
    print(_username);
    setProfile();
  }

  void dispose() {
    _currentPass.dispose();
    _pass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  void setProfile() async {
    Firestore.instance
        .collection("login_details")
        .document(_username)
        .get()
        .then((document) {
      _current = document['password'];
      _role = document['role'];
      print(_current);
      print(_role);
    });
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
    print(_username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new CommonAppBar("Change Password"),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: new Container(
                      child: new Container(
                    child: new Form(
                        child: new Card(
                      elevation: 30.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                        /*width: (MediaQuery.of(context).size.width),
                          height: (MediaQuery.of(context).size.height),*/
                        padding: const EdgeInsets.all(15.0),
                        child: new Column(
                          children: <Widget>[
                            new TextField(
                              onChanged: (value) {
                                _checkUser(value);
                                print(value);
                              },
                              controller: _currentPass,
                              obscureText: true,
                              enabled: _passConfirm ? false : true,
                              autofocus: _passConfirm ? false : true,
                              cursorColor: Colors.purple,
                              cursorRadius: Radius.circular(50.0),
                              cursorWidth: 3.0,
                              decoration: new InputDecoration(
                                  hintText: "Current Password",
                                  errorText: _currentPassValidate
                                      ? 'Password does not match'
                                      : null,
                                  hintStyle: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                  prefixIcon: new Icon(Icons.vpn_key),
                                  suffixIcon: new IconButton(
                                    icon: new Icon(_passConfirm
                                        ? Icons.verified_user
                                        : Icons.error),
                                    onPressed: null,
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                            ),
                            new Padding(
                                padding: const EdgeInsets.only(bottom: 15.0)),
                            new TextField(
                              onChanged: (value) {
                                validateStructure(value);
                              },
                              controller: _pass,
                              autofocus: _passConfirm ? true : false,
                              obscureText: _obscureText,
                              enabled: _passConfirm ? true : false,
                              cursorColor: Colors.purple,
                              cursorRadius: Radius.circular(50.0),
                              cursorWidth: 3.0,
                              decoration: new InputDecoration(
                                  hintText: "Set Password",
                                  errorText:
                                      _passValidate ? errorMessage : null,
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
                            new Padding(
                                padding: const EdgeInsets.only(bottom: 15.0)),
                            new TextField(
                              onChanged: (value) {
                                print(_passValidate);
                              },
                              controller: _confirmPass,
                              cursorColor: Colors.purple,
                              obscureText: _obscureText1,
                              enabled: _passConfirm ? true : false,
                              cursorRadius: Radius.circular(50.0),
                              cursorWidth: 3.0,
                              decoration: new InputDecoration(
                                  hintText: "Confirm Password",
                                  errorText:
                                      _cPassValidate ? errorMessage2 : null,
                                  hintStyle: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                  prefixIcon: new Icon(Icons.lock),
                                  suffixIcon: new IconButton(
                                    icon: new Icon(_obscureText1
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText1 = !_obscureText1;
                                      });
                                    },
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                            ),
                            new Padding(
                                padding: const EdgeInsets.only(bottom: 20.0)),
                            new ButtonBar(
                              alignment: MainAxisAlignment.center,
                              buttonAlignedDropdown: true,
                              children: <Widget>[
                                new RaisedButton(
                                  onPressed: () => {},
                                  splashColor: Colors.redAccent,
                                  color: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: new Text(
                                    "Forgot password?",
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      wordSpacing: 2.0,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                                new Padding(
                                    padding: const EdgeInsets.only(left: 30.0)),
                                new RaisedButton(
                                  color: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: new Text(
                                    "Save",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_passConfirm == true) {
                                        if (_passValidate == false) {
                                          if (_pass.text.isEmpty) {
                                            _passValidate = true;
                                            errorMessage =
                                                'This field can not be empty';
                                          } else {
                                            _passValidate = false;
                                          }
                                          if (_confirmPass.text.isEmpty) {
                                            _cPassValidate = true;
                                            errorMessage2 =
                                                "Password does not match";
                                          } else {
                                            _cPassValidate = false;
                                          }
                                          if (_passValidate == false &&
                                              _cPassValidate == false) {
                                            if (_pass.text.compareTo(
                                                    _confirmPass.text) !=
                                                0) {
                                              _cPassValidate = true;
                                              _confirmPass.clear();
                                              errorMessage2 =
                                                  "Password does not match";
                                            } else if (_pass.text
                                                    .compareTo(_current) ==
                                                0) {
                                              showGeneralDialog(
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  transitionBuilder: (context,
                                                      a1, a2, widget) {
                                                    final curvedValue = Curves
                                                            .easeInOutBack
                                                            .transform(
                                                                a1.value) -
                                                        1.0;
                                                    return Transform(
                                                      transform: Matrix4
                                                          .translationValues(
                                                              0.0,
                                                              curvedValue * 200,
                                                              0.0),
                                                      child: Opacity(
                                                        opacity: a1.value,
                                                        child: AlertDialog(
                                                          shape: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.0)),
                                                          title: Text(
                                                            'Error!',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 25),
                                                          ),
                                                          content: Text(
                                                              'Please set a new Password.'),
                                                          actions: <Widget>[
                                                            new FlatButton(
                                                                onPressed: () {
                                                                  _confirmPass
                                                                      .clear();
                                                                  _pass.clear();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: new Text(
                                                                  "Okay",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  transitionDuration: Duration(
                                                      milliseconds: 200),
                                                  barrierDismissible: true,
                                                  barrierLabel: '',
                                                  context: context,
                                                  pageBuilder:
                                                      // ignore: missing_return
                                                      (context, animation1,
                                                          animation2) {});
                                            } else {
                                              _passValidate = false;
                                              _cPassValidate = false;
                                              savePassword();
                                            }
                                          }
                                        }
                                      }
                                    });
                                  },
                                  splashColor: Colors.red,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
                  )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    setState(() {
      regExp.hasMatch(value) ? _passValidate = false : _passValidate = true;
      errorMessage = "Please set a Strong Password";
      print(_passValidate);
    });
    return regExp.hasMatch(value);
  }

  void _checkUser(String pass) async {
    var _passwordHash = md5.convert(utf8.encode(pass));
    if (_current.compareTo(_passwordHash.toString()) == 0) {
      setState(() {
        _currentPassValidate = false;
        _passConfirm = true;
        print(_passConfirm);
      });
    } else {
      setState(() {
        _currentPassValidate = true;
      });
    }
  }

  Future<void> savePassword() async {
    var _passwordHash = md5.convert(utf8.encode(_pass.text));
    try {
      Firestore.instance
          .collection("login_details")
          .document(_username)
          .updateData({
        'password': _passwordHash.toString(),
      });
      SharedPreferences prf = await SharedPreferences.getInstance();
      prf.setString("Username", "");
      switch (_role) {
        case "student":
          Fluttertoast.showToast(
            msg: "Password Changed",
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => new StudentActivity()));
          break;
        case "admin":
          Fluttertoast.showToast(
            msg: "Password Changed",
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => new Home()));
          break;
        case "faculty":
          Fluttertoast.showToast(
            msg: "Password Changed",
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => new FacultyActivity()));
          break;
        /*case "parent":
          Fluttertoast.showToast(
            msg: "Password Changed",
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => new ParentActivity()));
          break;*/
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
