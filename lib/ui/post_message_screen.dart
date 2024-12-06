import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/ui/thread_presenter.dart';
import 'package:isekai/ui/model/confirm_result_with_do_not_show_again_option.dart';
import 'package:isekai/data/model/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _postMessagePresenterProvider = Provider(
  (ref) => PostMessagePresenter(
    messageActions: ref.watch(messageActionsProvider),
    ref: ref,
  ),
);

class PostMessageScreen extends ConsumerStatefulWidget {
  const PostMessageScreen({super.key});

  @override
  ConsumerState<PostMessageScreen> createState() => _PostMessageScreenState();
}

class _PostMessageScreenState extends ConsumerState<PostMessageScreen> {
  String _message = '';

  @override
  void initState() {
    super.initState();

    ref.read(_threadPresenterProvider).showConfirmDialog =
        _showProfileUpdateDialog;
  }

  @override
  Widget build(BuildContext context) {
    final presenter = ref.watch(_postMessagePresenterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Message'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              presenter.sendMessage(text: _message);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              maxLines: 12,
              minLines: 12,
              decoration: const InputDecoration(
                hintText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  _message = text;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Future<ConfirmResultWithDoNotShowAgainOption?> _showProfileUpdateDialog({
    required Profile profile,
  }) async {
    return showDialog<ConfirmResultWithDoNotShowAgainOption>(
      context: context,
      builder: (context) {
        var doNotShowAgain = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              icon: Text(
                profile.icon,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              title: Text(
                S.of(context)!.profileUpdateDialogTitle(profile.name),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.of(context)!.profileUpdateDialogContent),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    value: doNotShowAgain,
                    onChanged: (value) {
                      setState(() {
                        doNotShowAgain = value!;
                      });
                    },
                    title: Text(S.of(context)!.doNotShowAgain),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(
                    context,
                    ConfirmResultWithDoNotShowAgainOption.doContinue(
                      doNotShowAgain: doNotShowAgain,
                    ),
                  ),
                  child: Text(S.of(context)!.post),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(
                    context,
                    const ConfirmResultWithDoNotShowAgainOption.cancel(),
                  ),
                  child: Text(S.of(context)!.cancel),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
