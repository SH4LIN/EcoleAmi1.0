import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/UpdateStudent.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'CommonAppBar.dart';
import 'StudentAdd.dart';

var itemsStudent;

class ManageStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ManageInformation(),
    );
  }
}

class ManageInformation extends StatefulWidget {
  @override
  _ManageInformationState createState() => _ManageInformationState();
}

class _ManageInformationState extends State<ManageInformation> {
  // List<String> names = ["Shalin"];
  //List<String> enrollment = ["Shalin"];
  /*void getNames() async {
    await Firestore.instance
        .collection("student_details")
        .getDocuments()
        .then((QuerySnapshot snap) {
      snap.documents.forEach((f) {
        names.add(f.data['first_name'] +
            " " +
            f.data['middle_name'] +
            " " +
            f.data['last_name']);
        enrollment.add(f.data['enrollment']);
        print(f.data['first_name']);
        print("Length" + names.length.toString());
        print(names.elementAt(0));
      });
    });
  }*/
  int len = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      appBar: CommonAppBar("Manage Student Details"),
      body: new Container(
        padding: EdgeInsets.all(5.0),
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("student_details")
                      .snapshots(),
                  builder: (context, snap) {
                    len = snap.data.documents.length;
                    return ListView.builder(
                      itemBuilder: _getListItemTile,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: len,
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new StudentAdd()));
        },
        child: new Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _getListItemTile(BuildContext context, int index) {
    return new Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      borderOnForeground: true,
      child: new Container(
        padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 90.0,
                  margin: EdgeInsets.only(left: 10.0, right: 7.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/dummyimg.png')),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("student_details")
                        .snapshots(),
                    builder: (context, snap) {
                      itemsStudent = snap.data.documents;
                      /*print(items.runtimeType);
                      print(items[index].documentID);
                      print(snap.data.runtimeType);*/
                      return Text(
                        "Name : " +
                            itemsStudent[index]['first_name'] +
                            " " +
                            itemsStudent[index]['middle_name'] +
                            " " +
                            itemsStudent[index]['last_name'],
                        style: new TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.bold),
                      );
                    }),
                new Padding(padding: EdgeInsets.only(bottom: 5.0)),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("student_details")
                        .snapshots(),
                    builder: (context, snap) {
                      itemsStudent = snap.data.documents;
                      return Text(
                        "Enrollment : " + itemsStudent[index]['enrollment'],
                        style: new TextStyle(
                            fontSize: 8.0, fontWeight: FontWeight.bold),
                      );
                    }),
                new Padding(padding: EdgeInsets.only(bottom: 21.0)),
                new Row(
                  children: <Widget>[
                    new OutlineButton(
                      onPressed: () => {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                          return new UpdateStudent(index);
                        }))
                      },
                      child: new Text("Update",
                          style: new TextStyle(color: Colors.green)),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(right: 20.0),
                    ),
                    new OutlineButton(
                      onPressed: () => studentRemove(index),
                      child: new Text("Remove",
                          style: new TextStyle(color: Colors.red)),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void studentRemove(int id) {
    var _document = itemsStudent[id].documentID;
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Caution!"),
            elevation: 20.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: new Text("Are You Sure You Want To Remove This User"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Cancel")),
              new FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await pr.show();
                    try {
                      await Firestore.instance
                          .collection('student_details')
                          .document(_document)
                          .delete();
                      final snapShot = await Firestore.instance
                          .collection('login_details')
                          .document(_document)
                          .get();
                      /*print(snapShot.exists.toString());
                      print(_document);
                      print(snapShot!=null);*/
                      if (snapShot != null || snapShot.exists) {
                        await Firestore.instance
                            .collection('login_details')
                            .document(_document)
                            .delete();
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                    pr.hide();
                    Fluttertoast.showToast(msg: "Record Removed");
                  },
                  child: new Text("Yes"))
            ],
          );
        });
  }
}
