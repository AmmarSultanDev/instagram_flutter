import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty /*|| file.isNotEmpty*/) {
        // register the user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // add user to our database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'email': email,
          'uid': cred.user!.uid,
          'username': username,
          'bio': bio,
          // 'profile_pic': file,
          'followers': [],
          'following': [],
        });

        res = 'Success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
