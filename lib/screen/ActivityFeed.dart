import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constants/app_color.dart';
import 'package:movieapp/screen/LoginAndTabView.dart';

class ActivityFeed extends StatefulWidget {
  ActivityFeed();

  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("movie")
                  .where('user',
                      isEqualTo: googleSignIn.currentUser!.email.toString())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Something went wrong"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  return CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate(
                                snapshot.data!.docs.map((DocumentSnapshot ds) {
                          Map<String, dynamic> data =
                              ds.data() as Map<String, dynamic>;
                          return movieCard(
                              data['name'], data['director'], data['picUrl']);
                        }).toList()))
                      ]);
                }
                return Container();
              }),
        ),
      ),
    );
  }

  Container movieCard(String name, String director, String picurl) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Container(
            width: 300,
            height: 170,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: primBlue),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(children: [
                Row(
                  children: [
                    Container(
                      height: 130,
                      width: 80,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage(picurl)),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Text(
                              name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )),
                        Container(
                            margin: EdgeInsets.only(left: 12, top: 5),
                            child: Text(
                              director,
                            ))
                      ],
                    )
                  ],
                ),
              ]),
            )));
  }
}
