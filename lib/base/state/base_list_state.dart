import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/state/base_state.dart';

/// Base state that holds necessary data for various state's status\
/// Holds a List of data with type of [List<T>]
/// Usually used for load list of data with pagination
class BaseListState<T> extends BaseState<T> {
  /// [page] indicate current page in list of data with pagination
  final int page;

  /// [pageSize] indicate the page size or how many items will be loaded in one page with pagination
  final int pageSize;

  /// [hasMoreData] indicates that current page is not a last page, and the data still available in next page
  final bool hasMoreData;

  /// Base state that holds necessary data for various state's status\
  /// Holds a List of data with type of [List<T>]
  /// Usually used for load list of data with pagination
  /// [status] is a [BaseStatus] enum to indicate state's status
  /// [errorTitle] is a title that will shown when state is error
  /// [errorMesage] is a message that will shown when state is error
  /// [data] is list of data of the state with type [List<T>]
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

  /// Function to alter or update the existing state instance with new values
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
