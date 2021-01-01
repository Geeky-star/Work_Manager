import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:internship_tak/home_page.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var _firebaseRef = FirebaseDatabase().reference().child('Posts');

  final fb = FirebaseDatabase.instance;

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  User _user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> formkey = new GlobalKey();

  TextEditingController _title = TextEditingController();

  TextEditingController _body = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text("Add todo"),
        centerTitle: true,
        
        elevation: 0.0,
      ),
      body: Form(
          key: formkey,
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
                      _addToCart();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    color: Colors.purple,
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Future _addToCart() {
    return _usersRef.doc(_user.uid).collection("Posts").doc(_title.text).set({
      "title": _title.text,
      "body": _body.text,
    
    });
  }

  /* Future _addToCart() {
    return _firebaseRef
        .child("Users")
        .child(_title.toString())
        .set({"title": _title.text, "body": _body.text});
  }*/
}
