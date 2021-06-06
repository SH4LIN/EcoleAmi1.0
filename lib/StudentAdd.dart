import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:ecoleami1_0/ManageStudent.dart';
import 'package:email_validator/email_validator.dart';
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
      backgroundColor: Colors.white,
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
  bool _semValidate = false;
  bool _divValidate = false;
  bool _batchValidate = false;
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

  String fNameErrorText = 'Please enter First Name';
  String mNameErrorText = 'Please enter Middle Name';
  String lNameErrorText = 'Please enter Last Name';
  bool _autoValidate = true;
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Container(
          child: new Form(
            autovalidate: _autoValidate,
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
                    decoration: new InputDecoration(
                        hintText: "First Name",
                        errorText: _fValidate ? fNameErrorText : null,
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
                      border: Border.all(style: BorderStyle.solid, width: 0.80),
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
                      child: new Text("    Please select Semester",
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
                      border: Border.all(style: BorderStyle.solid, width: 0.80),
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
                      child: new Text("    Please select Division",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w400))),
                  new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, width: 0.80),
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
                    onChanged: (String str) {
                      RegExp regexp = new RegExp(r'^[6789]\d{9}$');
                      setState(() {
                        if (regexp.hasMatch(str)) {
                          _parentValidate = false;
                        } else {
                          _parentValidate = true;
                        }
                      });
                    },
                    decoration: new InputDecoration(
                        hintText: "Parent's Phone Number",
                        errorText: _parentValidate
                            ? 'Please Enter Valid  Phone number'
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
                      style: new TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                    onPressed: () {
                      setState(() {
                        if ((_fName.text.trim()).length == 0) {
                          fNameErrorText = "Please Enter First Name";
                          _fValidate = true;
                        } else {
                          _fValidate = false;
                        }
                        if ((_mName.text.trim()).length == 0) {
                          mNameErrorText = "Please Enter Middle Name";
                          _mValidate = true;
                        } else {
                          _mValidate = false;
                        }
                        if ((_lName.text.trim()).length == 0) {
                          lNameErrorText = "Please Enter Last Name";
                          _lValidate = true;
                        } else {
                          _lValidate = false;
                        }
                        if ((_eMail.text.trim()).length == 0) {
                          _emailValidate = true;
                        } else {
                          _emailValidate = false;
                        }
                        if ((_phone.text.trim()).length == 0 ||
                            _phone.text.length < 10) {
                          _phoneValidate = true;
                        } else {
                          _phoneValidate = false;
                        }
                        if (_selectedSemester == null) {
                          _semValidate = true;
                        } else {
                          _semValidate = false;
                        }
                        if (_selectedDivision == null) {
                          _divValidate = true;
                        } else {
                          _divValidate = false;
                        }
                        if (_selectedBatch == null) {
                          _batchValidate = true;
                        } else {
                          _batchValidate = false;
                        }

                        if ((_parentPhone.text.trim()).length == 0 ||
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
      ],
    );
  }

  String ValidateEmail() {}

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
        'batch': _selectedBatch,
        'parent_phone_number': _parentPhone.text,
      });
      await databaseReference
          .collection("parent_details")
          .document(_parentPhone.text.toString())
          .setData({
        'student_enrollment': "------------",
        'phone_number': _parentPhone.text,
        'student_name': _fName.text + " " + _mName.text + " " + _lName.text,
        'student_email': _eMail.text,
        'student_phone_number': _phone.text,
        'student_semester': _selectedSemester,
        'student_division': _selectedDivision,
        'student_batch': _selectedBatch,
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