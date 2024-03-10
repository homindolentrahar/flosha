import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/logic/base_logic_mixin.dart';
import 'package:flosha/base/state/base_list_state.dart';
import 'package:flosha/util/helper/logger_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseListLogic<T> extends Cubit<BaseListState<T>>
    with BaseLogicMixin {
  /// Base logic or controller class that handle your state
  /// Handle state that wrap data with type List of Object or [List<T>]
  /// Write your business logic here and emit the necessary state to update UI with corresponding data
  BaseListLogic(super.initialState) {
    onInit();
  }

  /// Getter for getting data from emitted state
  List<T> get data => state.list ?? [];

  /// Getter for page size in pagination
  /// Override this with the amount of item you want to load
  int get pageSize => 10;

  /// Overridable function that will be executed when logic class initialized for the first time
  void onInit() {}

  /// Overridable function to load data from remote or local data source
  Future<void> loadData();

  /// Overridable function to load next data from remote or local data source
  void loadNextData();

  /// Overridable function to refresh fetching data from remote or local data source
  /// Usually used in pull to refresh scenario
  void refreshData();

  /// Invoke a **Loading** state
  void loading() {
    emit(
      state.copyWith(
        status: state.hasMoreData ? BaseStatus.loadMore : BaseStatus.loading,
      ),
    );
  }

  /// Invoke a **Success** state
  /// Pass down the [data] with corresponding type [List<T>]
  /// [page] parameters is optional,to indicate the current page in list of data with pagination
  void success({List<T> data = const [], int page = 1}) {
    if (data.isEmpty) {
      return emit(state.copyWith(status: BaseStatus.empty));
    }

    List<T> temp = state.list ?? [];

    if (page == 1) {
      temp.clear();
    }

    temp.addAll(data);

    emit(
      state.copyWith(
        status: BaseStatus.success,
        data: temp,
        page: page,
        hasMoreData: !(data.length < state.pageSize),
      ),
    );

    _finishRefresh();
  }

  /// Invoke a **Error** state
  /// Pass down the [errorTitle] and [errorMessage]
  void error({
    String? errorTitle,
    String? errorMessage,
  }) {
    emit(
      state.copyWith(
        status: BaseStatus.error,
        errorTitle: errorTitle,
        errorMessage: errorMessage,
      ),
    );

    LoggerHelper.create().error("$errorTitle: $errorMessage");

    _finishRefresh();
  }

  /// Invoke a **Empty** state
  void empty() {
    emit(state.copyWith(status: BaseStatus.empty, data: []));
  }

  /// Function to change the page size or how many items will be loaded in one page with pagination
  void changePageSize(int size) {
    emit(state.copyWith(pageSize: size, status: state.status));
  }

  /// Function to dismiss loading indicator on pull to refresh scenario
  void _finishRefresh() {
    if (refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }

    if (refreshController.isLoading) {
      refreshController.loadComplete();
    }
  }
}
