import 'package:equatable/equatable.dart';
import 'package:flosha/base/base_status.dart';

abstract class BaseState<T> extends Equatable {
  final BaseStatus status;
  final String errorTitle;
  final String errorMessage;
  final T? data;
  final List<T>? list;

  /// Base state that holds necessary data for various state's status\
  /// [status] is a [BaseStatus] enum to indicate state's status
  /// [errorTitle] is a title that will shown when state is error
  /// [errorMesage] is a message that will shown when state is error
  /// [data] is a data of the state with type [T]
  /// [list] is a list of data in the state with type [List<T>]
  const BaseState({
    required this.status,
    required this.errorTitle,
    required this.errorMessage,
    this.data,
    this.list,
  });

  @override
  List<Object?> get props => [status, errorTitle, errorMessage, data, list];

  /// Checking if state is [BaseStatus.initial]
  bool get isInitial => status == BaseStatus.initial;

  /// Checking if state is [BaseStatus.loading]
  bool get isLoading => status == BaseStatus.loading;

  /// Checking if state is [BaseStatus.loadMore]
  bool get isLoadMore => status == BaseStatus.loadMore;

  /// Checking if state is [BaseStatus.success]
  bool get isSuccess => status == BaseStatus.success;

  /// Checking if state is [BaseStatus.error]
  bool get isError => status == BaseStatus.error;

  /// Checking if state is [BaseStatus.empty]
  bool get isEmpty => status == BaseStatus.empty;
}
