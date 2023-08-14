import 'dart:typed_data';
import 'package:bmeducators/resources/storage_Methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../Models/livestreamModel.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();

  Future<String> startLiveStream(
      BuildContext context, String title, String url) async {
    String channelId = '';
    try {
      if (title.isNotEmpty && url != null) {
        if (true) {

          channelId = 'adminChannel';
          LiveStream liveStream = LiveStream(
            title: title,
            image: url,
            uid: "admin",
            username: "Admin",
            viewers: 0,
            channelId: channelId,
            startedAt: DateTime.now(),
          );

          FirebaseFirestore.instance
              .collection('livestream')
              .doc(channelId)
              .set(liveStream.toMap());
        }
      } else {
        print('Please enter all the fields');
      }
    } on FirebaseException catch (e) {
      print( e.message!);
    }
    return channelId;
  }

  Future<void> chat(String text, String id, BuildContext context) async {

    try {
      String commentId = "id";
      await _firestore
          .collection('livestream')
          .doc(id)
          .collection('comments')
          .doc(commentId)
          .set({
        'username': "admin",
        'message': text,
        'uid': "Admin",
        'createdAt': DateTime.now(),
        'commentId': commentId,
      });
    } on FirebaseException catch (e) {
    }
  }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    try {
      await _firestore.collection('livestream').doc(id).update({
        'viewers': FieldValue.increment(isIncrease ? 1 : -1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> endLiveStream(String channelId) async {
    try {
      QuerySnapshot snap = await _firestore
          .collection('livestream')
          .doc(channelId)
          .collection('comments')
          .get();

      for (int i = 0; i < snap.docs.length; i++) {
        await _firestore
            .collection('livestream')
            .doc(channelId)
            .collection('comments')
            .doc(
          ((snap.docs[i].data()! as dynamic)['commentId']),
        )
            .delete();
      }
      await _firestore.collection('livestream').doc(channelId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}