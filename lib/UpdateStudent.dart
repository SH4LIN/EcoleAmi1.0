import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/ManageStudent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'CommonAppBar.dart';

// ignore: must_be_immutable
class UpdateStudent extends StatelessWidget {
  int id;

  UpdateStudent(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpdateStudentData(this.id),
    );
  }
}

// ignore: must_be_immutable
class UpdateStudentData extends StatefulWidget {
  int id;

  UpdateStudentData(this.id);

  @override
  _UpdateStudentState createState() {
    return new _UpdateStudentState(id);
  }
}

class _UpdateStudentState extends State<UpdateStudentData> {
  int id;

  _UpdateStudentState(this.id);

  bool _obscureText = true;

  final databaseReference = Firestore.instance;

  List<String> _semesterList = ['1', '2', '3', '4', '5', '6'];
  String _selectedSemester;
  List<String> _divisionList = [
    'A',
    'B',
    'C',
  ];
  String _selectedDivision;
  List<String> _batchList = [
    '1',
    '2',
    '3',
  ];
  String _selectedBatch;

  bool _enrValidate = false;
  bool _fValidate = false;
  bool _mValidate = false;
  bool _lValidate = false;
  bool _emailValidate = false;
  bool _phoneValidate = false;
  bool _semValidate = false;
  bool _divValidate = false;
  bool _batchValidate = false;
  bool _parentValidate = false;

  void dispose() {
    super.dispose();
    _enr.dispose();
    _fName.dispose();
    _mName.dispose();
    _lName.dispose();
    _eMail.dispose();
    _phone.dispose();
    _parentPhone.dispose();
  }

  TextEditingController _fName = new TextEditingController();
  TextEditingController _mName = new TextEditingController();
  TextEditingController _lName = new TextEditingController();
  TextEditingController _eMail = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _parentPhone = new TextEditingController();
  TextEditingController _enr = new TextEditingController();

  String fNameErrorText = 'Please enter First Name';
  String mNameErrorText = 'Please enter Middle Name';
  String lNameErrorText = 'Please enter Last Name';
  bool _autoValidate = true;

  @override
  void initState() {
    super.initState();
    print(id);
    _fName.text = itemsStudent[id]['first_name'];
    _mName.text = itemsStudent[id]['middle_name'];
    _lName.text = itemsStudent[id]['last_name'];
    _eMail.text = itemsStudent[id]['email'];
    _phone.text = itemsStudent[id]['phone_number'];
    _selectedSemester = itemsStudent[id]['semester'];
    _selectedDivision = itemsStudent[id]['division'];
    _selectedBatch = itemsStudent[id]['batch'];
    _parentPhone.text = itemsStudent[id]['parent_phone_number'];
//    _sem.text = itemsStudent[id]['semester'];

    if (itemsStudent[id]['enrollment'] != null ||
        itemsStudent[id]['enrollment'] != "null") {
      _enr.text = itemsStudent[id]['enrollment'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Update Student Details"),
      backgroundColor: Colors.white,
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
            autovalidate: _autoValidate,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      controller: _enr,
                      enabled: true,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "Enrollment",
                          errorText:
                              _enrValidate ? "Enter valid enrollment" : null,
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
                      onChanged: (String str) {
                        RegExp fnameregex = RegExp(r"^[a-zA-Z]*$");
                        setState(() {
                          if (fnameregex.hasMatch(str)) {
                            _fValidate = false;
                          } else {
                            fNameErrorText =
                            "Name Should Contain Only Characters";
                            _fValidate = true;
                          }
                        });
                      },
                      controller: _fName,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purple,
                      cursorRadius: Radius.circular(50.0),
                      cursorWidth: 3.0,
                      decoration: new InputDecoration(
                          hintText: "First Name",
                          errorText:
                              _fValidate ? fNameErrorText : null,
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
                      onChanged: (String str) {
                        RegExp fnameregex = RegExp(r"^[a-zA-Z]*$");
                        setState(() {
                          if (fnameregex.hasMatch(str)) {
                            _mValidate = false;
                          } else {
                            mNameErrorText =
                            "Name Should Contain Only Characters";
                            _mValidate = true;
                          }
                        });
                      },
                      decoration: new InputDecoration(
                          hintText: "Middle Name",
                          errorText: _mValidate ? mNameErrorText : null,
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
                      onChanged: (String str) {
                        RegExp fnameregex = RegExp(r"^[a-zA-Z]*$");
                        setState(() {
                          if (fnameregex.hasMatch(str)) {
                            _lValidate = false;
                          } else {
                            lNameErrorText =
                            "Name Should Contain Only Characters";
                            _lValidate = true;
                          }
                        });
                      },
                      decoration: new InputDecoration(
                          hintText: "Last Name",
                          errorText: _lValidate ? lNameErrorText : null,
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
                      onChanged: (String str) {
                        setState(() {
                          if (EmailValidator.validate(str)) {
                            _emailValidate = false;
                          } else {
                            _emailValidate = true;
                          }
                        });
                      },
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
                      onChanged: (String str) {
                        RegExp regexp = new RegExp(r'^[6789]\d{9}$');
                        setState(() {
                          if (regexp.hasMatch(str)) {
                            _phoneValidate = false;
                          } else {
                            _phoneValidate = true;
                          }
                        });
                      },
                      maxLength: 10,
                      decoration: new InputDecoration(
                          hintText: "Phone Number",
                          errorText: _phoneValidate
                              ? 'Please Enter Valid Phone Number'
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        icon: Icon(Icons.format_list_numbered),
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
                    new Padding(padding: const EdgeInsets.only(bottom: 5.0)),
                    _semValidate == false
                        ? Container()
                        : new Align(
                            alignment: Alignment.centerLeft,
                            child: new Text("Please select Semester",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400))),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        icon: Icon(Icons.format_list_numbered),
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
                    new Padding(padding: const EdgeInsets.only(bottom: 5.0)),
                    _divValidate == false
                        ? Container()
                        : new Align(
                            alignment: Alignment.centerLeft,
                            child: new Text("Please select Division",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400))),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        border:
                            Border.all(style: BorderStyle.solid, width: 0.80),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: DropdownButton<String>(
                        /*iconEnabledColor: Colors.white,
                        iconDisabledColor: Colors.white,*/
                        icon: Icon(Icons.format_list_numbered),
                        underline: SizedBox(),
                        items: _batchList.map((String val) {
                          return new DropdownMenuItem<String>(
                            value: val,
                            child: new Text(val),
                          );
                        }).toList(),
                        hint: Text("Batch"),
                        onChanged: (String newVal) {
                          setState(() {
                            this._selectedBatch = newVal;
                          });
                        },
                        value: _selectedBatch,
                        isExpanded: true,
                      ),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 5.0)),
                    _batchValidate == false
                        ? Container()
                        : new Align(
                            alignment: Alignment.centerLeft,
                            child: new Text("Please select Batch",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400))),
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
                        "Update",
                        style:
                            new TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_enr.text.isEmpty) {
                            _enrValidate = true;
                          } else if (_enr.text.length != 12) {
                            _enrValidate = true;
                          } else {
                            _enrValidate = false;
                          }
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
                          if (_enrValidate == false &&
                              _fValidate == false &&
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
      ],
    );
    /*return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            color: Colors.white,
            child: Text("Hello"),
          ),
        ],
      ),
    );*/
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
    try {
      await Firestore.instance
          .collection('student_details')
          .document(itemsStudent[id].documentID)
          .updateData({
        'enrollment': _enr.text,
        'email': _eMail.text,
        'first_name': _fName.text,
        'last_name': _lName.text,
        'middle_name': _mName.text,
        'phone_number': _phone.text,
        'semester': _selectedSemester,
        'division': _selectedDivision,
        'parent_phone_number': _parentPhone.text,
      });
      await Firestore.instance
          .collection("parent_details")
          .document(_parentPhone.text)
          .updateData({
        'student_division': _selectedDivision,
        'student_email': _eMail.text,
        'student_name': _fName.text + " " + _mName.text + " " + _lName.text,
        'student_phone_number': _phone.text,
        'student_semester': _selectedSemester,
        'phone': _parentPhone.text,
      });
    } catch (e) {
      pr.hide();
      print(e.toString());
    }
    pr.hide();
    Fluttertoast.showToast(msg: "Record Updated");
    Navigator.of(context).pop();
  }
}
