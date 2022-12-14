import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_message.freezed.dart';

@freezed
class PostMessage with _$PostMessage {
  const factory PostMessage({
    required String text,
  }) = _PostMessage;
}
