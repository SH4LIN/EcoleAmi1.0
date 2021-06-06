import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ForgotPassword.dart';
import 'MainScreen.dart';

class SetForgotPass extends StatefulWidget {
  @override
  _SetForgotPassState createState() => _SetForgotPassState();
}

class _SetForgotPassState extends State<SetForgotPass> {
  SharedPreferences prf;

  TextEditingController _pass = new TextEditingController();
  TextEditingController _confirmPass = new TextEditingController();

  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _passValidate = false;
  bool _cPassValidate = false;

  String errorMessage;
  String errorMessage2;

  String _username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Username != null ? _username = Username : setUser();
    print(_username);
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("fUsername");
    print(_username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Set a new Password"),
      body: new Container(
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Container(
                  padding:
                  const EdgeInsets.only(top: 100, left: 15.0, right: 15.0),
                  child: new Form(
                      child: new Card(
                          elevation: 30.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                              padding: const EdgeInsets.all(15.0),
                              child: new Column(children: <Widget>[
                                new TextField(
                                  onChanged: (value) {
                                    validateStructure(value);
                                  },
                                  controller: _pass,
                                  obscureText: _obscureText,
                                  autofocus: true,
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
                                        borderRadius:
                                        BorderRadius.circular(20.0),
                                      )),
                                ),
                                new Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 15.0)),
                                new TextField(
                                  controller: _confirmPass,
                                  cursorColor: Colors.purple,
                                  obscureText: _obscureText1,
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
                                        borderRadius:
                                        BorderRadius.circular(20.0),
                                      )),
                                ),
                                new Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 20.0)),
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
                                      if (_passValidate == false) {
                                        print(_passValidate);
                                        if (_pass.text.isEmpty) {
                                          _passValidate = true;
                                          errorMessage =
                                          "Password can not be empty";
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
                                          } else {
                                            _passValidate = false;
                                            _cPassValidate = false;
                                            savePassword();
                                          }
                                        }
                                      }
                                    });
                                  },
                                  splashColor: Colors.red,
                                )
                              ])))))
            ],
          ),
        ),
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
      Fluttertoast.showToast(
          msg: "Password Changed",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new MainScreen()));
    } catch (e) {
      print(e.toString());
    }
  }
}