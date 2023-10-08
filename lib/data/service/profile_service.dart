import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/profile.dart';

final profileServiceProvider = Provider<Profile>((ref) {
  return Profile(icon: '👤', name: 'UserName');
});