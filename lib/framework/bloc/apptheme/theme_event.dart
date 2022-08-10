import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ChangeThemeEvent extends ThemeEvent {
  final bool isDarkTheme;

  ChangeThemeEvent(this.isDarkTheme);

  @override
  List<Object> get props => [isDarkTheme];
}
