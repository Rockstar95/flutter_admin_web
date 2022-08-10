import 'package:flutter_admin_web/framework/common/enums.dart';

abstract class ChangeThemeEvent {
  ThemeModuleType type;
  ThemeType themeType;

  ChangeThemeEvent(this.type, this.themeType);
}

class DecideTheme extends ChangeThemeEvent {
  DecideTheme(ThemeModuleType type, ThemeType themeType)
      : super(type, themeType);

  @override
  String toString() => 'Dedicate Theme $type';
}

class LightTheme extends ChangeThemeEvent {
  LightTheme(ThemeModuleType type, ThemeType themeType)
      : super(type, themeType);

  @override
  String toString() => 'LightTheme';
}

class DarkTheme extends ChangeThemeEvent {
  DarkTheme(ThemeModuleType type, ThemeType themeType) : super(type, themeType);

  @override
  String toString() => 'DarkTheme';
}
