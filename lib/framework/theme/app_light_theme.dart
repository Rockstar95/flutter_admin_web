import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/common/theme_colors.dart';

import 'base_theme.dart';
import 'ins_theme.dart';

class AppLightTheme extends BaseTheme {
  static final AppLightTheme _instance = AppLightTheme._();

  AppLightTheme._();

  factory AppLightTheme() => _instance;

  @override
  Color get primaryColor => LightThemeColors.primaryColor;

  @override
  Color get accentColor => LightThemeColors.accentColor;

  @override
  Brightness get brightness => Brightness.light;

  @override
  ThemeData get lightTheme {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
        textTheme: InsTheme().textTheme,
        primaryTextTheme: InsTheme().textTheme,
        accentTextTheme: InsTheme().textTheme,
        brightness: brightness,
        primaryColor: primaryColor,
        accentColor: accentColor,
        primaryColorDark: LightThemeColors.primaryColorDark,
        primaryColorLight: LightThemeColors.primaryColorLight,
        canvasColor: LightThemeColors.primaryColorDark,
        // Card background
        disabledColor: LightThemeColors.zoomInOutTextColor,
        dialogBackgroundColor: Colors.grey.shade200.withOpacity(0.2),
        backgroundColor: LightThemeColors.backgroundColor,
        highlightColor: LightThemeColors.primaryColorDark.withOpacity(0.5),
        hoverColor: LightThemeColors.primaryColor.withOpacity(0.7),
        splashColor: LightThemeColors.primaryColorDark.withOpacity(0.5),
        focusColor: LightThemeColors.primaryColor.withOpacity(0.7),
        scaffoldBackgroundColor: LightThemeColors.newsBackgroundColor,
        cardColor: LightThemeColors.newsCardBackgroundColor,
        cursorColor: LightThemeColors.primaryColor);
  }

  @override
  Color get darkAccentColor => Colors.black;

  @override
  Color get darkPrimaryColor => Colors.blue;

  @override
  ThemeData get darkTheme => ThemeData.dark();

  @override
  Color get buttonBorderColor => LightThemeColors.buttonBorderColor;
}
