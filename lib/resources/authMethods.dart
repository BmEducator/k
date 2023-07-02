
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // get user details

  Future<String> signUpUser({
    required String email,
    required String password,

  }) async {
    String res = "Some error Occurred";
    try {
      // registering user in auth with email and password
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (err) {
      return err.toString();
    }
    return res;
  }

// logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
        String t = "";
        await FirebaseMessaging.instance.getToken().then(
                (toke) {
              t = toke!;
            }
        );
        print("-----------");
        print(t);

        await FirebaseFirestore.instance.collection("admin").doc(
            "data").collection("students").doc(
            "allStudents").collection("allStudents")
            .doc(email).update({
          "token":t
        });
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      print(err);
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

// Future<String> signUpUseWithPhone({
//   required String phone,
//   required String username,
//   required String imageUrl,
//
//
// }) async {
//   String res = "";
//   String id = FirebaseAuth.instance.currentUser!.uid;
//   try {
//     if (phone.isNotEmpty || username.isNotEmpty)
//     {
//       String t = "";
//       await FirebaseMessaging.instance.getToken().then(
//               (toke) {
//             t = toke!;
//           }
//       );
//       model.User user = model.User(
//         username: username,
//         uid: id,
//         email: phone,
//         photoUrl: imageUrl,
//         location: "",
//         token: t,
//       );
//
//       // adding user in our database
//       await _firestore
//           .collection("users")
//           .doc(id)
//           .set(user.toJson());
//
//       return "success";
//     }
//
//   } catch (err) {
//     return err.toString();
//   }
//   return res;
// }
}
