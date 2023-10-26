import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final buildNumberProvider = FutureProvider((_) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final buildNumberString = packageInfo.buildNumber;
  return int.parse(buildNumberString);
});
