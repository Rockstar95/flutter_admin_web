import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  @override
  List<Object> get props => [];
}

class IntitialSplashState extends SplashState {}

class GetFourApiCallState extends SplashState {
  final bool isSuccess;

  GetFourApiCallState({this.isSuccess = false});
}

class GetAppLogoState extends SplashState {
  final String url;

  GetAppLogoState({this.url = ""});
}
