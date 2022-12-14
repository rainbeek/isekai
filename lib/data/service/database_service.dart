// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/model/post_message.dart';

final databaseActionsProvider = Provider(
  (ref) => DatabaseActions(),
);

class DatabaseActions {
  Future<void> setMessage(
    PostMessage message, {
    required String userId,
  }) async {
    // cspell:disable next
    const testThreadId = 'sELkOLGe1qHrasoPQpg0';
    final messageDictionary = <String, String>{
      'text': message.text,
    };

    final result = await FirebaseFirestore.instance
        .collection('threadContents')
        .doc(testThreadId)
        .collection(userId)
        .doc('messages')
        .collection('a')
        .add(messageDictionary);

    debugPrint('$result');
  }
}
