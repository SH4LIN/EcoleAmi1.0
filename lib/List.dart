import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class List extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {

  TextEditingController _userName = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
  bool _userValidate = false;
  bool _passValidate = false;

  void dispose() {
    _userName.dispose();
    _pass.dispose();
    super.dispose();
  }

  bool _obscureText = true;

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
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: new Column(
                  children: <Widget>[
                    new Padding(
                        padding: const EdgeInsets.only(bottom: 20.0)
                    ),
                    new TextField(
                      controller: _userName,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Username",
                          errorText: _userValidate ? 'Please enter Username' : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.account_circle),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )
                      ),

                    ),
                    new Padding(
                        padding: const EdgeInsets.only(bottom: 15.0)
                    ),
                    new TextField(
                      controller: _pass,
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Password",
                          errorText: _passValidate ? 'Please enter Password' : null,
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
                          )
                      ),
                    ),
                    new Padding(
                        padding: const EdgeInsets.only(bottom: 20.0)
                    ),
                    new RaisedButton(
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: new Text(
                        "Login",
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 15.0
                        ),
                      ),
                      onPressed: ()  {
                        setState(() {
//                          if (_userName.text.isEmpty || _pass.text.isEmpty) { _validate = true; } else { _validate = false; _onClick();}
                          if (_userName.text.isEmpty) {
                            _userValidate = true;
                          } else {
                            _userValidate = false;
                          }

                          if (_pass.text.isEmpty){
                            _passValidate = true;
                          } else {
                            _passValidate = false;
                          }
                          if (_userName.text.isNotEmpty && _pass.text.isNotEmpty) {
                            _onClick();
                          }
                        });
                      },
                      splashColor: Colors.red,
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 10.0)),
                    new Align(
                      alignment: Alignment.bottomRight,
                      child: new OutlineButton(
                        onPressed: () => {},
                        splashColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)
                        ),
                        child: new Text(
                          "Forgot password?",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: Colors.red
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

  }

  void _onClick() {
    String user = "Admin";
    String pass = "Admin";
    if (_userName.text.compareTo(user) == 1 &&
        _pass.text.compareTo(pass) == 0) {
      Fluttertoast.showToast(
        msg: "Invalid Username",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,);
//      _validate = false;
    } else if (_userName.text.compareTo(user) == 0 &&
        _pass.text.compareTo(pass) == 1) {
      Fluttertoast.showToast(
        msg: "Invalid Password",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,);
    } else if (_userName.text.compareTo(user) == 1 &&
        _pass.text.compareTo(pass) == 1) {
      Fluttertoast.showToast(
        msg: "Invalid Username and Password",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,);
    } else if (_userName.text.compareTo(user) == 0 &&
        _pass.text.compareTo(pass) == 0) {
      Fluttertoast.showToast(
        msg: "Login successfully",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) => new Home()));
    }
  }
}





/*
     final databaseReference = Firestore.instance;

     databaseReference
       .collection("Admin_Login")
       .getDocuments()
       .then((QuerySnapshot snapshot) {
       snapshot.documents.forEach((f) => print('${f.data}}'));
   });

 */