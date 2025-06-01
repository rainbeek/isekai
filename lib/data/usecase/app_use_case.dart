import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/service/app_service.dart';
import 'package:isekai/data/service/remote_config_service.dart';

final FutureProvider<bool> shouldUpdateAppProvider = FutureProvider((
  ref,
) async {
  final minimumBuildNumber = await ref.watch(minimumBuildNumberProvider.future);
  final currentBuildNumber = await ref.watch(buildNumberProvider.future);
  return currentBuildNumber < minimumBuildNumber;
});
