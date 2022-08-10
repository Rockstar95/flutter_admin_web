import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/common/theme_colors.dart';

import 'base_theme.dart';
import 'ins_theme.dart';

class AppDarkTheme extends BaseTheme {
  static final AppDarkTheme _instance = AppDarkTheme._();

  AppDarkTheme._();

  factory AppDarkTheme() => _instance;

  @override
  Color get primaryColor => LightThemeColors.primaryColor;

  @override
  Color get accentColor => LightThemeColors.accentColor;

  @override
  Brightness get brightness => Brightness.dark;

  @override
  ThemeData get darkTheme {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
        textTheme: InsTheme().textTheme,
        primaryTextTheme: InsTheme().textTheme,
        accentTextTheme: InsTheme().textTheme,
        brightness: brightness,
        primaryColor: DarkThemeColors.primaryColor,
        accentColor: DarkThemeColors.accentColor,
        primaryColorDark: DarkThemeColors.primaryColorDark,
        primaryColorLight: DarkThemeColors.primaryColorLight,
        canvasColor: DarkThemeColors.primaryColorDark.withOpacity(0.4),
        // Card background
        disabledColor: DarkThemeColors.zoomInOutTextColor,
        dialogBackgroundColor: Colors.grey.shade200.withOpacity(0.2),
        backgroundColor: DarkThemeColors.backgroundColor,
        highlightColor: DarkThemeColors.shimmerReceiverBackColor,
        splashColor: DarkThemeColors.shimmerSenderBackColor,
        hoverColor: DarkThemeColors.shimmerReceiverHighlightColor,
        focusColor: DarkThemeColors.shimmerSenderHighlightColor,
        scaffoldBackgroundColor: DarkThemeColors.newsBackgroundColor,
        cardColor: DarkThemeColors.newsCardBackgroundColor,
        cursorColor: DarkThemeColors.primaryColor);
  }

  @override
  Color get darkAccentColor => Colors.black;

  @override
  Color get darkPrimaryColor => Colors.blue;

  @override
  ThemeData get lightTheme => ThemeData.light();

  @override
  // TODO: implement buttonBorderColor
  Color get buttonBorderColor => DarkThemeColors.buttonBorderColor;
}
