import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String icon,
    required String name,
    required DateTime validUntil,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

extension ProfileGetter on Profile {
  bool isValid({required DateTime current}) {
    return validUntil.isAfter(current);
  }
}
