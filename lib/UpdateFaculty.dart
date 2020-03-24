import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'CommonAppBar.dart';
import 'ManageFaculty.dart';

// ignore: must_be_immutable
class UpdateFaculty extends StatelessWidget {
  int id;
  UpdateFaculty(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpdateFacultyData(this.id),
    );
  }
}

// ignore: must_be_immutable
class UpdateFacultyData extends StatefulWidget {
  int id;
  UpdateFacultyData(this.id);
  @override
  _UpdateFacultyState createState() {
    return new _UpdateFacultyState(id);
  }
}

class _UpdateFacultyState extends State<UpdateFacultyData> {
  int id;
  _UpdateFacultyState(this.id);

  TextEditingController _fName = new TextEditingController();
  TextEditingController _lName = new TextEditingController();
  TextEditingController _eMail = new TextEditingController();
  TextEditingController _phone = new TextEditingController();

  bool _fValidate = false;
  bool _lValidate = false;
  bool _emailValidate = false;
  bool _phoneValidate = false;

  void dispose() {
    super.dispose();
    _fName.dispose();
    _lName.dispose();
    _eMail.dispose();
    _phone.dispose();
  }

  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    print(id);
    _fName.text = itemsFaculty[id]['first_name'];
    _lName.text = itemsFaculty[id]['last_name'];
    _eMail.text = itemsFaculty[id]['email'];
    _phone.text = itemsFaculty[id]['phone_number'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Update Faculty Details"),
      backgroundColor: Colors.grey,
      body: BodyUpdate(context),
    );
  }
  // ignore: non_constant_identifier_names
  Widget BodyUpdate(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                          errorText: _fValidate
                              ? 'Please enter First Name'
                              : null,
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
                          errorText: _lValidate
                              ? 'Please enter Last Name'
                              : null,
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
                          errorText: _emailValidate
                              ? 'Please enter Email Address'
                              : null,
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
                          errorText: _phoneValidate
                              ? 'Please enter Phone Number'
                              : null,
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
                        "Update",
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 15.0
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_fName.text.isEmpty) {
                            _fValidate = true;
                          } else {
                            _fValidate = false;
                          }
                          if (_lName.text.isEmpty) {
                            _lValidate = true;
                          } else {
                            _lValidate = false;
                          }
                          if (_eMail.text.isEmpty) {
                            _emailValidate = true;
                          } else {
                            _emailValidate = false;
                          }
                          if (_phone.text.isEmpty) {
                            _phoneValidate = true;
                          } else {
                            _phoneValidate = false;
                          }
                          if (_fName.text.isNotEmpty &&
                              _lName.text.isNotEmpty &&
                              _eMail.text.isNotEmpty &&
                              _phone.text.isNotEmpty) {
                            _onClick();
                          }
                        });
                      },
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
  void _onClick() async{
    ProgressDialog pr = new ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
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
    try {
      await Firestore.instance.collection('faculty_details').document(
          itemsFaculty[id].documentID).updateData({
        'first_name': _fName.text,
        'last_name': _lName.text,
        'email': _eMail.text,
        'phone_number': _phone.text,
      });
    }catch(e){
      pr.hide();
      print(e.toString());
    }
    pr.hide();
    Fluttertoast.showToast(msg: "Record Updated");
    Navigator.of(context).pop();
  }
}
