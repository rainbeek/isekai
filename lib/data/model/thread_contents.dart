import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:live_bresto/data/model/post_message.dart';

part 'thread_contents.freezed.dart';

@freezed
class ThreadContents with _$ThreadContents {
  const factory ThreadContents({
    required List<PostMessage> messages,
  }) = _ThreadContents;
}
