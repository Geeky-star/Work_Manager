import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  final List results;

  const SearchView({this.results});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Results",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: widget.results == []
          ? Text(
              "No data matches",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: widget.results.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(12.0),
                  elevation: 4.0,
                  child: Column(
                    children: [
                      Text(
                        widget.results[index]['title'],
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.results[index]['body'],
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}
