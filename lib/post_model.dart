import 'package:flutter/material.dart';

class Post {
  final String title;
  final String imageUrl;
  final String body;

  Post({
    @required this.body,
    @required this.title,
    this.imageUrl,
  });

  static Post fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Post(
      title: map['title'],
      imageUrl: map['imageUrl'],
      body: map['body'],
    );
  }
}
