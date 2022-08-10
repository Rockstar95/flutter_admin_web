import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/events/app_event.dart';
import 'package:flutter_admin_web/framework/bloc/preference/bloc/preference_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/preference/event/preference_event.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/membership_plan_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/membership_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/state/preference_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/preference/preference_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Setting/payment_history.dart';
import 'package:flutter_admin_web/ui/auth/login_common_page.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/splash/splash_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/outline_button.dart';
import 'Privacyinfo.dart';

class RadioModel {
  bool isSelected;
  String title;
  int memberShipDurationID;
  String productId;

  RadioModel(this.isSelected, this.title, this.memberShipDurationID, this.productId);
}

class SiteSetting extends StatefulWidget {
  final Function refresh;
  final bool isHome;

  const SiteSetting(this.refresh, this.isHome);

  @override
  State<SiteSetting> createState() => _SiteSettingState();
}

class _SiteSettingState extends State<SiteSetting> {
  TextEditingController _controler = new TextEditingController();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late PreferenceBloc preferenceBloc;

  String _character = "";
  bool isLoading = false;
  late FToast flutterToast;
  bool _isLoadedPaymentGateway = false;

  List<RadioModel> planData = [];

  bool isSwitched = false;

  bool privacyboolvalue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controler.text = ApiEndpoints.strSiteUrl;

    preferenceBloc = PreferenceBloc(
        preferenceRepository: PreferenceRepositoryBuilder.repository());

    preferenceBloc.isFirstLoading = true;

    preferenceBloc.add(GetActiveMembershipEvent());

    preferenceBloc.add(GetMembershipPlanResponseEvent());

    getThemetype();

    getLanguage();
  }

  getThemetype() async {
    var switchStr = await sharePrefGetString(savedTheme);

    switchStr == "true" ? isSwitched = true : isSwitched = false;
    print("object $isSwitched");
    // isSwitched ? setDarkTheme() : setDefaultTheme();
  }

  saveThemetype([bool toggle = false]) async {
    sharePrefSaveString(savedTheme, toggle ? "true" : "false");
  }

  void setDarkTheme(bool beforeLogin) {
    saveThemetype(true);

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

    //appBloc.uiSettingModel.setmenuBGColor("#f5f5f5");
    //appBloc.uiSettingModel.setmenuTextColor("#352b44");

    appBloc.uiSettingModel.setmenuBGColor("#352b44");
    appBloc.uiSettingModel.setmenuTextColor("#f5f5f5");

    appBloc.uiSettingModel.setselectedMenuBGColor("#5a4973");
    appBloc.uiSettingModel.setselectedMenuTextColor("#f5f5f5");

    // appBloc.uiSettingModel.setappButtonBgColor("#201a28");
    // appBloc.uiSettingModel.setappButtonTextColor("#f5f5f5");
    appBloc.uiSettingModel.setExpiredBGColor("#352b44");

    beforeLogin ? moveToSplashScreen() : print("beforeLogin: $beforeLogin");

    // Future.delayed(Duration(seconds: )).then((value) {
    //   // setState(() {
    //   //   isLoading = true;
    //   // });
    // });
    widget.refresh();
  }

  setDefaultTheme(bool beforeLogin) async {
    saveThemetype(false);
    // String setappBGColor = "SETAPPBGCOLOR";
    // String setappLoginBGColor = "SETAPPLOGINBGCOLOR";
    // String setappTextColor = "SETAPPTEXTCOLOR";
    // String setappLoginTextolor = "SETAPPLOGINTEXTOLOR";
    // String setappHeaderColor = "SETAPPHEADERCOLOR";
    // String setappHeaderTextColor = "SETAPPHEADERTEXTCOLOR";
    // String setmenuBGColor = "SETMENUBGCOLOR";
    // String setmenuTextColor = "SETMENUTEXTCOLOR";
    // String setselectedMenuBGColor = "SETSELECTEDMENUBGCOLOR";
    // String setselectedMenuTextColor = "SETSELECTEDMENUTEXTCOLOR";
    // String setappButtonBgColor = "SETAPPBUTTONBGCOLOR";
    // String setappButtonTextColor = "SETAPPBUTTONTEXTCOLOR";

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

    beforeLogin ? moveToSplashScreen() : print("beforeLogin: $beforeLogin");
    appBloc.uiSettingModel.setExpiredBGColor("#b3b0b8");

    widget.refresh();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build;
    print("locally list ${appBloc.uiSettingModel.localeList.length}");

    // //sreekanth commented
    // String addprofileaddition = appBloc.uiSettingModel.AddProfileAdditionalTab;
    // List<String> addpr = addprofileaddition.split(",");
    // for (int i = 0; i < addpr.length; i++) {
    //   if (addpr[i] == 'privacy') {
    //     privacyboolvalue = true;
    //   }
    // }

    //basicDeviceHeightWidth(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    print("isHome:${widget.isHome}");

    return widget.isHome
        ? Scaffold(
            body: WillPopScope(
              onWillPop: () => isLoading ? Future.value(false) : Future.value(true),
              child: Stack(
                children: <Widget>[
                  Container(
                    color: InsColor(appBloc).appBGColor,
                    // padding: EdgeInsets.symmetric(
                    //     horizontal: ScreenUtil().setSp(20)),
                    width: MediaQuery.of(context).size.width,
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(5, 8, 8, 8),
                        //   child: Text(
                        //     "Site Settings",
                        //     style: Theme.of(context).textTheme.headline3.apply(
                        //           color: InsColor(appBloc).appTextColor,
                        //         ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       _showConfirmationDialog(context);
                        //     },
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.reset_tv,
                        //           color: Colors.grey,
                        //         ),
                        //         Expanded(
                        //           child: Padding(
                        //             padding:
                        //                 const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        //             child: Text(
                        //               "Reset my Site",
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .headline2
                        //                   .apply(
                        //                     color:
                        //                         InsColor(appBloc).appTextColor,
                        //                   ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        mainBody(),
                        // Divider(endIndent: 20),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       _showDialog(context);
                        //     },
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.track_changes,
                        //           color: Colors.grey,
                        //         ),
                        //         Expanded(
                        //           child: Padding(
                        //             padding:
                        //                 const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        //             child: Text(
                        //               "Change Site URL",
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .headline2
                        //                   ?.apply(
                        //                     color:
                        //                         InsColor(appBloc).appTextColor,
                        //                   ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Divider(endIndent: 2),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(5, 8, 8, 8),
                        //   child: Text(
                        //     "Account Settings",
                        //     style: Theme.of(context).textTheme.headline3?.apply(
                        //           color: InsColor(appBloc).appTextColor,
                        //         ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: GestureDetector(
                        //       onTap: () {
                        //         Navigator.of(context).push(MaterialPageRoute(
                        //             builder: (context) => PreferenceScreen()));
                        //       },
                        //       child: Row(
                        //         children: <Widget>[
                        //           Icon(
                        //             Icons.equalizer,
                        //             color: Colors.grey,
                        //           ),
                        //           Expanded(
                        //               child: Padding(
                        //             padding:
                        //                 const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        //             child: Text(
                        //               "Preference",
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .headline2
                        //                   ?.apply(
                        //                     color:
                        //                         InsColor(appBloc).appTextColor,
                        //                   ),
                        //             ),
                        //           ))
                        //         ],
                        //       )),
                        // ),
                        // Visibility(
                        //     visible: appBloc.uiSettingModel.enableMembership ==
                        //         'True',
                        //     child: Divider(endIndent: 20)),
                        // Visibility(
                        //   visible:
                        //       // appBloc.uiSettingModel.enableMembership == 'True',
                        //       true,
                        //   child: BlocConsumer<PreferenceBloc, PreferenceState>(
                        //     bloc: preferenceBloc,
                        //     listener: (context, state) {
                        //       if (state.status == Status.ERROR) {
                        //         if (state.message == "401") {
                        //           AppDirectory.sessionTimeOut(context);
                        //         }
                        //       }
                        //     },
                        //     builder: (context, state) {
                        //       if (!_isLoadedPaymentGateway) {
                        //         preferenceBloc.add(
                        //             GetPaymentGatewayResponseEvent(
                        //                 preferenceBloc.membership.currency));
                        //         _isLoadedPaymentGateway = true;
                        //       }
                        //
                        //       return Padding(
                        //         padding: const EdgeInsets.all(10.0),
                        //         child: GestureDetector(
                        //             onTap: () {
                        //               _showMembershipDialog(
                        //                   context, preferenceBloc.membership);
                        //               //Navigator.of(context).push(MaterialPageRoute(
                        //               //builder: (context) => PreferenceScreen()));
                        //             },
                        //             child: Row(
                        //               children: <Widget>[
                        //                 Icon(
                        //                   Icons.perm_identity,
                        //                   color: Colors.grey,
                        //                 ),
                        //                 Expanded(
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.fromLTRB(
                        //                         10, 0, 0, 0),
                        //                     child: Text(
                        //                       "Membership",
                        //                       style: Theme.of(context)
                        //                           .textTheme
                        //                           .headline2
                        //                           ?.apply(
                        //                             color: InsColor(appBloc)
                        //                                 .appTextColor,
                        //                           ),
                        //                     ),
                        //                   ),
                        //                 )
                        //               ],
                        //             )),
                        //       );
                        //     },
                        //   ),
                        // ),
                        // Divider(endIndent: 20),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: GestureDetector(
                        //       onTap: () {
                        //         Navigator.of(context).push(MaterialPageRoute(
                        //             builder: (context) =>
                        //                 PaymentHistoryScreen()));
                        //       },
                        //       child: Row(
                        //         children: <Widget>[
                        //           Icon(
                        //             Icons.payment,
                        //             color: Colors.grey,
                        //           ),
                        //           Expanded(
                        //             child: Padding(
                        //               padding: const EdgeInsets.fromLTRB(
                        //                   10, 0, 0, 0),
                        //               child: Text(
                        //                 "Purchase History",
                        //                 style: Theme.of(context)
                        //                     .textTheme
                        //                     .headline2
                        //                     ?.apply(
                        //                       color: InsColor(appBloc)
                        //                           .appTextColor,
                        //                     ),
                        //               ),
                        //             ),
                        //           )
                        //         ],
                        //       )),
                        // ),
                        // Divider(endIndent: 20),
                        //
                        // //sreekanth commented
                        // displayPrivacy(),
                        //
                        // Visibility(
                        //   visible: privacyboolvalue,
                        //   child: Divider(endIndent: 20),
                        // ),
                        //
                        // Visibility(
                        //   visible: appBloc.uiSettingModel.localeList.length > 1,
                        //   child: Padding(
                        //     padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                        //     child: Text(
                        //       "Language",
                        //       style: TextStyle(
                        //           color: Color(int.parse(
                        //               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 18.h),
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: appBloc.uiSettingModel.localeList.length > 1,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: GestureDetector(
                        //         onTap: () {
                        //           _showLanguageDialog(context, _character);
                        //         },
                        //         child: Row(
                        //           children: <Widget>[
                        //             Icon(
                        //               Icons.language,
                        //               color: Colors.grey,
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.fromLTRB(
                        //                   10, 0, 0, 0),
                        //               child: Column(
                        //                 crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //                 children: <Widget>[
                        //                   Text(
                        //                     "Language",
                        //                     style: TextStyle(
                        //                         color: Color(int.parse(
                        //                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        //                         fontSize: 16.h),
                        //                   ),
                        //                   Text(
                        //                     "App is set to $_character",
                        //                     style: TextStyle(
                        //                         color: Color(int.parse(
                        //                             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        //                         fontSize: 13.h),
                        //                   ),
                        //                 ],
                        //               ),
                        //             )
                        //           ],
                        //         )),
                        //   ),
                        // ),
                        // Divider(endIndent: 20),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                        //   child: Text(
                        //     "Theme",
                        //     style: Theme.of(context).textTheme.headline3?.apply(
                        //           color: InsColor(appBloc).appTextColor,
                        //         ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: GestureDetector(
                        //       onTap: () {},
                        //       child: Row(
                        //         children: <Widget>[
                        //           Icon(
                        //             Icons.color_lens_outlined,
                        //             color: Colors.grey,
                        //           ),
                        //           Padding(
                        //             padding:
                        //                 const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        //             child: Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: <Widget>[
                        //                 // Text(
                        //                 //   "Theme",
                        //                 //   style: TextStyle(
                        //                 //       color: Colors.black,
                        //                 //       fontSize: 16.h),
                        //                 // ),
                        //                 // Text(
                        //                 //   "Default Theme",
                        //                 //   style: TextStyle(
                        //                 //       color: Colors.black,
                        //                 //       fontSize: 13.h),
                        //                 // ),
                        //                 Switch(
                        //                     value: isSwitched,
                        //                     activeColor: Colors.blue,
                        //                     onChanged: (toggle) {
                        //                       isSwitched = toggle;
                        //                       isSwitched
                        //                           ? setDarkTheme(false)
                        //                           : setDefaultTheme(false);
                        //                       setState(() {
                        //                         // isSwitched = toggle;
                        //                       });
                        //                     })
                        //               ],
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  isLoading
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: SpinKitCircle(
                                color: Colors.grey,
                                size: 50.h,
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Settings",
                style: Theme.of(context).textTheme.headline1?.apply(
                      color: InsColor(appBloc).appTextColor,
                    ),
              ),
              backgroundColor: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
              leading: InkWell(
                onTap: () => isLoading ? {} : Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ),
              ),
            ),
            body: WillPopScope(
              onWillPop: () =>
                  isLoading ? Future.value(false) : Future.value(true),
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(20)),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                          child: Text(
                            "Preference",
                            style: TextStyle(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.h),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              _showConfirmationDialog(context);
                            },
                            child: Text(
                              "Reset my Site",
                              style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  fontSize: 16.h),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              _showDialog(context);
                            },
                            child: Text(
                              "Change Site URL  ",
                              style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  fontSize: 16.h),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: appBloc.uiSettingModel.localeList.length > 1,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                            child: Text(
                              "Language",
                              style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.h),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: appBloc.uiSettingModel.localeList.length > 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                                onTap: () {
                                  _showLanguageDialog(context, _character);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.language,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Language",
                                            style: TextStyle(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                fontSize: 16.h),
                                          ),
                                          Text(
                                            "App is set to $_character",
                                            style: TextStyle(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                fontSize: 13.h),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        Divider(endIndent: 20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                          child: Text(
                            "Theme",
                            style: TextStyle(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.h),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.color_lens_outlined,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Switch(
                                            value: isSwitched,
                                            activeColor: Colors.blue,
                                            onChanged: (toggle) {
                                              isSwitched = toggle;
                                              isSwitched ? setDarkTheme(true) : setDefaultTheme(true);
                                              setState(() {
                                                // isSwitched = toggle;
                                              });
                                            })
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                  isLoading
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: SpinKitCircle(
                                color: Colors.grey,
                                size: 50.h,
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
  }

  Widget mainBody(){
    return Column(
      children: [
        // commonListTile(onPressed: (){}, icon: Icons.equalizer, title: "Preference", subTitle: "preference" ),
        commonListTile(onPressed: (){ _showLanguageDialog(context, _character); }, icon: Icons.language, title: "Language", subTitle: "App is set to $_character" ),
        commonListTile(onPressed: (){}, icon: Icons.access_time, title: "Time Zone", subTitle: "Time zone is bangkok" ),
        commonListTile(onPressed: (){}, icon: Icons.history, title: "Update", subTitle: "Click to check Update" ),
        BlocConsumer<PreferenceBloc, PreferenceState>(
            bloc: preferenceBloc,
            listener: (context, state) {
              if (state.status == Status.ERROR) {
                if (state.message == "401") {
                  AppDirectory.sessionTimeOut(context);
                }
              }
            },
            builder: (context,state) {
              if (!_isLoadedPaymentGateway) {
                preferenceBloc.add(
                    GetPaymentGatewayResponseEvent(
                        preferenceBloc.membership.currency));
                _isLoadedPaymentGateway = true;
              }
              return commonListTile(
                  onPressed: (){_showMembershipDialog(context, preferenceBloc.membership);},
                  isFontAwsomeIcon: true,
                  icon: FontAwesomeIcons.addressCard,
                  title: "Membership",
                  subTitle: "Membership details" );
            }
        ),
        // commonListTile(onPressed: (){ }, icon: Icons.remove_red_eye_outlined, title: "Privacy", subTitle: "privacy" ),
        commonListTile(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PaymentHistoryScreen()));
            },
            icon: FontAwesomeIcons.creditCard,
            isFontAwsomeIcon: true,
            title: "Purchase History",
            subTitle: "Checkout the purchase history" ),
        commonListTile(onPressed: (){}, icon: Icons.color_lens_outlined, title: "Dark Theme", subTitle: "Will never turn on/off automatically",
            trailingWidget: Switch(
              value: isSwitched,
              activeColor: Colors.blue,
              onChanged: (toggle) {
                isSwitched = toggle;
                isSwitched
                    ? setDarkTheme(false)
                    : setDefaultTheme(false);
                setState(() {
                  // isSwitched = toggle;
                });
              })
        ),
      ],
    );
  }

  Widget commonListTile({ required void Function()? onPressed, required IconData icon, String title = "", String subTitle = "", Widget? trailingWidget, bool isFontAwsomeIcon = false}){
    return ListTile(
      onTap: onPressed,
      leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey
          ),
          padding: EdgeInsets.all(isFontAwsomeIcon?11:7),
          child: Icon(icon,color: Colors.white,size:isFontAwsomeIcon? 22:28,)),
      title: Text(title, style: Theme.of(context).textTheme.headline2?.apply(color: AppColors.getAppTextColor(),),),
      subtitle: Text(subTitle,style: TextStyle(color: Colors.grey,fontSize: 12.h)),
      trailing: trailingWidget,
    );
  }

  Widget displayPrivacy() {
    return Visibility(
      visible: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Privacyinfo())),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.remove_red_eye_outlined,
                color: Colors.grey,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Privacy",
                    style: Theme.of(context).textTheme.headline2?.apply(
                          color: InsColor(appBloc).appTextColor,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

//    return Container();
  }

  moveToSplashScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginCommonPage()),
        (Route<dynamic> route) => false);
  }

  _showDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: InsColor(appBloc).appBGColor,
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextFormField(
                  style: Theme.of(context).textTheme.headline2?.apply(
                        color: InsColor(appBloc).appTextColor,
                      ),
                  controller: _controler,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: "Site URL",
                      hintStyle: Theme.of(context).textTheme.subtitle1?.apply(
                            color:
                                InsColor(appBloc).appTextColor.withOpacity(0.5),
                          ),
                      hintText: ApiEndpoints.strSiteUrl,
                      labelStyle: Theme.of(context).textTheme.headline2?.apply(
                            color: InsColor(appBloc).appTextColor,
                          )),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: Text(
                  appBloc.localstr.siteurlsettingAlertbuttonCancelbutton,
                  style: Theme.of(context).textTheme.subtitle1?.apply(
                        color: InsColor(appBloc).appTextColor,
                      ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: Text(
                  'Change',
                  style: Theme.of(context).textTheme.subtitle1?.apply(
                        color: InsColor(appBloc).appTextColor,
                      ),
                ),
                onPressed: () async {
                  print("_controler.text   ${_controler.text}");
                  try {
                    Response? response =
                        await RestClient.getData(_controler.text, true);

                    if (response?.statusCode == 200) {
                      await sharePrefSaveString(
                          sharedPref_siteURL, _controler.text);
                      Future.delayed(Duration(seconds: 1)).then((value) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => SplashScreen(true)),
                            (Route<dynamic> route) => false);
                      });
                    } else {
                      FToast()
                        ..init(context).showToast(
                          child: CommonToast(displaymsg: "Enter Valid URL"),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: Duration(seconds: 2),
                        );
                    }
                  } catch (e) {
                    FToast()
                      ..init(context).showToast(
                        child: CommonToast(displaymsg: "Enter Valid URL"),
                        gravity: ToastGravity.BOTTOM,
                        toastDuration: Duration(seconds: 2),
                      );
                  }
                })
          ],
        );
      },
    );
  }

  _showConfirmationDialog(BuildContext context) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                  child: new Text(
                    appBloc.localstr
                        .siteurlsettingAlertsubtitleDoyouwantresetsiteurl,
                    style: Theme.of(context).textTheme.headline2?.apply(
                          color: InsColor(appBloc).appTextColor,
                        ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: Text('No',
                      style: Theme.of(context).textTheme.subtitle1?.apply(
                            color: InsColor(appBloc).appTextColor,
                          )),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: Text('Yes',
                      style: Theme.of(context).textTheme.subtitle1?.apply(
                            color: InsColor(appBloc).appTextColor,
                          )),
                  onPressed: () {
                    sharePrefSaveString(
                        sharedPref_siteURL, ApiEndpoints.mainSiteURL);
                    Future.delayed(Duration(seconds: 1)).then((value) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => SplashScreen(true)),
                          (Route<dynamic> route) => false);
                    });
                  })
            ],
          );
        });
  }

  _showMembershipDialog(
      BuildContext context, MembershipModel membership) async {
    print(membership.toJson());
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: InsColor(appBloc).appBGColor,
            //contentPadding: const EdgeInsets.all(16.0),
            content: Container(
              height: 280,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.card_giftcard_outlined,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 16),
                            Text("Current Plan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))))
                          ])),
                  SizedBox(height: 8),
                  Divider(thickness: 1, indent: 0),
                  SizedBox(height: 8),
                  Expanded(
                    flex: 6,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Membership Plan : ",
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Expanded(
                                child: Text(
                                  membership.userMembership,
                                  style: TextStyle(
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Billing Period : ",
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Text(
                                membership.durationType,
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              )
                            ],
                          ),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Effective Date : ",
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Text(
                                membership.displayStartDate,
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              )
                            ],
                          ),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Next Invoice date : ",
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Text(
                                membership.displayExpirydate,
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              )
                            ],
                          ),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Next Invoice Amount : ",
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Text(
                                (membership.currency) +
                                    (membership.purchasedAmount),
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              )
                            ],
                          )
                        ]),
                  ),
                  SizedBox(height: 16),
                  Visibility(
                    visible: preferenceBloc.manualPayment,
                    child: Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Visibility(
                            visible: false,
                            child: Expanded(
                              child: OutlineButton(
                                border: Border.all(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                child: Text("Cancel Membership",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: MaterialButton(
                              disabledColor: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                  .withOpacity(0.5),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                              child: Text("Update Membership",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                              onPressed: () async {
                                Navigator.pop(context);

                                _showMembershipPlansDialog(
                                    context,
                                    preferenceBloc.memberShipPlanResponse,
                                    preferenceBloc.membership.currency);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _showMembershipPlansDialog(BuildContext context,
      MemberShipPlanResponse membershipRes, String currency) async {
    planData = membershipRes.memberShipPlans
        .map((e) => RadioModel(
            false,
            "$currency${e.amount}/${e.durationValue} ${e.durationType}",
            e.memberShipDurationId,
            e.durationName))
        .toList();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              //contentPadding: const EdgeInsets.all(16.0),
              content: Container(
                height: 280,
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(membershipRes.displayText,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))))
                            ])),
                    SizedBox(height: 8),
                    Divider(thickness: 1, indent: 0),
                    SizedBox(height: 8),
                    Expanded(
                      flex: 9,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: planData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new InkWell(
                              onTap: () {
                                setState(() {
                                  planData.forEach(
                                      (element) => element.isSelected = false);
                                  planData[index].isSelected = true;
                                });
                              },
                              child: new RadioItem(planData[index], appBloc),
                            );
                          }),
                    ),
                    Expanded(
                      flex: 2,
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
                                  appBloc.localstr.detailsButtonUpdatebutton,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                              onPressed: () async {
                                var selectedPlan = planData.firstWhere(
                                    (element) => element.isSelected);
                                if (selectedPlan.memberShipDurationID != null) {
                                  var url =
                                      ApiEndpoints.membershipRenewRedirectUrl(
                                          selectedPlan.memberShipDurationID
                                              .toString());
                                  print(url);
                                  await launchUrlString(url);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _showLanguageDialog(BuildContext context, String character) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            contentPadding: const EdgeInsets.all(16.0),
            content: Container(
              color: InsColor(appBloc).appBGColor,
              width: 300,
              height: 200,
              child: Stack(
                children: <Widget>[
                  new ListView.builder(
                      shrinkWrap: true,
                      itemCount: appBloc.uiSettingModel.localeList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: RadioListTile<String>(
                            title: Text(
                              '${appBloc.uiSettingModel.localeList[index].languagename}',
                              style: InsTheme().textTheme.headline2?.copyWith(
                                  color: InsColor(appBloc).appTextColor),
                            ),
                            value: appBloc
                                .uiSettingModel.localeList[index].locale
                                .toString(),
                            groupValue: _character,
                            onChanged: (String? value) {
                              print("language value $value");
                              appBloc.add(ChangeLanEvent(lanCode: value ?? ""));
                              Navigator.pop(context);
                              setState(() {
                                _character = value ?? "";
                                isLoading = true;
                              });

                              Future.delayed(Duration(seconds: 7))
                                  .then((value) {
                                widget.refresh();
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        });
  }

  Future<void> getLanguage() async {
    var language = await sharePrefGetString(sharedPref_AppLocale);
    setState(() {
      _character = language;
    });
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  final AppBloc appBloc;

  RadioItem(this._item, this.appBloc);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width * 0.6,
            child: new Center(
              child: new Text(_item.title,
                  style: new TextStyle(
                      color: _item.isSelected
                          ? Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
                            )
                          : Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            ),
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected
                      ? Colors.blueAccent
                      : InsColor(appBloc).appBtnBgColor),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
        ],
      ),
    );
  }
}
