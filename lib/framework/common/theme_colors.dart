import 'package:flutter/material.dart';

class LightThemeColors {
  static Color primaryColor = Colors.black;
  static Color primaryColorDark = Colors.white;
  static Color primaryColorLight = Colors.grey;
  static Color accentColor = Color(0xFF8BC741);
  static Color backgroundColor = Color(0xFFF5F5F5);
  static Color backgroundColor1 = Color(0xFF00000080);
  static Color zoomInOutTextColor = Colors.black.withOpacity(0.4);
  static Color buttonBorderColor = Colors.grey;
  static Color kColorLightBlue = Color(0xFFD2D8FF);
  static Color selectedTextColor = Colors.black;
  static Color secondaryTextColor =
      LightThemeColors.zoomInOutTextColor.withOpacity(0.7);
  static Color highlightedTextColor = Color.fromARGB(255, 255, 92, 92);
  static Color shimmerReceiverBackColor = Colors.white;
  static Color shimmerReceiverHighlightColor =
      Color.fromARGB(255, 221, 223, 221);
  static Color shimmerSenderHighlightColor = Color.fromARGB(255, 230, 232, 230);

  static Color newsBackgroundColor = primaryColorDark;
  static Color newsCardBackgroundColor = backgroundColor;
}

class DarkThemeColors {
  static Color primaryColor = Colors.white;
  static Color primaryColorDark = Colors.black;
  static Color primaryColorLight = Colors.white;
  static Color accentColor = Color(0xFFFFC502);
  static Color backgroundColor = Color(0xFF262324);
  static Color zoomInOutTextColor = Colors.white.withOpacity(0.7);
  static Color buttonBorderColor = Colors.white;

  static Color selectedTextColor = Colors.white;
  static Color secondaryTextColor =
      DarkThemeColors.zoomInOutTextColor.withOpacity(0.7);
  static Color highlightedTextColor = Color.fromARGB(255, 255, 92, 92);
  static Color shimmerReceiverBackColor = Color.fromARGB(255, 19, 19, 21);
  static Color shimmerReceiverHighlightColor = Color.fromARGB(255, 49, 49, 51);
  static Color shimmerSenderBackColor = Color.fromARGB(255, 60, 57, 58);
  static Color shimmerSenderHighlightColor = Color.fromARGB(255, 90, 87, 88);
  static Color kColorDarkBlue = Color(0xFF435eff);
  static Color newsBackgroundColor = Color(0xFF37373D);
  static Color newsCardBackgroundColor = Color(0xFF27272D);
}

const Color kColorLightOrange = Color(0xFFFFC081);
const Color kColorPink = Color(0xFFFC5192);
const Color kColorAlert = Color(0xFFFE5C5C);
const Color kColorDisabledPrimary = Color(0xAA00619E);
const Color kColorEnabledPrimary = Color(0xFF00619E);
const Color kColorDisabledWhite = Colors.white30;
const Color kColorLightBlue = Color(0xFF4A90E2);
const Color kColorDarkBlue = Color(0xFF435eff);
const Color kColorGreen = Colors.green;
const Color kColorRed = Colors.red;
const Color kColorHeader = Color(0xFFFF5C5C);

// Movie module colors
const Color kColorShowtimes = Color(0xFFFF00B1);

class WeatherPageColors {
  static const Color primaryBackground = Color.fromARGB(255, 36, 36, 43);
  static const Color dailyprimaryBackground = Color.fromARGB(124, 36, 36, 43);
  static const Color primaryText = Color.fromARGB(255, 255, 255, 255);
}

class AlarmPageColors {
  static const Color primaryText = Color.fromARGB(255, 255, 255, 255);
  static const Color secondaryText = Color.fromARGB(255, 254, 83, 94);
}

class MusicPageColors {
  static const Color greenColor = Color(0xffCCFF00);
  static const Color trackNotActiveColor = Color(0xffFFFFFF99);
  static const Color musicBgColor = Color(0xff262324);
}
