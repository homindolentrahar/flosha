import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/logic/base_logic_mixin.dart';
import 'package:flosha/base/state/base_object_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseObjectLogic<T> extends Cubit<BaseObjectState<T>>
    with BaseLogicMixin {
  /// Base logic or controller class that handle your state
  /// Handle state that wrap data with type of Object or [T]
  /// Write your business logic here and emit the necessary state to update UI with corresponding data
  BaseObjectLogic(super.initialState) {
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
  /// Pass down the [data] with corresponding type [T]
  void success(T? data) {
    emit(state.copyWith(status: BaseStatus.success, data: data));
  }

  /// Invoke a **Error** state
  /// Pass down the [errorTitle] and [errorMessage]
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

  /// Function to populate fetched data into UI
  /// Will emit **Success** state when the fetching process is considered success
  /// Or emit **Error** state when the fetching process is considered failed, indicated by dirty [errorMessage] or [errorMessage] is not empty
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

  /// Callback function that executed when fetching process considered success
  void _successCallback(T? data) {
    success(data);

    _finishRefresh();
  }

  /// Callback function that executed when fetching process considered failed
  void _errorCallback({String? errorTitle, String? errorMessage}) {
    this.error(errorTitle: errorTitle, errorMessage: errorMessage);

    _finishRefresh();
  }

  /// Function to dismiss loading indicator on pull to refresh scenario
  void _finishRefresh() {
    if (refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }
  }
}
