import 'dart:io';
import 'dart:typed_data';
import 'upload_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:search_india/chat.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class FinalAdd extends StatefulWidget {
  final Map<String, String> map;

  FinalAdd({this.map});

  @override
  _FinalAddState createState() => _FinalAddState();
}

class _FinalAddState extends State<FinalAdd> {

  List<Asset> images = List<Asset>();
  final _auth = FirebaseAuth.instance;
  String _error = 'No Error Dectected';
  final _firestore = Firestore.instance;
  FirebaseUser loggedinuser;
  bool loading = false;
  List<File> _images = [];
  String location, uid1;
  var uris = [];

  void getCurrentUser() async {
    try {
      setState(() {
        loading = true;
      });
      var user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
        uid1 = loggedinuser.uid;
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> uploadImage({@required List<Asset> assets}) async {
    List<String> uploadUrls = [];

    await Future.wait(
        assets.map((Asset asset) async {
          ByteData byteData = await asset.getByteData();
          List<int> imageData = byteData.buffer.asUint8List();
          StorageReference reference = FirebaseStorage.instance.ref().child(
              "pics/" + DateTime.now().millisecondsSinceEpoch.toString());
          StorageUploadTask uploadTask = reference.putData(imageData);
          StorageTaskSnapshot storageTaskSnapshot;
          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          if (snapshot.error == null) {
            storageTaskSnapshot = snapshot;
            final String downloadUrl =
                await storageTaskSnapshot.ref.getDownloadURL();
            uploadUrls.add(downloadUrl);

            print('Upload success');
          } else {
            print('Error from image repo ${snapshot.error.toString()}');
            throw ('This file is not an image');
          }
        }),
        eagerError: true,
        cleanUp: (_) {
          print('eager cleaned up');
        });

    return uploadUrls;
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          statusBarColor: "#191919",
          actionBarColor: "#212121",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#212121",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    images.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          title: Text('Create Report'),
          actions: <Widget>[IconButton(icon: Icon(Icons.attach_file), onPressed: (){ Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FileUploader()));
          })],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.black.withAlpha(80),
                    ),
                    child: images.length == 0
                        ? Center(
                            child: InkWell(
                              onTap: (){
                                loadAssets();
                              },
                              child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  size: 100,
                                  color: Colors.white.withAlpha(230),
                                ),
                                Text(
                                  'SELECT PICTURES',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white.withAlpha(230),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 30, top: 20),
                                    alignment: Alignment.bottomCenter,
                                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            "Maximum 9 images allowed at a time."),
                                        Text(
                                          'Use real picture, not Catalog.',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                          ),
                            ))
                        : Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 0, 8, 0),
                                    child: Container(child: buildGridView()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom:12.0, top: 5),
                                  child: Column(
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.refresh, size: 32, color: Colors.white,),
                                          onPressed: (){
                                            loadAssets();
                                          }),
                                      Text("Re-take")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
              ),
            ),
            SizedBox(
              height: 70,
            ),

            GestureDetector(
              onTap: () async {
                setState(() {
                  loading = true;
                });
                uris = await uploadImage(assets: images);
                await _firestore.collection('adds').add({
                  'uid': uid1,
                  'category': widget.map['category'],
                  'subcategory': widget.map['subcategory'],
                  'posttype': widget.map['posttype'] == '0' ? 'LOST' : "FOUND",
                  'city': widget.map['city'],
                  'uri': uris,
                  'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                });
                setState(() {
                  loading = true;
                });
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black),
                  child: Center(
                    child: Text(
                      'Finish',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      'Back',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 45,
            ),
          ],
        ),
      ),
    );
  }





}

