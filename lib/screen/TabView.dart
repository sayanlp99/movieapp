import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/screen/ActivityFeed.dart';
import 'package:movieapp/screen/Profile.dart';
import 'package:movieapp/screen/Upload.dart';

class TabView extends StatefulWidget {
  TabView();

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          ActivityFeed(),
          Upload(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
            BottomNavigationBarItem(icon: Icon(Icons.upload_file)),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
          ]),
    );
  }
}
