import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/logic/base_logic_mixin.dart';
import 'package:flosha/base/state/base_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseListLogic<T> extends Cubit<BaseListState<T>>
    with BaseLogicMixin {
  /// Base logic or controller class that handle your state
  /// Handle state that wrap data with type List of Object or [List<T>]
  /// Write your business logic here and emit the necessary state to update UI with corresponding data
  BaseListLogic(super.initialState) {
    onInit();
  }

  /// Overridable function that will be executed when logic class initialized for the first time
  void onInit() {}

  /// Overridable function to load data from remote or local data source
  Future<void> loadData();

  /// Overridable function to refresh fetching data from remote or local data source
  /// Usually used in pull to refresh scenario
  void refreshData();

  /// Invoke a **Loading** state
  void loading() {
    emit(state.copyWith(status: BaseStatus.loading));
  }

  /// Invoke a **Success** state
  /// Pass down the [data] with corresponding type [List<T>]
  /// [page] parameters is optional,to indicate the current page in list of data with pagination
  void success(List<T>? data, {int page = 1}) {
    emit(
      state.copyWith(
        status: BaseStatus.success,
        data: data,
        page: page,
      ),
    );
  }

  /// Invoke a **Error** state
  /// Pass down the [errorTitle] and [errorMessage]
  void error({
    String? errorTitle,
    String? errorMessage,
    int page = 1,
  }) {
    emit(
      state.copyWith(
        status: BaseStatus.error,
        errorTitle: errorTitle,
        errorMessage: errorMessage,
        page: page,
      ),
    );
  }

  /// Invoke a **Empty** state
  void empty() {
    emit(state.copyWith(status: BaseStatus.empty, data: []));
  }

  /// Function to change the page size or how many items will be loaded in one page with pagination
  void changePageSize(int size) {
    emit(state.copyWith(pageSize: size));
  }

  /// Function to populate fetched data into UI
  /// Will emit **Success** state when the fetching process is considered success
  /// Or emit **Error** state when the fetching process is considered failed, indicated by dirty [errorMessage] or [errorMessage] is not empty
  void populateData({
    List<T>? data,
    String errorTitle = "",
    String errorMessage = "",
    int page = 1,
  }) {
    if (errorMessage.isNotEmpty) {
      _errorCallback(
        errorTitle: errorTitle,
        errorMessage: errorMessage,
        page: page,
      );
      return;
    }

    _successCallback(data ?? [], page: page);
  }

  /// Function to clear list of data saved in a state
  void _clearListData() {
    emit(state.copyWith(data: []));
  }

  /// Callback function that executed when fetching process considered success
  void _successCallback(List<T> data, {int page = 1}) {
    List<T>? temp = state.list;

    if (state.page == 1) {
      _clearListData();
    }

    temp?.addAll(data);

    success(temp, page: page);

    emit(state.copyWith(hasMoreData: !(data.length < state.pageSize)));

    _finishRefresh();
  }

  /// Callback function that executed when fetching process considered failed
  void _errorCallback({
    String? errorTitle,
    String? errorMessage,
    int page = 1,
  }) {
    this.error(
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      page: page,
    );

    _finishRefresh();
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
