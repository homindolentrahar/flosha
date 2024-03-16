import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/logic/base_logic_mixin.dart';
import 'package:flosha/base/state/base_list_state.dart';
import 'package:flosha/flosha.dart';
import 'package:flosha/util/helper/cache_helper.dart';
import 'package:flosha/util/helper/map_helper.dart';

abstract class BaseListLogic<T extends ModelSerialize>
    extends Cubit<BaseListState<T>> with BaseLogicMixin {
  /// Base logic or controller class that handle your state
  /// Handle state that wrap data with type List of Object or [List<T>]
  /// Write your business logic here and emit the necessary state to update UI with corresponding data
  BaseListLogic(super.initialState) {
    onInit();
  }

  /// Cache helper to help with getting/saving cache into local storage
  final CacheHelper _cacheHelper = CacheHelper.create();

  /// Getter for getting data from emitted state
  List<T> get data => state.list ?? [];

  /// Getter for getting data form cache
  List<Map<String, dynamic>> get cache =>
      _cacheHelper.getCache(cacheKey) == null
          ? []
          : (_cacheHelper.getCache(cacheKey) as List<dynamic>)
              .map((e) => MapHelper.fromDynamic(e))
              .toList();

  /// Wether to load initial data from cache (if have any)
  /// Default [true]
  bool get loadFromCache => true;

  /// Wether to display data from cache (if have any) instead of error container
  /// Default [false]
  bool get replaceErrorWithCache => false;

  /// Custom key to save data into cache
  /// Override this tto change from default key
  String get cacheKey => "${T.runtimeType.toString()}_list";

  /// Getter for getting
  List<T> get deserializeFromJson;

  /// Getter for page size in pagination
  /// Override this with the amount of item you want to load
  int get pageSize => 10;

  /// Overridable function that will be executed when logic class initialized for the first time
  void onInit() {
    if (loadFromCache) {
      if (deserializeFromJson.isEmpty) {
        return;
      }

      // success(data: deserializeFromJson);
      emit(state.copyWith(data: deserializeFromJson));
    }

    loadData(initialLoad: true);
  }

  /// Overridable function to load data from remote or local data source
  Future<void> loadData({int page = 1, bool initialLoad = false});

  /// Overridable function to load next data from remote or local data source
  void loadNextData();

  /// Overridable function to refresh fetching data from remote or local data source
  /// Usually used in pull to refresh scenario
  void refreshData();

  /// Invoke a **Loading** state
  void loading({bool initialLoad = false}) {
    emit(
      state.copyWith(
        status: initialLoad || !state.hasMoreData
            ? BaseStatus.loading
            : BaseStatus.loadMore,
      ),
    );
  }

  /// Invoke a **Success** state
  /// Pass down the [data] with corresponding type [List<T>]
  /// [page] parameters is optional,to indicate the current page in list of data with pagination
  void success({List<T> data = const [], int page = 1, bool saveCache = true}) {
    if (data.isEmpty && page == 1) {
      return emit(state.copyWith(status: BaseStatus.empty));
    }

    List<T> temp = state.list ?? [];

    if (page == 1) {
      temp.clear();

      if (saveCache) {
        _cacheHelper.saveCache(
          key: cacheKey,
          data: data.map((e) => e.toJson()).toList(),
        );
      }
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
    if (replaceErrorWithCache && cache.isNotEmpty) {
      success(data: deserializeFromJson);
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
