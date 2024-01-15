import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/state/base_state.dart';

class BaseListState<T> extends BaseState<T> {
  final int page;
  final int pageSize;
  final bool hasMoreData;

  const BaseListState({
    BaseStatus status = BaseStatus.initial,
    String? errorTitle = "",
    String? errorMessage = "",
    List<T>? data,
    this.page = 1,
    this.pageSize = 10,
    this.hasMoreData = false,
  }) : super(
          status: status,
          errorTitle: errorTitle ?? "",
          errorMessage: errorMessage ?? "",
          list: data,
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
        data: data ?? list,
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        hasMoreData: hasMoreData ?? this.hasMoreData,
      );
}
