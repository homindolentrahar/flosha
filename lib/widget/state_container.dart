import 'package:flosha/base/state/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part './state/state_error_container.dart';
part './state/state_empty_container.dart';

class StateContainerConfig {
  /// [title] that will displayed in the state container display
  final String? title;

  /// [message] that will displayed in the state container display
  final String? message;

  /// Textstyle for [title]
  final TextStyle? titleStyle;

  /// Textstyle for [message]
  final TextStyle? messageStyle;

  /// Custom widget to replace default state container display
  final Widget? widget;

  /// Custom image to replace default state container display - icon
  final ImageProvider? image;

  StateContainerConfig(
    this.title,
    this.message,
    this.titleStyle,
    this.messageStyle,
    this.widget,
    this.image,
  );
}

class StateContainer<B extends Cubit<S>, S extends BaseState<T>, T>
    extends StatelessWidget {
  /// Logic class that handle state to display data\
  /// Pass [B] type in the first generic type to define Logic class type
  final B logic;

  /// Custom widget to replace loading widget
  final Widget? loadingWidget;

  /// Config for empty widget that will shown when state is `empty`
  final StateContainerConfig? emptyConfig;

  /// Config for error widget that will shown when state is `error`
  final StateContainerConfig? errorConfig;

  /// Callback function to display desired widget when state is `success`\
  /// Receive [data] as parameter with type [T] from [state.data]
  final Widget Function(T? data) onSuccess;

  /// Function to determine wether to rebuild the container based on certain condition\
  /// Return [bool] value, container will rebuild when value is `true`\
  /// Default: Container will be rebuild when [previous] state is not same as [next] state\
  /// [S] type in the second generic type is to define Logic state type\
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
    required this.onSuccess,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: logic,
      buildWhen: buildWhen ?? (previous, next) => previous != next,
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: loadingWidget ?? const CircularProgressIndicator(),
          );
        } else if (state.isSuccess) {
          return onSuccess(state.data);
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
