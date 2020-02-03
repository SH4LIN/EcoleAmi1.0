import 'package:ecoleami1_0/ManageFaculty.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FacultyAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new AddInfo(),
    );
  }
}
class AddInfo extends StatefulWidget {
  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          child: new Add(),
        ),
      ),
    );
  }
}

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {

  final databaseReference = Firestore.instance;

//    TextEditingController _enr;
  TextEditingController _fName = new TextEditingController();
  TextEditingController _lName = new TextEditingController();
  TextEditingController _eMail = new TextEditingController();
  TextEditingController _phone = new TextEditingController();

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Align(
          alignment: Alignment.topCenter,
          child: new Text(
            "Faculty Details",
            style: new TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),
          ),
        ),
        new Container(
          padding: const EdgeInsets.only(left: 10.0,right: 10.0),
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
                        padding: const EdgeInsets.only(bottom: 15.0)
                    ),
                    new TextField(
                      controller: _fName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "First Name",
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.person),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )
                      ),
                    ),
                    new Padding(
                        padding: const EdgeInsets.only(bottom: 15.0)
                    ),
                    new TextField(
                      controller: _lName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Last Name",
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.person),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )
                      ),
                    ),
                    new Padding(
                        padding: const EdgeInsets.only(bottom: 15.0)
                    ),
                    new TextField(
                      controller: _eMail,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Email Address",
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.email),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )
                      ),
                    ),
                    new Padding(
                        padding: const EdgeInsets.only(bottom: 15.0)
                    ),
                    new TextField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      maxLength: 10,
                      decoration: new InputDecoration(
                          hintText: "Phone Number",
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.phone),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )
                      ),
                    ),
                    new Padding(
                        padding: const EdgeInsets.only(bottom: 15.0)
                    ),
                    new TextField(
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText,
                      enabled: false,
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
                        padding: const EdgeInsets.only(bottom: 15.0)
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
                        "Add",
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 15.0
                        ),
                      ),
                      onPressed: ()=>{_onClick()},
                      splashColor: Colors.red,
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
  void _onClick()  async {

    if (_fName.text.isEmpty || _lName.text.isEmpty || _eMail.text.isEmpty || _phone.text.isEmpty ) {
      Fluttertoast.showToast(msg: "All fields are compulsory",gravity: ToastGravity.BOTTOM);
    }else {

      await databaseReference.collection("Faculty")
          .document("1")
          .setData({
        'first_name': _fName.text,
        'last_name': _lName.text,
        'email': _eMail.text,
        'phone_num': _phone.text,
      });

//   DocumentReference ref = await databaseReference.collection("Student")
//        .add({
//      'first_name': _fName.text,
//      'middle_name': _mName.text,
//      'last_name': _lName.text,
//      'email': _eMail.text,
//      'phone_num': _phone.text,
//      'sem': _sem.text,
//    });

      Fluttertoast.showToast(msg: "Record Added Successfully",gravity: ToastGravity.BOTTOM);
      Navigator.of(context).push(
          new MaterialPageRoute(builder: (BuildContext context)=>new ManageFaculty())
      );
    }

    //print(ref.documentID);
  }
}
