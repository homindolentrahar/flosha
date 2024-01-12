import 'package:equatable/equatable.dart';
import 'package:flosha/base/base_status.dart';

abstract class BaseState extends Equatable {
  final BaseStatus status;
  final String errorTitle;
  final String errorMessage;
  final dynamic data;

  const BaseState({
    required this.status,
    required this.errorTitle,
    required this.errorMessage,
    required this.data,
  });

  @override
  List<Object?> get props => [status, errorTitle, errorMessage, data];
}
