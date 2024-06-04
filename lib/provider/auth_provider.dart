import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  //  firebaseAuth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // fireStore instace
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // firebaseStorage instance
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  // Login function
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _fireStore.collection('users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
        SetOptions(merge: true),
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Logout Function
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Upload profile image
  Future<String> uploadUserImage(
      UserCredential userCredential, Uint8List imageSource) async {
    UploadTask uploadTask = _fireStorage
        .ref()
        .child('UsersProfilePicture/${userCredential.user!.uid}/image.jpg')
        .putData(imageSource);
    try {
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Create account Function
  Future<UserCredential> createUserWithEmailandPassword(
      String email, String password, String name,
      {Uint8List? imageSource}) async {
    String? downloadUrl;
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (imageSource != null) {
        downloadUrl = await uploadUserImage(userCredential, imageSource);
      }

      if (downloadUrl != null) {
        _fireStore.collection('users').doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': email,
            'name': name,
            'image': downloadUrl,
            'createOn': DateTime.now(),
          },
        );
      } else {
        _fireStore.collection('users').doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': email,
            'name': name,
            'createOn': DateTime.now(),
          },
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Change password Function
  Future<void> changePassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
