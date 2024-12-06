import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/model/profile.dart';
import 'package:isekai/data/repository/preference_repository.dart';
import 'package:isekai/data/usecase/message_use_case.dart';
import 'package:isekai/data/usecase/preference_use_case.dart';
import 'package:isekai/ui/model/confirm_result_with_do_not_show_again_option.dart';

class ThreadPresenter {
  ThreadPresenter({
    required MessageActions messageActions,
    required PreferenceActions preferenceActions,
    required Ref ref,
  })  : _messageActions = messageActions,
        _preferenceActions = preferenceActions,
        _ref = ref;

  final MessageActions _messageActions;
  final PreferenceActions _preferenceActions;
  final Ref _ref;

  late Future<ConfirmResultWithDoNotShowAgainOption?> Function({
    required Profile profile,
  }) showConfirmDialog;
}
