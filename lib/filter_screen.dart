import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List _allResults = [];

  Future resultsLoaded;
  FirebaseAuth _user = FirebaseAuth.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getFilter();
  }

  getFilter() async {
    final uid = await _user.currentUser.uid;
    var data = await Firestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Posts")
        .orderBy('title')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    print("data is");
    print(data.size);
    print(data.docs);
    print("_allresults");
    print(_allResults);
    return "completed";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text("Filtered todos"),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              itemCount: _allResults.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  child: Card(
                    margin: EdgeInsets.all(12.0),
                    elevation: 4.0,
                    child: Column(
                      children: [
                        Text(_allResults[index]['title'],
                        style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),
                      
                      SizedBox(height: 6,),
                        Text(_allResults[index]['body'],
                        style: TextStyle(fontSize: 18),),
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
