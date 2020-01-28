import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'List.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
         primarySwatch: Colors.blue
      ),
      home: new _LoginPage(),
    );
  }
}

class _LoginPage extends StatefulWidget {
  @override
  __LoginPageState createState() => __LoginPageState();
}

class __LoginPageState extends State<_LoginPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          child: new List(),
        ),
      ),
    );
  }
}

