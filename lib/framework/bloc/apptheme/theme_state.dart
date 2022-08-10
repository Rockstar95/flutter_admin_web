import 'package:flutter_admin_web/framework/common/api_state.dart';

class ThemeState extends ApiState {
  ThemeState.completed(data) : super.completed(data);

  ThemeState.loading(data) : super.loading(data);

  ThemeState.error(data) : super.error(data);

  @override
  List<Object> get props => [];
}

class IntitialThemeStateState extends ThemeState {
  IntitialThemeStateState.completed(data) : super.completed(data);
}

class ChangeThemeState extends ThemeState {
  bool isDarkTheme = false;

  ChangeThemeState.loading(data) : super.loading(data);

  ChangeThemeState.completed(this.isDarkTheme) : super.completed(isDarkTheme);
}
