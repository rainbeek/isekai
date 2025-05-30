import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String userName,
    required String userIcon,
    required String text,
    required DateTime createdAt,
  }) = _Message;
}
