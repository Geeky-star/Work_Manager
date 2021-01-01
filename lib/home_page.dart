import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internship_tak/authentication/login.dart';
import 'package:internship_tak/screens/add_post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:internship_tak/screens/profile_screen.dart';
import 'package:internship_tak/view/search_view.dart';
import 'package:internship_tak/filter_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  DatabaseReference _userRef =
      new FirebaseDatabase().reference().child("Users");

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

  rejectJob(String jobId) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(_user.currentUser.uid)
        .collection("Posts")
        .doc(jobId)
        .delete();
  }

  Future updatePost(jobId, String title, String body) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_user.currentUser.uid)
          .collection("Posts")
          .doc(jobId)
          .update({"title": title, "body": body});
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FilterScreen()));
                },
                child: Icon(Icons.filter)),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.purpleAccent,
        title: Text("Your todos"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 100,
              color: Colors.purple[100],
              child: Center(
                  child: Text(
                "Your drawer",
                style: TextStyle(
                    color: Colors.purple[900],
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
              )),
            ),
            ListTile(
              title: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: Text(
                  "Account",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
              leading: Icon(Icons.account_circle),
            ),
            ListTile(
              title: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  "LogOut",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
              leading: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        tooltip: "Add todo",
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: searchController,
                      onChanged: (String query) {
                        getSearch();
                      },
                      decoration: InputDecoration(
                          hintText: "search", border: InputBorder.none),
                    )),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchView(results: _resultsList,)));
                        },
                        child: Container(child: Icon(Icons.search)))
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection('Posts')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Nothing to Show");
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) => _buildListItem(
                              context, snapshot.data.documents[index]),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    );
                  }
                  return Text("Cart is Empty");
                },
              ),
            ],
          ),
        ),
      ),
    );
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
                            onPressed: () {
                              rejectJob(document.id);
                            },
                            icon: Icon(Icons.delete, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () {
                              (document.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostDetails(
                                            documentId: document.id,
                                            title: document['title'],
                                            body: document['body'],
                                          )));
                            },
                            icon: Icon(Icons.edit, color: Colors.black),
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

class PostDetails extends StatefulWidget {
  final String documentId;
  final String title;
  final String body;

  const PostDetails(
      {@required this.documentId, @required this.title, @required this.body});

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  DatabaseReference _userRef =
      new FirebaseDatabase().reference().child("Users");

  FirebaseAuth _user = FirebaseAuth.instance;

  Future updatePost(String jobId, String title, String body) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_user.currentUser.uid)
          .collection("Posts")
          .doc(jobId)
          .update({"title": title, "body": body});
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  TextEditingController _title = TextEditingController();

  TextEditingController _body = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _title,
              decoration: InputDecoration(
                  labelText: "Post tilte", border: OutlineInputBorder()),
              validator: (val) {
                if (val.isEmpty) {
                  return "title field cant be empty";
                } else if (val.length > 16) {
                  return "title cannot have more than 16 characters ";
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _body,
              decoration: InputDecoration(
                  labelText: "Post body", border: OutlineInputBorder()),
              validator: (val) {
                if (val.isEmpty) {
                  return "body field cant be empty";
                }
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 200,
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  updatePost(widget.documentId, _title.text, _body.text);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                color: Colors.purple,
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
