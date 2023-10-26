// ignore_for_file: prefer-match-file-name

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/definition/app_mode.dart';
import 'package:isekai/data/service/database_service.dart';

final currentThreadProvider = StreamProvider((ref) {
  return ref.watch(threadProvider(threadIdForDebug).stream);
});
