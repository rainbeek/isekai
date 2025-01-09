import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isekai/data/model/message.dart';

part 'message_firestore.freezed.dart';

@freezed
class MessageFirestore with _$MessageFirestore {
  const factory MessageFirestore({
    required String? threadId,
    required String? userName,
    required String? text,
    required DateTime? createdAt,
    required String? profileIcon, // Added profileIcon field
  }) = _MessageFirestore;

  const MessageFirestore._();

  factory MessageFirestore.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    final data = snapshot.data();
    return MessageFirestore(
      threadId: data?['threadId'] as String?,
      userName: data?['userName'] as String?,
      text: data?['text'] as String?,
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
      profileIcon: data?['profileIcon'] as String?, // Handle profileIcon field
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      if (threadId != null) 'threadId': threadId,
      if (userName != null) 'userName': userName,
      if (text != null) 'text': text,
      if (createdAt != null) 'createdAt': createdAt,
      if (profileIcon != null) 'profileIcon': profileIcon, // Handle profileIcon field
    };
  }

  Message? toMessage({required String userId}) {
    if (userName == null || text == null || createdAt == null) {
      return null;
    }

    return Message(
      userName: userName!,
      text: text!,
      createdAt: createdAt!,
      profileIcon: profileIcon, // Handle profileIcon field
    );
  }
}
