import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/logic/base_logic_mixin.dart';
import 'package:flosha/base/state/base_object_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseObjectLogic<T> extends Cubit<BaseObjectState<T>>
    with BaseLogicMixin {
  BaseObjectLogic(super.initialState) {
    onInit();
  }

  void onInit() {}

  Future<void> loadData();

  void refreshLoad();

  /// Invoke a **Loading** state
  void loading() {
    emit(state.copyWith(status: BaseStatus.loading));
  }

  /// Invoke a **Success** state
  /// Pass down the **data**
  void success(T? data) {
    emit(state.copyWith(status: BaseStatus.success, data: data));
  }

  /// Invoke a **Error** state
  /// Pass down the **error**
  void error({String? errorTitle, String? errorMessage}) {
    emit(
      state.copyWith(
        status: BaseStatus.error,
        errorTitle: errorTitle,
        errorMessage: errorMessage,
      ),
    );
  }

  /// Invoke a **Empty** state
  void empty() {
    emit(state.copyWith(status: BaseStatus.empty, data: null));
  }

  void populateData({
    T? data,
    String errorTitle = "",
    String errorMessage = "",
  }) {
    if (errorMessage.isNotEmpty) {
      _errorCallback(errorTitle: errorTitle, errorMessage: errorMessage);
      return;
    }

    _successCallback(data);
  }

  void _successCallback(T? data) {
    success(data);

    _finishRefresh();
  }

  void _errorCallback({String? errorTitle, String? errorMessage}) {
    this.error(errorTitle: errorTitle, errorMessage: errorMessage);

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
