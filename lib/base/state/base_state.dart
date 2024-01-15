import 'package:equatable/equatable.dart';
import 'package:flosha/base/base_status.dart';

abstract class BaseState<T> extends Equatable {
  final BaseStatus status;
  final String errorTitle;
  final String errorMessage;
  final T? data;
  final List<T>? list;

  const BaseState({
    required this.status,
    required this.errorTitle,
    required this.errorMessage,
    this.data,
    this.list,
  });

  @override
  List<Object?> get props => [status, errorTitle, errorMessage, data, list];

  bool get isInitial => status == BaseStatus.initial;

  bool get isLoading => status == BaseStatus.loading;

  bool get isSuccess => status == BaseStatus.success;

  bool get isError => status == BaseStatus.error;

  bool get isEmpty => status == BaseStatus.empty;
}
