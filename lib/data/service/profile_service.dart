import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/model/profile.dart';

final profileServiceProvider = Provider<Profile>((ref) {
  return Profile(icon: '👤', name: 'UserName');
});
