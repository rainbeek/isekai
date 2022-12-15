// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/model/post_message.dart';

final threadMessagesProvider =
    StreamProvider.family<List<PostMessage>, String>((_, threadId) {
  return FirebaseFirestore.instance
      .collectionGroup('messages')
      .withConverter(
        fromFirestore: PostMessage.fromFirestore,
        toFirestore: (postMessage, options) => postMessage.toFirestore(),
      )
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
      );
});

final databaseActionsProvider = Provider(
  (ref) => DatabaseActions(),
);

class DatabaseActions {
  Future<void> setMessage(
    PostMessage message, {
    required String userId,
  }) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('messages')
        .withConverter(
          fromFirestore: PostMessage.fromFirestore,
          toFirestore: (postMessage, _) => postMessage.toFirestore(),
        )
        .add(message);

    debugPrint('$result');
  }
}
