import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/screen/LoginAndTabView.dart';

final movieRef = FirebaseFirestore.instance.collection('movie');

class Upload extends StatefulWidget {
  Upload();

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _picUrlController = TextEditingController();

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
              child: TextField(
                controller: _picUrlController,
                decoration: InputDecoration(
                    labelText: "Pic url", border: OutlineInputBorder()),
              )),
          ElevatedButton(
              onPressed: () {
                submitData(
                    _nameController.text,
                    _directorController.text,
                    _picUrlController.text,
                    googleSignIn.currentUser!.email.toString());
              },
              child: Text("Add"))
        ],
      )),
    ));
  }

  void submitData(String text, String text2, String text3, String user) async {
    movieRef
        .add({"name": text, "director": text2, "picUrl": text3, "user": user});
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => TabView()));
  }
}
