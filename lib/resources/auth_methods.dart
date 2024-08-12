import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/utils/utils.dart';

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
    required BuildContext context,
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

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        // add user to our database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'email': email,
          'uid': cred.user!.uid,
          'username': username,
          'bio': bio,
          // 'profile_pic': file,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        });

        res = 'Success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'The email address is badly formatted.';
        showSnackBar(context, res);
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
        showSnackBar(context, res);
      } else if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
        showSnackBar(context, res);
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
