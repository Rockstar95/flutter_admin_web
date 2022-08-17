import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/controllers/my_learning_download_controller.dart';
import 'package:flutter_admin_web/framework/bloc/Splash/bloc/splash_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/Splash/event/splash_event.dart';
import 'package:flutter_admin_web/framework/bloc/Splash/states/splash_state.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/events/app_event.dart';
import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/local_downloading_service.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/splash_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/splash_repositry_public.dart';
import 'package:flutter_admin_web/framework/repository/auth/provider/authentication_repository.dart';
import 'package:flutter_admin_web/ui/OnBoarding/on_boarding_screen.dart';
import 'package:flutter_admin_web/ui/auth/login_common_page.dart';
import 'package:flutter_admin_web/ui/home/ActBase.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appModule/app.dart';

const kLocalContentUrl =
    "http://qademo.instancy.com/content/SiteConfiguration/374/SplashImages.zip";

class SplashScreen extends StatefulWidget {
  final bool downloadServiceInitialized;

  const SplashScreen(this.downloadServiceInitialized);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashBloc splashBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  LocalDownloadService? _downloader;
  int _downloadProgress = 0;
  bool _downloaded = false;

  List<FileSystemEntity> fileList = [];
  String directory = "";
  String isLoggedIn = "";
  String appLogoUrl = "";

  bool savedThemes = false;

  @override
  void initState() {
    isSubsiteEntered();
    // _checkFirstLaunch();
    super.initState();
    changeThemeBloc.onLightThemeChange();

    splashBloc = SplashBloc(splashRepository: SplashRepositoryBuilder.repository());
    splashBloc.add(GetAppLogoEvent());
  }

  // Future<void> _checkFirstLaunch() async {
  //   setState(() async {
  //     var isFirstTime = await sharePref_getBool(isAppLaunchFirstTime);
  //   });
  // }

  Future<void> isSubsiteEntered() async {
    var switchStr = await sharePrefGetString(savedTheme);

    String siteURL = await sharePrefGetString(sharedPref_siteURL);

    switchStr == "true" ? savedThemes = true : savedThemes = false;

    // switchStr == "true" ? isSwitched = true : isSwitched = false;

    String isFromSubSite = await sharePrefGetString(sharedPrefIsSubSiteEntered);
    String subsiteID = await sharePrefGetString(sharedPrefSubSiteSiteId);

    if (isFromSubSite == 'true') {
      ApiEndpoints.siteID = subsiteID;
    }

    if (siteURL.isEmpty) {
      appLogoUrl = ApiEndpoints.mainSiteURL + "Content/SiteConfiguration/374/LoginSettingLogo/logo.png";
    }
    else {
      appLogoUrl = siteURL + "Content/SiteConfiguration/374/LoginSettingLogo/logo.png";
    }
  }

  Future<void> downloadZip(SplashBloc splashBloc, BuildContext context) async {
    print("downloadZip called");
    _downloader = LocalDownloadService(
      "${ApiEndpoints.strSiteUrl}/content/SiteConfiguration/374/SplashImages.zip",
      (CallbackParam? callbackParam) {
        if (callbackParam != null) {
          _downloaderCallBack(callbackParam, splashBloc, context);
        }
      },
      "SplashImages",
    );

    await _hasModel();

    initialiseModelDownload();
  }

  // Update the progress on the model download
  Future<void> _downloaderCallBack(CallbackParam callbackParam, SplashBloc splashBloc, BuildContext context) async {
    _downloadProgress = callbackParam.progress;
    _downloaded = callbackParam.status == DownloadTaskStatus.complete && callbackParam.isFileExtracted;

    if (_downloadProgress == -1) {
      nextScreenNav(context, false);
    }

    if (_downloaded) {
      List<FileSystemEntity> imageList = await _downloader!.getOnBoardingImages();

      //nextScreenNav(context, false, imageList);
    }
  }

  Future<bool> _hasModel() async {
    // TODO - fix isModelsAvailable as only checks for directory and not
    return await _downloader?.isModelsAvailable() ?? false;
  }

  Future<void> initialiseModelDownload() async {
    if (!widget.downloadServiceInitialized) {
      await _downloader?.initialize();
    }
    _downloader?.startDownload();
  }

  void nextScreenNav(BuildContext context, bool isLogin, [List<String> imageList = const []]) {
    if (isLogin) {
      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false,);
      //  i am already login  go to home page
    }
    else {
      MyPrint.printOnConsole("EnableNativeSplashImage ---------------${appBloc.uiSettingModel.enableNativeSplashImage}");
      if (appBloc.uiSettingModel.enableNativeSplashImage == "true") {
        if (imageList.isNotEmpty) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OnBoardingScreen(imageList: imageList,)), (_) => false);
        }
        else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginCommonPage()), (_) => false);
        }
      }
      else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginCommonPage()), (_) => false);
      }
    }
  }

  void doGetData() async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getString('login') ?? "";

    if (isLoggedIn == 'true') {
      //TODO: Code TO Implement Get New Bearer Token
      appBloc.userid = await sharePrefGetString(sharedPref_userid);
      appBloc.imageUrl = await sharePrefGetString(sharedPref_image);

      bool networkAvailable = await AppDirectory.checkInternetConnectivity();
      if(!networkAvailable) {
        await MyLearningDownloadController().checkDownloadedContentSubscribed();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ActBase()), (_) => false);
        return;
      }

      Response? response = await SplashRepositoryPublic().notificationCount();
      print("SplashScreen Notification Count Response Status:${response?.statusCode}, Body:${response?.body}");

      if(response != null) {
        if(response.statusCode == 401) {
          String email = await sharePrefGetString(sharedPref_LoginEmailId);
          String password = await sharePrefGetString(sharedPref_LoginPassword);

          print("Splash Screen Login Email:$email");
          print("Splash Screen Login Password:$password");

          bool loggedIn = await AuthenticationRepository().doLogin(email, password, ApiEndpoints.strSiteUrl, '', '374', false);
          print("Splash Screen IsLoggedIn:$loggedIn");

          if(loggedIn) {
            await MyLearningDownloadController().checkDownloadedContentSubscribed();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ActBase()), (_) => false);
          }
          else {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginCommonPage()), (Route<dynamic> route) => false);
          }
        }
        else {
          await MyLearningDownloadController().checkDownloadedContentSubscribed();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ActBase()), (_) => false);
        }
      }
      else {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginCommonPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      List<String> imageList = [];
      nextScreenNav(context, false, imageList);
    }*/

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // isLoggedIn = prefs.getString('login') ?? "";
    //
    // print("isLoggedIn : $isLoggedIn" );
    // if (isLoggedIn == 'true') {

    appBloc.userid = await sharePrefGetString(sharedPref_userid);
    Map<String,dynamic> userIdPass = await AuthenticationRepository().gettingSiteMetadata(ApiEndpoints.authToken);
    bool loggedIn = await AuthenticationRepository().doLogin(userIdPass["email"], userIdPass["pass"], ApiEndpoints.strSiteUrl, '', '374', false,isEncrypted: true);

    MyPrint.printOnConsole("loggedIn:$loggedIn");
    if(loggedIn) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ActBase()), (_) => false);
    }
    else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginCommonPage()), (_) => false);
    }
  }

  void setDarkTheme() {
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

    // appBloc.uiSettingModel.setappButtonBgColor("#201a28");
    // appBloc.uiSettingModel.setappButtonTextColor("#f5f5f5");

    appBloc.uiSettingModel.setExpiredBGColor("#352b44");
  }

  setDefaultTheme() async {
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

  @override
  Widget build(BuildContext context) {
    //basicDeviceHeightWidth(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    appScreenSize = MediaQuery.of(context).size;

    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState themeState) {
        return BlocConsumer<SplashBloc, SplashState>(
          bloc: splashBloc,
          listener: (context, state) async {
            // do stuff here based on BlocA's state
            if (state is GetFourApiCallState) {
              appBloc.add(SetUiSettingEvent());
              doGetData();
            }
            else if (state is GetAppLogoState) {
              setState(() {
                appLogoUrl = state.url;
              });
              splashBloc.add(GetFourApiCallEvent());
            }
          },
          builder: (context, state) {
            return Container(
              color: themeState.themeData.primaryColorDark,
              child: Stack(
                children: <Widget>[
                  appLogoUrl.length > 0
                      ? Center(
                    child: SizedBox(
                      // height: 130.h,
                      // width: MediaQuery.of(context).size.width,
                      height: 86.h,
                      width: 276.h,
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Image.asset(
                          kSplashLogo,
                        ),
                        errorWidget: (context, url, _) => Image.asset(
                          kSplashLogo,
                        ),
                        imageUrl: appLogoUrl,
                      ),
                    ),
                  )
                      : Center(
                    child: SpinKitCircle(
                      color: Colors.grey,
                      size: 25.h,
                    ),
                  ),
                  Align(
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
