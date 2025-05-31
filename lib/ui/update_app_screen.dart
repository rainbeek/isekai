import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:isekai/data/definition/source.dart';
import 'package:isekai/l10n/generated/app_localizations.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({super.key});

  static const name = 'UpdateAppScreen';

  static MaterialPageRoute<UpdateAppScreen> route() =>
      MaterialPageRoute<UpdateAppScreen>(
        builder: (_) => const UpdateAppScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _showDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }

  Future<void> _showDialog() async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return PopScope(
          // Android OSのバックボタンでダイアログが閉じないようにする
          canPop: false,
          child: AlertDialog(
            content: Text(S.of(context)!.newVersionIsAvailableDescription),
            actions: [
              TextButton(
                child: Text(S.of(context)!.update),
                onPressed: () async {
                  await InAppReview.instance.openStoreListing(
                    appStoreId: appStoreId,
                  );
                },
              ),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
  }
}
