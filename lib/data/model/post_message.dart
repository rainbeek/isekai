import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_message.freezed.dart';

@freezed
class PostMessage with _$PostMessage {
  const factory PostMessage({
    required String? text,
  }) = _PostMessage;

  const PostMessage._();

  factory PostMessage.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    final data = snapshot.data();
    return PostMessage(
      text: data?['text'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      if (text != null) 'text': text,
    };
  }
}
