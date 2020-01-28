import 'package:ecoleami1_0/ManageStudent.dart';
import 'package:flutter/material.dart';

import 'ManageFaculty.dart';

class ManageVerification extends StatelessWidget {
  String txt;
  ManageVerification(String txt){
    this.txt = txt;
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Verification(txt),
    );
  }
}

class Verification extends StatefulWidget {
  String txt;
  Verification(String txt){
    this.txt = txt;
  }
  @override
  _VerificationState createState() => _VerificationState(txt);
}

class _VerificationState extends State<Verification> {

  String txt;
  _VerificationState(String txt){
    this.txt = txt;
  }
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Align(
        alignment: Alignment.center,
        child: new SingleChildScrollView(
          child: new Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            //margin: const EdgeInsets.symmetric(vertical: 200.0),
            child: Container(
              padding: const EdgeInsets.only(top: 15.0,right: 15.0,left: 15.0,bottom: 15.0),
              child: new Column(
                children: <Widget>[
                  new Text(
                    "Info Management Verification",
                    style: Theme.of(context).textTheme.title,
                    //new TextStyle(color: Colors.black,fontSize: 11.0),
                  ),
                  new Padding(
                      padding: const EdgeInsets.only(bottom: 20.0)
                  ),
                  new TextField(
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
                          icon: new Icon(_obscureText?Icons.visibility_off : Icons.visibility),
                          onPressed: (){
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
                      "Verify",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 15.0
                      ),
                    ),
                    onPressed: ()=>{Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => txt.startsWith("S")?new ManageStudent() : new ManageFaculty()))},
                    splashColor: Colors.red,
                  ),
                  new Padding(padding: const EdgeInsets.only(bottom: 10.0)),
                  new Align(
                    alignment: Alignment.bottomRight,
                    child: new OutlineButton(
                      onPressed: ()=>{},
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
    );
  }
}

