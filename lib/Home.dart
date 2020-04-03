import 'package:bubble/bubble.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoleami1_0/CommonAppBar.dart';
import 'package:ecoleami1_0/MainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddEvent.dart';
import 'ManageVerification.dart';
import 'SplashScreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences prf;
  String _username;
  Color backgroundColor;

  void initState() {
    super.initState();
    user != null ? _username = user : setUser();
  }

  void setUser() async {
    prf = await SharedPreferences.getInstance();
    _username = prf.get("Username");
    //Fluttertoast.showToast(msg: prf.get("Username"));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: CommonAppBar("EcoleAmi"),
        drawer: new Drawer(
          elevation: 100.0,
          child: new ListView(
            padding: EdgeInsets.only(top: 25.0),
            children: <Widget>[
              new UserAccountsDrawerHeader(
                margin: EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(5.0)),
                accountName: StreamBuilder(
                  stream: Firestore.instance
                      .collection("admin_details")
                      .document(_username)
                      .snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var username = snapshot.data;
                      return Text(
                          username['first_name'] + " " + username['last_name']);
                    }
                  },
                ),
                accountEmail: StreamBuilder(
                  stream: Firestore.instance
                      .collection("admin_details")
                      .document(_username)
                      .snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var username = snapshot.data;
                      return Text(username['email']);
                    }
                  },
                ),
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
                title: new Text(
                  "Manage Student",
                  style: Theme.of(context).textTheme.subhead,
                ),
                trailing: new Icon(Icons.account_circle),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new ManageVerification("Student")));
                },
              ),
              new ListTile(
                title: new Text(
                  "Manage Faculty",
                  style: Theme.of(context).textTheme.subhead,
                ),
                trailing: new Icon(Icons.account_circle),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new ManageVerification("Faculty")));
                },
              ),
              new ListTile(
                title: new Text(
                  "Add Events",
                  style: Theme.of(context).textTheme.subhead,
                ),
                trailing: new Icon(Icons.add_circle),
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new AddEvent()));
                },
              ),
              new ListTile(
                title: new Text(
                  "Dummy 2",
                  style: Theme.of(context).textTheme.subhead,
                ),
                trailing: new Icon(Icons.cancel),
                onTap: _onItemTapped1,
              ),
              new ListTile(
                title: new Text(
                  "Dummy 3",
                  style: Theme.of(context).textTheme.subhead,
                ),
                trailing: new Icon(Icons.cancel),
                onTap: _onItemTapped1,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      body: callPage(selectedIndex),
      backgroundColor: selectedIndex == 0
          ? Colors.grey
          : selectedIndex == 1
          ? Colors.red
          : selectedIndex == 2
          ? Colors.greenAccent
          : selectedIndex == 3 ? Colors.black : Colors.grey,
    );
  }

  int selectedIndex = 0;
  List<NavigationItem> items = [
    NavigationItem(Icon(Icons.home), Text("Home"), Colors.deepPurpleAccent),
    NavigationItem(
        Icon(Icons.account_circle), Text("Profile"), Colors.purpleAccent),
    NavigationItem(Icon(Icons.chat), Text("QnA"), Colors.greenAccent),
    NavigationItem(Icon(Icons.settings), Text("Settings"), Colors.black)
  ];
  Widget BottomNavBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.height) * 0.10,
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          color: Colors.white),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            var itemIndex = items.indexOf(item);
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = itemIndex;
                  //print(selectedIndex);
                });
              },
              child: _buildItem(item, selectedIndex == itemIndex),
            );
          }).toList()),
    );
  }

  Widget _buildItem(NavigationItem item, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      padding: EdgeInsets.only(left: 10.0),
      width: isSelected ? 120 : 60,
      height: 45,
      decoration: isSelected
          ? BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(16.0),
      )
          : null,
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconTheme(
              data: IconThemeData(
                  size: 25.0,
                  color: isSelected
                      ? item.title.data.compareTo("Settings") == 0
                      ? Colors.white
                      : backgroundColor
                      : Colors.black),
              child: item.icon,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: isSelected
                  ? Text(
                item.title.data,
                style: TextStyle(
                    color: item.title.data.compareTo("Settings") == 0
                        ? Colors.white
                        : backgroundColor),
              )
                  : Container(),
            )
          ],
        ),
      ]),
    );
  }
  Widget _buildBodyHome() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          height: 180.0,
          width: 300.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
          child: Carousel(
            dotColor: Colors.grey,
            borderRadius: true,
            radius: Radius.circular(50.0),
            autoplayDuration: Duration(seconds: 5),
            autoplay: true,
            animationCurve: Curves.easeIn,
            animationDuration: Duration(milliseconds: 1000),
            dotSize: 6.0,
            dotIncreasedColor: Colors.purple,
            dotBgColor: Colors.transparent,
            dotPosition: DotPosition.bottomCenter,
            dotVerticalPadding: 10.0,
            showIndicator: true,
            indicatorBgPadding: 7.0,
            onImageTap: (index) {
              print(index);
            },
            images: [
              FadeInImage.assetNetwork(
                  placeholder: 'images/loading.gif',
                  fit: BoxFit.fill,
                  image:
                  'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
              FadeInImage.assetNetwork(
                  placeholder: 'images/loading.gif',
                  fit: BoxFit.fill,
                  image:
                  "https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg"),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 15.0),
          height: 175.0,
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Events",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ),
              Container(
                height: 140.0,
                padding: EdgeInsets.all(5.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      semanticContainer: true,
                      borderOnForeground: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FadeInImage.assetNetwork(
                              placeholder: 'images/loading.gif',
                              width: 170.0,
                              height: 100,
                              fit: BoxFit.cover,
                              image:
                              'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text("Maisaie",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 3.0)),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 175.0,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "College Schedule",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ),
              Container(
                height: 140.0,
                padding: EdgeInsets.all(5.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      semanticContainer: true,
                      borderOnForeground: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FadeInImage.assetNetwork(
                              placeholder: 'images/loading.gif',
                              width: 170.0,
                              height: 100,
                              fit: BoxFit.cover,
                              image:
                              'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text("Maisaie",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 3.0)),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 175.0,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Fee Payment",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ),
              Container(
                height: 140.0,
                padding: EdgeInsets.all(5.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      semanticContainer: true,
                      borderOnForeground: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FadeInImage.assetNetwork(
                              placeholder: 'images/loading.gif',
                              width: 170.0,
                              height: 100,
                              fit: BoxFit.cover,
                              image:
                              'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text("Maisaie",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 3.0)),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool stat = false;
  Widget _buildBodyProfile() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage.assetNetwork(
                  placeholder: 'images/loading.gif',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  image:
                  'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
              child: Column(
                children: <Widget>[
                  stat == false
                      ? Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.purple,
                          cursorRadius: Radius.circular(50.0),
                          cursorWidth: 3.0,
                          decoration: new InputDecoration(
                              hintText: "Enrollment",
                              hintStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.white70,
                              ),
                              prefixIcon: new Icon(Icons.account_circle),
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        ),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            stat = true;
                            print(stat);
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        colorBrightness: Brightness.light,
                        elevation: 24.0,
                        animationDuration: Duration(seconds: 5),
                        child: Text("Update"),
                      )
                    ],
                  )
                      : TextField(
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.purple,
                    cursorRadius: Radius.circular(50.0),
                    cursorWidth: 3.0,
                    decoration: new InputDecoration(
                        hintText: "Enrollment",
                        hintStyle: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white70,
                        ),
                        prefixIcon: new Icon(Icons.account_circle),
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                  ),
                  new Padding(padding: const EdgeInsets.only(bottom: 15.0)),
                  new TextFormField(
                    //controller: _eMail,
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.purple,
                    cursorRadius: Radius.circular(50.0),
                    cursorWidth: 3.0,
                    decoration: new InputDecoration(
                        hintText: "Email Address",
                       /* errorText: _emailValidate
                            ? 'Please enter Email Address'
                            : null,*/
                        hintStyle: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white70,
                        ),
                        prefixIcon: new Icon(Icons.email),
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBodyQnA() {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.65,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Wrap(children: <Widget>[
                              Bubble(
                                elevation: 10.0,
                                shadowColor: Colors.white,
                                child: Text(
                                    "Hello My Name Is Shalin Shah I am From GovernMent Polytechnic Ahmedabad"),
                                nip: BubbleNip.leftTop,
                              ),
                            ]),
                            padding: EdgeInsets.only(top: 25.0, left: 5),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Wrap(children: <Widget>[
                              Bubble(
                                elevation: 10.0,
                                shadowColor: Colors.white,
                                child: Text(
                                    "Hello My Name Is Shalin Shah I am From GovernMent Polytechnic Ahmedabad"),
                                nip: BubbleNip.rightTop,
                              ),
                            ]),
                            padding: EdgeInsets.only(top: 25.0, right: 5),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                reverse: true,
                itemCount: 10,
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 8),
                                IconButton(
                                    icon: Icon(
                                      Icons.insert_emoticon,
                                    ),
                                    onPressed: null),
                                SizedBox(width: 8),
                                Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      minLines: 1,
                                      maxLines: 100,
                                      decoration: InputDecoration(
                                        hintText: 'Type a message',
                                        border: InputBorder.none,
                                        alignLabelWithHint: true,
                                      ),
                                    )),
                                Icon(Icons.attach_file,
                                    color: Theme.of(context).hintColor),
                                SizedBox(width: 8.0),
                                Icon(Icons.camera_alt,
                                    color: Theme.of(context).hintColor),
                                SizedBox(width: 8.0),
                                SizedBox(width: 8.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25),
                      child: GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          child: Icon(Icons.send),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildBodySettings() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            title: Text(
              "About Us",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),

          ),
          ListTile(
            leading: Icon(
              Icons.call,
              color: Colors.white,
            ),
            title: Text(
              "Contact Us",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
          ListTile(
              title: new Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              trailing: new Icon(Icons.arrow_forward_ios, color: Colors.white),
              leading: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onTap: () async {
                SharedPreferences prf =
                await SharedPreferences.getInstance();
                prf.setBool("isLoggedIn", false);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => new MainScreen()));
              })
        ],
      ),
    );
  }

  Widget callPage(index) {
    switch (index) {
      case 0:
        return _buildBodyHome();
        break;
      case 1:
        return _buildBodyProfile();
        break;
      case 2:
        return _buildBodyQnA();
        break;
      case 3:
        return _buildBodySettings();
        break;
    }
  }

  void _onItemTapped1() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Under Construction!"),
            elevation: 20.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: new Text(
                "This Part of Application is Still Under Construction"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Close"))
            ],
          );
        });
  }
}
class NavigationItem {
  final Icon icon;
  final Text title;
  final Color color;

  NavigationItem(this.icon, this.title, this.color);
}