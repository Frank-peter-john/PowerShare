// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:powershare/screens/welcome.dart';
import '../../utils/show_snack_bar.dart';
import '../../utils/storage_methods.dart';
import 'confirm/confirm_email/confirm_email.dart';
import 'confirm/confirm_email/finish_to_confirm_email.dart';
import 'forgot_password/finish_forgot_password.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  FirebaseAuthMethods();

  // SIGN UP WITH EMAIL
  Future<String> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required Uint8List file,
    required BuildContext context,
  }) async {
    String response = '';
    try {
      // REGISTER USER
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ADDING PROFILE PIC TO FIREBASE
      String name = '$firstName $lastName';
      String imageUrl =
          await StorageMethods().uploadImage('users/profilePics/$name', file);

      // ADD USER TO DATABSE
      await _fireStore.collection('users').doc(userCredential.user!.uid).set(
        {
          'name': name,
          'email': email,
          'imageUrl': imageUrl,
          'role': 'none',
          'totalWatts': 0.0,
          'phoneNumber': phoneNumber,
        },
      );

      response = 'success';

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) {
            return const ConfirmEmail();
          },
        ),
      );
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'auth/email-already-in-use':
          response =
              "Email already is in use by another account, please try another email";
          break;
        case "invalid-email":
          response = "Invalid email address";
          break;

        default:
          response = error.message!;
      }
    }
    return response;
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification({
    required BuildContext context,
  }) async {
    try {
      await _auth.currentUser!.sendEmailVerification();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) {
            return const FinishToComfirmEmail();
          },
        ),
      );
    } on FirebaseAuthException catch (err) {
      String errorMessage;

      switch (err.code) {
        case "user-disabled":
          errorMessage = "User account disabled";
          break;

        case "too-many-attempts":
          errorMessage = "Too many attempts. Please try again later";
          break;
        case "operation-not-allowed":
          errorMessage =
              "Email/password accounts are not enabled. Please contact support";
          break;
        default:
          errorMessage = err.message!;
      }

      showSnackBar(context, errorMessage);
    }
  }

  // LOGIN WITH EMAIL
  Future<String> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String response;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      response = 'success';

      // After successful login
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => const WelcomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/user-not-found') {
        response = 'There is no user record corresponding to this identifier.';
      } else if (e.code == 'auth/wrong-password') {
        response = 'The password is invalid.';
      } else if (e.code == 'auth/invalid-email') {
        response = 'The email address is invalid.';
      } else {
        response = e.message!;
      }
    }
    return response;
  }

  // FOGOT PASSWORD
  Future<void> forgotPassword({
    required email,
    required BuildContext context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return FinishForgotPassword(email: email);
      }));
    } on FirebaseAuthException catch (err) {
      String errorMessage;
      switch (err.code) {
        case "user-disabled":
          errorMessage = "User account disabled";
          break;
        case "unknown":
          errorMessage = "Too many attempts. Please try again later";
          break;
        case "operation-not-allowed":
          errorMessage =
              "Email/password accounts are not enabled. Please contact support";
          break;
        default:
          errorMessage = err.message!;
      }

      showSnackBar(context, errorMessage);
    }
  }
}
