import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/apptheme/theme_event.dart';
import 'package:flutter_admin_web/framework/bloc/apptheme/theme_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  AppBloc appBloc;

  ThemeBloc(dynamic data, this.appBloc) : super(ThemeState.completed(data)) {
    on<ChangeThemeEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(ThemeEvent event, Emitter emit) async {
    print("ThemeBloc onEventHandler called for ${event.runtimeType}");
    Stream<ThemeState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (ThemeState authState) {
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

  @override
  // TODO: implement initialState
  ThemeState get initialState => IntitialThemeStateState.completed('data');

  @override
  Stream<ThemeState> mapEventToState(event) async* {
    try {
      if (event is ChangeThemeEvent) {
        yield ChangeThemeState.loading("data");
        if (event.isDarkTheme) {
          setDarkTheme();
        } else {
          setDefaultTheme();
        }
        yield ChangeThemeState.completed(true);
      }
    } catch (e) {
      print("Error in ThemeBloc.mapEventToState():$e");
    }
  }

  Future<void> setDarkTheme() async {
    sharePrefSaveString(setappBGColor, appBloc.uiSettingModel.appBGColor);

    sharePrefSaveString(
        setappLoginBGColor, appBloc.uiSettingModel.appLoginBGColor);

    sharePrefSaveString(setappTextColor, appBloc.uiSettingModel.appTextColor);

    sharePrefSaveString(
        setappLoginTextolor, appBloc.uiSettingModel.appLoginTextolor);

    sharePrefSaveString(
        setappHeaderColor, appBloc.uiSettingModel.appHeaderColor);

    sharePrefSaveString(
        setappHeaderTextColor, appBloc.uiSettingModel.appHeaderTextColor);

    sharePrefSaveString(setmenuBGColor, appBloc.uiSettingModel.menuBGColor);

    sharePrefSaveString(
        setmenuTextColor, appBloc.uiSettingModel.menuTextColor);

    sharePrefSaveString(
        setselectedMenuBGColor, appBloc.uiSettingModel.selectedMenuBGColor);

    sharePrefSaveString(
        setselectedMenuTextColor, appBloc.uiSettingModel.selectedMenuTextColor);

    // sharePref_saveString(
    //     setappButtonBgColor, appBloc.uiSettingModel.appButtonBgColor);
    //
    // sharePref_saveString(
    //     setappButtonTextColor, appBloc.uiSettingModel.appButtonTextColor);

    appBloc.uiSettingModel.setappBGColor("#332940");
    appBloc.uiSettingModel.setappLoginBGColor("#f5f5f5");

    appBloc.uiSettingModel.setappTextColor("#f5f5f5");
    appBloc.uiSettingModel.setappLoginTextolor("#f5f5f5");

    appBloc.uiSettingModel.setappHeaderColor("#292134");
    appBloc.uiSettingModel.setappHeaderTextColor("#f5f5f5");

    appBloc.uiSettingModel.setmenuBGColor("#352b44");
    appBloc.uiSettingModel.setmenuTextColor("#f5f5f5");

    appBloc.uiSettingModel.setselectedMenuBGColor("#5a4973");
    appBloc.uiSettingModel.setselectedMenuTextColor("#f5f5f5");
    appBloc.uiSettingModel.setExpiredBGColor("#352b44");

    print("setDarkTheme");
  }

  Future<void> setDefaultTheme() async {
    appBloc.uiSettingModel
        .setappBGColor(await sharePrefGetString(setappBGColor));
    appBloc.uiSettingModel
        .setappLoginBGColor(await sharePrefGetString(setappLoginBGColor));
    appBloc.uiSettingModel
        .setappTextColor(await sharePrefGetString(setappTextColor));
    appBloc.uiSettingModel
        .setappLoginTextolor(await sharePrefGetString(setappLoginTextolor));
    appBloc.uiSettingModel
        .setappHeaderColor(await sharePrefGetString(setappHeaderColor));
    appBloc.uiSettingModel.setappHeaderTextColor(
        await sharePrefGetString(setappHeaderTextColor));
    appBloc.uiSettingModel
        .setmenuBGColor(await sharePrefGetString(setmenuBGColor));
    appBloc.uiSettingModel
        .setmenuTextColor(await sharePrefGetString(setmenuTextColor));
    appBloc.uiSettingModel.setselectedMenuBGColor(
        await sharePrefGetString(setselectedMenuBGColor));
    appBloc.uiSettingModel.setselectedMenuTextColor(
        await sharePrefGetString(setselectedMenuTextColor));
    appBloc.uiSettingModel.setExpiredBGColor("#b3b0b8");
  }
}

// class AppThemeChange  {
//   static Future<int> _saveOptionValue(int optionValue) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setInt('theme_option', optionValue);
//   }
//
//   static Future<int> getOption() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     int option = preferences.get('theme_option') ?? 0;
//     return option;
//   }
//
//   static Future<int> setDarkTheme() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     int option = preferences.get('theme_option') ?? 0;
//     return option;
//   }
//
//   static Future<int> setDefaultTheme() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     int option = preferences.get('theme_option') ?? 0;
//     return option;
//   }
// }
