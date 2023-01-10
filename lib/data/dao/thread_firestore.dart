import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:live_bresto/data/model/thread.dart';

part 'thread_firestore.freezed.dart';

@freezed
class ThreadFirestore with _$ThreadFirestore {
  const factory ThreadFirestore({
    required String? threadId,
    required String? title,
  }) = _ThreadFirestore;

  const ThreadFirestore._();

  factory ThreadFirestore.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    final data = snapshot.data();
    return ThreadFirestore(
      threadId: data?['threadId'] as String?,
      title: data?['title'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      if (threadId != null) 'threadId': threadId,
      if (title != null) 'title': title,
    };
  }

  Thread toMessage() {
    return Thread(
      title: title!,
    );
  }
}
