// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/dto/message_firestore.dart';
import 'package:live_bresto/data/model/message.dart';

final threadMessagesProvider =
    StreamProvider.family<List<Message>, String>((_, threadId) {
  return FirebaseFirestore.instance
      .collectionGroup('messages')
      .where('threadId', isEqualTo: threadId)
      .withConverter(
        fromFirestore: MessageFirestore.fromFirestore,
        toFirestore: (postMessage, options) => postMessage.toFirestore(),
      )
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) {
              final userId = doc.reference.parent.parent?.id;
              if (userId == null) {
                return null;
              }

              final messageFirestore = doc.data();
              return messageFirestore.toMessage(userId: userId);
            })
            .whereNotNull()
            .toList(),
      );
});

final databaseActionsProvider = Provider(
  (ref) => DatabaseActions(),
);

class DatabaseActions {
  Future<void> setMessage({
    required String threadId,
    required String text,
    required String userId,
  }) async {
    final messageFirestore = MessageFirestore(threadId: threadId, text: text);

    final result = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('messages')
        .withConverter(
          fromFirestore: MessageFirestore.fromFirestore,
          toFirestore: (postMessage, _) => postMessage.toFirestore(),
        )
        .add(messageFirestore);

    debugPrint('$result');
  }
}
