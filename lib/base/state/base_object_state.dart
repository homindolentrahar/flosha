import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/state/base_state.dart';

class BaseObjectState<T> extends BaseState {
  final T? data;

  const BaseObjectState({
    BaseStatus status = BaseStatus.initial,
    String? errorTitle = "",
    String? errorMessage = "",
    this.data,
  }) : super(
          status: status,
          errorTitle: errorTitle ?? "",
          errorMessage: errorMessage ?? "",
        );

  BaseObjectState<T> copyWith({
    BaseStatus? status,
    String? errorTitle,
    String? errorMessage,
    T? data,
  }) =>
      BaseObjectState(
        status: status ?? this.status,
        errorTitle: errorTitle ?? this.errorTitle,
        errorMessage: errorMessage ?? this.errorMessage,
        data: data ?? this.data,
      );
}
