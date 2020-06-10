import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FacultyActivity.dart';
import 'Home.dart';
import 'package:ecoleami1_0/ParentActivity.dart';
import 'MainScreen.dart';
import 'StudentActivity.dart';

var user;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences prf;
  void checkState() async {
    print("Check State");
    prf = await SharedPreferences.getInstance();
    if (prf != null) {
      print("IF1");
      print(prf.getBool("isLoggedIn").toString());
      if (prf.get("isLoggedIn") != null && prf.getBool("isLoggedIn")) {
        print("IF2");
        user = prf.get("Username");
        switch (prf.get("Role")) {
          case "student":
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new StudentActivity()));
            break;
          case "admin":
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new Home()));
            break;
          case "faculty":
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new FacultyActivity()));
            break;
          case "parent":
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new ParentActivity()));
            break;
        }
      } else {
        print("Else1");
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new MainScreen()));
      }
    } else {
      print("Else2");
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new MainScreen()));
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
    Timer(Duration(seconds: 5), () => checkState());
  }

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        foregroundDecoration: BoxDecoration(
            //backgroundBlendMode: BlendMode.colorBurn,
            /*gradient: LinearGradient(
            colors: const [
              Colors.grey,
              Colors.black,
            ],
          ),*/
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 30.0),
              child: Image(
                image: AssetImage('images/ecoleami.png'),
                width: (MediaQuery.of(context).size.width) - 30.0,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
