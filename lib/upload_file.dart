import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class FileUploader extends StatefulWidget {
  @override
  _FileUploaderState createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  String fileType = '';
  bool loading = false;
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

  Future filePicker(BuildContext context) async {
    try {
      if (fileType == 'image') {
        file = await FilePicker.getFile(type: FileType.image);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
      }
      if (fileType == 'audio') {
        file = await FilePicker.getFile(type: FileType.audio);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
      }
      if (fileType == 'video') {
        file = await FilePicker.getFile(type: FileType.video);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
      }
      if (fileType == 'pdf') {
        file = await FilePicker.getFile(
            type: FileType.custom, fileExtension: 'pdf');
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
      }
      if (fileType == 'others') {
        file = await FilePicker.getFile(type: FileType.any);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
      }
    } catch (e) {
//      showDialog(
//          context: context,
//          builder: (BuildContext context) {
//            return AlertDialog(
//              title: Text('Upload Cancelled'),
//              content: Text('Upload cancelled by the user. Please select again and choose your files to upload.'),
//              actions: <Widget>[
//                FlatButton(
//                  child: Text('OK'),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                )
//              ],
//            );
//          }
//      );
    }
  }

  Future<void> _uploadFile(File file, String filename) async {
    setState(() {
      loading = true;
    });
    StorageReference storageReference;
    if (fileType == 'image') {
      storageReference =
          FirebaseStorage.instance.ref().child("images/$filename");
    }
    if (fileType == 'audio') {
      storageReference =
          FirebaseStorage.instance.ref().child("audio/$filename");
    }
    if (fileType == 'video') {
      storageReference =
          FirebaseStorage.instance.ref().child("videos/$filename");
    }
    if (fileType == 'pdf') {
      storageReference = FirebaseStorage.instance.ref().child("pdf/$filename");
    }
    if (fileType == 'others') {
      storageReference =
          FirebaseStorage.instance.ref().child("others/$filename");
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    setState(() {
      loading = false;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff212121).withAlpha(80),
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Please wait uploading....")
                ],
              ),
            )
          : Center(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Image',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.image,
                      color: Colors.green.shade700,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'image';
                      });
                      filePicker(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Audio',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.audiotrack,
                      color: Colors.green.shade700,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'audio';
                      });
                      filePicker(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Video',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.video_label,
                      color: Colors.green.shade700,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'video';
                      });
                      filePicker(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'PDF',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.pages,
                      color: Colors.green.shade700,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'pdf';
                      });
                      filePicker(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Others',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.attach_file,
                      color: Colors.green.shade700,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'others';
                      });
                      filePicker(context);
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  fileName != ""
                      ? Text(
                          "File loaded\n\n" + fileName,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            fileName != ""
                ? InkWell(
                    onTap: () {
                      _uploadFile(file, fileName);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.cloud_upload),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Tap to Upload")
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Text("Choose your file type and select an image."),
                    ),
                  )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Upload File',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
