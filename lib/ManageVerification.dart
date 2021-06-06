import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:ecoleami1_0/ManageStudent.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ForgotValidation.dart';
import 'ManageFaculty.dart';
import 'SplashScreen.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

// ignore: must_be_immutable
class ManageVerification extends StatelessWidget {
  String txt;

  //TextEditingController _pass = new TextEditingController();
  ManageVerification(String txt) {
    this.txt = txt;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Verification(txt),
    );
  }
}

// ignore: must_be_immutable
class Verification extends StatefulWidget {
  String txt;

  Verification(String txt) {
    this.txt = txt;
  }

  @override
  _VerificationState createState() => _VerificationState(txt);
}

class _VerificationState extends State<Verification> {
  String _username;
  SharedPreferences prf;
  String pass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user != null ? _username = user : setUser();
    print(_username);
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
    print(_username);
  }

//  TextEditingController _pass = new TextEditingController();
  String txt;
  bool _validate = false;

  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  _VerificationState(String txt) {
    this.txt = txt;
  }

//  bool _obscureText = true;
  TextEditingController _pass = new TextEditingController();
  TextEditingController _confirmPass = new TextEditingController();
  TextEditingController _verify = new TextEditingController();

  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _passValidate = false;
  bool _cPassValidate = false;

  String errorMessage;
  String errorMessage2;
  String errorMessage3;

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _authorizedOrNot = "Not Authorized";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      appBar: CommonAppBar("Verification"),
      body: new Align(
        alignment: Alignment.center,
        child: new SingleChildScrollView(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("verification_details")
                    .document(_username)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot != null && snapshot.hasData) {
                    var doc = snapshot.data;
                    pass = doc['password'];
                  }
                  return pass == null
                      ? new Card(
                      elevation: 30.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: new Column(children: <Widget>[
                            new Text(
                              "Set a Password",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            new Padding(
                                padding:
                                const EdgeInsets.only(bottom: 15.0)),
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
                          ])))
                      : new Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    //margin: const EdgeInsets.symmetric(vertical: 200.0),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 20.0,
                          right: 15.0,
                          left: 15.0,
                          bottom: 15.0),
                      child: new Column(
                        children: <Widget>[
                          new Padding(
                              padding:
                              const EdgeInsets.only(bottom: 20.0)),
                          new TextField(
                            onChanged: (value) {
                              _onClick(value);
                            },
                            controller: _verify,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            obscureText: _obscureText,
                            cursorColor: Colors.purple,
                            cursorRadius: Radius.circular(50.0),
                            cursorWidth: 3.0,
                            decoration: new InputDecoration(
                                hintText: "Password",
                                errorText:
                                _validate ? errorMessage3 : null,
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
                              const EdgeInsets.only(bottom: 20.0)),
                          new IconButton(
                              icon: Icon(
                                Icons.fingerprint,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: _checkBiometric),
                          new Padding(
                              padding:
                              const EdgeInsets.only(bottom: 10.0)),
                          new Align(
                            alignment: Alignment.bottomRight,
                            child: new OutlineButton(
                              onPressed: () => {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ForgotValidation()))
                              },
                              splashColor: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(50.0)),
                              child: new Text(
                                "Forgot password?",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })),
      ),
    );
  }

  Future<void> savePassword() async {
    var _passwordHash = md5.convert(utf8.encode(_pass.text));
    try {
      Firestore.instance
          .collection("verification_details")
          .document(_username)
          .updateData({
        'password': _passwordHash.toString(),
      });
      Fluttertoast.showToast(
          msg: "Password Set Successfully",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black);
    } catch (e) {
      print(e.toString());
    }
  }

  bool _canCheckBiometric = false;

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });

    if (_canCheckBiometric == false) {
      Fluttertoast.showToast(msg: "You can\'t use biometric");
    } else {
      _getListOfBiometricTypes();
    }
  }

  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listofBiometrics;
    try {
      listofBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _availableBiometricTypes = listofBiometrics;
    });

    if (_availableBiometricTypes.isEmpty) {
      Fluttertoast.showToast(msg: "There is no biometric in your phone");
    } else {
      _authorizeNow();
    }
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Scan you biometric to continue",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    if (isAuthorized) {
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(builder: (context) {
        return txt.startsWith("S") ? new ManageStudent() : new ManageFaculty();
      }));
    } else {
      Fluttertoast.showToast(msg: "Biometric authentication failed");
    }
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

  void _onClick(String text) async {
    String password;
    var _passwordHash = md5.convert(utf8.encode(text));
    await Firestore.instance
        .collection("verification_details")
        .document(_username)
        .get()
        .then((document) {
      password = document['password'];
      print(password);
    });
//    print(text);
    if (_passwordHash.toString().compareTo(password) == 0) {
      _validate = false;
      print('Okay');
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(builder: (context) {
        return txt.startsWith("S") ? new ManageStudent() : new ManageFaculty();
      }));
    } else {
      setState(() {
        _validate = true;
        errorMessage3 = "Incorrect Password";
      });
    }
    print(_validate);
  }
}
