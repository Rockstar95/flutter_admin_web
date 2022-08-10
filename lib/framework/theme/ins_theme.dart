import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';

//Important : Don't Modify
class InsTheme {
  static String fontFamily = "Roboto";

  TextTheme textTheme = TextTheme(
    headline1: TextStyle(
        fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.normal),
    //NavigationBar , Header Title
    headline2: TextStyle(
        fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.normal),
    //Alert Message/Title, BottomSheet Title
    headline3: TextStyle(
        fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600),
    // headline4: ,
    // headline5: ,
    // headline6: ,
    caption: TextStyle(
        color: Colors.black,
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500),
    //ContentTitle
    subtitle1: TextStyle(
        fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.normal),
    subtitle2: TextStyle(
        fontFamily: fontFamily, fontSize: 13, fontWeight: FontWeight.normal),
    bodyText1: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Color.fromRGBO(0, 0, 0, 54)),
    // All Body Content with gray color
    //bodyText2: ,
    button: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    //overline: ,
  );
}

class InsColor {
  final AppBloc appBloc;

  InsColor(this.appBloc);

  Color get appTextColor => Color(int.parse(
      "0xFF${appBloc.uiSettingModel.appTextColor.isNotEmpty ? appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase() : "000000"}"));

  Color get appBGColor => Color(int.parse(
      "0xFF${appBloc.uiSettingModel.appBGColor.isNotEmpty ? appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase() : "000000"}"));

  Color get appIconColor => Color(int.parse(
      "0xFF${appBloc.uiSettingModel.appTextColor.isNotEmpty ? appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase() : "000000"}"));

  Color get appBtnTextColor => Color(int.parse(
      "0xFF${appBloc.uiSettingModel.appButtonTextColor.isNotEmpty ? appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase() : "000000"}"));

  Color get appBtnBgColor => Color(int.parse(
      "0xFF${appBloc.uiSettingModel.appButtonBgColor.isNotEmpty ? appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase() : "000000"}"));

  Color get appHeaderTxtColor => Color(int.parse(
      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.isNotEmpty ? appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase() : "000000"}"));
}
