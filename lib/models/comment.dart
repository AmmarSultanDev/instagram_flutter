import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String commentId;
  final String text;
  final String uid;
  final String username;
  final String profileImage;
  DateTime datePublished;
  final List<dynamic> likes;
  final String postId; // Added property

  Comment({
    required this.commentId,
    required this.text,
    required this.uid,
    required this.username,
    required this.profileImage,
    required this.datePublished,
    required this.likes,
    required this.postId, // Added parameter
  });

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      commentId: snapshot['commentId'],
      text: snapshot['text'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      profileImage: snapshot['profileImage'],
      datePublished: snapshot['datePublished'].toDate(),
      likes: snapshot['likes'],
      postId: snapshot['postId'], // Added property
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'text': text,
      'uid': uid,
      'username': username,
      'profileImage': profileImage,
      'datePublished': datePublished,
      'likes': likes,
      'postId': postId, // Added property
    };
  }
}
