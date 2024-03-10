import 'package:flosha/flosha.dart';

class BaseStateObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    LoggerHelper.create().trace("${bloc.runtimeType.toString()}::-> Created");
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    LoggerHelper.create().trace(
      "${bloc.runtimeType.toString()}::-> State Changes: {From: ${change.currentState.status}, To: ${change.nextState.status}}",
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    LoggerHelper.create().trace("${bloc.runtimeType.toString()}::-> Closed");
  }
}
