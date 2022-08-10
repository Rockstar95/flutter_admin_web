import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();
}

class GetFourApiCallEvent extends SplashEvent {
  GetFourApiCallEvent();

  @override
  List<Object> get props => [];
}

class GetAppLogoEvent extends SplashEvent {
  GetAppLogoEvent();

  @override
  List<Object> get props => [];
}
