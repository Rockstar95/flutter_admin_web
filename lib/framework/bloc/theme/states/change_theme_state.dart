import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/theme/base_theme.dart';

class ChangeThemeState {
  final ThemeData themeData;
  final ThemeType type;
  bool isDarkTheme = false;

  ChangeThemeState({required this.themeData, this.type = ThemeType.Light}) {
    this.isDarkTheme = themeData.brightness == Brightness.light;
  }

  factory ChangeThemeState.lightTheme(
      {ThemeModuleType moduleType = ThemeModuleType.Common,
      ThemeType type = ThemeType.Light}) {
    return ChangeThemeState(
      themeData: getModuleLightTheme(moduleType),
      type: type,
    );
  }

  factory ChangeThemeState.darkTheme(
      {ThemeModuleType moduleType = ThemeModuleType.Common,
      ThemeType type = ThemeType.Dark}) {
    return ChangeThemeState(
      themeData: getModuleDarkTheme(moduleType),
      type: type,
    );
  }
}
