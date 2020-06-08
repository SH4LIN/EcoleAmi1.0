import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShowLeave extends StatelessWidget {
  final url;

  ShowLeave(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new Dismissible(
            direction: DismissDirection.down,
            key: Key('key'),
            onDismissed: (_) => Navigator.pop(context),
            child: CachedNetworkImage(
              width: (MediaQuery.of(context).size.width),
              height: (MediaQuery.of(context).size.height),
              imageUrl: url,
              fadeInDuration: Duration(seconds: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 10),
            child: Align(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              alignment: Alignment.topLeft,
            ),
          ),
        ],
      ),
    );
  }
}
