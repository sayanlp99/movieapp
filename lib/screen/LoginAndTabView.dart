import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movieapp/screen/ActivityFeed.dart';
import 'package:movieapp/screen/Profile.dart';
import 'package:movieapp/screen/Upload.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final GoogleSignIn googleSignIn = GoogleSignIn();

class TabView extends StatefulWidget {
  TabView();

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  bool isAuth = false;
  late PageController pageController;
  int pageIndex = 0;
  bool loading = true;

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
    setState(() {
      loading = false;
    });
    print(account.email);
    print("isAuth: " + isAuth.toString());
    print("loading: " + loading.toString());
  }

  login() {
    googleSignIn.signIn();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account!);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    googleSignIn.signInSilently(suppressErrors: true).then((account) {
      handleSignIn(account!);
    }).catchError((err) {
      print('Error signing in: $err');
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold signedOutUser() {
    if (!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 60),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Sign in");
                      login();
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
                  ),
                )
              ],
            )));
  }

  Scaffold signedInUser() {
    if (!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }
    return Scaffold(
      body: PageView(
        children: <Widget>[ActivityFeed(), Upload(), Profile()],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: "Explore"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.upload,
                  size: 35.0,
                ),
                label: "Upload"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
    );
  }

  Container loadingUserScreen() {
    if (!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }
    return Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10.0),
        child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    if (isAuth == true) {
      return signedInUser();
    } else {
      return signedOutUser();
    }
  }
}
