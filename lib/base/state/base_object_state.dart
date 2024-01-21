import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/state/base_state.dart';

/// Base state that holds necessary data for various state's status\
/// Holds a single data with type Object of [T]
class BaseObjectState<T> extends BaseState<T> {
  /// Base state that holds necessary data for various state's status
  /// Holds a single data with type Object of [T]
  /// [status] is a [BaseStatus] enum to indicate state's status
  /// [errorTitle] is a title that will shown when state is error
  /// [errorMesage] is a message that will shown when state is error
  /// [data] is a data of the state with type [T]
  const BaseObjectState({
    BaseStatus status = BaseStatus.initial,
    String? errorTitle = "",
    String? errorMessage = "",
    T? data,
  }) : super(
          status: status,
          errorTitle: errorTitle ?? "",
          errorMessage: errorMessage ?? "",
          data: data,
        );

  /// Function to alter or update the existing state instance with new values
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
