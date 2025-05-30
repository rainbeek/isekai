import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_result_with_do_not_show_again_option.freezed.dart';

@freezed
sealed class ConfirmResultWithDoNotShowAgainOption
    with _$ConfirmResultWithDoNotShowAgainOption {
  const factory ConfirmResultWithDoNotShowAgainOption.doContinue({
    required bool doNotShowAgain,
  }) = ConfirmResultWithDoNotShowAgainOptionContinued;

  const factory ConfirmResultWithDoNotShowAgainOption.cancel() =
      ConfirmResultWithDoNotShowAgainOptionCanceled;
}
