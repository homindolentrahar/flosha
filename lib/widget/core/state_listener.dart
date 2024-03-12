import 'package:flosha/base/error_state_wrapper.dart';
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
  /// Receive [result] as parameter with the type of Either which return error on the Left side, and data on the Right side
  final Function(Either<ErrorStateWrapper, T> result) onListen;

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
    required this.onListen,
    this.onSuccess,
    this.listenWhen,
    this.onError,
    this.onLoading,
    this.onEmpty,
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
      child: child,
    );
  }
}
