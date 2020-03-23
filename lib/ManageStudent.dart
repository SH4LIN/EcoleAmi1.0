import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/UpdateStudent.dart';
import 'package:flutter/material.dart';
import 'CommonAppBar.dart';
import 'StudentAdd.dart';

class ManageStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new ManageInformation(),
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
    //getNames();
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
                builder:(context,snap) {
                  len = snap.data.documents.length;
                  return ListView.builder(
                    itemBuilder: _getListItemTile,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: len,
                  );
                }
              ),
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
  Widget _getListItemTile(BuildContext context, int index){
    return new Card(
      elevation: 10.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      borderOnForeground: true,
      child: new Container(
        padding: EdgeInsets.only(top: 20.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 5.0, bottom: 20.0),
                  child: new Image(
                    image: AssetImage('images/dummyimg.png'),
                    width: 100.0,
                    height: 100.0,
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
                      var items = snap.data.documents;
                      return Text(
                        "Name : " +
                            items[index]['first_name'] +
                            " " +
                            items[index]['middle_name'] +
                            " " +
                            items[index]['last_name'],
                        style: new TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      );
                    }),
                new Padding(
                    padding: EdgeInsets.only(bottom: 5.0)),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("student_details")
                        .snapshots(),
                    builder: (context, snap) {
                      var items = snap.data.documents;
                      return Text(
                        "Enrollment : " +
                            items[index]['enrollment'],

                        style: new TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold),
                      );
                    }),
                new Padding(
                    padding: EdgeInsets.only(bottom: 21.0)),
                new Row(
                  children: <Widget>[
                    new OutlineButton(
                      onPressed: () => {
                        Navigator.push(context, new MaterialPageRoute(builder: (context){
                          return new UpdateStudentData();
                        }))
                      },
                      child: new Text("Update",
                          style:
                          new TextStyle(color: Colors.green)),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(right: 20.0),
                    ),
                    new OutlineButton(
                      onPressed: () => {},
                      child: new Text("Remove",
                          style:
                          new TextStyle(color: Colors.red)),
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
}
