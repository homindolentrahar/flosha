import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

extension FormExt on GlobalKey<FormBuilderState> {
  Map<String, dynamic> get value => currentState?.value ?? {};
  Map<String, String> get errors => currentState?.errors ?? {};
}
