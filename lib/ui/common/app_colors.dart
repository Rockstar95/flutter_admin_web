import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/navigation_controller.dart';
import '../../framework/bloc/app/bloc/app_bloc.dart';

class AppColors {
  static AppBloc _appBloc({BuildContext? context}) => BlocProvider.of(context ?? NavigationController().mainNavigatorKey.currentContext!, listen: false);

  static Color getColorFromString(String color, {String defaultColor = "FFFFFF"}) {
    color = color.replaceAll("#", "");

    if(color.isNotEmpty) {
      int? value = int.tryParse("0xFF${color.toUpperCase()}");
      if(value == null) {
        color = defaultColor;
      }
    }
    else {
      color =  defaultColor;
    }

    return Color(int.parse("0xFF${color.toUpperCase()}"));
  }

  static Color getAppBGColor({BuildContext? context}) {
    return getColorFromString(_appBloc().uiSettingModel.appBGColor);
  }

  static Color getExpireBGColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.expiredBGColor);
  }

  static Color getAppTextColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.appTextColor);
  }

  static Color getAppLoginBGColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.appLoginBGColor);
  }

  static Color getAppButtonBGColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.appButtonBgColor);
  }

  static Color getMenuBGColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.menuBGColor);
  }

  static Color getMenuTextColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.menuTextColor);
  }

  static Color getSelectedMenuBGColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.selectedMenuBGColor);
  }

  static Color getSelectedMenuTextColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.selectedMenuTextColor);
  }

  static Color getMenuBGSelectTextColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.menuBGSelectTextColor);
  }

  static Color getAppHeaderColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.appHeaderColor);
  }

  static Color getMenuHeaderBGColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.menuHeaderBGColor);
  }

  static Color getAppHeaderTextColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.appHeaderTextColor);
  }

  static Color getMenuHeaderTextColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.menuHeaderTextColor);
  }

  static Color getMenuBGAlternativeColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.menuBGAlternativeColor);
  }

  static Color getFileUploadButtonColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.fileUploadButtonColor);
  }

  static Color getAppButtonTextColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.appButtonTextColor);
  }

  static Color getAppLogoBackgroundColor({BuildContext? context}) {
    return getColorFromString(_appBloc(context: context).uiSettingModel.appLogoBackgroundColor);
  }


  //Extra Colors
  static Color getNotificationCardFlashIconBackgroundColor() {
    return getColorFromString("#17628F");
  }

  static Color getNotificationCardFlashIconColor() {
    return getColorFromString("#FFFFFF");
  }

  static Color getNotificationCardSlideMarkAsReadColor() {
    return getColorFromString("#4A90E2");
  }

  static Color getNotificationCardSlideDeleteColor() {
    return getColorFromString("#C51825");
  }

  static Color getNotificationCardUnreadBGColor() {
    return getColorFromString("#F5F5F5");
  }

  static Color getNotificationCardBorderColor() {
    return getColorFromString("#E4E5E8");
  }

  static Color getProgressIndicatorColor() {
    return getColorFromString("#595959");
  }

  static Color getBorderColor() {
    return getColorFromString("#E1E1E1");
  }
  static Color getDisableBorderColor() {
    return getColorFromString("#DADCE0");
  }
  static Color getEnabledBorderColor() {
    return getColorFromString("#202124");
  }

  static Color getFilterIconColor() {
    return getColorFromString("#B5BBC6");
  }

  static Color getLinkColor() {
    return getColorFromString("#047BFE");
  }

  static Color getContentStatusTagColor() {
    return getColorFromString("#047BFE");
  }
  static Color getSiteBrandingLinkColor() {
    return getColorFromString("#3498db");
  }

  static Color getMandatoryStarColor() {
    return Colors.red;
  }

  static Color getTextFieldHintColor() {
    return getAppTextColor().withOpacity(0.7);
  }

  static Color getTextFieldBorderColor() {
    return getAppTextColor().withOpacity(0.2);
  }
}