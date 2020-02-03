import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Home.dart';

class List extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {

  TextEditingController _userName = new TextEditingController();
  TextEditingController _pass = new TextEditingController();

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
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Username",
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
                      onPressed: () => {_onClick()},
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
    if (_userName.text.compareTo(user) == 0 && _pass.text.compareTo(pass)== 0) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) => new Home()));
    }
    else{
      Fluttertoast.showToast(msg: "Wrong Username Or Password",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,);
    }
  }
}
