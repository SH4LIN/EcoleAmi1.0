import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'Home.dart';

class ShowNotice extends StatelessWidget {
  DocumentSnapshot _username;

  ShowNotice(this._username);

  /*var formatter = new DateFormat('dd-MM-yyyy jms');
  String formatted;*/

  @override
  Widget build(BuildContext context) {
    return Show(_username);
  }
}

class Show extends StatefulWidget {
  DocumentSnapshot _username;

  Show(this._username);

  @override
  _ShowState createState() => _ShowState(_username);
}

class _ShowState extends State<Show> {
  DocumentSnapshot _username;

  _ShowState(this._username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(_username['title']),
        body: new Container(
          child: ListView(
            children: <Widget>[
              new Container(
                child: new Stack(
                  children: <Widget>[
                    new CachedNetworkImage(
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.cyan,
                      )),
                      width: (MediaQuery.of(context).size.width),
                      height: (MediaQuery.of(context).size.width),
                      imageUrl: _username['url'],
                      fadeInDuration: Duration(seconds: 1),
                    ),
                  ],
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(top: 15),
                child: new Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(15),
                  child: new Column(
                    children: <Widget>[
                      new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          _username['description'],
                          style: TextStyle(
                            fontSize: 21,
                          ),
                        ),
                      ),
                      new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                      new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          _username['type'],
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                new Text(
                                  "Upload Date",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: new Text(
                                    _username['timestamp'].toDate().toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                new Text(
                                  "Expiry Date",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: new Text(
                                    _username['expiry_date']
                                        .toDate()
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
