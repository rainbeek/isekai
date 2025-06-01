import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/model/profile.dart';
import 'package:isekai/data/repository/preference_repository.dart';
import 'package:isekai/l10n/generated/app_localizations.dart';
import 'package:isekai/ui/model/confirm_result_with_do_not_show_again_option.dart';
import 'package:isekai/ui/post_message_presenter.dart';

class PostMessageScreen extends ConsumerStatefulWidget {
  const PostMessageScreen({super.key});

  static const name = 'PostMessageScreen';

  static MaterialPageRoute<PostMessageScreen> route() => MaterialPageRoute(
    builder: (_) => const PostMessageScreen(),
    settings: const RouteSettings(name: name),
    fullscreenDialog: true,
  );

  @override
  ConsumerState<PostMessageScreen> createState() => _PostMessageScreenState();
}

class _PostMessageScreenState extends ConsumerState<PostMessageScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref
        .read(postMessagePresenterProvider)
        .registerListeners(
          showConfirmDialog: _showProfileUpdateDialog,
          close: () => Navigator.pop(context),
        );

    _controller.addListener(() {
      ref.read(postMessagePresenterProvider).onChangeMessage(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.postComment)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(alignment: Alignment.centerRight, child: _ProfilePanel()),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              autofocus: true,
              maxLines: 8,
              minLines: 8,
              maxLength: PostMessagePresenter.maxMessageLength,
              decoration: InputDecoration(
                hintText: S.of(context)!.writeComment,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _PostMessageButton(controller: _controller),
          ],
        ),
      ),
    );
  }

  Future<ConfirmResultWithDoNotShowAgainOption?> _showProfileUpdateDialog({
    required Profile profile,
  }) {
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
                spacing: 16,
                children: [
                  Text(S.of(context)!.profileUpdateDialogContent),
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

class _PostMessageButton extends ConsumerWidget {
  const _PostMessageButton({required TextEditingController controller})
    : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(canPostMessageOnPostMessageScreenProvider);
    final presenter = ref.watch(postMessagePresenterProvider);

    final onPressed = enabled
        ? () {
            final text = _controller.text;
            presenter.sendMessage(text: text);
          }
        : null;

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(S.of(context)!.post),
    );
  }
}

class _ProfilePanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    if (profile == null) {
      return const CircularProgressIndicator();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(profile.icon, style: Theme.of(context).textTheme.bodySmall),
        Text(profile.name, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
