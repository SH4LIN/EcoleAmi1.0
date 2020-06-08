// in setProfile()

_fullName = document['first_name'] +
          " " +
          document['middle_name'] +
          " " +
          document['last_name'];


// Final QnA Student

TextEditingController _msg = new TextEditingController();
  int _type;
  var _semester;

  Widget _buildBodyQnA() {
    var msgItems;
    //print(DateTime.now().day.toString() +"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString());
    Firestore.instance
        .collection("student_details")
        .document(_username)
        .get()
        .then((snapshot) {
      setState(() {
        _semester = snapshot["semester"];
      });
    });
    return _semester != null
        ? ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.65,
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('QnA')
                      .document("student")
                      .collection(_semester)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot != null && snapshot.hasData) {
                      msgItems = snapshot.data.documents;
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        String senderUsername = msgItems[index]['userid'];
                        String senderFullName =
                        msgItems[index]['full_name'];
                        int type = msgItems[index]['type'];
                        return Column(
                          crossAxisAlignment:
                          (senderUsername.compareTo(_username)) == 0
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.5,
                              alignment:
                              (senderUsername.compareTo(_username)) ==
                                  0
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Wrap(children: <Widget>[
                                Bubble(
                                  padding: BubbleEdges.only(left: 8),
                                  elevation: 10.0,
                                  shadowColor: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        (senderUsername.compareTo(
                                            _username)) ==
                                            0
                                            ? "You"
                                            : senderFullName,
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                      ),
                                      SizedBox(height: 8),
                                      type == 0
                                          ? Text(
                                        msgItems[index]['message'],
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black),
                                      )
                                          : GestureDetector(
                                        onTap: () {
                                          print(index);
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext
                                                  context) =>
                                                      ShowImage(msgItems[
                                                      index]
                                                      [
                                                      'message'])));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: msgItems[index]
                                          ['message'],
                                          placeholder: (context,
                                              url) =>
                                              Center(
                                                  child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context,
                                              url, error) =>
                                          new Icon(Icons.error),
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            msgItems[index]['time'],
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  nip: (senderUsername
                                      .compareTo(_username)) ==
                                      0
                                      ? BubbleNip.rightTop
                                      : BubbleNip.leftTop,
                                ),
                              ]),
                              padding:
                              EdgeInsets.only(top: 10.0, left: 8),
                              margin: EdgeInsets.only(bottom: 8),
                            ),
                          ],
                        );
                      },
                      reverse: true,
                      itemCount: msgItems != null ? msgItems.length : 0,
                    );
                  }),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 16),
                                Expanded(
                                    child: TextFormField(
                                      controller: _msg,
                                      keyboardType: TextInputType.multiline,
                                      minLines: 1,
                                      maxLines: 100,
                                      decoration: InputDecoration(
                                        hintText: 'Type a message',
                                        border: InputBorder.none,
                                        alignLabelWithHint: true,
                                      ),
                                    )),
                                GestureDetector(
                                  onTap: () => sendCameraImage(),
                                  child: Icon(Icons.camera_alt,
                                      color: Theme
                                          .of(context)
                                          .hintColor),
                                ),
                                SizedBox(width: 8.0),
                                GestureDetector(
                                  onTap: () => sendImage(),
                                  child: Icon(Icons.image,
                                      color: Theme
                                          .of(context)
                                          .hintColor),
                                ),
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
                      margin: EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _type = 0;
                            sendMessage(_msg.text);
                            _msg.clear();
                          });
                        },
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
    )
        : Center(child: CircularProgressIndicator());
  }

  var _uploadedFileURL;

  void sendCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = null;
      _image = image;
      _type = 1;
    });
    if (_image != null) {
      print("FILE SIZE BEFORE: " + _image.lengthSync().toString());
      await CompressImage.compress(
          imageSrc: _image.path,
          desiredQuality: 50); //desiredQuality ranges from 0 to 100
      print("FILE SIZE  AFTER: " + _image.lengthSync().toString());
      print(_image.path);
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('QnA Images/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);

      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        print(fileURL);
        if (fileURL == null) {
          throw Exception("URL Null");
        }
        _uploadedFileURL = fileURL;
      });
      if (_uploadedFileURL == null) {
        throw Exception("URL Null..");
      }
      print("URL: " + _uploadedFileURL);
      await Firestore.instance
          .collection('QnA')
          .document('student')
          .collection(_semester)
          .document(DateTime.now().toString())
          .setData({
      'full_name': _fullName,
      'userid': _username,
      'message': _uploadedFileURL,
      'timestamp': DateTime.now(),
      'date': DateTime.now().day.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().year.toString(),
      'time': DateTime.now().hour.toString() +
      ":" +
      DateTime.now().minute.toString() +
      ":" +
      DateTime.now().second.toString(),
      'type': _type
      });
    }
  }

  void sendImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = null;
      _image = image;
      _type = 1;
    });
    if (_image != null) {
      print("FILE SIZE BEFORE: " + _image.lengthSync().toString());
      await CompressImage.compress(
          imageSrc: _image.path,
          desiredQuality: 50); //desiredQuality ranges from 0 to 100
      print("FILE SIZE  AFTER: " + _image.lengthSync().toString());
      print(_image.path);
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('QnA Images/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        print(fileURL);
        if (fileURL == null) {
          throw Exception("URL Null");
        }
        _uploadedFileURL = fileURL;
      });
      if (_uploadedFileURL == null) {
        throw Exception("URL Null..");
      }
      print("URL: " + _uploadedFileURL);
      await Firestore.instance
          .collection('QnA')
          .document('student')
          .collection(_semester)
          .document(DateTime.now().toString())
          .setData({
      'full_name': _fullName,
      'userid': _username,
      'message': _uploadedFileURL,
      'timestamp': DateTime.now(),
      'date': DateTime.now().day.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().year.toString(),
      'time': DateTime.now().hour.toString() +
      ":" +
      DateTime.now().minute.toString() +
      ":" +
      DateTime.now().second.toString(),
      'type': _type
      });
    }
  }

  void sendMessage(String msg) async {
    if (msg.isNotEmpty) {
      await Firestore.instance
          .collection('QnA')
          .document('student')
          .collection(_semester)
          .document(DateTime.now().toString())
          .setData({
      'full_name': _fullName,
      'userid': _username,
      'message': msg,
      'timestamp': DateTime.now(),
      'date': DateTime.now().day.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().year.toString(),
      'time': DateTime.now().hour.toString() +
      ":" +
      DateTime.now().minute.toString() +
      ":" +
      DateTime.now().second.toString(),
      'type': _type
      });
    } else {
      Fluttertoast.showToast(
          msg: "Nothing To Send", gravity: ToastGravity.CENTER);
    }
  }
