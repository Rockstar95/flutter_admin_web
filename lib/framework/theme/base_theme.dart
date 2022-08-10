import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';

import 'app_dark_theme.dart';
import 'app_light_theme.dart';
import 'ins_theme.dart';

abstract class BaseTheme {
  Brightness brightness = Brightness.light;

  Color get primaryColor;

  Color get darkPrimaryColor;

  Color get accentColor;

  Color get darkAccentColor;

  Color get buttonBorderColor;

  ThemeData get lightTheme;

  ThemeData get darkTheme;
}

ThemeData getModuleLightTheme(ThemeModuleType moduleType) {
  return AppLightTheme().lightTheme.copyWith(
        textTheme: InsTheme().textTheme,
        primaryTextTheme: InsTheme().textTheme,
        accentTextTheme: InsTheme().textTheme,
      );
}

ThemeData getModuleDarkTheme(ThemeModuleType moduleType) {
  return AppDarkTheme().darkTheme;
}
