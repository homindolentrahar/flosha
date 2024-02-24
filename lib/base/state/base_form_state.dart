import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/state/base_state.dart';

/// Base state that holds necessary data for various state's status\
/// Holds a single data with type Object of [T]
class BaseFormState<T> extends BaseState<T> {
  /// [errors] is a set key-value pair of errors in Form's state
  final Map<String, String>? errors;

  /// [formData] is a Form's data or value
  final Map<String, dynamic>? formData;

  /// Base state that holds necessary data for various state's status
  /// Holds a single data with type Object of [T]
  /// [status] is a [BaseStatus] enum to indicate state's status
  /// [errorTitle] is a title that will shown when state is error
  /// [errorMesage] is a message that will shown when state is error
  /// [data] is a data of the state with type [T]
  const BaseFormState({
    BaseStatus status = BaseStatus.initial,
    String? errorTitle = "",
    String? errorMessage = "",
    this.errors = const {},
    this.formData = const {},
    dynamic data,
  }) : super(
          status: status,
          errorTitle: errorTitle ?? "",
          errorMessage: errorMessage ?? "",
          data: data,
        );

  /// Function to alter or update the existing state instance with new values
  BaseFormState<T> copyWith({
    BaseStatus? status,
    String? errorTitle,
    String? errorMessage,
    dynamic data,
    Map<String, String>? errors,
    Map<String, dynamic>? formData,
  }) =>
      BaseFormState(
        status: status ?? this.status,
        errorTitle: errorTitle ?? this.errorTitle,
        errorMessage: errorMessage ?? this.errorMessage,
        data: data ?? this.data,
        errors: errors ?? this.errors,
        formData: formData ?? this.formData,
      );
}
