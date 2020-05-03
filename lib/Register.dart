import 'dart:async';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SetPassword.dart';
import 'MainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'SetParentDetails.dart';

var registeredUser;
var userRole;

void main() => runApp(new Register());

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new _RegisterPage(),
    );
  }
}

class _RegisterPage extends StatefulWidget {
  @override
  __RegisterPageState createState() => __RegisterPageState();
}

class __RegisterPageState extends State<_RegisterPage> {
  TextEditingController _userName = new TextEditingController();
  TextEditingController _otp = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();

  String role;
  String pass;
  SharedPreferences prf;

  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _usernameValidate = false;
  bool _otpValidate = false;

  void saveSate() async {
    prf = await SharedPreferences.getInstance();
    prf.setString("rUsername", _userName.text);
    prf.setString("rRole", role);
    registeredUser = _userName.text;
    userRole = role;
    print(userRole);
  }

  void init() {
    super.initState();
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      showBottom(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          codeAutoRetrievalTimeout: autoRetrieve,
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  signIn();
                  /*_auth.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      if (role == "parent") {
                        Navigator.of(context).pushReplacement(new MaterialPageRoute(
                            builder: (BuildContext context) => new SetParentDetails()));
                      } else {
                        Navigator.of(context).pushReplacement(new MaterialPageRoute(
                            builder: (BuildContext context) => new SetPassword()));
                      }
                    } else {
                      signIn();
                    }
                  });*/
                },
              )
            ],
          );
        });
  }

  // ignore: missing_return
  Future<bool> showBottom(BuildContext context) {
    showBottomSheet(
        context: context,
        elevation: 20,
        builder: (context) {
          return Container(
              padding: const EdgeInsets.all(15.0),
              height: 300,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black))
              ),
              child: new Center(
                child: new Wrap(
                  children: <Widget>[
                    Center(child: Text("OTP Verification",style: Theme.of(context).textTheme.title,),),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextField(
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
                            errorText: errorMessage,
                            hintText: "Enter OTP",
                            hintStyle: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                            prefixIcon: new Icon(Icons.message),
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                      ),
                    ),
                    new Padding(
                        padding:
                            const EdgeInsets.only(bottom: 40.0)),
                    Center(
                      child: new RaisedButton(
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
                            saveSate();
                            print("Pressed");
                            _auth.currentUser().then((user) {
                              if (user != null) {
                                Navigator.of(context).pop();
                                if (role == "parent") {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (
                                              BuildContext context) => new SetParentDetails()));
                                } else {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (
                                              BuildContext context) => new SetPassword()));
                                }
                              } else {
                                signIn();
                              }
                            });
                          }),
                    )
                  ],
                ),
              ));
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)) as FirebaseUser;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
      if (role == "parent") {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new SetParentDetails()));
      } else {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new SetPassword()));
      }
    } catch (e) {
      handleError(e);
      print("Erorrrrrrrrrrrrrrrrrrrrr " + e.toString());
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

  Future<void> _checkUser() async{
    // ignore: missing_return
    await Firestore.instance
        .collection("login_details")
        .document(_userName.text)
        .get()
        .then((document) {
      if (!document.exists) {
        dialogNoUser();
      } else {
        pass = document['password'];
        if (pass != null && pass != "") {
          allreadyRegistered();
        } else if (pass == null || pass == "") {
          role = document['role'];
          print(role);
          switch (role) {
            case "student":
              Firestore.instance
                  .collection("student_details")
                  .document(_userName.text)
                  .get()
                  .then((document) {
                if (document.exists) {
                  final String phone = "+91" + _userName.text.trim();
                  verifyPhone();
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
                  verifyPhone();
                } else {
                  dialogNoUser();
                }
              });
              break;
            case "parent":
              Firestore.instance
                  .collection("parent_details")
                  .document(_userName.text)
                  .get()
                  .then((document) {
                if (document.exists) {
                  final phone = "+91" + _userName.text.trim();
                  verifyPhone();
                } else {
                  dialogNoUser();
                }
              });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: CommonAppBar("Register"),
      body: new Container(
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Container(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
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
                  Text('Please contact your coordinator.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => new MainScreen()));
                },
              ),
              FlatButton(
                child: Text('Edit Username'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void allreadyRegistered() => showDialog<void>(
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
                  Text('You are all ready registered.'),
                  Text('Please Login.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Login'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => new MainScreen()));
                },
              ),
            ],
          );
        },
      );
}
