import 'package:flosha/base/error_state_wrapper.dart';
import 'package:flosha/base/state/base_state.dart';
import 'package:flosha/flosha.dart';
import 'package:flosha/widget/state_widget_config.dart';
import 'package:flutter/material.dart';

class StateConsumer<B extends Cubit<S>, S extends BaseState<T>, T>
    extends StatelessWidget {
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
  /// Receive [data] as parameter with type [T] from [state.data]
  final Widget Function(T? data) successWidget;

  /// Callback function to execute when state is changed\
  /// Receive [result] as parameter with the type of Either which return error on the Left side, and data on the Right side
  final Function(Either<ErrorStateWrapper, T> result) onListen;

  /// Callback function to execute code when state is `loading`\
  final Widget Function()? onLoading;

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
    this.buildWhen,
    this.listenWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      bloc: logic,
      listenWhen: listenWhen ?? (previous, next) => previous != next,
      buildWhen: buildWhen ?? (previous, next) => previous != next,
      listener: (ctx, state) {
        late Either<ErrorStateWrapper, T> result;

        if (state.isLoading) {
          onLoading?.call();
        } else if (state.isSuccess) {
          result = right(
            B is BaseListLogic<S> ? state.list as T : state.data as T,
          );
        } else if (state.isError) {
          result = left(
            ErrorStateWrapper(
              state.errorTitle,
              state.errorMessage,
            ),
          );
        } else if (state.isEmpty) {
          onLoading?.call();
        }

        onListen.call(result);
      },
      builder: (ctx, state) {
        if (state.isLoading) {
          return Center(
            child: loadingWidget ?? const CircularProgressIndicator(),
          );
        } else if (state.isSuccess) {
          return successWidget(
            B is BaseListLogic<S> ? state.list as T : state.data as T,
          );
        } else if (state.isError) {
          return StateErrorContainer(config: errorConfig);
        } else if (state.isEmpty) {
          return StateEmptyContainer(config: emptyConfig);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
