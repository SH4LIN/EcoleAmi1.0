import 'package:flutter/material.dart';

import 'FacultyAdd.dart';

class ManageFaculty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new ManageInfo(),
    );
  }
}

class ManageInfo extends StatefulWidget {
  @override
  _ManageInfoState createState() => _ManageInfoState();
}

class _ManageInfoState extends State<ManageInfo> {
  List<String> names = ["Shalin","Jayshil","Mrugen","Khushangee","Shashank"];
  List<String> enrollment = ["176170307109","176170307035","166170307501","176170307114","176170307059"];
  List<String> semester = ["6th","6th","6th","6th","6th"];
  List<String> division = ["B","A","A","B","A"];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
          padding: EdgeInsets.all(5.0),
          child: new Column(
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(top: 25.0)
              ),
              new Text("Faculty Manager",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),),
              new Expanded(
                child: new ListView.builder(
                  itemBuilder: (BuildContext context,int index){
                    return new Card(
                      elevation: 20.0,
                      child: new Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(left: 10.0,right: 5.0,bottom: 10.0),
                              child: new Image(
                                image: AssetImage('images/dummyimg.png'),
                                width: 100.0,
                                height: 100.0,
                              ),
                            ),
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  "Name : "+names[index],
                                  style: new TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(bottom: 5.0)
                                ),
                                new Text(
                                  "Enrollment : "+enrollment[index],
                                  style: new TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(bottom: 5.0)
                                ),
                                new Text(
                                  "Semester : "+semester[index]+" "+"Division : "+division[index],
                                  style: new TextStyle(
                                      fontSize: 8.0
                                  ),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(bottom: 5.0)
                                ),
                                new Row(
                                  children: <Widget>[
                                    new OutlineButton(
                                      onPressed: ()=>{},
                                      child: new Text("Update",style: new TextStyle(color: Colors.green)),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                    ),
                                    new OutlineButton(
                                      onPressed: ()=>{},
                                      child: new Text("Remove",style: new TextStyle(color: Colors.red)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: names.length,
                ),
              ),
              new Align(
                  alignment: Alignment.bottomRight,
                  child: new FloatingActionButton(
                    onPressed: (){
                      Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (BuildContext context) => new FacultyAdd()
                          )
                      );
                    },
                    child: new Icon(Icons.add),
                  )
              ),
            ],
          ),
        )
    );;
  }
}