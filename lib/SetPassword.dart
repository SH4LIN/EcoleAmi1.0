import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Register.dart';
import 'MainScreen.dart';

class SetPassword extends StatefulWidget {
  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {

  SharedPreferences prf;

  TextEditingController _pass = new TextEditingController();
  TextEditingController _confirmPass = new TextEditingController();
  TextEditingController _fullName = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _enroll = new TextEditingController();

  bool _obscureText = true;
  bool _passValidate = false;
  bool _cPassValidate = false;

  FocusNode myFocusNode;
  String _username;
  String _checkPass;
  String _role;
  String _enrCheck = '------------';

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
   /* print("UserRole: " + userRole);
    print("UserName: " + registeredUser);*/
    registeredUser != null ? _username = registeredUser : setUser();
    userRole != null ? _role = userRole : setUser();
    print(_role);
    print(_username);
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("rUsername");
    _role = prf.get("rRole");
    print(_role);
    print(_username);
  }

  void dispose() {
    _pass.dispose();
    _confirmPass.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white70,
      appBar: CommonAppBar("Set Password"),
      body: new Container(
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Container(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: new Form(
                    child: Card(
                  elevation: 30.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new ExpansionTile(
                          title: Text("Personal Details",
                              style: TextStyle(fontSize: 15)),
                          initiallyExpanded: true,
                          children: <Widget>[
                            StreamBuilder(
                                stream: Firestore.instance
                                    .collection(_role + "_details")
                                    .document(_username)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.none) {
                                    _fullName.text = "Loading...!";
                                  }
                                  if (snapshot.hasData) {
                                    var document = snapshot.data;
                                    _fullName.text =
                                        document['first_name'] + " " + document['middle_name'] + " " + document['last_name'];
                                  }
                                  return new TextField(
                                    controller: _fullName,
                                    enabled: false,
                                    decoration: new InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                        hintText: "Full Name",
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
                                    .collection(_role + "_details")
                                    .document(_username)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.none) {
                                    _email.text = "Loading...!";
                                  }
                                  if (snapshot.hasData) {
                                    var document = snapshot.data;
                                    _email.text =
                                        document['email'];
                                  }
                                  return new TextField(
                                    controller: _email,
                                    enabled: false,
                                    decoration: new InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        hintText: "Email",
                                        hintStyle: new TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white70,
                                        ),
                                        prefixIcon: new Icon(Icons.email),
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(20.0),
                                        )),
                                  );
                                }),
                            StreamBuilder(
                                stream: Firestore.instance
                                    .collection("student_details")
                                    .document(_username)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.none) {
                                    _enroll.text = "Loading...!";
                                  }
                                  if (snapshot.hasData) {
                                    var document = snapshot.data;
                                    _enroll.text = document['enrollment'];
                                    _enrCheck = document['enrollment'];
                                    print(_enrCheck);
                                  }
                                  return (_enrCheck
                                              .compareTo("------------")) ==
                                          0
                                      ? Container(width: 0, height: 0)
                                      : TextField(
                                          controller: _enroll,
                                          enabled: false,
                                          decoration: new InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              hintText: "Enrollment",
                                              hintStyle: new TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white70,
                                              ),
                                              prefixIcon:
                                                  new Icon(Icons.person),
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              )),
                                        );
                                }),
                            Padding(padding: EdgeInsets.only(bottom: 15))
                            /*: new Container();*/
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
              ),
              new Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0),
                  child: new Form(
                      child: new Card(
                          elevation: 30.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                              padding: const EdgeInsets.all(15.0),
                              child: new Column(children: <Widget>[
                                new TextField(
                                  controller: _pass,
                                  obscureText: _obscureText,
                                  focusNode: myFocusNode,
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
                                      if (_passValidate == false &&
                                          _cPassValidate == false) {
                                        if (_pass.text != _confirmPass.text) {
                                          Fluttertoast.showToast(
                                              msg: "Password does not match",
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor: Colors.black);
                                          myFocusNode.requestFocus();
                                        } else {
                                          savePassword();
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

  Future<void> savePassword() async {
    try {
      Firestore.instance
          .collection("login_details")
          .document(_username)
          .updateData({
        'password': _pass.text,
      });
      SharedPreferences prf = await SharedPreferences.getInstance();
      prf.setString("rUsername", "");
      Fluttertoast.showToast(
          msg: "Password saved",
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
