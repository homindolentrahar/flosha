import 'package:flosha/base/error_state_wrapper.dart';
import 'package:flosha/base/state/base_form_state.dart';
import 'package:flosha/flosha.dart';
import 'package:flosha/widget/core/state_widget_config.dart';
import 'package:flutter/material.dart';

class StateForm<T> extends StatelessWidget {
  /// Logic class that handle state to display data\
  /// Pass [T] type to define Logic's data type
  final BaseFormLogic<T> logic;

  /// Auto-validate mode for auto validating the Form state
  final AutovalidateMode? validateMode;

  /// Initial value of Form
  final Map<String, dynamic> initialValue;

  /// Custom widget to replace loading widget
  final Widget? loadingWidget;

  /// Config for empty widget that will shown when state is `empty`
  final StateWidgetConfig? emptyConfig;

  /// Config for error widget that will shown when state is `error`
  final StateWidgetConfig? errorConfig;

  /// Config for Submit buttom
  final StateFormSubmitButtonConfig? submitButtonConfig;

  /// Widget that represents fields inside Form
  final Widget child;

  /// Callback function to handle Form submission
  final VoidCallback? onSubmit;

  /// Callback function to execute when state is changed\
  /// Receive [result] as parameter with the type of Either which return error on the Left side, and data on the Right side
  final Function(Either<ErrorStateWrapper, T> result) onListen;

  /// Callback function to execute code when state is `loading`\
  final VoidCallback? onLoading;

  /// Callback function to execute code when state is `empty`
  final VoidCallback? onEmpty;

  /// Function to determine wether to rebuild the container based on certain condition\
  /// Return [bool] value, container will rebuild when value is `true`\
  /// Default: Container will be rebuild when [previous] state is not same as [next] state\
  final bool Function(BaseFormState, BaseFormState)? buildWhen;

  /// Function to determine wether to listen to the state changes on certain condition\
  /// Return [bool] value, this callback will be called when value is `true`\
  /// Default: Callback will be called when [previous] state is not same as [next] state\
  final bool Function(BaseFormState, BaseFormState)? listenWhen;

  /// Container that reactive to state changes that handle Form functionality. Used handle Form state that emitted from `Logic` class\
  /// Third generic type [T] define the data type returned when [state] is `Success`
  const StateForm({
    super.key,
    required this.logic,
    this.validateMode,
    this.initialValue = const {},
    this.loadingWidget,
    this.emptyConfig,
    this.errorConfig,
    this.submitButtonConfig,
    required this.child,
    required this.onListen,
    this.onLoading,
    this.onEmpty,
    this.onSubmit,
    this.buildWhen,
    this.listenWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<BaseFormLogic, BaseFormState>(
      bloc: logic,
      listenWhen: listenWhen ?? (previous, next) => previous != next,
      listener: (ctx, state) {
        if (state.isLoading) {
          onLoading?.call();
        } else if (state.isSuccess) {
          onListen.call(right(
            logic.dataType == BaseLogicDataType.list
                ? state.list as T
                : state.data as T,
          ));
        } else if (state.isError) {
          onListen.call(left(
            ErrorStateWrapper(
              state.errorTitle,
              state.errorMessage,
            ),
          ));
        } else if (state.isEmpty) {
          onLoading?.call();
        }
      },
      child: FormBuilder(
        key: logic.formKey,
        autovalidateMode: validateMode,
        initialValue: initialValue,
        clearValueOnUnregister: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
              SizedBox(height: submitButtonConfig?.spaceFromFields ?? 32),
              Visibility(
                visible: submitButtonConfig?.showDefaultSubmitButton ?? true,
                child: BlocBuilder<BaseFormLogic<T>, BaseFormState<T>>(
                  bloc: logic,
                  buildWhen: buildWhen ?? (previous, next) => previous != next,
                  builder: (ctx, state) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: submitButtonConfig?.buttonWidget ??
                          ElevatedButton(
                            onPressed: state.isLoading ? null : onSubmit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              elevation: 0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            child: Text(
                              submitButtonConfig?.buttonText ?? "Submit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
