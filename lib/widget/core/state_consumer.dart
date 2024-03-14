import 'package:flosha/base/error_state_wrapper.dart';
import 'package:flosha/base/state/base_list_state.dart';
import 'package:flosha/base/state/base_object_state.dart';
import 'package:flosha/base/state/base_state.dart';
import 'package:flosha/flosha.dart';
import 'package:flosha/widget/core/state_widget_config.dart';
import 'package:flosha/widget/state/state_empty_container.dart';
import 'package:flosha/widget/state/state_error_container.dart';
import 'package:flutter/material.dart';

class StateConsumer<B extends Cubit<S>, S extends BaseState<T>,
    T extends ModelSerialize> extends StatelessWidget {
  /// Logic class that handle state to display data\
  /// Pass [B] type in the first generic type to define Logic class type
  final B logic;

  /// Custom widget to replace loading widget
  final Widget? loadingWidget;

  /// Config for empty widget that will shown when state is `empty`
  final StateWidgetConfig? emptyConfig;

  /// Config for error widget that will shown when state is `error`
  final StateWidgetConfig? errorConfig;

  /// Callback function to display desired widget when state is `success`\
  final Widget successWidget;

  /// Callback function to execute when state is changed\
  /// Receive [result] as parameter with the type of Either which return error on the Left side, and data on the Right side
  final Function(Either<ErrorStateWrapper, T> result) onListen;

  /// Callback function to execute code when state is `loading`\
  final Widget Function()? onLoading;

  /// Callback function to execute code when state is `empty`\
  final Widget Function()? onEmpty;

  /// Function to determine wether to rebuild the container based on certain condition\
  /// Return [bool] value, container will rebuild when value is `true`\
  /// Default: Container will be rebuild when [previous] state is not same as [next] state\
  /// [S] type in the second generic type is to define Logic state type\
  final bool Function(S, S)? buildWhen;

  /// Function to determine wether to listen to the state changes on certain condition\
  /// Return [bool] value, this callback will be called when value is `true`\
  /// Default: Callback will be called when [previous] state is not same as [next] state\
  /// [S] type in the second generic type is to define Logic state type\
  final bool Function(S, S)? listenWhen;

  /// Container that reactive to state changes. Used for displaying data in the state that emitted from `Logic` class\
  /// First  generic type [B] define the Logic class type\
  /// Second generic type [S] define the Logic's state type\
  /// Third generic type [T] define the data type returned when [state] is `Success`
  const StateConsumer({
    super.key,
    required this.logic,
    this.loadingWidget,
    this.emptyConfig,
    this.errorConfig,
    required this.successWidget,
    required this.onListen,
    this.onLoading,
    this.onEmpty,
    this.buildWhen,
    this.listenWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      bloc: logic,
      listenWhen: listenWhen,
      listener: (ctx, state) {
        if (state.isLoading) {
          onLoading?.call();
        } else if (state.isSuccess) {
          onListen.call(
            right(
              B is BaseListLogic<S>? ? state.list as T : state.data as T,
            ),
          );
        } else if (state.isError) {
          onListen.call(
            left(
              ErrorStateWrapper(
                state.errorTitle,
                state.errorMessage,
              ),
            ),
          );
        } else if (state.isEmpty) {
          onEmpty?.call();
        }
      },
      child: logic is BaseListLogic
          ? _StateListContainer<T>(
              logic: logic as BaseListLogic<T>,
              loadingWidget: loadingWidget,
              emptyConfig: emptyConfig,
              errorConfig: errorConfig,
              successWidget: successWidget,
              buildWhen: (prev, current) =>
                  buildWhen?.call(prev as S, current as S) ?? false,
            )
          : _StateObjectContainer<T>(
              logic: logic as BaseObjectLogic<T>,
              loadingWidget: loadingWidget,
              emptyConfig: emptyConfig,
              errorConfig: errorConfig,
              successWidget: successWidget,
              buildWhen: (prev, current) =>
                  buildWhen?.call(prev as S, current as S) ?? false,
            ),
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
  final Widget successWidget;

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
            return successWidget;
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

class _StateObjectContainer<T extends ModelSerialize> extends StatelessWidget {
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
  final Widget successWidget;

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
            return successWidget;
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
