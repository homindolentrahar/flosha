import 'package:flosha/base/state/base_list_state.dart';
import 'package:flosha/base/state/base_object_state.dart';
import 'package:flosha/base/state/base_state.dart';
import 'package:flosha/flosha.dart';
import 'package:flosha/widget/state_widget_config.dart';
import 'package:flutter/material.dart';

part './state/state_error_container.dart';
part './state/state_empty_container.dart';

class StateContainer<B extends BlocBase<S>, S extends BaseState, T>
    extends StatelessWidget {
  /// Logic class that handle state to display data\
  final B logic;

  /// Custom widget to replace loading widget
  final Widget? loadingWidget;

  /// Config for empty widget that will shown when state is `empty`
  final StateWidgetConfig? emptyConfig;

  /// Config for error widget that will shown when state is `error`
  final StateWidgetConfig? errorConfig;

  /// Callback function to display desired widget when state is `success`\
  /// Receive [data] as parameter with type [T] from [state.data]
  final Widget Function(B logic) successWidget;

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
            successWidget: (logic) => successWidget(logic as B),
            buildWhen: (prev, current) =>
                buildWhen?.call(prev as S, current as S) ?? true,
          )
        : _StateObjectContainer<T>(
            logic: logic as BaseObjectLogic<T>,
            loadingWidget: loadingWidget,
            emptyConfig: emptyConfig,
            errorConfig: errorConfig,
            successWidget: (logic) => successWidget(logic as B),
            buildWhen: (prev, current) =>
                buildWhen?.call(prev as S, current as S) ?? true,
          );
  }
}

class _StateListContainer<T> extends StatelessWidget {
  /// Logic class that handle state to display data\
  final BaseListLogic<T> logic;

  /// Custom widget to replace loading widget
  final Widget? loadingWidget;

  /// Config for empty widget that will shown when state is `empty`
  final StateWidgetConfig? emptyConfig;

  /// Config for error widget that will shown when state is `error`
  final StateWidgetConfig? errorConfig;

  /// Callback function to display desired widget when state is `success`\
  /// Receive [data] as parameter with type [T] from [state.data]
  final Widget Function(BaseListLogic<T> logic) successWidget;

  /// Function to determine wether to rebuild the container based on certain condition\
  /// Return [bool] value, container will rebuild when value is `true`\
  /// Default: Container will be rebuild when [previous] state is not same as [next] state\
  final bool Function(BaseListState<T>, BaseListState<T>)? buildWhen;

  const _StateListContainer({
    super.key,
    required this.logic,
    required this.loadingWidget,
    required this.emptyConfig,
    required this.errorConfig,
    required this.successWidget,
    required this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: logic.refreshController,
      onRefresh: logic.refreshData,
      enablePullDown: true,
      enablePullUp: logic.state.hasMoreData,
      child: BlocBuilder<BaseListLogic<T>, BaseListState<T>>(
        bloc: logic,
        buildWhen: buildWhen ?? (previous, next) => previous != next,
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: loadingWidget ?? const CircularProgressIndicator(),
            );
          } else if (state.isSuccess || state.isLoadMore) {
            return successWidget(logic);
          } else if (state.isError) {
            return StateErrorContainer(
              config: errorConfig ??
                  StateWidgetConfig(
                    title: state.errorTitle,
                    message: state.errorMessage,
                  ),
            );
          } else if (state.isEmpty) {
            return StateEmptyContainer(config: emptyConfig);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StateObjectContainer<T> extends StatelessWidget {
  /// Logic class that handle state to display data\
  final BaseObjectLogic<T> logic;

  /// Custom widget to replace loading widget
  final Widget? loadingWidget;

  /// Config for empty widget that will shown when state is `empty`
  final StateWidgetConfig? emptyConfig;

  /// Config for error widget that will shown when state is `error`
  final StateWidgetConfig? errorConfig;

  /// Callback function to display desired widget when state is `success`\
  /// Receive [data] as parameter with type [T] from [state.data]
  final Widget Function(BaseObjectLogic<T> logic) successWidget;

  /// Function to determine wether to rebuild the container based on certain condition\
  /// Return [bool] value, container will rebuild when value is `true`\
  /// Default: Container will be rebuild when [previous] state is not same as [next] state\
  final bool Function(BaseObjectState<T>, BaseObjectState<T>)? buildWhen;

  const _StateObjectContainer({
    super.key,
    required this.logic,
    required this.loadingWidget,
    required this.emptyConfig,
    required this.errorConfig,
    required this.successWidget,
    required this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: logic.refreshController,
      onRefresh: logic.refreshData,
      enablePullDown: true,
      child: BlocBuilder<BaseObjectLogic<T>, BaseObjectState<T>>(
        bloc: logic,
        buildWhen: buildWhen ?? (previous, next) => previous != next,
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: loadingWidget ?? const CircularProgressIndicator(),
            );
          } else if (state.isSuccess || state.isLoadMore) {
            return successWidget(logic);
          } else if (state.isError) {
            return StateErrorContainer(
              config: errorConfig ??
                  StateWidgetConfig(
                    title: state.errorTitle,
                    message: state.errorMessage,
                  ),
            );
          } else if (state.isEmpty) {
            return StateEmptyContainer(config: emptyConfig);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
