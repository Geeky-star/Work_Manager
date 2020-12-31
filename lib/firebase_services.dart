import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseServices extends ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FirebaseAuth _user = FirebaseAuth.instance;

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("Chairs");

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("Users");

  rejectJob(String jobId) {
    notifyListeners();
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(_user.currentUser.uid)
        .collection("Cart")
        .doc(jobId)
        .delete();
  }

  Future<List> getWishlistedItems() async {
      await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('Wishlist')
        .snapshots();
  }
}
