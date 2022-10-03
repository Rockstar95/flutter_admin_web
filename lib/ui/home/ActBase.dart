
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/common/local_str.dart';
import 'package:flutter_admin_web/framework/dataprovider/data_provider.dart';
import 'package:flutter_admin_web/framework/dataprovider/helper/local_database_helper.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/model/mobileGetLearningPortalInfoResponse.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/model/mobileGetNativeMenusResponse.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/splash_repositry_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/events/app_event.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/app/states/app_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/bloc/profile/states/profile_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/logout_alert_dialog.dart';
import 'package:flutter_admin_web/framework/common/notification_string.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Catalog/calalog_sub_category_screen.dart';
import 'package:flutter_admin_web/ui/Catalog/catalog_refresh.dart';
import 'package:flutter_admin_web/ui/Catalog/catalog_sub_screen.dart';
import 'package:flutter_admin_web/ui/Catalog/catlog_main_home.dart';
import 'package:flutter_admin_web/ui/Catalog/wish_list.dart';
import 'package:flutter_admin_web/ui/Discussions/discussion_main_home.dart';
import 'package:flutter_admin_web/ui/Events/event_main_page.dart';
import 'package:flutter_admin_web/ui/Events/event_wishlist.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/MyLearnPlusHomescreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/my_learning_home.dart';
import 'package:flutter_admin_web/ui/MyLearning/wait_list.dart';
import 'package:flutter_admin_web/ui/Setting/site_setting.dart';
import 'package:flutter_admin_web/ui/askTheExpert/user_questions_list.dart';
import 'package:flutter_admin_web/ui/auth/login_common_page.dart';
import 'package:flutter_admin_web/ui/competencies/job_role_skills.dart';
import 'package:flutter_admin_web/ui/feedback/feedback_screen.dart';
import 'package:flutter_admin_web/ui/home/helper/drawer_header.dart';
import 'package:flutter_admin_web/ui/home/webpage_screen.dart';
import 'package:flutter_admin_web/ui/learningcommunities/learning_communitiesscreen.dart';
import 'package:flutter_admin_web/ui/messages/message_users_list.dart';
import 'package:flutter_admin_web/ui/myConnections/connection_index_screen.dart';
import 'package:flutter_admin_web/ui/mydashboard/mydashboard_screen.dart';
import 'package:flutter_admin_web/ui/notifications/notifications.dart';
import 'package:flutter_admin_web/ui/profile/profile_page.dart';
import 'package:flutter_admin_web/ui/progressReport/progress_report.dart';
import 'package:flutter_admin_web/ui/splash/splash_screen.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../backend/classroom_events/classroom_events_controller.dart';
import '../../configs/app_menu_ids.dart';
import '../../configs/app_strings.dart';
import '../../framework/helpers/parsing_helper.dart';
import '../../framework/helpers/providermodel.dart';
import '../../providers/my_learning_download_provider.dart';
import '../MyLearning/my_downloads_screen.dart';
import '../classroom_events/event_main_page2.dart';
import '../common/app_colors.dart';
import '../common/bottomsheet_option_tile.dart';
import '../instabot/instabot_screen.dart';

//Function to handle Notification data in background.
// Future<dynamic> backgroundMessageHandler(RemoteMessage message) {
//   print("FCM backgroundMessageHandler $message");

//   return Future<void>.value();
// }

class ActBase extends StatefulWidget {
  final String notification;
  final String contentId;
  final bool isFromNotification;
  final String selectedMenu;

  ActBase({
    this.notification = "",
    this.contentId = '',
    this.isFromNotification = false,
    this.selectedMenu = "",
  });

  @override
  _ActBaseState createState() => _ActBaseState();
}

class _ActBaseState extends State<ActBase> {
  bool isFirst = true, pageMounted = false;

  String strTAG = "ActBase";
  String username = "";
  String userimageUrl = "";
  String landingpageType = "1";

  int _selectedDrawerIndex = 1;
  int _currentBottomMenuIndex = 2;
  String selectedmenu = "13";
  bool isDrawer = false;
  bool isChanged = false;
  var isCatalogChanged = "";
  Map<String, String> filterMenus = {};

  String imgUrl =
      "https://www.insertcart.com/wp-content/uploads/2018/05/thumbnail.jpg";

  GlobalKey _drawerKey = GlobalKey();
  int taskID = 0;
  Offset currentOffset = const Offset(0, 0);
  NativeMenuModel? nativeMenuModel;

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  String count = '';
  String appBarTitle = 'My Dashboard';

  var isFromSubSite = 'false';
  String contentID = "";

  List<String> groupValueArr = [
    'Group By',
    'Categories',
    'Learning Community',
    'Content Type',
  ];

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late MyLearningDetailsBloc detailsBloc;
  late ProfileBloc profileBloc;

  // FlutterLocalNotificationsPlugin notificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String urlTolaunch = '';

  bool isDrawerOpened = false;
  Timestamp? lastUpdatedTime, lastGlobalConfigurationUpdated;
  bool isLoading = false, isGlobalConfigurationLoading = false;
  late DocumentReference<Map<String, dynamic>> documentReference;
  final LocalDataProvider _localHelper = LocalDataProvider(localDataProviderType: LocalDataProviderType.hive);

  Map<String, String> defaultMenuItems = {};

  void mySetState() {
    if(!mounted) {
      return;
    }

    if(pageMounted) {
      setState(() {});
    }
    else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    }
  }

  void onlineSync(){
    documentReference = FirebaseFirestore.instance.collection(ApiEndpoints.syncCollection).doc(ApiEndpoints.syncDocument);
    documentReference.snapshots().listen(listenToChangeInData);
  }

  Future<void> listenToChangeInData(DocumentSnapshot<Map<String, dynamic>> event) async {
    Map<String,dynamic> data = event.data() ?? {};
    /*isDrawerOpened = ParsingHelper.parseBoolMethod(data["is_drawer_opened"]);

    if(isDrawerOpened){
      NavigationController().actbaseScaffoldKey.currentState?.openDrawer();
    }
    else {
      NavigationController().actbaseScaffoldKey.currentState?.closeDrawer();
    }*/

    if(lastUpdatedTime != null) {
      if(!lastUpdatedTime!.toDate().isAtSameMomentAs(data["last_menus_updated"].toDate())) {
        setState((){
          isLoading = true;
        });
        lastUpdatedTime = data["last_menus_updated"];
        print("date : ${lastUpdatedTime!.toDate().isAtSameMomentAs(data["last_menus_updated"].toDate())}");
        // api call
        // Response mobileGetNativeMenusResponseStr =
        Response? mobileGetNativeMenusResponse = await SplashRepositoryBuilder.repository().getMobileGetNativeMenus();
        String mobileGetNativeMenusResponseStr = mobileGetNativeMenusResponse?.body ?? "{}";
        // developer.log(
        //     "mobileGetNativeMenusResponseStr:$mobileGetNativeMenusResponseStr");
        MobileGetNativeMenusResponse mobileNativeMenusResponse = mobileGetNativeMenusResponseFromJson(mobileGetNativeMenusResponseStr);
        appBloc.setNativeMenusModal(mobileNativeMenusResponse);
        List<NativeMenuModel> tempListNativeModel = appBloc.listNativeModel.where((element) => element.contextmenuId == selectedmenu).toList();
        appBarTitle = tempListNativeModel.first.displayname;
        // appBarTitle = appBloc.listNativeModel.;
        setState((){
          isLoading = false;
        });
      }
    }
    else {
      lastUpdatedTime = data["last_menus_updated"];
      print("date in else");
    }

    if(lastGlobalConfigurationUpdated != null){

      if(!lastGlobalConfigurationUpdated!.toDate().isAtSameMomentAs(data["last_global_configuration_updated"].toDate())){
        setState((){
          isGlobalConfigurationLoading = true;
        });
        lastGlobalConfigurationUpdated = data["last_global_configuration_updated"];
        await getAndSetGlobalConfiguration();
        setState((){
          isGlobalConfigurationLoading = false;
        });
      }

    }
    else {
      lastGlobalConfigurationUpdated = data["last_global_configuration_updated"];
      // await getAndSetGlobalConfiguration();
    }

    String selectedMenuInFirebase = ParsingHelper.parseStringMethod(data['selected_menu']);
    MyPrint.printOnConsole("selectedMenuInFirebase:$selectedMenuInFirebase");
    List<NativeMenuModel> selectedMenus = appBloc.listNativeModel.where((element) => element.menuid == selectedMenuInFirebase).toList();

    NativeMenuModel? nativeMenuModel;
    if(selectedMenus.isNotEmpty) {
      nativeMenuModel = selectedMenus.first;
    }
    else {
      //nativeMenuModel = appBloc.listNativeModel.isNotEmpty ? appBloc.listNativeModel.first : null;
    }

    if(nativeMenuModel != null) {
      selectedmenu = nativeMenuModel.contextmenuId;
      appBarTitle = nativeMenuModel.displayname;
    }
    else if(defaultMenuItems.keys.contains(selectedMenuInFirebase)) {
      selectedmenu = selectedMenuInFirebase;
      appBarTitle = defaultMenuItems[selectedMenuInFirebase] ?? "Title";
    }
    else if(selectedMenuInFirebase == AppMenuIds.INSTABOT) {
      if(appBloc.uiSettingModel.enableChatBot.toLowerCase() == "true") {
         Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InstaBotScreen()));
      }
    }
    else if(selectedMenuInFirebase == AppMenuIds.MESSAGES) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessageUsersList()));
    }
    else {
      selectedmenu = AppMenuIds.NOT_IMPLEMENTED;
      appBarTitle = "Coming Soon";
    }

    mySetState();
  }

  Future<void> getAndSetGlobalConfiguration() async {
    String language = await sharePrefGetString(sharedPref_AppLocale);
    print("Language:$language");
    if (language.isEmpty) {
      language = "en-us";
      await sharePrefSaveString(sharedPref_AppLocale, language);
    }
    try {
      Response? mobileGetLearningPortalInfoResponse = await SplashRepositoryBuilder.repository().getMobileGetLearningPortalInfo();
      MobileGetLearningPortalInfoResponse mobileGetLearningPortalInfoResponseModel = mobileGetLearningPortalInfoResponseFromJson(mobileGetLearningPortalInfoResponse?.body ?? "{}");
      appBloc.setUiSettingFromMobileGetLearningPortalInfo(mobileGetLearningPortalInfoResponseModel);


      Response? mobileTinCanConfigurationsResponse = await SplashRepositoryBuilder.repository().getMobileTinCanConfigurations();
      await _localHelper.localService(
        enumLocalDatabaseOperation: LocalDatabaseOperation.create,
        table: table_splash,
        values: {
          mobileTinCanConfigurationsKey: mobileTinCanConfigurationsResponse?.body ?? "{}",
        },
      );

      Response? getJsonfileResponse =
      await SplashRepositoryBuilder.repository().getLanguageJsonFile(language);


      Map<String, dynamic> jsonData = json.decode(getJsonfileResponse?.body ?? "{}");

      LocalStr localStr = LocalStr.fromJson(jsonData);
      Locale appLocale = Locale(language);
      ChangeLangState(appLocale: appLocale, localstr: localStr);

      MyPrint.logOnConsole("GetLanguageJsonFile Response:${getJsonfileResponse?.body}");
    } catch (e){
      print("Error in the getAndSetGlobalConfiguration:$e");
    }

  }

  refresh() {
    setState(() {
//all the reload processes
    });
  }

  updateTitle() {
    setState(() {
      appBarTitle = appBloc.feedbackTitle;
    });
  }

  signOutFunc() {
    _confirmSignout(context);
  }

  Future<void> checkSubSiteLogin() async {
    isFromSubSite = await sharePrefGetString(sharedPrefIsSubSiteEntered);
  }

  Future<void> _confirmSignout(BuildContext context) async {
    final didiReqestSignOut = await LogoutAlertDialog(
      defaultActionText: 'OK',
      cancelActionText: 'Cancel',
      title: 'Logout',
      content: 'Are you sure that you want to Logout?',
      appBloc: appBloc,
    ).show(context);

    if (didiReqestSignOut == true) {
      print("Logout");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('login', 'false');

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginCommonPage()),
          (Route<dynamic> route) => false);
    }
  }

  Widget getCominSoon(context) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
      child: const Text(
        "Coming soon... Bottom Navigation bar items",
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  void onTabTapped(int index) {
    List<NativeMenuModel> listNativeModel = [];
    appBloc.listNativeModel.forEach((element) {
      if (element.parentMenuId == "0") {
        listNativeModel.add(element);
      }
    });
    setState(() {
      if ([0, 1, 2, 3].contains(index)) {
        _selectedDrawerIndex = index;
        _currentBottomMenuIndex = index;
        selectedmenu = listNativeModel[index].contextmenuId;
        appBarTitle = listNativeModel[index].displayname;
      }
      else {
        print("ShowMoreActionforBottommenu ${appBloc.uiSettingModel.showMoreActionForBottomMenu}");
        if (appBloc.uiSettingModel.showMoreActionForBottomMenu != "true") {
          NavigationController().actbaseScaffoldKey.currentState?.openDrawer();
        }
        else {
          _settingBottomSheet(context);
        }
      }
      documentReference.update({"selected_menu":listNativeModel[index].menuid});

      isDrawer = true;
    });
    print("Drawer Click $index $appBarTitle");
  }

  _navItem(String text, IconData icon) {
    return BottomNavigationBarItem(
      label: text,
      icon: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  void openEndDrawer() {
    NavigationController().actbaseScaffoldKey.currentState?.openEndDrawer();
  }

  void closeEndDrawer(BuildContext context) {
    Navigator.of(context).pop();
  }

  void fireStoreAuth() async {
    bool networkAvailable = await AppDirectory.checkInternetConnectivity();
    if(!networkAvailable) return;
    UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: 'admin@instancy.com', password: 'ins&@5263');
    //print(result);
  }

//Function to handle Notification Click.
  // Future<void> onSelectNotification(String payload) async {
  //   setState(() {
  //     widget.isFromNotification = false;
  //     appBloc.uiSettingModel.setIsFromPush(true);
  //   });
  //   switch (payload) {
  //     case "2":
  //       appBloc.listNativeModel.forEach((element) {
  //         if (element.contextmenuId == payload) {
  //           setState(() {
  //             selectedmenu = element.contextmenuId;
  //             appBarTitle = element.displayname;
  //           });
  //         }
  //       });
  //       break;
  //     case "1":
  //       appBloc.listNativeModel.forEach((element) {
  //         print('content id $contentID');
  //         if (element.contextmenuId == payload) {
  //           setState(() {
  //             selectedmenu = element.contextmenuId;
  //             appBarTitle = element.displayname;
  //             _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex, true,
  //                 selectedmenu);
  //           });
  //         }
  //       });
  //       break;
  //     case "3":
  //       appBloc.listNativeModel.forEach((element) {
  //         if (element.contextmenuId == payload) {
  //           setState(() {
  //             selectedmenu = element.contextmenuId;
  //             appBarTitle = element.displayname;
  //           });
  //         }
  //       });
  //       break;
  //     case "4":
  //       appBloc.listNativeModel.forEach((element) {
  //         if (element.contextmenuId == payload) {
  //           setState(() {
  //             selectedmenu = element.contextmenuId;
  //             appBarTitle = element.displayname;
  //           });
  //         }
  //       });
  //       break;
  //     case "5":
  //       appBloc.listNativeModel.forEach((element) {
  //         if (element.contextmenuId == payload) {
  //           setState(() {
  //             selectedmenu = element.contextmenuId;
  //             appBarTitle = element.displayname;
  //           });
  //         }
  //       });
  //       break;
  //   }

  //   if (payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  // }

  showAlertDialog(BuildContext context, String message, String title) {
    // Create button

    Widget cancelButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        // discussionMainHomeBloc.myDiscussionForumList.removeAt(index);
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title),
      content: Text(message),
      actions: [cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool isMenuExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if ((profileBloc.userprivilige[i].privilegeid == 1227) && !appBloc.uiSettingModel.isMsgMenuExist) {
        return true;
      }
    }
    return false;
  }

  void _addPlaygroundMenu(List<Widget> drawerOptions, BuildContext context) async {
    if (isFromSubSite == 'true') {
      var strUserID = await sharePrefGetString(sharedPref_main_userid);
      var strBearer = await sharePrefGetString(sharedPref_main_bearer);
      var strMainsiteurl = await sharePrefGetString(sharedPref_main_siteurl);
      var strProfileImage =
          await sharePrefGetString(sharedPref_main_tempProfileImage);
      print('passing playground');
      const Divider();
      drawerOptions.add(
        Container(
          //height: 6 * SizeConfig.heightMultiplier,
          child: ListTile(
            leading: Icon(Icons.arrow_back,
                color: appBloc.uiSettingModel.menuTextColor.isEmpty
                    ? Colors.white
                    : Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}"))
                //color: GloballColor.secondaryAppColor,
                ),
            title: Text(
              "Instancy Learning",
              style: TextStyle(
                  color: appBloc.uiSettingModel.menuTextColor.isEmpty
                      ? Colors.white
                      : Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}"))),
            ),
            onTap: () async => {
              ApiEndpoints.mainSiteURL = strMainsiteurl,
              await sharePrefSaveString(sharedPrefIsSubSiteEntered, 'false'),
              isFromSubSite = 'false',
              await sharePrefSaveString(
                  sharedPref_siteURL, ApiEndpoints.mainSiteURL),
              await sharePrefSaveString(sharedPref_userid, strUserID),
              await sharePrefSaveString(sharedPref_bearer, strBearer),
              await sharePrefSaveString(
                  sharedPref_tempProfileImage, strProfileImage),
              ApiEndpoints.siteID = '374',
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SplashScreen(true)),
                  (Route<dynamic> route) => false)
            },
          ),
        ),
      );
    }
    else {
      //print('passing sign out' + isFromSubSite.toString());
      _addMessageMenu(drawerOptions, context);
      // drawerOptions.add(
      //   Container(
      //     //height: 6 * SizeConfig.heightMultiplier,
      //     child: ListTile(
      //       leading: Icon(Icons.logout,
      //           color: appBloc.uiSettingModel.menuTextColor.isEmpty
      //               ? Colors.white
      //               : Color(int.parse(
      //                   "0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}"))
      //           //color: GlobalColor.secondaryAppColor,
      //           ),
      //       title: new Text(
      //         "Sign Out",
      //         style: TextStyle(
      //             color: appBloc.uiSettingModel.menuTextColor.isEmpty
      //                 ? Colors.white
      //                 : Color(int.parse(
      //                     "0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}"))),
      //       ),
      //       onTap: () => _confirmSignout(context),
      //     ),
      //   ),
      // );
    }
  }

  void _addMessageMenu(List<Widget> drawerOptions, BuildContext context) async {
    //Divider();
    // drawerOptions.add(const SizedBox(height: 16));
    drawerOptions.add(
      Container(
        //height: 6 * SizeConfig.heightMultiplier,
        child: ListTile(
          leading: Icon(Icons.message_outlined,
              color: appBloc.uiSettingModel.menuTextColor.isEmpty
                  ? Colors.white
                  : AppColors.getMenuTextColor()
              //color: GloballColor.secondaryAppColor,
              ),
          title: Text(
            "Message",
            style: TextStyle(
                color: appBloc.uiSettingModel.menuTextColor.isEmpty
                    ? Colors.white
                    : Colors.black),
          ),
          onTap: () async => {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MessageUsersList()),
            ),
            // documentReference.update({"selected_menu":selectedmenu}),
          },
        ),
      ),
    );
  }

  _setContainer(int selectedDrawerIndex, int currentBottomMenuIndex, bool isDrawer, String selectedmenu) {
    print("selectedDrawerIndex $selectedDrawerIndex, currentBottomMenuIndex $currentBottomMenuIndex, isDrawer $isDrawer, selectedmenu:$selectedmenu");

    if (isDrawer) {
      //print("selectedmenu $selectedmenu");

      switch (selectedmenu) {
        case AppMenuIds.PROFILE:
          //return new ActSetting();

          return const Profile(
            isFromProfile: true,
          );
        case AppMenuIds.MY_LEARNING:
          appBloc.listNativeModel.forEach((element) async {
            if ([AppMenuIds.MY_LEARNING].contains(element.contextmenuId)) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });

          // return MyLearnPlusHomescreen(
          //   nativeModel: nativeMenuModel,
          //   contentId: contentID,
          // );

          return ActMyLearning(
            nativeModel: nativeMenuModel!,
            contentId: contentID,
          );
        case AppMenuIds.MY_LEARNING_PLUS:
          appBloc.listNativeModel.forEach((element) async {
            if (element.contextmenuId == AppMenuIds.MY_LEARNING_PLUS) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });

          return MyLearnPlusHomeScreen(
            nativeModel: nativeMenuModel ?? NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0),
            contentId: contentID,
          );
        case AppMenuIds.CATALOG:
          // ignore: missing_return
          appBloc.listNativeModel.forEach((element) async {
            if (element.displayname == appBarTitle) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          print("landingpageType:$landingpageType");
          if (landingpageType == "1") {
            return CatalogMainScreen();
          }
          else if (landingpageType == "2") {
            return CatalogSubCategoryScreen(
                categaoryID: 0,
                categaoryName: "",
                nativeMenuModel: nativeMenuModel!);
          }
          else {
            MyPrint.printOnConsole("isChanged:$isChanged");
            try {
              if (isChanged) {
                return CatalogRefreshScreen(
                  categaoryID: 0,
                  categaoryName: "",
                  nativeMenuModel: nativeMenuModel!,
                );
              } else {
                return CatalogSubScreen(
                    categaoryID: 0,
                    categaoryName: "",
                    nativeMenuModel: nativeMenuModel!,
                    contentId: contentID);
              }
            } catch (e) {
              print('error : $e');
            }
          }
          //return CatalogSubCategoryScreen(categaoryID: 0,categaoryName: "",);
          break;
        case AppMenuIds.DISCUSSION:
          appBloc.listNativeModel.forEach((element) async {
            if (element.contextmenuId == AppMenuIds.DISCUSSION) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return widget.isFromNotification
              ? DiscussionMain(contentId: widget.contentId)
              : appBloc.uiSettingModel.isFromPush
                  ? DiscussionMain(
                      contentId: contentID,
                      isFromPush: appBloc.uiSettingModel.isFromPush)
                  : DiscussionMain(
                      isFromPush: false,
                    );
        case AppMenuIds.QnA:
          appBloc.listNativeModel.forEach((element) async {
            if (element.contextmenuId == AppMenuIds.QnA) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return UserQuestionsList(
            nativeMenuModel: nativeMenuModel,
          );
        case AppMenuIds.MY_COMPETENCIES:
          appBloc.listNativeModel.forEach((element) async {
            if (element.contextmenuId == AppMenuIds.MY_COMPETENCIES) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return JobRoleSkills(
            nativeMenuModel: nativeMenuModel!,
          );
        case AppMenuIds.PROGRESS_REPORT:
          appBloc.listNativeModel.forEach((element) async {
            if ([AppMenuIds.PROGRESS_REPORT].contains(element.contextmenuId)) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return ProgressReportGraph(
            nativeMenuModel: nativeMenuModel!,
          );
        case AppMenuIds.WEB_PAGE_SCREEN:
          String parmString = "";
          appBloc.listNativeModel.forEach((element) async {
            print("displayname ${element.displayname}");
            print("parameterString ${element.parameterString}");
            if (element.contextmenuId == AppMenuIds.WEB_PAGE_SCREEN) {
              parmString = element.parameterString;
            }
          });
          print("parmString $parmString");
          String urlStr = "";

          if (parmString.split("=")[1].toString().isNotEmpty) {
            urlStr = "" +
                ApiEndpoints.strSiteUrl +
                "/content/PublishFiles/" +
                parmString.split("=")[1];
          }
          return WebPageScreen(urlStr);
        case AppMenuIds.CLASSROOM_EVENTS:
          appBloc.listNativeModel.forEach((element) async {
            //print("Display Name:${element.displayname}");
            if ([AppMenuIds.CLASSROOM_EVENTS].contains(element.contextmenuId)) {
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return EventMainPage2(classroomEventsController: Provider.of<ClassroomEventsController>(context, listen: false),);
        case AppMenuIds.COMMUNITIES:
          appBloc.listNativeModel.forEach((element) async {
            if (element.contextmenuId == AppMenuIds.COMMUNITIES) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return LearningCommunitiesScreen(nativeMenuModel: nativeMenuModel!);
        case AppMenuIds.LEADERBOARD: // leaderboard
          appBloc.listNativeModel.forEach((element) async {
            if (element.contextmenuId == AppMenuIds.LEADERBOARD) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return MyDashBoardScreen(nativeMenuModel: nativeMenuModel!);
        case AppMenuIds.MyAchivements: // Myachivements
          appBloc.listNativeModel.forEach((element) async {
            if (element.contextmenuId == AppMenuIds.MyAchivements) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return MyDashBoardScreen(nativeMenuModel: nativeMenuModel!);
        case AppMenuIds.SETTINGS:
          //return new ActSetting();
          return SiteSetting(refresh, true);
        case AppMenuIds.FEEDBACK:
          return FeedbackScreen(updateTitle);
        case AppMenuIds.NOTIFICATIONS:
          appBloc.listNativeModel.forEach((element) async {
            if (element.contextmenuId == AppMenuIds.NOTIFICATIONS) {
              nativeMenuModel = element;
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return Notifications(
              nativeMenuModel: nativeMenuModel ?? NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0));

        case AppMenuIds.MY_DOWNLOADS: {
          return MyDownloadsScreen(
            myLearningBloc: myLearningBloc,
            myLearningDownloadProvider: Provider.of<MyLearningDownloadProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false),
          );
        } case AppMenuIds.MY_CONNECTIONS:
          return ConnectionIndexScreen();
        default:
          return const Center(
            child: Text(
              "Please click on the plus icon '+' to add a component",
              style: TextStyle(color: Colors.grey),
            ),
          );
      }
    }
    else {
      switch (currentBottomMenuIndex) {
        case 0:
          return getCominSoon(context);
        case 1:
          appBloc.listNativeModel.forEach((element) async {
            if (element.displayname == "Catalog") {
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          // ignore: missing_return
          if (landingpageType == "1") {
            return CatalogMainScreen();
          } else if (landingpageType == "2") {
            return const CatalogSubCategoryScreen(
              categaoryID: 0,
              categaoryName: "",
            );
          } else {
            return CatalogSubScreen(
              categaoryID: 0,
              categaoryName: "",
              nativeMenuModel: nativeMenuModel!,
            );
          }
        case 2:
          appBloc.listNativeModel.forEach((element) async {
            if (element.displayname == "My Learning") {
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return ActMyLearning(
            nativeModel: nativeMenuModel!,
            contentId: contentID,
          );

        case 3:
          appBloc.listNativeModel.forEach((element) async {
            if (element.displayname == "Training Events") {
              await sharePrefSaveString(
                  sharedPref_ComponentID, element.componentId);
              await sharePrefSaveString(
                  sharedPref_RepositoryId, element.repositoryId);
            }
          });
          return EventMainPage2(classroomEventsController: Provider.of<ClassroomEventsController>(context, listen: false),);
        default:
          return getCominSoon(context);
      }
    }
  }

  Future<void> getUserDetails() async {
    String name = await sharePrefGetString(sharedPref_LoginUserName);
    String imageurl = await sharePrefGetString(sharedPref_tempProfileImage);
    print("image =- $imageurl");
    setState(() {
      userimageUrl = imageurl;
      username = name;
    });
  }

  Map<String, String> generateHashMap(List<String> conditionsArray) {
    Map<String, String> map = Map();
    if (conditionsArray.length != 0) {
      for (int i = 0; i < conditionsArray.length; i++) {
        var filterArray = conditionsArray[i].split("=");
        //print(" forvalue   $filterArray");
        if (filterArray.length > 1) {
          map[filterArray[0]] = filterArray[1];
        }
      }
    } else {}
    return map;
  }

  void getCatalogLandingPage() {
    var landingpageTypestr, strConditions;
    appBloc.listNativeModel.forEach((element) {
      if (element.contextTitle == "Catalog") {
        strConditions = element.conditions;
      }
    });
    print("neel  --- strConditions ---- $strConditions");
    Map<String, String> responMap = Map();
    if (strConditions != null && strConditions != "") {
      if (strConditions.contains("#@#")) {
        var conditionsArray = strConditions.split("#@#");
        int conditionCount = conditionsArray.length;
        if (conditionCount > 0) {
          responMap = generateHashMap(conditionsArray);
        }
      }
    }
    filterMenus = responMap;

    if (responMap != null && responMap.containsKey("CategoryStyle")) {
      String categoryStyle = responMap["CategoryStyle"] ?? "";
      if (categoryStyle.contains("showlevel1category")) {
        landingpageTypestr = "1";
      } else if (categoryStyle.contains("thumbnails")) {
        landingpageTypestr = "2";
      } else {
        landingpageTypestr = "0";
      }
    } else {
      landingpageTypestr = "0";
    }
    setState(() {
      landingpageType = landingpageTypestr;
    });
    print("neel  --- landingpageType ---- $landingpageTypestr");
  }

  void _settingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: InsColor(appBloc).appBGColor,
      context: context,
      builder: (BuildContext bc) {
        List<NativeMenuModel> listNativeModel = [];

        appBloc.listNativeModel.forEach((element) {
          if (element.parentMenuId == "0") {
            listNativeModel.add(element);
          }
        });

        return Container(
          child: ListView.builder(
            itemCount: listNativeModel.length + 2,
            itemBuilder: (context, pos) {
              if (pos > 3) {
                if (pos == listNativeModel.length + 1) {
                  return ListTile(
                      title: Text("Sign Out",
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.apply(color: InsColor(appBloc).appTextColor)),
                      leading: Icon(
                        Icons.logout,
                        color: InsColor(appBloc).appIconColor,
                      ),
                      onTap: () => _confirmSignout(context));
                  // return Container(height: 1,);
                } else if (pos == listNativeModel.length) {
                  return Column(children: [
                    ListTile(
                      leading: Icon(
                        Icons.insert_chart,
                        color: InsColor(appBloc).appIconColor,
                      ),
                      title: Text(
                        appBloc.localstr.loginActionsheetSettingsoption,
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            ?.apply(color: InsColor(appBloc).appTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          selectedmenu = "2000";
                          appBarTitle =
                              appBloc.localstr.loginActionsheetSettingsoption;
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.feedback,
                        color: InsColor(appBloc).appIconColor,
                      ),
                      title: Text(
                        'Feedback',
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            ?.apply(color: InsColor(appBloc).appTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          selectedmenu = "2001";
                          // appBarTitle = 'Feedback';
                          appBarTitle = appBloc.feedbackTitle;
                        });
                      },
                    )
                  ]);
                } else {
                  return ExpansionTile(
                      trailing: _buildList(listNativeModel[pos]).length == 0
                          ? const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            )
                          : const Icon(Icons.keyboard_arrow_down),
                      leading: Icon((listNativeModel[pos].image != null &&
                              listNativeModel[pos].image.length > 0)
                          ? listNativeModel[pos].image.contains("-")
                              ? IconDataSolid(int.parse('0x${"f02d"}'))
                              : IconDataSolid(
                                  int.parse('0x${listNativeModel[pos].image}'))
                          : IconDataSolid(int.parse(
                              '0x${"f02d"}',
                            ))),
                      title: GestureDetector(
                        onTap: () {
                          if (_buildList(listNativeModel[pos]).length == 0) {
                            Navigator.of(context).pop(); // close the drawer
                            setState(() {
                              appBarTitle = listNativeModel[pos].displayname;
                              _selectedDrawerIndex = pos;
                              selectedmenu = listNativeModel[pos].contextmenuId;
                              isDrawer = true;
                            });
                          }
                        },
                        child: Text(listNativeModel[pos].displayname,
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.apply(color: InsColor(appBloc).appTextColor)),
                      ),
                      children: <Widget>[
                        Align(
                          child: Column(
                              children: _buildList(listNativeModel[pos])),
                        )
                      ]
                      /*onTap: (){
                    setState(() {
                      appBarTitle = listNativeModel[pos].displayname;
                      _selectedDrawerIndex = pos;
                      isDrawer = true;
                    });
                    Navigator.pop(context);
                  },*/
                      );
                }
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    NavigationController().actbaseScaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
    checkSubSiteLogin();
    appBloc.add(NotificationCountEvent());
    appBloc.add(WishlistCountEvent());

    defaultMenuItems = {
      AppMenuIds.SETTINGS : appBloc.localstr.loginActionsheetSettingsoption,
      AppMenuIds.FEEDBACK : appBloc.feedbackTitle,
      AppMenuIds.NOTIFICATIONS : "Notifications",
    };

    if (widget.notification != null && widget.isFromNotification) {
      if (widget.notification.toString() == NewConnectionRequest) {
        selectedmenu = '10';
        appBarTitle = 'My Connections';
      } else if (widget.notification.toString() == ForumCommentNotification) {
        selectedmenu = '4';
        appBarTitle = 'Discussions';
      } else if (widget.notification.toString() == NewInDiscussionThread) {
        selectedmenu = '4';
        appBarTitle = 'Discussions';
      }
    }

    // Set the background messaging handler early on, as a named top-level function
    // FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsIOS = IOSInitializationSettings();
    // var initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) {
    //   if (message != null) {
    //     /*data = message.data["contextmenuid"];
    //     contentId = message.data["contentid"];
    //     print('&&&&22222 : ' + data);
    //     doGetData(data, contentId);*/
    //   }
    // });

    appBloc.uiSettingModel.setIsFromPush(false);

    fireStoreAuth();

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   //fcmResponse = fcmResponseFromJson(message.toString());
    //   //this.data = messetState(() {
    //   // data = message.data["contextmenuid"];
    //   contentID = message.data["contentid"];
    //   // doGetData(data, contentId);

    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             channelDescription: channel.description,
    //             // TODO add a proper drawable resource to android, for now using
    //             icon: '@mipmap/ic_launcher',
    //           ),
    //         ),
    //         payload: message.data['contextmenuid']);
    //   }

    //   print('Message data: ${message.data}');
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   contentID = message.data["contentid"];
    //   if (message.data["contextmenuid"] != null &&
    //       message.data["contentid"] != '') {
    //     appBloc.listNativeModel.asMap().forEach((index, element) {
    //       if (element.contextmenuId == widget.notification) {
    //         print("#### : " +
    //             appBloc.nativeMenuModel.menuid +
    //             " : " +
    //             appBloc.nativeMenuModel.displayname);

    //         _selectedDrawerIndex = index;
    //         switch (message.data["contextmenuid"].toString()) {
    //           case "2":
    //             appBloc.listNativeModel.forEach((element) {
    //               if (element.contextmenuId == message.data["contextmenuid"]) {
    //                 selectedmenu = element.contextmenuId;
    //                 appBarTitle = element.displayname;
    //                 contentID = message.data["contentid"];
    //                 _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex,
    //                     true, selectedmenu);
    //               }
    //             });
    //             break;
    //           case "1":
    //             appBloc.listNativeModel.forEach((element) {
    //               if (element.contextmenuId == message.data["contextmenuid"]) {
    //                 selectedmenu = element.contextmenuId;
    //                 appBarTitle = element.displayname;
    //                 contentID = message.data["contentid"];
    //                 _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex,
    //                     true, selectedmenu);
    //               }
    //             });

    //             break;
    //           case "3":
    //             appBloc.listNativeModel.forEach((element) {
    //               if (element.contextmenuId == message.data["contextmenuid"]) {
    //                 selectedmenu = element.contextmenuId;
    //                 appBarTitle = element.displayname;
    //                 contentID = message.data["contentid"];
    //                 _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex,
    //                     true, selectedmenu);
    //               }
    //             });
    //             break;
    //           case "4":
    //             appBloc.listNativeModel.forEach((element) {
    //               if (element.contextmenuId == message.data["contextmenuid"]) {
    //                 selectedmenu = element.contextmenuId;
    //                 appBarTitle = element.displayname;
    //                 contentID = message.data["contentid"];
    //                 _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex,
    //                     true, selectedmenu);
    //               }
    //             });
    //             break;
    //           case "5":
    //             appBloc.listNativeModel.forEach((element) {
    //               if (element.contextmenuId == message.data["contextmenuid"]) {
    //                 selectedmenu = element.contextmenuId;
    //                 appBarTitle = element.displayname;
    //                 contentID = message.data["contentid"];
    //                 _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex,
    //                     true, selectedmenu);
    //               }
    //             });
    //             break;
    //         }
    //       }
    //     });
    //   }
    // });

    // notificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: (value) => onSelectNotification(value ?? ""));

    print("getMobileAppMenuPosition ${appBloc.uiSettingModel.menuBGColor}");
    getUserDetails();
    getCatalogLandingPage();
    profileBloc = ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    profileBloc.add(GetProfileInfo());
    detailsBloc = MyLearningDetailsBloc(myLearningRepository: MyLearningRepositoryBuilder.repository());
    onlineSync();
  }

  @override
  Widget build(BuildContext context) {
    pageMounted = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pageMounted = true;
    });

    //appBloc.count = '';
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    /*if (isDrawer) {
      widget.isFromNotification = false;
      widget.contentId = '';
    }*/
    basicDeviceHeightWidth(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    List<Widget> drawerOptions = <Widget>[];
    List<BottomNavigationBarItem> bottomOptions = <BottomNavigationBarItem>[];

    List<NativeMenuModel> listNativeModel = [];

    appBloc.listNativeModel.forEach((element) {
      if (element.parentMenuId == "0") {
        listNativeModel.add(element);
      }
    });

    if (appBloc.uiSettingModel.mobileAppMenuPosition == "bottom" && appBloc.uiSettingModel.showMoreActionForBottomMenu != "true") {
      for (var i = 0; i < listNativeModel.length + 2; i++) {
        if (i == listNativeModel.length + 1) {
          //print("om navigation come");
          isFromSubSite == 'true'
              ? _addPlaygroundMenu(drawerOptions, context)
              : print('isFromSubSite false');
          /*
          drawerOptions.add(
            Container(
              //height: 6 * SizeConfig.heightMultiplier,
              child: ListTile(
                leading: Icon(
                  Icons.insert_chart,
                  //color: GlobalColor.secondaryAppColor,
                ),
                title: new Text(
                  "Sign Out",
                  style: TextStyle(
                      color: appBloc.uiSettingModel.menuTextColor.isEmpty
                          ? Colors.white
                          : Colors.black),
                ),
                onTap: () => _confirmSignout(context),
              ),
            ),
          );
        */
        }
        else if (i == listNativeModel.length) {
          drawerOptions.add(
            Container(
              //height: 6 * SizeConfig.heightMultiplier,
              child: ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
                title: Text(
                  appBloc.localstr.loginActionsheetSettingsoption,
                  style: TextStyle(
                      color: appBloc.uiSettingModel.menuTextColor.isEmpty
                          ? Colors.white
                          // : Color(int.parse("0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}"))),
                          : AppColors.getMenuTextColor()),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    selectedmenu = "2000";
                    appBarTitle = appBloc.localstr.loginActionsheetSettingsoption;
                    documentReference.update({"selected_menu":selectedmenu});
                  });
                },
              ),
            ),
          );
        }
        else {
          if (i > 3) {
            drawerOptions.add(
              Container(
                //height: 6 * SizeConfig.heightMultiplier,
                child: ExpansionTile(
                  leading: Icon((listNativeModel[i].image != null &&
                          listNativeModel[i].image.length > 0)
                      ? listNativeModel[i].image.contains("-")
                          ? IconDataSolid(int.parse('0x${"f02d"}'))
                          : IconDataSolid(
                              int.parse('0x${listNativeModel[i].image}'))
                      : IconDataSolid(int.parse(
                          '0x${"f02d"}',
                        ))),
                  trailing: _buildList(listNativeModel[i]).length == 0
                      ? const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        )
                      : const Icon(Icons.keyboard_arrow_down),
                  title: GestureDetector(
                    onTap: () {
                      if (_buildList(listNativeModel[i]).length == 0) {
                        Navigator.of(context).pop(); // close the drawer
                        setState(() {
                          appBarTitle = listNativeModel[i].displayname;
                          _selectedDrawerIndex = i;
                          selectedmenu = listNativeModel[i].contextmenuId;
                          isDrawer = true;
                          documentReference.update({"selected_menu":listNativeModel[i].menuid});
                        });
                      }
                    },
                    child: Text(
                      listNativeModel[i].displayname,
                      style: TextStyle(
                          color: appBloc.uiSettingModel.menuTextColor.isEmpty
                              ? Colors.white
                              : AppColors.getMenuTextColor()),
                    ),
                  ),
                  children: <Widget>[
                    Column(children: _buildList(listNativeModel[i]))
                  ],
                ),
              ),
            );
          }
        }
      }
    }
    //print("Drawer Options Length:${drawerOptions.length}");

    if (appBloc.uiSettingModel.mobileAppMenuPosition != "bottom") {
      //print("om navigation come:${listNativeModel.length}");
      //print("First Model:${listNativeModel.first.displayname}");

      for (var i = 0; i < listNativeModel.length + 2; i++) {
        if (i == listNativeModel.length + 1) {
          _addMessageMenu(drawerOptions, context);
          //print("om navigation come");
          isFromSubSite == 'true'
              ? _addPlaygroundMenu(drawerOptions, context)
              : print('isFromSubSite false');
          /*
          if (isFromSubSite ?? false) {
            print('passing playground');
            Divider();
            drawerOptions.add(
              Container(
                //height: 6 * SizeConfig.heightMultiplier,
                child: ListTile(
                  leading: Icon(Icons.arrow_back,
                      color: appBloc.uiSettingModel.menuTextColor.isEmpty
                          ? Colors.white
                          : Colors.black
                      //color: GlobalColor.secondaryAppColor,
                      ),
                  title: new Text(
                    "Playground",
                    style: TextStyle(
                        color: appBloc.uiSettingModel.menuTextColor.isEmpty
                            ? Colors.white
                            : Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}"))),
                  ),
                  onTap: () => {
                    sharePref_saveBool(sharedPrefIsSubSiteEntered, false),
                    sharePref_saveString(
                        sharedPref_siteURL, ApiEndpoints.mainSiteURL),
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => SplashScreen(true)),
                        (Route<dynamic> route) => false)
                  },
                ),
              ),
            );
          } else {
            print('passing sign out');
            drawerOptions.add(
              Container(
                //height: 6 * SizeConfig.heightMultiplier,
                child: ListTile(
                  leading: Icon(Icons.insert_chart,
                      color: appBloc.uiSettingModel.menuTextColor.isEmpty
                          ? Colors.white
                          : Colors.black
                      //color: GlobalColor.secondaryAppColor,
                      ),
                  title: new Text(
                    "Sign Out",
                    style: TextStyle(
                        color: appBloc.uiSettingModel.menuTextColor.isEmpty
                            ? Colors.white
                            : Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}"))),
                  ),
                  onTap: () => _confirmSignout(context),
                ),
              ),
            );
          }
          */
        }
        else if (i == listNativeModel.length) {
          drawerOptions.add(
            Container(
              //height: 6 * SizeConfig.heightMultiplier,
              child: ListTile(
                leading: Icon(Icons.settings,
                    color: appBloc.uiSettingModel.menuTextColor.isEmpty
                        ? Colors.white
                        : AppColors.getMenuTextColor()
                      //color: GlobalColor.secondaryAppColor,
                    ),
                title: Text(
                  appBloc.localstr.loginActionsheetSettingsoption != null
                      ? appBloc.localstr.loginActionsheetSettingsoption
                      : "",
                  style: TextStyle(
                      color: appBloc.uiSettingModel.menuTextColor.isEmpty
                          ? Colors.white
                          // : Color(int.parse("0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}"))),
                          : Colors.black),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    selectedmenu = "2000";
                    appBarTitle = appBloc.localstr.loginActionsheetSettingsoption;
                    documentReference.update({"selected_menu":selectedmenu});
                  });
                },
              ),
            ),
          );

          MyPrint.printOnConsole("appBloc.uiSettingModel.enableChatBot:${appBloc.uiSettingModel.enableChatBot}");
          if(appBloc.uiSettingModel.enableChatBot.toLowerCase() == "true") {
            drawerOptions.add(
              Container(
                //height: 6 * SizeConfig.heightMultiplier,
                child: ListTile(
                  leading: Image.asset(
                    "assets/images/chatbot-chat-Icon.png",
                    height: 30,
                    width: 30,
                    errorBuilder: (_, __, ___) => const Icon(Icons.info),
                  ),
                  title: Text(
                    "InstaBot",
                    style: TextStyle(
                        color: appBloc.uiSettingModel.menuTextColor.isEmpty
                            ? Colors.white
                            : Colors.black),
                  ),
                  onTap: () async => {
                    Navigator.pop(context),
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InstaBotScreen())),
                    // documentReference.update({"selected_menu":"2003"}),
                  },
                ),
              ),
            );
          }

          drawerOptions.add(
            Container(
              //height: 6 * SizeConfig.heightMultiplier,
              child: ListTile(
                leading: Icon(Icons.feedback,
                    color: appBloc.uiSettingModel.menuTextColor.isEmpty
                        ? Colors.white
                        : AppColors.getMenuTextColor()
                    //color: GlobalColor.secondaryAppColor,
                    ),
                title: Text(
                  'Feedback',
                  style: TextStyle(
                      color: appBloc.uiSettingModel.menuTextColor.isEmpty
                          ? Colors.white
                          : Colors.black),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    selectedmenu = "2001";
                    // appBarTitle = 'Feedback';
                    appBarTitle = appBloc.feedbackTitle;
                    documentReference.update({"selected_menu":selectedmenu});
                  });
                },
              ),
            ),
          );
          drawerOptions.add(
            Container(
              // width: 40,
              // height: 40,
              //height: 6 * SizeConfig.heightMultiplier,
              child: ListTile(
                leading: Icon(Icons.notifications,
                    color: appBloc.uiSettingModel.menuTextColor.isEmpty
                        ? Colors.white
                        : Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}"))
                    //color: GlobalColor.secondaryAppColor,
                    ),
                title: Text(
                  'Notifications',
                  style: TextStyle(
                      color: appBloc.uiSettingModel.menuTextColor.isEmpty
                          ? Colors.white
                          : Colors.black),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    selectedmenu = "2002";
                    appBarTitle = 'Notifications';
                    documentReference.update({"selected_menu":selectedmenu});
                  });
                },
              ),
            ),
          );
          drawerOptions.add(
            Container(
              /*width: 40,
              height: 40,*/
              //color: Colors.red,
              //height: 6 * SizeConfig.heightMultiplier,
              child: BottomsheetOptionTile(
                iconData: Icons.download,
                text: AppStrings.my_downloads,
                iconColor: AppColors.getMenuTextColor(),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    selectedmenu = AppMenuIds.MY_DOWNLOADS;
                    appBarTitle = AppStrings.my_downloads;
                  });
                },
              ),
            ),
          );
        }
        else {
          NativeMenuModel nativeMenuModel = listNativeModel[i];
          //print("NativeMenuModel:${nativeMenuModel.displayname}");
          drawerOptions.add(
            Container(
              //height: 6 * SizeConfig.heightMultiplier,
              child: ExpansionTile(
                onExpansionChanged: (bool? value) {
                  if (_buildList(nativeMenuModel).length == 0) {
                    Navigator.of(context).pop(); // close the drawer
                    //print("close the drawer called");
                    setState(() {
                      appBarTitle = nativeMenuModel.displayname;
                      _selectedDrawerIndex = i;
                      selectedmenu = nativeMenuModel.contextmenuId;
                      documentReference.update({"selected_menu":nativeMenuModel.menuid});
                      isDrawer = true;
                      if (isChanged) {
                        isChanged = false;
                        isCatalogChanged = nativeMenuModel.componentId;
                      }
                      else {
                        isChanged = true;
                        isCatalogChanged = nativeMenuModel.componentId;
                      }
                    });
                  }
                },
                  leading: Icon(
                    (listNativeModel[i].image != null && listNativeModel[i].image.length > 0)
                        ? listNativeModel[i].image.contains("-")
                            ? IconDataSolid(int.parse('0x${"f02d"}'))
                            : IconDataSolid(int.parse('0x${listNativeModel[i].image}'))
                        : IconDataSolid(int.parse('0x${"f02d"}')),
                    color: (appBarTitle == listNativeModel[i].displayname)
                        ? Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                        : appBloc.uiSettingModel.menuTextColor.isEmpty
                            ? Colors.white
                            : Color(int.parse("0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}")),
                  ),
                  trailing: _buildList(listNativeModel[i]).length == 0
                      ? Icon(
                          Icons.arrow_drop_down,
                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.menuBGColor.substring(1, 7).toUpperCase()}")),
                        )
                      : const Icon(Icons.keyboard_arrow_down),
                  title: Text(
                    nativeMenuModel.displayname,
                    style: const TextStyle(
                      color: Colors.black)
                        // color: (appBarTitle == nativeMenuModel.displayname)
                        //     ? Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                        //     : appBloc.uiSettingModel.menuTextColor.isEmpty
                        //         ? Colors.white
                        //         : Color(int.parse("0xFF${appBloc.uiSettingModel.menuTextColor.substring(1, 7).toUpperCase()}"))),
                  ),
                  children: <Widget>[
                    Column(children: _buildList(nativeMenuModel))
                  ],
              ),
            ),
          );
        }
      }
    }
    //print("Drawer Options Length:${drawerOptions.length}");

    if (listNativeModel.length >= 5) {
      for (var i = 0; i < 5; i++) {
        if (i == 4) {
          bottomOptions.add(_navItem("More", Icons.apps));
        }
        else {
          bottomOptions.add(_navItem(
            listNativeModel[i].displayname,
            // IconDataSolid(int.parse('0x${"f02d"}')),
            (listNativeModel[i].image.length > 0)
                ? listNativeModel[i].image.contains("-")
                    ? IconDataSolid(int.parse('0x${"f02d"}'))
                    : IconDataSolid(int.parse('0x${listNativeModel[i].image}'))
                : IconDataSolid(int.parse(
                    '0x${"f02d"}',
                  )),
          ));
        }
      }
    }

    //NativeMenuModel? nativeMenuModel = appBloc.listNativeModel.isNotEmpty ? appBloc.listNativeModel.first : null;
    //print("First Native Model:${nativeMenuModel?.displayname}");

    if (isFirst) {
      isFirst = false;

      if (listNativeModel.isNotEmpty) {
        NativeMenuModel nativeMenuModel = listNativeModel.first;
        //NativeMenuModel nativeMenuModel = listNativeModel[1];

        print("Selected Menu in IsFirst:${widget.selectedMenu}");
        if(widget.selectedMenu.isNotEmpty) {
          List<NativeMenuModel> list = listNativeModel.where((element) => element.contextmenuId == widget.selectedMenu).toList();
          if(list.isNotEmpty) {
            nativeMenuModel = list.first;
          }
          print("List Length:${list.length}");
        }

        selectedmenu = nativeMenuModel.contextmenuId;
        appBarTitle = nativeMenuModel.displayname;
        _currentBottomMenuIndex = listNativeModel.indexOf(nativeMenuModel);
        if(_currentBottomMenuIndex < 0) _currentBottomMenuIndex = 0;

        _selectedDrawerIndex = 0;
        isDrawer = true;
        if (isChanged) {
          isChanged = false;
          isCatalogChanged = nativeMenuModel.componentId;
        }
        else {
          isChanged = true;
          isCatalogChanged = nativeMenuModel.componentId;
        }
      }
      else {
        selectedmenu = "2000";
        appBarTitle = appBloc.localstr.loginActionsheetSettingsoption;
      }
    }

    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            if (_selectedDrawerIndex == 0) {
              return true;
            }
            else {
              //Navigator.of(context).pushReplacementNamed(route_actbase);
              return false;
            }
          },
          child: BlocConsumer(
            bloc: appBloc,
            listener: (context, state) {
              if (state is ProfileImageState) {
                print('imageurll_bloc ${appBloc.imageUrl}');
                setState(() {
                  userimageUrl = appBloc.imageUrl;
                });
              }
            },
            builder: (context, state) => Scaffold(
              key: NavigationController().actbaseScaffoldKey,
              backgroundColor: Colors.white,
              appBar: getAppBar(),
              body: SafeArea(
                child: Container(
                  key: _drawerKey,
                  child: _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex, true, selectedmenu),
                ),
              ),
              onDrawerChanged: (bool val){
                //documentReference.update({"is_drawer_opened":val});
              },
              drawer: getDrawer(useMobileLayout, drawerOptions),
              bottomNavigationBar: getBottomNavigationBar(bottomOptions),
            ),
          ),
        ),
        isGlobalConfigurationLoading
            ? Container(
            color: Colors.black.withOpacity(0.3),
            child: const SpinKitFadingCircle(color: Colors.green,))
            : Container()
      ],
    );
  }


  AppBar getAppBar() {
    //print("Wishlist Count in ActBase:${appBloc.wishlistcount}");

    //print("Text Color:${appBloc.uiSettingModel.appHeaderTextColor}");

    Color backgroundColor = AppColors.getMenuTextColor();
    Color lableColor = AppColors.getMenuBGColor();
    MyPrint.printOnConsole("selected menu : $selectedmenu");

    return AppBar(
      iconTheme: IconThemeData(
        color: lableColor,
      ),
      backgroundColor: backgroundColor,
      elevation: 0,
      title: Text(
        appBarTitle,
        maxLines: 1,
        overflow: TextOverflow.visible,
        style: TextStyle(
          fontSize: 20,
          color: lableColor,
        ),
      ),
      actions: <Widget>[
        // Icon(Icons.notifications),
        Stack(
          children: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: (){
                  setState(() {
                    setState(() {
                      selectedmenu = "2002";
                      appBarTitle = 'Notifications';
                    });
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: selectedmenu == "4" ? 0 : 12.0),
                  child: Center(child: Icon(Icons.notifications,size: 25.h,)),
                )),
            // IconButton(
            //   alignment: Alignment.center,
            //   padding: EdgeInsets.zero,
            //     icon: Icon(Icons.notifications, color: lableColor),
            //     onPressed: () async {
            //       /*Navigator.push(context, MaterialPageRoute(builder: (_) {
            //         return TempInAppPurchasePage();
            //       }));*/
            //       setState(() {
            //         setState(() {
            //           selectedmenu = "2002";
            //           appBarTitle = 'Notifications';
            //         });
            //       });
            //     }),
            Visibility(
              visible: (int.tryParse(appBloc.count) ?? 0) > 0,
              // visible: true,
              child: Positioned(
                right:selectedmenu =="4"? 0: 11,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    //color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.isNotEmpty ? appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase() : "000000"}")),
                    color: lableColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: backgroundColor),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    appBloc.count,
                    style: TextStyle(
                      color: backgroundColor,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
        selectedmenu == "1"
            ? SizedBox(
                width: ScreenUtil().setWidth(20),
              )
            : Container(),
        selectedmenu == "1"
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WaitListScreen()));
                },
                child: Icon(
                  Icons.featured_play_list,
                  color: lableColor,
                ))
            : Container(),
        selectedmenu == "1"
            ? SizedBox(
                width: ScreenUtil().setWidth(20),
              )
            : Container(),
        selectedmenu == "4"
            ? SizedBox(
                width: ScreenUtil().setWidth(20),
              )
            : Container(),
        (selectedmenu == "2" && landingpageType == "0")
            ? Stack(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => ProviderModel(),
                            child: WishList(
                              categaoryID: 0,
                              categaoryName: "",
                              detailsBloc: detailsBloc,
                              filterMenus: filterMenus,
                            ),
                          )));
                    },
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11.0),
                          child: Icon(Icons.favorite,size: 25.h,color: lableColor,),
                        )),

                  ),
                  Visibility(
                    visible: (int.tryParse(appBloc.wishlistcount) ?? 0) > 0,
                    child: new Positioned(
                      right: 6,
                      top: 14,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: lableColor,
                          // color: Color(int.parse(
                          //     "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                          // borderRadius: BorderRadius.circular(6),
                          shape: BoxShape.circle,
                          border: Border.all(color: backgroundColor),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          appBloc.wishlistcount,
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              )
       : Container(),
       (selectedmenu == "8")
            ? Stack(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EventWishListScreen()));
                    },
                    child: Center(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0),
                      child: Icon(Icons.favorite, color: lableColor,size: 25.h),
                    )),
                  ),
                  Visibility(
                    visible: (int.tryParse(appBloc.wishlistcount) ?? 0) > 0,
                    // visible: true,
                    child: Positioned(
                      right: 6,
                      top: 14,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: lableColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: backgroundColor),
                          // color: Color(int.parse(
                          //     "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                          // borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          appBloc.wishlistcount,
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
        (selectedmenu == "2" && landingpageType == "0") || selectedmenu == "8"
            ? SizedBox(
                width: ScreenUtil().setWidth(20),
              )
            : Container(),
        selectedmenu == "14"
            ? Visibility(
                visible: false, //appBloc.isAllowGroupBy ? true : false,
                child: Container(
                    color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        ),
                        child: PopupMenuButton(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                          child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.list,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                              )),
                          elevation: 3.2,
                          onSelected: (String value) {
                            setState(() {
                              appBloc.groupVlaue = value;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return groupValueArr.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(
                                  choice,
                                  style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  ),
                                ),
                              );
                            }).toList();
                          },
                        ))
                    /* new DropdownButtonHideUnderline(
                          child:  DropdownButton(
                              icon: Padding(padding: EdgeInsets.only(right: 8.0),
                                  child:Icon(Icons.list,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),)),
                              items: groupValueArr.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value,
                                    style: TextStyle(color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),),
                                );
                              }).toList(),
                              onChanged:  (String value){
                                setState(() {
                                  appBloc.groupVlaue = value;
                                });
                              }


                          )))*/
                    ))
            : Container(),
      ],
    );
  }

  Widget getDrawer(bool useMobileLayout, List<Widget> drawerOptions) {
    return Builder(
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width * (useMobileLayout ? 0.7 : 0.4),
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  DrawerHeaderWidget(
                    signOutFunc: signOutFunc,
                  ),
                  Expanded(
                    child: BlocConsumer<ProfileBloc, ProfileState>(
                      bloc: profileBloc,
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state.status == Status.COMPLETED) {
                          if (isMenuExists()) {
                            _addMessageMenu(drawerOptions, context);
                            appBloc.uiSettingModel.setIsMsgMenuExist(true);
                          }
                        }
                        return Container(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.menuBGColor.substring(1, 7).toUpperCase()}")),
                          child: ListView.builder(
                            itemCount: drawerOptions.length,
                            itemBuilder: (context, pos) {

                              return drawerOptions[pos];
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? getBottomNavigationBar(List<BottomNavigationBarItem> bottomOptions) {
    if (appBloc.uiSettingModel.mobileAppMenuPosition == "bottom") {
      return BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
        elevation: 20,
        unselectedItemColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")).withOpacity(0.5),
        selectedFontSize: ScreenUtil().setSp(6),
        unselectedFontSize: ScreenUtil().setSp(8),
        selectedItemColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
        onTap: onTabTapped,
        currentIndex: _currentBottomMenuIndex,
        type: BottomNavigationBarType.fixed,
        // 4+ items in the bar
        items: bottomOptions,
      );
    }
    //return Container();
  }

  List<Widget> _buildList(NativeMenuModel model) {
    List<Widget> list = [];

    for (int i = 0; i < appBloc.listNativeModel.length; i++) {
      if (appBloc.listNativeModel[i].parentMenuId == model.menuid) {
        list.add(GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // close the drawer
              setState(() {
                appBarTitle = appBloc.listNativeModel[i].displayname;
                _selectedDrawerIndex = i;
                selectedmenu = appBloc.listNativeModel[i].contextmenuId;
                isDrawer = true;
                documentReference.update({"selected_menu":appBloc.listNativeModel[i].menuid});
              });
            },
            child: ListTile(
                title: Text(
                  appBloc.listNativeModel[i].displayname,
                  style: TextStyle(
                      color: appBloc.uiSettingModel.menuTextColor.isEmpty
                          ? Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                          : Colors.black),
                ),
                leading: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ))));
      }
    }
    return list;
  }
}
