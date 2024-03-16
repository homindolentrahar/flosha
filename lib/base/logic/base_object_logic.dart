import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/logic/base_logic_mixin.dart';
import 'package:flosha/base/model/model_serialize.dart';
import 'package:flosha/base/state/base_object_state.dart';
import 'package:flosha/util/helper/cache_helper.dart';
import 'package:flosha/util/helper/logger_helper.dart';
import 'package:flosha/util/helper/map_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseObjectLogic<T extends ModelSerialize>
    extends Cubit<BaseObjectState<T>> with BaseLogicMixin {
  /// Base logic or controller class that handle your state
  /// Handle state that wrap data with type of Object or [T]
  /// Write your business logic here and emit the necessary state to update UI with corresponding data
  BaseObjectLogic(super.initialState) {
    onInit();
  }

  /// Cache helper to help with getting/saving cache into local storage
  final CacheHelper _cacheHelper = CacheHelper.create();

  /// Getter for getting data from emitted state
  T? get data => state.data;

  /// Getter for getting data form cache
  Map<String, dynamic>? get cache => _cacheHelper.getCache(cacheKey) == null
      ? null
      : MapHelper.fromDynamic(_cacheHelper.getCache(cacheKey));

  /// Wether to load initial data from cache (if have any)
  /// Default [true]
  bool get loadFromCache => true;

  /// Wether to display data from cache (if have any) instead of error container
  /// Default [false]
  bool get replaceErrorWithCache => false;

  /// Custom key to save data into cache
  /// Override this tto change from default key
  String get cacheKey => T.runtimeType.toString();

  /// Getter for getting
  T? get deserializeFromJson;

  /// Overridable function that will be executed when logic class initialized for the first time
  void onInit() {
    if (loadFromCache) {
      if (deserializeFromJson == null) {
        return;
      }

      success(deserializeFromJson);
    }

    loadData();
  }

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
  void success(T? data, {bool saveCache = true}) {
    if (saveCache) {
      _cacheHelper.saveCache(
        key: cacheKey,
        data: data?.toJson(),
      );
    }

    emit(state.copyWith(status: BaseStatus.success, data: data));

    _finishRefresh();
  }

  /// Invoke a **Error** state
  /// Pass down the [errorTitle] and [errorMessage]
  void error({String? errorTitle, String? errorMessage}) {
    if (replaceErrorWithCache && cache != null) {
      success(deserializeFromJson);
    } else {
      emit(
        state.copyWith(
          status: BaseStatus.error,
          errorTitle: errorTitle,
          errorMessage: errorMessage,
        ),
      );
    }

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
