import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/events/change_theme_event.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/theme/app_light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ChangeThemeBloc changeThemeBloc = ChangeThemeBloc()
  ..onDecideThemeChange();

class ChangeThemeBloc extends Bloc<ChangeThemeEvent, ChangeThemeState> {
  static ChangeThemeBloc of(BuildContext context) =>
      BlocProvider.of<ChangeThemeBloc>(context);
  ThemeModuleType moduleType;
  ThemeType themeType;

  ChangeThemeBloc(
      {this.moduleType = ThemeModuleType.Common,
      this.themeType = ThemeType.Light})
      : super(ChangeThemeState.lightTheme()) {
    on<DecideTheme>(onEventHandler);
    on<LightTheme>(onEventHandler);
    on<DarkTheme>(onEventHandler);
  }

  FutureOr<void> onEventHandler(ChangeThemeEvent event, Emitter emit) async {
    print("ChangeThemeBloc onEventHandler called for ${event.runtimeType}");
    Stream<ChangeThemeState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (ChangeThemeState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  void onLightThemeChange() {
    print("moduleType $moduleType");
    add(LightTheme(moduleType, ThemeType.Light));
  }

  void onDarkThemeChange() => add(DarkTheme(moduleType, ThemeType.Dark));

  void onDecideThemeChange() => add(DecideTheme(moduleType, themeType));

  @override
  ChangeThemeState get initialState =>
      ChangeThemeState(themeData: AppLightTheme().lightTheme);

  @override
  Stream<ChangeThemeState> mapEventToState(ChangeThemeEvent event) async* {
    print("Modül tpe is $moduleType");
    if (event is DecideTheme) {
      final int optionValue = await getOption();
      if (optionValue == 0) {
        yield ChangeThemeState.darkTheme(
          moduleType: moduleType,
        );
      } else if (optionValue == 1) {
        yield ChangeThemeState.lightTheme(
          moduleType: moduleType,
        );
      }
    } else if (event is LightTheme) {
      yield ChangeThemeState.lightTheme(
        moduleType: moduleType,
      );
      try {
        _saveOptionValue(1);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    } else if (event is DarkTheme) {
      yield ChangeThemeState.darkTheme(
        moduleType: moduleType,
      );
      try {
        _saveOptionValue(0);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }
  }

  Future<Null> _saveOptionValue(int optionValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('theme_option', optionValue);
  }

  Future<int> getOption() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    int option = (preferences.get('theme_option') ?? 1) as int;
    return option;
  }
}
