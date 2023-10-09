import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faker/faker.dart';
import 'dart:math';
import 'package:live_bresto/data/repository/preference_repository.dart';
import 'package:live_bresto/data/model/profile.dart';

String randomEmoji() {
  var rand = Random();
  int emojiValue = 0x1F600 + rand.nextInt(0x50);
  return String.fromCharCode(emojiValue);
}

final randomNameProvider = Provider<String>((ref) {
  var fakerObj = Faker();
  return '${randomEmoji()} ${fakerObj.person.firstName()} ${fakerObj.person.lastName()}';
});

class DebugScreen extends StatelessWidget {
  const DebugScreen({Key? key}): super(key: key);

  static const name = 'DebugScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.debug),
      ),
      body: Center(
        child: Consumer(builder: (context, watch, _) {
          final profileRepo = watch(preferenceRepositoryProvider);
          final name = watch(randomNameProvider);

          return TextButton(
            onPressed: () => profileRepo.updateProfile(Profile(name: name, emoji: randomEmoji())),
            child: Text('Change name to $name'),
          );
        }),
      ),
    );
  }

  static MaterialPageRoute<DebugScreen> route() => MaterialPageRoute(
    builder: (_) => const DebugScreen(),
    settings: const RouteSettings(name: name),
  );
}
