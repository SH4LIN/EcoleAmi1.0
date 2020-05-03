import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/material.dart';

class TakeAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar("Attendance"),
      body: Attendance(),
    );
  }
}

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

