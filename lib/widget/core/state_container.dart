import 'package:flosha/base/state/base_list_state.dart';
import 'package:flosha/base/state/base_object_state.dart';
import 'package:flosha/base/state/base_state.dart';
import 'package:flosha/flosha.dart';
import 'package:flosha/widget/core/state_widget_config.dart';
import 'package:flosha/widget/state/state_empty_container.dart';
import 'package:flosha/widget/state/state_error_container.dart';
import 'package:flutter/material.dart';

class StateContainer<S extends BaseState, T extends ModelSerialize>
    extends StatelessWidget {
  /// Logic class that handle state to display data\
  final BlocBase logic;

  /// Wether to use SmartRefresher outside the StateContainer or not
  /// Default [false].
  final bool useExternalRefresher;

  /// Custom widget to replace loading widget
  final Widget? loadingWidget;

  /// Config for empty widget that will shown when state is `empty`
  final StateWidgetConfig? emptyConfig;

  /// Config for error widget that will shown when state is `error`
  final StateWidgetConfig? errorConfig;

  /// Widget that will be displayed when state is `success`\
  final Widget Function(S) successWidget;

  /// Function to determine wether to rebuild the container based on certain condition\
  /// Return [bool] value, container will rebuild when value is `true`\
  /// Default: Container will be rebuild when [previous] state is not same as [next] state\

  final bool Function(S, S)? buildWhen;

  /// Container that reactive to state changes. Used for displaying data in the state that emitted from `Logic` class\
  /// First  generic type [B] define the Logic class type\
  /// Second generic type [S] define the Logic's state type\
  /// Third generic type [T] define the data type returned when [state] is `Success`
  const StateContainer({
    super.key,
    required this.logic,
    this.useExternalRefresher = false,
    this.loadingWidget,
    this.emptyConfig,
    this.errorConfig,
    required this.successWidget,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return logic is BaseListLogic
        ? _StateListContainer<T>(
            logic: logic as BaseListLogic<T>,
            loadingWidget: loadingWidget,
            emptyConfig: emptyConfig,
            errorConfig: errorConfig,
            successWidget: (state) => successWidget(state as S),
            buildWhen: (prev, current) => true,
            useExternalRefresher: useExternalRefresher,
          )
        : _StateObjectContainer<T>(
            logic: logic as BaseObjectLogic<T>,
            loadingWidget: loadingWidget,
            emptyConfig: emptyConfig,
            errorConfig: errorConfig,
            successWidget: (state) => successWidget(state as S),
            buildWhen: (prev, current) => true,
            useExternalRefresher: useExternalRefresher,
          );
  }
}

class _StateListContainer<T extends ModelSerialize> extends StatelessWidget {
  /// Logic class that handle state to display data\
  final BaseListLogic<T> logic;

  /// Wether to use SmartRefresher outside the StateContainer or not
  /// Default [false].
  final bool useExternalRefresher;

  /// Custom widget to replace loading widget
  final Widget? loadingWidget;

  /// Config for empty widget that will shown when state is `empty`
  final StateWidgetConfig? emptyConfig;

  /// Config for error widget that will shown when state is `error`
  final StateWidgetConfig? errorConfig;

  /// Callback function to display desired widget when state is `success`\
  final Widget Function(BaseListState<T> st) successWidget;

  /// Function to determine wether to rebuild the container based on certain condition\
  /// Return [bool] value, container will rebuild when value is `true`\
  /// Default: Container will be rebuild when [previous] state is not same as [next] state\
  final bool Function(BaseListState<T>, BaseListState<T>)? buildWhen;

  const _StateListContainer({
    super.key,
    required this.logic,
    this.useExternalRefresher = false,
    required this.loadingWidget,
    required this.emptyConfig,
    required this.errorConfig,
    required this.successWidget,
    required this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseListLogic<T>, BaseListState<T>>(
      bloc: logic,
      // buildWhen: buildWhen ?? (previous, next) => previous != next,
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: loadingWidget ?? const CircularProgressIndicator(),
          );
        } else if (state.isSuccess || state.isLoadMore) {
          return useExternalRefresher
              ? successWidget(state)
              : SmartRefresher(
                  controller: logic.refreshController,
                  onRefresh: logic.refreshData,
                  onLoading: logic.loadNextData,
                  enablePullDown: true,
                  enablePullUp: logic.state.hasMoreData,
                  child: successWidget(state),
                );
        } else if (state.isError) {
          final loadedWidget = StateErrorContainer(
            config: errorConfig ??
                StateWidgetConfig(
                  title: state.errorTitle,
                  message: state.errorMessage,
                ),
          );

          return useExternalRefresher
              ? loadedWidget
              : SmartRefresher(
                  controller: logic.refreshController,
                  onRefresh: logic.refreshData,
                  enablePullDown: true,
                  enablePullUp: false,
                  child: loadedWidget,
                );
        } else if (state.isEmpty) {
          final loadedWidget = StateEmptyContainer(config: emptyConfig);

          return useExternalRefresher
              ? loadedWidget
              : SmartRefresher(
                  controller: logic.refreshController,
                  onRefresh: logic.refreshData,
                  enablePullDown: true,
                  enablePullUp: false,
                  child: loadedWidget,
                );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _StateObjectContainer<T extends ModelSerialize> extends StatelessWidget {
  /// Logic class that handle state to display data\
  final BaseObjectLogic<T> logic;

  /// Wether to use SmartRefresher outside the StateContainer or not
  /// Default [false].
  final bool useExternalRefresher;

  /// Custom widget to replace loading widget
  final Widget? loadingWidget;

  /// Config for empty widget that will shown when state is `empty`
  final StateWidgetConfig? emptyConfig;

  /// Config for error widget that will shown when state is `error`
  final StateWidgetConfig? errorConfig;

  /// Widget that will displayed when state is `success`\
  final Widget Function(BaseObjectState<T>) successWidget;

  /// Function to determine wether to rebuild the container based on certain condition\
  /// Return [bool] value, container will rebuild when value is `true`\
  /// Default: Container will be rebuild when [previous] state is not same as [next] state\
  final bool Function(BaseObjectState<T>, BaseObjectState<T>)? buildWhen;

  const _StateObjectContainer({
    super.key,
    required this.logic,
    this.useExternalRefresher = false,
    required this.loadingWidget,
    required this.emptyConfig,
    required this.errorConfig,
    required this.successWidget,
    required this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseObjectLogic<T>, BaseObjectState<T>>(
      bloc: logic,
      // buildWhen: buildWhen ?? (previous, next) => previous != next,
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: loadingWidget ?? const CircularProgressIndicator(),
          );
        } else if (state.isSuccess || state.isLoadMore) {
          return useExternalRefresher
              ? successWidget(state)
              : SmartRefresher(
                  controller: logic.refreshController,
                  onRefresh: logic.refreshData,
                  enablePullDown: true,
                  child: successWidget(state),
                );
        } else if (state.isError) {
          final loadedWidget = StateErrorContainer(
            config: errorConfig ??
                StateWidgetConfig(
                  title: state.errorTitle,
                  message: state.errorMessage,
                ),
          );

          return useExternalRefresher
              ? loadedWidget
              : SmartRefresher(
                  controller: logic.refreshController,
                  onRefresh: logic.refreshData,
                  enablePullDown: true,
                  enablePullUp: false,
                  child: loadedWidget,
                );
        } else if (state.isEmpty) {
          final loadedWidget = StateEmptyContainer(config: emptyConfig);

          return useExternalRefresher
              ? loadedWidget
              : SmartRefresher(
                  controller: logic.refreshController,
                  onRefresh: logic.refreshData,
                  enablePullDown: true,
                  enablePullUp: false,
                  child: loadedWidget,
                );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
