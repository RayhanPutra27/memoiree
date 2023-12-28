import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'FirestoreSystem.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return 'Login Failed';
      }
    } catch (e) {
      return 'Login Failed';
    }
  }

  Future<String?> signUp2({
    required String email,
    required String password,
    required String name,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => FirestoreSystem.addUser(
          name: name,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          uid: value.user!.uid));
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for the email';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      var signup = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => value.user!.uid);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for the email';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<void> signOut({required BuildContext context}) async {

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AuthService.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
