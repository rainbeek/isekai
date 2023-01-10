// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/dao/message_firestore.dart';
import 'package:live_bresto/data/dao/thread_firestore.dart';
import 'package:live_bresto/data/model/message.dart';
import 'package:live_bresto/data/model/thread.dart';

final threadProvider = StreamProvider.family<Thread, String>((_, threadId) {
  return FirebaseFirestore.instance
      .collection('threads')
      .doc(threadId)
      .withConverter(
        fromFirestore: ThreadFirestore.fromFirestore,
        toFirestore: (postMessage, options) => postMessage.toFirestore(),
      )
      .snapshots()
      .map((snapshot) {
    final threadFirestore = snapshot.data()!;
    return threadFirestore.toMessage();
  });
});

final threadMessagesProvider =
    StreamProvider.family<List<Message>, String>((_, threadId) {
  return FirebaseFirestore.instance
      .collectionGroup('messages')
      .where('threadId', isEqualTo: threadId)
      .orderBy('createdAt', descending: true)
      .withConverter(
        fromFirestore: MessageFirestore.fromFirestore,
        toFirestore: (postMessage, options) => postMessage.toFirestore(),
      )
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) {
              final messagesCollectionRef = doc.reference.parent;
              final userDocumentRef = messagesCollectionRef.parent;
              final userId = userDocumentRef?.id;
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
  Future<void> sendMessage({
    required String threadId,
    required String text,
    required String userId,
    required DateTime createdAt,
  }) async {
    final messageFirestore = MessageFirestore(
      threadId: threadId,
      text: text,
      createdAt: createdAt,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('messages')
        .withConverter(
          fromFirestore: MessageFirestore.fromFirestore,
          toFirestore: (postMessage, _) => postMessage.toFirestore(),
        )
        .add(messageFirestore);
  }
}
