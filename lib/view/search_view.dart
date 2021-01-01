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
  List _allResults = [];

  List _resultsList = [];

  Future resultsLoaded;
  FirebaseAuth _user = FirebaseAuth.instance;

  TextEditingController searchController = new TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getSearch();
  }

  TextEditingController _searchController = TextEditingController();

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        showResults.add(tripSnapshot);
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getSearch() async {
    final uid = await _user.currentUser.uid;
    var data = await Firestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Posts")
        .where('title', isEqualTo: _searchController.text)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    print("data is");
    print(data.size);
    print(data.docs);
    print("_allresults");
    print(_allResults);
    return "completed";
  }

  @override
  void initState() {
    super.initState();
    print(getSearch());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: ListView.builder(
            itemCount: _resultsList.length,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                child: Card(
                  margin: EdgeInsets.all(12.0),
                  elevation: 4.0,
                  child: Column(
                    children: [
                      Text(
                       _resultsList[index]['title'],
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                         _resultsList[index]['body'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  Widget _buildListItem(BuildContext context) {
    return ListView.builder(
        itemCount: _allResults.length,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            child: Card(
              margin: EdgeInsets.all(12.0),
              elevation: 4.0,
              child: Column(
                children: [
                  Text(
                    _allResults[index]['title'],
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    _allResults[index]['body'],
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
