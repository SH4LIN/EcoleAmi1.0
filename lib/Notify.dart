import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new OverlaySupport(
            child: MaterialApp(
              title: 'Overlay Support Example',
              home: Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      showOverlayNotification((context) {
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: SafeArea(
                            child: ListTile(
                              leading: SizedBox.fromSize(
                                  size: const Size(40, 40),
                                  child: ClipOval(
                                      child: Container(
                                        child: Icon(Icons.add_alert, color: Colors.red,),
                                      ))),
                              title: Text('Alert'),
                              subtitle: Text('A3 Lab is in 105 classroom'),
                              trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    OverlaySupportEntry.of(context).dismiss();
                                  }),
                            ),
                          ),
                        );
                      }, duration: Duration(minutes: 10));
                    },
                    child: Icon(Icons.notifications),
                  )
              ),
          )
      ),
    );
  }
}

