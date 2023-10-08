import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String icon,
    required String name,
  }) = _Profile;
}
