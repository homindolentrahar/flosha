import 'package:flosha/base/base_status.dart';
import 'package:flosha/base/logic/base_logic_data_type.dart';
import 'package:flosha/base/logic/base_logic_mixin.dart';
import 'package:flosha/base/state/base_form_state.dart';
import 'package:flosha/util/extension/form_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

abstract class BaseFormLogic<T> extends Cubit<BaseFormState<T>>
    with BaseLogicMixin {
  /// Base logic or controller class that handle your Form functionality
  /// Handle Form's state that wrap data with type of Object or [T]
  /// Write your business logic here and emit the necessary state to update UI with corresponding data
  BaseFormLogic(super.initialState) {
    onInit();
  }

  /// [formKey] is a key to track form's state and value
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// Getter to determine wether the result of Form's operation return data as an object or list
  BaseLogicDataType get dataType;

  /// Function to save Form's value into current state of the key
  void saveForm() => formKey.currentState?.save();

  /// Function to save Form's value into current state of the key and validate the Form's value with the available validators
  bool get saveAndValidateForm {
    final isSaveAndValidate = formKey.currentState?.saveAndValidate() ?? false;

    emit(
      state.copyWith(
        formData: formKey.value,
        errors: formKey.errors,
      ),
    );

    return isSaveAndValidate;
  }

  /// Getter to check wether Form's value is valid
  bool get isValid => formKey.currentState?.isValid ?? false;

  /// Getter to get Form's value
  Map<String, dynamic> get values => formKey.value;

  /// Getter to get Form's errors
  Map<String, String> get errors => formKey.errors;

  /// Overridable function that will be executed when logic class initialized for the first time
  void onInit() {}

  /// Invoke a **Loading** state
  void loading() {
    emit(state.copyWith(status: BaseStatus.loading));
  }

  /// Invoke a **Success** state
  /// Pass down the [data] with corresponding type [T]
  void success({T? data}) {
    emit(state.copyWith(status: BaseStatus.success, data: data));
  }

  /// Invoke a **Error** state
  /// Pass down the [errorTitle] and [errorMessage]
  void error({String? errorTitle, String? errorMessage}) {
    emit(
      state.copyWith(
        status: BaseStatus.error,
        errorTitle: errorTitle,
        errorMessage: errorMessage,
        errors: this.errors,
      ),
    );
  }

  /// Invoke a **Empty** state
  void empty() {
    emit(
      state.copyWith(
        status: BaseStatus.empty,
        data: dataType == BaseLogicDataType.object ? null : [],
      ),
    );
  }

  /// Function to populate initial data or value into Form's state
  void initialFormData(Map<String, dynamic> initialData) {
    emit(
      state.copyWith(
        status: BaseStatus.initial,
        formData: initialData,
        errors: {},
      ),
    );
  }
}
