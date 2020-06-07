import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecoleami1_0/Register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'FacultyActivity.dart';
import 'Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SplashScreen.dart';
import 'StudentActivity.dart';

class List extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  TextEditingController _userName = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
  SharedPreferences prf;
  bool _userValidate = false;
  bool _passValidate = false;
  bool _obscureText = true;
  var role;
  var _password;
  ProgressDialog pr;

  void dispose() {
    _userName.dispose();
    _pass.dispose();
    super.dispose();
  }

  void saveState() async {
    print(_pass.text);
    print(_passwordHash.toString());
    prf = await SharedPreferences.getInstance();
    prf.setBool("isLoggedIn", true);
    prf.setString("Username", _userName.text);
    prf.setString("Password", _passwordHash.toString());
    prf.setString("Role", role);
    user = _userName.text;
  }

  @override
  void initState() {
    super.initState();
    //checkState();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Image(
          image: AssetImage('images/ecoleami.png'),
          width: 170.0,
          height: 160.0,
        ),
        new Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: new Form(
            child: new Card(
              elevation: 30.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: new Column(
                  children: <Widget>[
                    new Padding(padding: const EdgeInsets.only(bottom: 20.0)),
                    new TextField(
                      controller: _userName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Username",
                          errorText:
                              _userValidate ? 'Please enter Username' : null,
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
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Password",
                          errorText:
                              _passValidate ? 'Please enter Password' : null,
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
                        "Login",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          wordSpacing: 2.0,
                          letterSpacing: 0.3,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_userName.text.isEmpty) {
                            _userValidate = true;
                          } else {
                            _userValidate = false;
                          }

                          if (_pass.text.isEmpty) {
                            _passValidate = true;
                          } else {
                            _passValidate = false;
                          }
                          if (_userName.text.isNotEmpty &&
                              _pass.text.isNotEmpty) {
                            _onClick();
                          }
                        });
                      },
                      splashColor: Colors.red,
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 10.0)),
                    new ButtonBar(
                      alignment: MainAxisAlignment.center,
                      buttonAlignedDropdown: true,
                      children: <Widget>[
                        new OutlineButton(
                          onPressed: () => {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new Register()))
                          },
                          splashColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: new Text(
                            "Register  ",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: Colors.red,
                              wordSpacing: 2.0,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        new RaisedButton(
                          onPressed: () => {},
                          splashColor: Colors.redAccent,
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
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
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  var _passwordHash;

  void _onClick() {
    showProgressbar();
    Firestore.instance
        .collection("login_details")
        .document(_userName.text.trim())
        .get()
        .then((document) {
      if (!document.exists) {
        Fluttertoast.showToast(
            msg: "Username Does Not Exist",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG);
        pr.hide();
      } else {
        role = document['role'];
        _password = document['password'];
        print(_password);
        _passwordHash = md5.convert(utf8.encode(_pass.text));
        if (_passwordHash.toString().compareTo(_password) == 0) {
          saveState();
          switch (role) {
            case "student":
              Fluttertoast.showToast(
                msg: "Login successfully",
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT,
              );
              pr.hide();
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => new StudentActivity()));
              break;
            case "admin":
              Fluttertoast.showToast(
                msg: "Login successfully",
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT,
              );
              pr.hide();
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => new Home()));
              break;
            case "faculty":
              Fluttertoast.showToast(
                msg: "Login successfully",
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT,
              );
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => new FacultyActivity()));
              pr.hide();
              break;
            case "parent":
              Fluttertoast.showToast(
                msg: "Login successfully",
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT,
              );
              pr.hide();
              break;
          }
        } else {
          pr.hide();
          Fluttertoast.showToast(
            msg: "Invalid Password",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      }
    });
  }

  void showProgressbar() async {
    pr = new ProgressDialog(context,
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
  }
}
