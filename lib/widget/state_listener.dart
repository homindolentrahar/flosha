import 'package:flosha/base/logic/base_list_logic.dart';
import 'package:flosha/base/state/base_state.dart';
import 'package:flosha/flosha.dart';
import 'package:flutter/material.dart';

class StateLiestener<B extends Cubit<S>, S extends BaseState<T>, T>
    extends StatelessWidget {
  /// Logic class that handle state to display data\
  /// Pass [B] type in the first generic type to define Logic class type
  final B logic;

  /// child widget that will be wrapped inside the listener
  final Widget child;

  /// Callback function to execute code when state is `success`\
  /// Receive [data] as parameter with type [T] from [state.data]
  final Widget Function(T? data)? onSuccess;

  /// Callback function to execute code when state is `error`\
  /// Receive [title] and [message] as parameter
  final Widget Function({String title, String message})? onError;

  /// Callback function to execute code when state is `loading`\
  final Widget Function()? onLoading;

  /// Callback function to execute code when state is `empty`\
  final Widget Function()? onEmpty;

  /// Callback function to execute when state is changed\
  /// Receive [data] as parameter with type [T] from [state.data]
  final Widget Function(S? data)? onListen;

  /// Function to determine wether to listen to the state changes on certain condition\
  /// Return [bool] value, this callback will be called when value is `true`\
  /// Default: Callback will be called when [previous] state is not same as [next] state\
  /// [S] type in the second generic type is to define Logic state type\
  final bool Function(S, S)? listenWhen;

  /// Wrapper for listening state changes. Used for execute code when state change emitted from `Logic` class\
  /// First  generic type [B] define the Logic class type\
  /// Second generic type [S] define the Logic's state type\
  /// Third generic type [T] define the data type returned when [state] is `Success`
  const StateLiestener({
    super.key,
    required this.logic,
    required this.child,
    this.onSuccess,
    this.listenWhen,
    this.onError,
    this.onLoading,
    this.onEmpty,
    this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      bloc: logic,
      listenWhen: listenWhen,
      listener: (ctx, state) {
        onListen?.call(state);

        if (state.isLoading) {
          onLoading?.call();
        } else if (state.isSuccess) {
          onSuccess?.call(
            B is BaseListLogic<S>? ? state.list as T : state.data as T,
          );
        } else if (state.isError) {
          onError?.call(title: state.errorTitle, message: state.errorMessage);
        } else if (state.isEmpty) {
          onEmpty?.call();
        }
      },
      child: child,
    );
  }
}
