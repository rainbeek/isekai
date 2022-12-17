import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:live_bresto/data/model/message.dart';

part 'message_firestore.freezed.dart';

@freezed
class MessageFirestore with _$MessageFirestore {
  const factory MessageFirestore({
    required String? threadId,
    required String? text,
    required DateTime? createdAt,
  }) = _MessageFirestore;

  const MessageFirestore._();

  factory MessageFirestore.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    final data = snapshot.data();
    return MessageFirestore(
      threadId: data?['threadId'] as String?,
      text: data?['text'] as String?,
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      if (threadId != null) 'threadId': threadId,
      if (text != null) 'text': text,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  Message? toMessage({required String userId}) {
    if (text == null || createdAt == null) {
      return null;
    }

    return Message(
      userId: userId,
      text: text!,
      createdAt: createdAt!,
    );
  }
}
