import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:ecoleami1_0/ManageStudent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class StudentAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new AddDetails(),
    );
  }
}

class AddDetails extends StatefulWidget {
  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      appBar: CommonAppBar("Student Details"),
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
  bool _obscureText = true;

  final databaseReference = Firestore.instance;

  List<String> _semesterList = ['1', '2', '3', '4', '5', '6'];
  String _selectedSemester;
  List<String> _divisionList = [
    'A1',
    'A2',
    'A3',
    'B1',
    'B2',
    'B3',
    'C1',
    'C2',
    'C3'
  ];
  String _selectedDivision;

  TextEditingController _fName = new TextEditingController();
  TextEditingController _mName = new TextEditingController();
  TextEditingController _lName = new TextEditingController();
  TextEditingController _eMail = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _parentPhone = new TextEditingController();

  bool _fValidate = false;
  bool _mValidate = false;
  bool _lValidate = false;
  bool _emailValidate = false;
  bool _phoneValidate = false;
  bool _parentValidate = false;

  void dispose() {
    super.dispose();
    _fName.dispose();
    _mName.dispose();
    _lName.dispose();
    _eMail.dispose();
    _phone.dispose();
    _parentPhone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Container(
          child: new Form(
            child: new Card(
              elevation: 30.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: new Column(
                  children: <Widget>[
                    new TextField(
//                      controller: _enr,
                      enabled: false,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Enrollment",
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.account_circle),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
                      controller: _fName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "First Name",
                          errorText:
                          _fValidate ? 'Please enter First Name' : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.person),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
                      controller: _mName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Middle Name",
                          errorText:
                          _mValidate ? 'Please enter Middle Name' : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.person),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
                      controller: _lName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Last Name",
                          errorText:
                          _lValidate ? 'Please enter Last Name' : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.person),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextFormField(
                      controller: _eMail,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Email Address",
                          errorText: _emailValidate
                              ? 'Please enter valid Email Address'
                              : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.email),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
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
                              ? 'Please enter valid Phone Number'
                              : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.phone),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    Container(
                      padding: const EdgeInsets.only(left: 30.0,right: 30),
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        border:
                        Border.all(style: BorderStyle.solid, width: 0.80),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: DropdownButton<String>(
/*                      iconEnabledColor: Colors.white,
                      iconDisabledColor: Colors.white,*/
                        icon: Icon(Icons.keyboard_arrow_down),
                        underline: SizedBox(),
                        items: _semesterList.map((String val) {
                          return new DropdownMenuItem<String>(
                            value: val,
                            child: new Text(val),
                          );
                        }).toList(),
                        hint: Text("Semester"),
                        onChanged: (String newVal) {
                          setState(() {
                            this._selectedSemester = newVal;
                            print(_selectedSemester);
                          });
                        },
                        value: _selectedSemester,
                        isExpanded: true,
                      ),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    Container(
                      padding: const EdgeInsets.only(left: 30.0,right: 30),
//                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        border:
                        Border.all(style: BorderStyle.solid, width: 0.80),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: DropdownButton<String>(
                        /*iconEnabledColor: Colors.white,
                        iconDisabledColor: Colors.white,*/
                        icon: Icon(Icons.keyboard_arrow_down),
                        underline: SizedBox(),
                        items: _divisionList.map((String val) {
                          return new DropdownMenuItem<String>(
                            value: val,
                            child: new Text(val),
                          );
                        }).toList(),
                        hint: Text("Division"),
                        onChanged: (String newVal) {
                          setState(() {
                            this._selectedDivision = newVal;
                          });
                        },
                        value: _selectedDivision,
                        isExpanded: true,
                      ),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
                      controller: _parentPhone,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Parent's Phone Number",
                          errorText: _parentValidate
                              ? 'Please enter valid Parent\'s Phone number'
                              : null,
                          hintStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          prefixIcon: new Icon(Icons.phone),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new TextField(
//                      controller: _pass,
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
                          )),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new Padding(padding: const EdgeInsets.only(bottom: 20.0)),
                    new RaisedButton(
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: new Text(
                        "Add",
                        style:
                        new TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_fName.text.isEmpty) {
                            _fValidate = true;
                          } else {
                            _fValidate = false;
                          }
                          if (_mName.text.isEmpty) {
                            _mValidate = true;
                          } else {
                            _mValidate = false;
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
                          if (_phone.text.isEmpty || _phone.text.length < 10) {
                            _phoneValidate = true;
                          } else {
                            _phoneValidate = false;
                          }
                          if (_parentPhone.text.isEmpty ||
                              _parentPhone.text.length < 10) {
                            _parentValidate = true;
                          } else {
                            _parentValidate = false;
                          }
                          if (_fValidate == false &&
                              _mValidate == false &&
                              _lValidate == false &&
                              _emailValidate == false &&
                              _phoneValidate == false &&
                              _parentValidate == false) {
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

  void _onClick() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
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
    final snapShot = await Firestore.instance
        .collection("student_details")
        .document(_phone.text)
        .get();
    if (snapShot == null || !snapShot.exists) {
      await databaseReference
          .collection("student_details")
          .document(_phone.text.toString())
          .setData({
        'enrollment': "------------",
        'first_name': _fName.text,
        'middle_name': _mName.text,
        'last_name': _lName.text,
        'email': _eMail.text,
        'phone_number': _phone.text,
        'semester': _selectedSemester,
        'division': _selectedDivision,
        'parent_phone_number': _parentPhone.text,
      });
      await databaseReference
          .collection("parent_details")
          .document(_parentPhone.text.toString())
          .setData({
        'phone_number': _parentPhone.text,
        'student_name': _fName.text + " " + _mName.text + " " + _lName.text,
        'student_email': _eMail.text,
        'student_phone_number': _phone.text,
        'student_semester': _selectedSemester,
        'student_division': _selectedDivision,
      });

      final snapShot = await databaseReference
          .collection("login_details")
          .document(_phone.text)
          .get();
      print(snapShot.exists.toString());
      print(_phone.text);
      print(snapShot != null);
      if (snapShot == null || snapShot.exists) {
      } else {
        await databaseReference
            .collection("login_details")
            .document(_phone.text)
            .setData({'password': null, 'role': "student"});
        await databaseReference
            .collection("login_details")
            .document(_parentPhone.text)
            .setData({'password': null, 'role': "parent"});
      }
      Fluttertoast.showToast(
          msg: "Record Added Successfully", gravity: ToastGravity.BOTTOM);
      pr.hide();
      Navigator.pop(context);
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ManageStudent()));
    } else {
      Fluttertoast.showToast(
          msg: "Record Exist",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black);
      pr.hide();
    }
  }
}
