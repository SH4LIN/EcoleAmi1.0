import 'package:flutter/material.dart';

void main() => runApp(new Register());

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new _RegisterPage(),
    );
  }
}

class _RegisterPage extends StatefulWidget {
  @override
  __RegisterPageState createState() => __RegisterPageState();
}

class __RegisterPageState extends State<_RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        child: new Center(
          child: new ListView(
            children: <Widget>[
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
                            //controller: _userName,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.purple,
                            cursorRadius: Radius.circular(50.0),
                            cursorWidth: 3.0,
                            decoration: new InputDecoration(
                                hintText: "Username",
                                //errorText: _userValidate ? 'Please enter Username' : null,
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
                              padding: const EdgeInsets.only(bottom: 20.0)
                          ),
                          new RaisedButton(
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
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
}

