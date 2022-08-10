import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/events/app_event.dart';
import 'package:flutter_admin_web/framework/bloc/preference/bloc/preference_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/preference/event/preference_event.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/user_profile_setting_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/state/preference_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/feedback/feedback_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/preference/preference_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';

import '../common/outline_button.dart';

class PreferenceScreen extends StatefulWidget {
  PreferenceScreen();

  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late PreferenceBloc preferenceBloc;

  FeedbackRepository? feedbackRepository;

  String _timezone = '';

  //List<String> _langKnown = ['English', 'Thai'];
  String _currentLang = '';
  int activities = 0;
  late FToast flutterToast;

  @override
  void initState() {
    super.initState();
    flutterToast = FToast();
    preferenceBloc = PreferenceBloc(
        preferenceRepository: PreferenceRepositoryBuilder.repository());

    preferenceBloc.isFirstLoading = true;

    preferenceBloc.add(GetProfileSettingResponseEvent());
    preferenceBloc.add(GetTimeZoneResponseEvent());
    getLanguage();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    flutterToast.init(context);

    return Container(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "Preferences",
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
            ),
            backgroundColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
              ),
            ),
            actions: <Widget>[],
          ),
          body: BlocConsumer<PreferenceBloc, PreferenceState>(
            bloc: preferenceBloc,
            listener: (context, state) {
              if (state.status == Status.ERROR) {
                if (state.message == "401") {
                  AppDirectory.sessionTimeOut(context);
                }
              }
              if (preferenceBloc.isFirstLoading == false &&
                  state.data == "Success") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Preference Saved Successfully'),
                  ),
                );

                Future.delayed(Duration(seconds: 1)).then((value) {
                  Navigator.pop(context);
                });

                //Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (preferenceBloc.isFirstLoading == true) {
                return Container(
                  child: Center(
                    child: AbsorbPointer(
                      child: SpinKitCircle(
                        color: Colors.grey,
                        size: 70,
                      ),
                    ),
                  ),
                );
              }
              AcSetting? timeZoneSettings = preferenceBloc
                  .userProfileSettings.acSettings
                  .firstWhere((element) => element.dataFieldName == 'TimeZone');
              AcSetting? langSelectionSettings = preferenceBloc
                  .userProfileSettings.acSettings
                  .firstWhere((element) =>
                      element.dataFieldName == 'LanguageSelection');
              AcSetting? userLangSettings =
                  preferenceBloc.userProfileSettings.acSettings.firstWhere(
                      (element) => element.dataFieldName == 'UserLanguage');

              this.activities =
                  preferenceBloc.userProfileSettings.userLrsActivities;
              return Column(
                children: <Widget>[
                  const SizedBox(height: 7),
                  /*//TODO: Timezone
                  Visibility(
                    visible: timeZoneSettings.visible,
                    child: Column(
                      children: [
                        SmartSelect<String>.single(
                          modalHeaderStyle: S2ModalHeaderStyle(
                              textStyle: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              backgroundColor: InsColor(appBloc).appBGColor),
                          modalStyle: S2ModalStyle(
                              backgroundColor: InsColor(appBloc).appBGColor),
                          choiceStyle: S2ChoiceStyle(
                              titleStyle: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              subtitleStyle: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              activeColor: InsColor(appBloc).appTextColor,
                              color: InsColor(appBloc).appTextColor),
                          choiceHeaderStyle:
                              S2ChoiceHeaderStyle(backgroundColor: Colors.red),
                          title: timeZoneSettings.displaytext,
                          value: preferenceBloc.userProfileSettings != null
                              ? preferenceBloc.userProfileSettings.timeZone
                              : '',
                          choiceItems: preferenceBloc.timezoneList
                              .map((e) =>
                                  S2Choice(value: e.tid, title: e.displayName))
                              .toList(),
                          onChange: (state) => setState(() {
                            if (state == null) {
                              return;
                            }
                            preferenceBloc.userProfileSettings.timeZone =
                                state.value;
                            _timezone = state.valueTitle;
                          }),
                          modalType: S2ModalType.bottomSheet,
                          tileBuilder: (context, state) {
                            //S2Tile(title: ,)
                            return S2Tile.fromState(
                              state,
                              isTwoLine: true,
                              value: _timezone == ''
                                  ? (preferenceBloc.userProfileSettings != null
                                      ? preferenceBloc
                                          .userProfileSettings.timeZone
                                      : _timezone)
                                  : _timezone,
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                timeZoneSettings.displaytext,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.apply(color: InsColor(appBloc).appTextColor),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          indent: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  //TODO: UserLanguage
                  Visibility(
                    visible: userLangSettings.visible,
                    child: Column(
                      children: [
                        SmartSelect<String>.multiple(
                          modalHeaderStyle: S2ModalHeaderStyle(
                              actionsIconTheme: IconThemeData(
                                  color: InsColor(appBloc).appTextColor),
                              textStyle: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              backgroundColor: InsColor(appBloc).appBGColor),
                          modalStyle: S2ModalStyle(
                              backgroundColor: InsColor(appBloc).appBGColor),
                          choiceStyle: S2ChoiceStyle(
                              titleStyle: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              subtitleStyle: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              activeColor: InsColor(appBloc).appTextColor,
                              color: InsColor(appBloc).appTextColor),
                          title: userLangSettings.displaytext,
                          value: preferenceBloc
                                      .userProfileSettings.userLanguage ==
                                  ''
                              ? []
                              : preferenceBloc.userProfileSettings.userLanguage
                                  .split(','),
                          modalConfirm: true,
                          choiceItems: appBloc.uiSettingModel.localeList
                              .map((e) => S2Choice(
                                  value: e.locale, title: e.languagename))
                              .toList(),
                          modalType: S2ModalType.bottomSheet,
                          onChange: (state) => setState(() {
                            if (state == null) {
                              return;
                            }
                            //print('state.value' + state.value.toString());
                            setState(() {
                              preferenceBloc.userProfileSettings.userLanguage =
                                  state.value.join(",");
                              //state.value.join(",");
                            });

                            //_timezone = state.value
                          }),
                          tileBuilder: (context, state) {
                            return S2Tile.fromState(
                              state,
                              isTwoLine: true,
                              title: Text(
                                userLangSettings.displaytext,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.apply(color: InsColor(appBloc).appTextColor),
                              ),
                              value: _getKnownLanguages(preferenceBloc),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Icon(
                                  Icons.language,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          indent: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  //TODO: Language Selection
                  Visibility(
                    visible: langSelectionSettings.visible,
                    child: Column(
                      children: [
                        SmartSelect<String>.single(
                          modalHeaderStyle: S2ModalHeaderStyle(
                              actionsIconTheme: IconThemeData(
                                  color: InsColor(appBloc).appTextColor),
                              textStyle: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              backgroundColor: InsColor(appBloc).appBGColor),
                          modalStyle: S2ModalStyle(
                              backgroundColor: InsColor(appBloc).appBGColor),
                          choiceStyle: S2ChoiceStyle(
                              titleStyle: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              subtitleStyle: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              activeColor: InsColor(appBloc).appTextColor,
                              color: InsColor(appBloc).appTextColor),
                          title: langSelectionSettings.displaytext,
                          value: _currentLang == "" ? "" : _currentLang,
                          //value: preferenceBloc.userProfileSettings != null
                          //     ? preferenceBloc.userProfileSettings.languageName
                          //     : '',
                          choiceItems: appBloc.uiSettingModel.localeList
                              .map((e) => S2Choice(
                                  value: e.locale, title: e.languagename))
                              .toList(),
                          modalType: S2ModalType.bottomSheet,
                          onChange: (state) => setState(() {
                            if (state == null) {
                              return;
                            }

                            _currentLang = state.valueTitle;
                            preferenceBloc.userProfileSettings
                                .languageSelection = state.value;
                            preferenceBloc.userProfileSettings.languageName =
                                state.valueTitle;
                          }),
                          choiceConfig: S2ChoiceConfig(
                              headerStyle: S2ChoiceHeaderStyle(
                                  textStyle: TextStyle(
                                      color: InsColor(appBloc).appTextColor))),
                          tileBuilder: (context, state) {
                            return S2Tile.fromState(
                              state,
                              isTwoLine: true,
                              title: Text(
                                langSelectionSettings.displaytext,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.apply(color: InsColor(appBloc).appTextColor),
                              ),
                              value: "App is set to $_currentLang",
                              leading: const CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.language_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          indent: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.amber,
                          child: Icon(
                            Icons.local_activity_outlined,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Activities',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      ?.apply(
                                          color:
                                              InsColor(appBloc).appTextColor),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Show my activities to all my connections',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.apply(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Switch(
                            activeColor: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                            value: preferenceBloc
                                    .userProfileSettings.userLrsActivities ==
                                1,
                            onChanged: (val) {
                              print(val);
                              setState(() {
                                activities = val ? 1 : 0;
                                preferenceBloc.userProfileSettings
                                    .userLrsActivities = activities;
                              });
                            })
                      ],
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Divider(
                    indent: 20,
                    color: Colors.grey,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: OutlineButton(
                            border: Border.all(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                            child: Text(
                                appBloc.localstr
                                    .achievementsAlertbuttonCancelbutton,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: MaterialButton(
                            disabledColor: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                .withOpacity(0.5),
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                            child: Text(
                                appBloc.localstr.catalogButtonSavebuttontitle,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                            onPressed: () async {
                              var userProfile = guard(
                                  () => preferenceBloc.userProfileSettings,
                                  defaultValue: UserProfileSettingResponse(
                                      languagedata: [], acSettings: []));

                              //print('activities' + activities.toString());
                              preferenceBloc.add(PostPreferenceEvent(
                                  userProfile.timeZone,
                                  userProfile.languageSelection,
                                  userProfile.userLanguage,
                                  activities));

                              appBloc.add(ChangeLanEvent(
                                  lanCode: userProfile.languageSelection));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> getLanguage() async {
    var language = await sharePrefGetString(sharedPref_AppLocale);
    setState(() {
      _currentLang = language;
    });
  }

  String _getKnownLanguages(PreferenceBloc preferenceBloc) {
    //print()
    if (preferenceBloc.userProfileSettings == null) {
      return '';
    }
    this.activities = preferenceBloc.userProfileSettings.userLrsActivities;

    var userLang = preferenceBloc.userProfileSettings.userLanguage;
    List<String> langNames = [];

    if (userLang.contains(',') || userLang.length > 1) {
      for (var item in userLang.split(',')) {
        //print(item);
        var sd = preferenceBloc.userProfileSettings.languagedata
            .where((e) => e.loceid == item);
        if (sd.length > 0) {
          langNames.add(sd.first.languagename);
        }
      }
      return langNames.join(",");
    }

    return '';
  }
}

T guard<T>(T Function() callback, {required T defaultValue}) {
  T? result;

  try {
    result = callback();
  } catch (err) {}

  return result ?? defaultValue;
}

Future<T> asyncGuard<T>(Future<T> Function() callback,
    {required T defaultValue}) async {
  T? result;

  try {
    result = await callback();
  } catch (err) {}

  return result ?? defaultValue;
}
