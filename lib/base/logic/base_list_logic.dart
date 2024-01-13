import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/logic/base_logic_mixin.dart';
import 'package:flosha/base/state/base_list_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseListLogic<T> extends Cubit<BaseListState<T>>
    with BaseLogicMixin {
  BaseListLogic(super.initialState) {
    onInit();
  }

  void onInit() {
    debugPrint("onInit Logic::->");
  }

  void refreshLoad();

  /// Invoke a **Loading** state
  void loading() {
    emit(state.copyWith(status: BaseStatus.loading));
  }

  /// Invoke a **Success** state
  /// Pass down the **data**
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
  /// Pass down the **error**
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

  void changePageSize(int size) {
    emit(state.copyWith(pageSize: size));
  }

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

  void _successCallback(List<T> data, {int page = 1}) {
    List<T>? temp = state.data;

    if (state.page == 1) {
      empty();
    }

    temp?.addAll(data);

    success(temp, page: page);

    emit(state.copyWith(hasMoreData: !(data.length < state.pageSize)));

    _finishRefresh();
  }

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

  void _finishRefresh() {
    if (refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }

    if (refreshController.isLoading) {
      refreshController.loadComplete();
    }
  }
}
