import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/state/base_state.dart';

class BaseListState<T> extends BaseState {
  final int page;
  final int pageSize;
  final bool hasMoreData;
  @override
  final List<T>? data;

  const BaseListState({
    BaseStatus status = BaseStatus.initial,
    String? errorTitle = "",
    String? errorMessage = "",
    this.data,
    this.page = 1,
    this.pageSize = 10,
    this.hasMoreData = false,
  }) : super(
          status: status,
          errorTitle: errorTitle ?? "",
          errorMessage: errorMessage ?? "",
        );

  BaseListState<T> copyWith({
    BaseStatus? status,
    String? errorTitle,
    String? errorMessage,
    List<T>? data,
    int? page,
    int? pageSize,
    bool? hasMoreData,
  }) =>
      BaseListState(
        status: status ?? this.status,
        errorTitle: errorTitle ?? this.errorTitle,
        errorMessage: errorMessage ?? this.errorMessage,
        data: data ?? this.data,
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        hasMoreData: hasMoreData ?? this.hasMoreData,
      );
}
