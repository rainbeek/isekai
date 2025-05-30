import 'package:freezed_annotation/freezed_annotation.dart';

part 'thread.freezed.dart';

@freezed
abstract class Thread with _$Thread {
  const factory Thread({required String title}) = _Thread;
}
