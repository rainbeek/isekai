import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/model/profile.dart';

final profileProvider = Provider<Profile>((ref) {
  return Profile(icon: '👨🏻‍💼', name: '山田 ヒゲ太郎');
});
