import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

String imgUrl;

class UpdatePic extends StatefulWidget {
  final String uid;
  final String name;
  final String number;
  final String city;

  UpdatePic(this.uid, this.name, this.number, this.city);

  @override
  _UpdatePicState createState() => _UpdatePicState();
}

class _UpdatePicState extends State<UpdatePic> {
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  void initState() {
    super.initState();
    print(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload Image"),
        ),
        floatingActionButton: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade300,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 28,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    radius: 28,
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_library,
                        size: 28,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      color: Colors.pink,
                    ),
                  ),
                ],
              )
            : Container(
                height: 0,
                width: 0,
              ),
        body: _imageFile != null
            ? Container(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(32),
                        child: Image.file(
                          _imageFile,
                          height: MediaQuery.of(context).size.height * .4,
                          width: MediaQuery.of(context).size.height * .4,
                          fit: BoxFit.cover,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.grey.shade600,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.crop),
                                Text("Crop")
                              ],
                            ),
                          ),
                          onPressed: _cropImage,
                        ),
                        FlatButton(
                          color: Colors.grey.shade600,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.refresh),
                                Text("Reload")
                              ],
                            ),
                          ),
                          onPressed: _clear,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Uploader(
                          file: _imageFile,
                          uid: widget.uid,
                          city: widget.city,
                          name: widget.name,
                          number: widget.number,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            : Container(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "images/upload.gif",
                        height: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Tap on icons below to choose your source and upload your image.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Only one image is allowed.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                )),
              ));
  }
}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;

  final String uid;
  final String name;
  final String number;
  final String city;

  Uploader({Key key, this.file, this.uid, this.name, this.number, this.city})
      : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final firestore = Firestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://search-india-cb545.appspot.com/');

  StorageUploadTask _uploadTask;

  updateData() async {
    await firestore.collection('users').document(widget.uid).updateData({
      'name': widget.name,
      'mobile': widget.number,
      'city': widget.city,
      'img': imgUrl,
    });
    Navigator.pop(context, imgUrl);
  }

  _startUpload() async {
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
    var downUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    imgUrl = downUrl;
    print(downUrl.toString());
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ignore: sdk_version_ui_as_code
                  if (_uploadTask.isComplete)
                    Text('Upload Complete! Please wait a moment...',
                        style: TextStyle(
                            color: Colors.white, height: 2, fontSize: 18)),
                  // ignore: sdk_version_ui_as_code
                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow, size: 30),
                      onPressed: _uploadTask.resume,
                    ),
                  // ignore: sdk_version_ui_as_code
                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause, size: 30),
                      onPressed: _uploadTask.pause,
                    ),
                  SizedBox(
                    height: 6,
                  ),
                  LinearProgressIndicator(value: progressPercent),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                    style: TextStyle(fontSize: 18),
                  ),
                ]);
          });
    } else {
      return InkWell(
          onTap: _startUpload,
          child: Container(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Upload to Server',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ));
    }
  }
}
