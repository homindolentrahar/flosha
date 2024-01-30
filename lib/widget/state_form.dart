import 'package:flosha/base/logic/base_list_logic.dart';
import 'package:flosha/base/state/base_state.dart';
import 'package:flosha/flosha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class StateForm<B extends Cubit<S>, S extends BaseState<T>, T>
    extends StatelessWidget {
  /// Logic class that handle state to display data\
  /// Pass [B] type in the first generic type to define Logic class type
  final B logic;

  /// Form key to save the form's state & value
  final GlobalKey<FormBuilderState> formKey;

  /// Auto-validate mode for auto validating the Form state
  final AutovalidateMode? validateMode;

  /// Initial value of Form
  final Map<String, dynamic> initialValue;

  /// Custom widget to replace loading widget
  final Widget? loadingWidget;

  /// Config for empty widget that will shown when state is `empty`
  final StateContainerConfig? emptyConfig;

  /// Config for error widget that will shown when state is `error`
  final StateContainerConfig? errorConfig;

  /// Widget that represents fields inside Form
  final Widget child;

  /// Custom button widget to replace the default form button
  final Widget? buttonWidget;

  /// Callback function to handle Form submission
  final VoidCallback? onSubmit;

  /// Callback function to execute when state is changed\
  /// Receive [data] as parameter with type [T] from [state.data]
  final Widget Function(S? data)? onListen;

  /// Callback function to do execute when state is `success`\
  /// Receive [data] as parameter with type [T] from [state.data]
  final Widget Function(T? data)? onSuccess;

  /// Callback function to execute code when state is `error`\
  /// Receive [title] and [message] as parameter
  final Widget Function({String title, String message})? onError;

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

  /// Container that reactive to state changes that handle Form functionality. Used handle Form state that emitted from `Logic` class\
  /// First  generic type [B] define the Logic class type\
  /// Second generic type [S] define the Logic's state type\
  /// Third generic type [T] define the data type returned when [state] is `Success`
  const StateForm({
    super.key,
    required this.logic,
    required this.formKey,
    this.validateMode,
    this.initialValue = const {},
    this.loadingWidget,
    this.emptyConfig,
    this.errorConfig,
    required this.child,
    this.buttonWidget,
    required this.onListen,
    this.onSuccess,
    this.onLoading,
    this.onEmpty,
    this.onError,
    this.onSubmit,
    this.buildWhen,
    this.listenWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      bloc: logic,
      listenWhen: listenWhen ?? (previous, next) => previous != next,
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
      child: FormBuilder(
        key: formKey,
        autovalidateMode: validateMode,
        initialValue: initialValue,
        clearValueOnUnregister: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            const SizedBox(height: 16),
            BlocBuilder<B, S>(
              bloc: logic,
              buildWhen: buildWhen ?? (previous, next) => previous != next,
              builder: (ctx, state) {
                if (state.isLoading) {
                  return Center(
                    child: loadingWidget ?? const CircularProgressIndicator(),
                  );
                } else if (state.isSuccess) {
                  return buttonWidget ??
                      ElevatedButton(
                        onPressed: onSubmit,
                        child: const Text("Submit"),
                      );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
