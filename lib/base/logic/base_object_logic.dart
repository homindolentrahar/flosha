import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/logic/base_logic_mixin.dart';
import 'package:flosha/base/state/base_object_state.dart';
import 'package:flosha/util/helper/logger_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseObjectLogic<T> extends Cubit<BaseObjectState<T>>
    with BaseLogicMixin {
  /// Base logic or controller class that handle your state
  /// Handle state that wrap data with type of Object or [T]
  /// Write your business logic here and emit the necessary state to update UI with corresponding data
  BaseObjectLogic(super.initialState) {
    onInit();
  }

  /// Getter for getting data from emitted state
  T? get data => state.data;

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

    _finishRefresh();
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

    LoggerHelper.create().error("$errorTitle: $errorMessage");

    _finishRefresh();
  }

  /// Invoke a **Empty** state
  void empty() {
    emit(state.copyWith(status: BaseStatus.empty, data: null));
  }

  /// Function to dismiss loading indicator on pull to refresh scenario
  void _finishRefresh() {
    if (refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }
  }
}
