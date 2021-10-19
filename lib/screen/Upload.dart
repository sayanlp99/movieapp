import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/screen/LoginAndTabView.dart';
import 'package:path/path.dart';

final movieRef = FirebaseFirestore.instance.collection('movie');

class Upload extends StatefulWidget {
  Upload();

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  UploadTask? task;
  File? file;
  late String picUrl;
  bool submitting = false;
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
          child: Column(
        children: [
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: "Movie Name", border: OutlineInputBorder()),
              )),
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: _directorController,
                decoration: InputDecoration(
                    labelText: "Director Name", border: OutlineInputBorder()),
              )),
          Container(
              margin: EdgeInsets.all(20),
              child: Row(children: [
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      selectFile();
                    },
                    child: Row(children: [
                      Icon(Icons.collections),
                      Text("Add image")
                    ])),
                Spacer()
              ])),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  submitting = true;
                });
                picUrl = await uploadFile();
                submitData(_nameController.text, _directorController.text,
                    picUrl, googleSignIn.currentUser!.email.toString());
              },
              child: Text("Add")),
          SizedBox(height: 20),
          Container(child: error == true ? Text("Enter all data") : Text("")),
          SizedBox(height: 20),
          Container(
              child:
                  submitting == true ? CircularProgressIndicator() : Text("")),
        ],
      )),
    ));
  }

  void submitData(String text, String text2, String pic, String user) async {
    if (text.isEmpty ||
        text2.isEmpty ||
        pic.isEmpty ||
        text == "" ||
        text2 == "" ||
        pic == "" ||
        pic == "Empty") {
      setState(() {
        error = true;
        submitting = false;
      });
    } else {
      movieRef
          .add({"name": text, "director": text2, "picUrl": pic, "user": user});
      Navigator.of(this.context)
          .push(MaterialPageRoute(builder: (context) => TabView()));
      setState(() {
        submitting = false;
      });
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future<String> uploadFile() async {
    if (file == null) return "Empty";

    final fileName = basename(file!.path);
    final destination = 'movie_poster/$fileName';

    task = uploadImg(destination, file!);
    setState(() {});

    if (task == null) return "Empty";

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');
    return urlDownload;
  }

  uploadImg(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
