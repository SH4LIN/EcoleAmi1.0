import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'ManageVerification.dart';

class StudentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new StudentActivityPage(),
    );
  }
}

class StudentActivityPage extends StatefulWidget {
  @override
  _StudentActivityPageState createState() => _StudentActivityPageState();
}

class _StudentActivityPageState extends State<StudentActivityPage> {
  SharedPreferences prf;
  String _username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUser();
  }
  void setUser() async{
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
    //Fluttertoast.showToast(msg: prf.get("Username"));
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Ecoleami"),
      ),
      drawer: new Drawer(
        elevation: 100.0,
        child: new ListView(
          padding: EdgeInsets.only(top: 25.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text("Admin"),
              accountEmail: Text("sahilshh723@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? Colors.blue
                    : Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              arrowColor: Colors.red,
            ),
            new ListTile(
              title: new Text("Manage Student",style: Theme.of(context).textTheme.subhead,),
              trailing: new Icon(Icons.account_circle),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ManageVerification("Student")));
              },
            ),
            new ListTile(
              title: new Text("Manage Faculty",style: Theme.of(context).textTheme.subhead,),
              trailing: new Icon(Icons.account_circle),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ManageVerification("Faculty")));
              },
            ),
            new ListTile(
              title: new Text("Dummy 1",style: Theme.of(context).textTheme.subhead,),
              trailing: new Icon(Icons.cancel),
              onTap: _onItemTapped1,
            ),
            new ListTile(
              title: new Text("Dummy 2",style: Theme.of(context).textTheme.subhead,),
              trailing: new Icon(Icons.cancel),
              onTap: _onItemTapped1,
            ),
            new ListTile(
              title: new Text("Dummy 3",style: Theme.of(context).textTheme.subhead,),
              trailing: new Icon(Icons.cancel),
              onTap: _onItemTapped1,
            ),
            new ListTile(
                title: new Text("Logout",style: Theme.of(context).textTheme.subhead,),
                trailing: new Icon(Icons.arrow_back),
                onTap: (){
                  prf.setBool("isLoggedIn", false);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context)=>new MyApp()));
                }
            )
          ],
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text("Home")
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle),
              title: Text("Profile")
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.chat),
              title: Text("QnA")
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.settings),
              title: Text("Settings")
          ),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int value) {
    showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text("Under Construction!"),
        elevation: 20.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        content: new Text("This Part of Application is Still under Construction"),
        actions: <Widget>[
          new FlatButton(onPressed: (){Navigator.of(context).pop();}, child: new Text("Close"))
        ],
      );
    });
  }

  void _onItemTapped1() {
    showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text("Under Construction!"),
        elevation: 20.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        content: new Text("This Part of Application is Still Under Construction"),
        actions: <Widget>[
          new FlatButton(onPressed: (){Navigator.of(context).pop();}, child: new Text("Close"))
        ],
      );
    });
  }
}

