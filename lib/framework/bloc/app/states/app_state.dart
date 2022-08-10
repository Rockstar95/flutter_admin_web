import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/app/ui_setting_model.dart';
import 'package:flutter_admin_web/framework/common/local_str.dart';

// TODO: Need to check merge API and the normal state
class AppState {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppApiStatus {
  List<Object> get props => [];
}

class AppInitialized extends AppState {
  final Locale? appLocale;

  const AppInitialized({this.appLocale});
}

class ShowDomainPageState extends AppState {}

class CheckingInitAppDataState extends AppState {
  const CheckingInitAppDataState();

  @override
  List<Object> get props => [];
}

class IsNotConnected extends AppState {}

class UserLocation extends AppState {
  final double latitude;
  final double longitude;
  final String timeZone;
  final String updatedAt;

  const UserLocation(
      {this.latitude = 0,
      this.longitude = 0,
      this.timeZone = "",
      this.updatedAt = ""});
}

class SetUiSettingState extends AppState {
  final UISettingModel uiSettingModel;
  final List<NativeMenuModel> nativeMenuModelList;
  final LocalStr localstr;

  const SetUiSettingState(
      this.uiSettingModel, this.nativeMenuModelList, this.localstr);
}

class ChangeLangState extends AppState {
  final Locale appLocale;
  final LocalStr localstr;

  const ChangeLangState({required this.appLocale, required this.localstr});
}

class ProfileImageState extends AppState {
  final String imgUrl;

  const ProfileImageState({this.imgUrl = ""});
}

class NotificationCountState extends AppState {
  NotificationCountState();

  @override
  List<Object> get props => [];
}

class WishlistCountState extends AppState {
  WishlistCountState();

  @override
  List<Object> get props => [];
}
