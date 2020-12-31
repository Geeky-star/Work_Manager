import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  final String search;

  SearchView({@required this.search});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List lists = new List();
  FirebaseAuth _user = FirebaseAuth.instance;

  TextEditingController searchController = new TextEditingController();

  getSearchWallpaper(String searchQuery) async {
    setState(() {});
  }

  List<String> listData = [];
/*
Stream<QuerySnapshot> listRef = Firestore.instance
    .collection("Users")
    .document(_user.currentUser.uid)
    .collection("Posts")
    .snapshots();
listRef.forEach((field) {
  field.documents.asMap().forEach((index, data) {
    listData.add(field.documents[index]["title"]);
  });
});
*/
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");
  final dbRef = FirebaseDatabase.instance
      .reference()
      .child("Users")
      .orderByChild('title');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xfff5f8fd),
              borderRadius: BorderRadius.circular(30),
            ),
            margin: EdgeInsets.symmetric(horizontal: 24),
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      hintText: "search todos", border: InputBorder.none),
                ))
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ListView.builder(
            itemCount: listData.length,
            itemBuilder: (context, data) {
              return Text(data.toString());
            },
          )
        ]))));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              child: ListTile(
                title: Container(
                  height: 150,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            document["title"],
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w700),
                          )),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        document['body'],
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]);
  }
}
