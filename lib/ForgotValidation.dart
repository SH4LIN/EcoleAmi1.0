import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:ecoleami1_0/ManageVerification.dart';
import 'package:ecoleami1_0/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainScreen.dart';
import 'SetForgotPass.dart';
import 'package:crypto/crypto.dart';

var Username;

class ForgotValidation extends StatefulWidget {
  @override
  _ForgotValidationState createState() => _ForgotValidationState();
}

class _ForgotValidationState extends State<ForgotValidation> {
  TextEditingController _userName = new TextEditingController();
  TextEditingController _otp = new TextEditingController();

  String role;
  String pass;
  SharedPreferences prf;

  String phoneNo;
  String smsOTP;
  AuthCredential credential;
  static String verificationId;
  String errorMessage = '';

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _usernameValidate = false;
  bool _otpValidate = false;

  void saveSate() async {
    prf = await SharedPreferences.getInstance();
    prf.setString("fUsername", _userName.text);
    Username = _userName.text;
  }

  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Forgot Password"),
      body: new Container(
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Container(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 50),
                child: new Form(
                  child: new Card(
                    elevation: 30.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: new Column(
                        children: <Widget>[
                          new Padding(
                              padding: const EdgeInsets.only(bottom: 20.0)),
                          new TextField(
                            onChanged: (value) {
                              this.phoneNo = "+91" + value;
                              print(phoneNo);
                            },
                            controller: _userName,
                            autofocus: true,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.purple,
                            cursorRadius: Radius.circular(50.0),
                            cursorWidth: 3.0,
                            decoration: new InputDecoration(
                                hintText: "Username",
                                errorText: _usernameValidate
                                    ? 'Please enter valid UserName'
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
                          new Padding(
                              padding: const EdgeInsets.only(bottom: 20.0)),
                          new RaisedButton(
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: new Text(
                              "Check",
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                wordSpacing: 2.0,
                                letterSpacing: 0.3,
                              ),
                            ),
                            splashColor: Colors.red,
                            onPressed: () {
                              setState(() {
                                if (_userName.text.isEmpty ||
                                    _userName.text.length != 10) {
                                  _usernameValidate = true;
                                } else {
                                  _usernameValidate = false;
                                  _checkUser();
                                  saveSate();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkUser() async{
    // ignore: missing_return
    await Firestore.instance
        .collection("verification_details")
        .document(_userName.text)
        .get()
        .then((document) {
      if (!document.exists) {
        dialogNoUser();
      } else {
        pass = document['password'];
        if (pass == null) {
          notRegistered();
        } else {
          role = document['role'];
          print(role);
          switch (role) {
            case "admin":
              Firestore.instance
                  .collection("admin_details")
                  .document(_userName.text)
                  .get()
                  .then((document) {
                if (document.exists) {
                  final String phone = "+91" + _userName.text.trim();
                  verifyPhone(phone, context);
                } else {
                  dialogNoUser();
                }
              });
              break;
            case "faculty":
              Firestore.instance
                  .collection("faculty_details")
                  .document(_userName.text)
                  .get()
                  .then((document) {
                if (document.exists) {
                  final phone = "+91" + _userName.text.trim();
                  verifyPhone(phone, context);
                } else {
                  dialogNoUser();
                }
              });
              break;
          }
        }
      }
    });
  }

  void dialogNoUser() => showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Username does not exist!'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void notRegistered() => showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('First register yourself'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Register'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => new Register()));
                },
              ),
            ],
          );
        },
      );

  Future<void> verifyPhone(String phone, BuildContext context) async {
    saveSate();
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = await result.user;
          if (user != null) {
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new SetValidationPass()));
          } else {
            print("Error");
          }
        },
        verificationFailed: (AuthException exception) {
          errorMessage = exception.toString();
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          Fluttertoast.showToast(
            msg: "OTP sent on " + phone,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.grey,
          );
          showBottom(context);
        },
        codeAutoRetrievalTimeout: null);
  }

  // ignore: missing_return
  Future<void> showBottom(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(15.0),
            color: Colors.white,
            height: 600,
            child: new Wrap(
              children: <Widget>[
                new TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                  controller: _otp,
                  autofocus: true,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.purple,
                  cursorRadius: Radius.circular(50.0),
                  cursorWidth: 3.0,
                  decoration: new InputDecoration(
                      hintText: "Enter OTP",
                      errorText: _otpValidate ? "Invalid OTP" : null,
                      hintStyle: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                      prefixIcon: new Icon(Icons.message),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                ),
                new RaisedButton(
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: new Text(
                      "Verify",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        wordSpacing: 2.0,
                        letterSpacing: 0.3,
                      ),
                    ),
                    splashColor: Colors.red,
                    onPressed: () async {
                      /*           if (_otp.text.length < 6) {
                        setState(() {
                          _otpValidate = true;
                          errorMessage = "Invalid OTP";
                        });
                      } else {
          setState(() {
          _otpValidate = false;
          });
          }*/
                      /*try {
                        print("Try");
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId,
                                smsCode: _otp.text.trim());
                        AuthResult result =
                            await _auth.signInWithCredential(credential);
                        FirebaseUser user = result.user;
                        print("User");
                        print(user);
                        if (user != null) {
                          Navigator.of(context).pop();
                          if (role == "parent") {
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new SetForgotPass()));
                          } else {
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new SetPassword()));
                          }
                        } else {
                          print("Error");
                        }
                      } catch (e) {
                        print("Errorr");
                        handleError(e);
                      }*/
                      try {
                         this.credential =
                            PhoneAuthProvider.getCredential(
                          verificationId: verificationId,
                          smsCode: _otp.text.trim(),
                        );

                            signIn();
                        /*final FirebaseUser currentUser =
                            await _auth.currentUser();

                        assert(user.uid == currentUser.uid);
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new SetValidationPass()));*/
                      } catch (e) {
                        handleError(e);
                      }
                    })
              ],
            ),
          );
        });
  }

  signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this.credential)
          .then((AuthResult authRes) {
        user = authRes.user;
        print(user.toString());
      });

      Navigator.of(context).pop();
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new SetValidationPass()));
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        showBottom(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }
}
/*
This is happening due to the verificationId being null while reaching the manualPhoneAuth function. Somehow verification id is not getting assigned in the codeSent callback function.I changed the verificationId to a static variable and voila, It worked.

Change String verificationId to static String verificationId
*/

class SetValidationPass extends StatefulWidget {
  @override
  _SetValidationPassState createState() => _SetValidationPassState();
}

class _SetValidationPassState extends State<SetValidationPass> {
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

  TextEditingController _pass = new TextEditingController();
  TextEditingController _confirmPass = new TextEditingController();

  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _passValidate = false;
  bool _cPassValidate = false;

  String errorMessage;
  String errorMessage2;

  String _username;
  SharedPreferences prf;

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
          .collection("verification_details")
          .document(_username)
          .updateData({
        'password': _passwordHash.toString(),
      });
      SharedPreferences prf = await SharedPreferences.getInstance();
      prf.setString("fUsername", "");
      Fluttertoast.showToast(
          msg: "Password Changed",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }
}
