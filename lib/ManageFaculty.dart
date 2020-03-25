import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/UpdateFaculty.dart';
import 'package:flutter/material.dart';
import 'CommonAppBar.dart';
import 'FacultyAdd.dart';
import 'UpdateFaculty.dart';

var itemsFaculty;

class ManageFaculty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ManageInfo(),
    );
  }
}

class ManageInfo extends StatefulWidget {
  @override
  _ManageInfoState createState() => _ManageInfoState();
}

class _ManageInfoState extends State<ManageInfo> {
  int len = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      appBar: CommonAppBar("Manage Faculty Details"),
      body: new Container(
        padding: EdgeInsets.all(5.0),
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("faculty_details")
                      .snapshots(),
                  builder: (context, snap) {
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
              builder: (BuildContext context) => new FacultyAdd()));
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
                        .collection("faculty_details")
                        .snapshots(),
                    builder: (context, snap) {
                      itemsFaculty = snap.data.documents;
                      /*print(items.runtimeType);
                      print(items[index].documentID);
                      print(snap.data.runtimeType);*/
                      return Text(
                        "Name : " +
                            itemsFaculty[index]['first_name'] +
                            " " +
                            itemsFaculty[index]['last_name'],
                        style: new TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.bold),
                      );
                    }),
                new Padding(padding: EdgeInsets.only(bottom: 5.0)),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("faculty_details")
                        .snapshots(),
                    builder: (context, snap) {
                      itemsFaculty = snap.data.documents;
                      return Text(
                        "Email : " + itemsFaculty[index]['email'],
                        style: new TextStyle(
                            fontSize: 8.0, fontWeight: FontWeight.bold),
                      );
                    }),
                new Padding(padding: EdgeInsets.only(bottom: 21.0)),
                new Row(
                  children: <Widget>[
                    new OutlineButton(
                      onPressed: () =>
                      {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                              return new UpdateFaculty(index);
                            }))
                      },
                      child: new Text("Update",
                          style: new TextStyle(color: Colors.green)),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(right: 20.0),
                    ),
                    new OutlineButton(
                      onPressed: () =>{}, //studentRemove(index),
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
}



