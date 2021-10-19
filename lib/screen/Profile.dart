import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';

import 'LoginAndTabView.dart';

class Profile extends StatefulWidget {
  Profile();

  @override
  _ProfileState createState() => _ProfileState();
}

ElevatedButton logout(context) {
  return ElevatedButton(
    onPressed: () async {
      if (await confirm(context,
          title: Text("Logout"), content: Text('Sure to logout?'))) {
        googleSignIn.signOut();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TabView()));
      }
    },
    child: Text("Logout"),
  );
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(googleSignIn.currentUser!.photoUrl.toString()),
              ),
              SizedBox(width: 10),
              Text(
                googleSignIn.currentUser!.displayName.toString(),
              ),
              Spacer(),
              logout(context)
            ],
          )
        ],
      ),
    )));
  }
}
