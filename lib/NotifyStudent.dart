import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SplashScreen.dart';

class NotifyStudent extends StatefulWidget {
  @override
  _NotifyStudentState createState() => _NotifyStudentState();
}

class _NotifyStudentState extends State<NotifyStudent> {
  TextEditingController _description = new TextEditingController();
  SharedPreferences prf;
  String _username;
  String _name;

  var _selectedSemester;
  var _selectedDiv;

  List<String> _divList = ['A', 'B', 'C'];

  bool _descriptionValidate = false;
  bool _semValidate = false;
  bool _divValidate = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _description.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user != null ? _username = user : setUser();
    setProfile();
    print(_username);
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
    print(_username);
  }

  Future setProfile() async {
    Firestore.instance
        .collection("faculty_details")
        .document(_username)
        .get()
        .then((document) {
      _name = document['first_name'] + " " + document['last_name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new CommonAppBar("Notify Student"),
      body: new Container(
          child: new ListView(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              index += 1;
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? Colors.blue
                            : Colors.black12,
                    child: Text(
                      index.toString(),
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ),
                  /*trailing: new IconButton(
      icon: new Icon(Icons.add_a_photo),
      onPressed: () {
      _showBottom(index.toString(), "student");
      },
      ),*/
                  title: Text("Semester " + index.toString()),
                  onTap: () {
                    /*    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
      Student_Semester(index.toString())));*/
                  },
                ),
              );
            },
            itemCount: 6,
          ),
   /*       new Container(
            padding: const EdgeInsets.only(left: 24.0, right: 25.0, top: 25.0),
            child: new Form(
                child: new Card(
              elevation: 30.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: new Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: new BoxDecoration(
                        border:
                            Border.all(style: BorderStyle.solid, width: 0.80),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("semwise_subjects")
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<String> _semesters = new List<String>();
                            if (snapshot != null && snapshot.hasData) {
                              List<DocumentSnapshot> document =
                                  snapshot.data.documents;
                              document.forEach((element) async {
                                await _semesters.add(element.documentID);
                              });
                              return DropdownButton<String>(
                                underline: SizedBox(),
                                items: _semesters.map((String val) {
                                  return new DropdownMenuItem<String>(
                                    value: val,
                                    child: new Text(val),
                                  );
                                }).toList(),
                                hint: Text("Semester"),
                                onChanged: (String newVal) {
                                  setState(() {
                                    this._selectedSemester = newVal;
                                  });
                                },
                                value: _selectedSemester,
                                isExpanded: true,
                              );
                            } else {
                              return DropdownButton<String>(
                                underline: Container(),
                                hint: Text("Semester"),
                                isExpanded: true,
                              );
                            }
                          }),
                    ),
                    new Padding(padding: const EdgeInsets.only(bottom: 5.0)),
                    _semValidate
                        ? new Text("    Please select Semester",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w400))
                        : Container(),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    _selectedSemester != null
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: new BoxDecoration(
                              border: Border.all(
                                  style: BorderStyle.solid, width: 0.80),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: DropdownButton<String>(
                              underline: SizedBox(),
                              items: _divList.map((String val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              hint: Text("Division"),
                              onChanged: (String newVal) {
                                setState(() {
                                  this._selectedDiv = newVal;
                                });
                              },
                              value: _selectedDiv,
                              isExpanded: true,
                            ),
                          )
                        : Container(),
                    new Padding(padding: const EdgeInsets.only(bottom: 5.0)),
                    _divValidate
                        ? new Text("    Please select Division",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w400))
                        : Container(),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    _selectedDiv != null
                        ? new TextField(
                            controller: _description,
                            autofocus: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            maxLength: 50,
                            cursorColor: Colors.purple,
                            cursorRadius: Radius.circular(50.0),
                            cursorWidth: 3.0,
                            decoration: new InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      bottom: 28.0),
                                  child: new Icon(Icons.description),
                                ),
//                                    labelText: "Description",
                                hintText: "Description",
                                errorText: _descriptionValidate
                                    ? 'Description can\'t be empty'
                                    : null,
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                hintStyle: new TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey,
                                )),
                          )
                        : Container(),
                    new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                    new RaisedButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedSemester == null) {
                            _semValidate = true;
                          } else {
                            _semValidate = false;
                            if (_selectedDiv == null) {
                              _divValidate = true;
                            } else {
                              _divValidate = false;
                            }
                          }
                          if (_description.text.isEmpty) {
                            _descriptionValidate = true;
                          } else {
                            _descriptionValidate = false;
                          }
                          if (_description.text.trim().length == 0) {
                            _descriptionValidate = true;
                          } else {
                            _descriptionValidate = false;
                          }
                          print(_semValidate);
                          print(_divValidate);
                          print(_descriptionValidate);
                          if (_semValidate == false &&
                              _divValidate == false &&
                              _descriptionValidate == false) {
                            _sendMessage(_description.text);
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.redAccent,
                      child: Text(
                        "Notify",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            )),
          )*/
        ],
      )),
    );
  }

  void _sendMessage(String msg) async {
    if (msg.isNotEmpty) {
      await Firestore.instance
          .collection('Notify_student')
          .document(_selectedSemester)
          .collection(_selectedDiv)
          .document(DateTime.now().toString())
          .setData({
        'faculty_id': _username,
        'full_name': _name,
        'description': msg,
        'timestamp': DateTime.now(),
        'semester': _selectedSemester,
        'division': _selectedDiv,
        'date': DateTime.now().day.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().year.toString(),
        'time': DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString() +
            ":" +
            DateTime.now().second.toString(),
      });
      print("Message sent");
      Fluttertoast.showToast(msg: "Notified Student");
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "Nothing to send");
    }
  }
}
