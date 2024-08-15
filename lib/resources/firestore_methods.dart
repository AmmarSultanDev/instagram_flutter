import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = 'Some error occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());

      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // like post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayRemove([uid])
          },
        );
      } else {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayUnion([uid])
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // post comment
  Future<String> postComment(Comment comment) async {
    String res = 'Some error occured';
    try {
      if (comment.text.isNotEmpty) {
        String commentId = const Uuid().v1();
        Map<String, dynamic> commentData = {
          'postId': comment.postId,
          'commentId': commentId,
          'text': comment.text,
          'uid': comment.uid,
          'username': comment.username,
          'profileImage': comment.profileImage,
          'datePublished': DateTime.now(),
          'likes': comment.likes,
        };
        await _firestore
            .collection('posts')
            .doc(comment.postId)
            .collection('comments')
            .doc(commentId)
            .set(commentData);
        res = 'Success';
      } else {
        res = 'Comment cannot be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // like comment
  Future<void> likeComment(
    String postId,
    String commentId,
    String uid,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update(
          {
            'likes': FieldValue.arrayRemove([uid])
          },
        );
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update(
          {
            'likes': FieldValue.arrayUnion([uid])
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // delete post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // delete comment
  Future<String> deleteComment(String postId, String commentId) async {
    String res = 'Some error occured';

    // check if the user is the owner of the comment

    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      res = 'Success';
    } catch (e) {
      print(e.toString());
      res = e.toString();
    }

    return res;
  }
}
