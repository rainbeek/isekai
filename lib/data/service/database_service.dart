import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/dao/message_firestore.dart';
import 'package:isekai/data/dao/thread_firestore.dart';
import 'package:isekai/data/definition/app_mode.dart';
import 'package:isekai/data/model/message.dart';
import 'package:isekai/data/model/thread.dart';

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
    final threadFirestore = snapshot.data();
    if (threadFirestore == null) {
      return threadForDebug;
    }

    return threadFirestore.toThread();
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
            .nonNulls
            .toList(),
      );
});

final databaseActionsProvider = Provider(
  (ref) => DatabaseActions(),
);

class DatabaseActions {
  Future<void> sendMessage({
    required String userId,
    required String threadId,
    required String userName,
    required String userIcon,
    required String text,
    required DateTime createdAt,
  }) async {
    final messageFirestore = MessageFirestore(
      threadId: threadId,
      userName: userName,
      userIcon: userIcon,
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
