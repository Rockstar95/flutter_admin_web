import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/app/WishlistResponse.dart';
import 'package:flutter_admin_web/framework/bloc/app/events/app_event.dart';
import 'package:flutter_admin_web/framework/bloc/app/localization_selection_model.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/app/notification_count_res.dart';
import 'package:flutter_admin_web/framework/bloc/app/states/app_state.dart';
import 'package:flutter_admin_web/framework/bloc/app/ui_setting_model.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/local_str.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/data_provider.dart';
import 'package:flutter_admin_web/framework/dataprovider/helper/local_database_helper.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/contract/splash_repository.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/model/mobileGetLearningPortalInfoResponse.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/model/mobileGetNativeMenusResponse.dart';
import 'package:flutter_admin_web/framework/repository/persistence_repository.dart';
import 'package:flutter_admin_web/utils/my_print.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  SplashRepository splashRepository;
  UISettingModel uiSettingModel = new UISettingModel();
  NativeMenuModel nativeMenuModel = new NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0);
  List<NativeMenuModel> listNativeModel = [];
  LocalStr localstr = LocalStr.fromJson({});
  final LocalDataProvider _localHelper = LocalDataProvider(localDataProviderType: LocalDataProviderType.hive);
  String imageUrl = "";
  String profilePic = "";
  String userName = "";
  String count = '';
  String wishlistcount = '';
  Locale appLocale = Locale('en');
  int selectedIndex = 0;
  String feedbackTitle = 'Enter New Feedback';
  String filterValue = 'CreatedDate Desc';
  String groupVlaue = 'Group By';
  bool isAllowGroupBy = true;
  String userid = "";

  bool savedThemes = false;
  NotificationCountRes notificationCountRes =
      new NotificationCountRes(table: []);
  WishlistResponse wishlistResponse = WishlistResponse(wishListDetails: []);

  AppBloc({
    required this.splashRepository,
  }) : super(AppState()) {
    _init(); // Perform the Init operation
    on<InitApp>(onEventHandler);
    on<ProfileImageUpdate>(onEventHandler);
    on<ConnectivityStatus>(onEventHandler);
    on<GetLocationEvent>(onEventHandler);
    on<PerformInitOperation>(onEventHandler);
    on<SetUiSettingEvent>(onEventHandler);
    on<ChangeLanEvent>(onEventHandler);
    on<NotificationCountEvent>(onEventHandler);
    on<WishlistCountEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(AppEvent event, Emitter emit) async {
    print("AppBloc onEventHandler called for ${event.runtimeType}");
    Stream<AppState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (AppState authState) {
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
  AppState get initialState => CheckingInitAppDataState();

  @override
  Stream<AppState> mapEventToState(event) async* {
    print("App Bloc Event:${event.runtimeType}");

    switch (event.runtimeType) {
      case InitApp:
        // TODO: Handle app init operations here
        await (PersistenceRepository.instance).initSharedPref();
        yield AppInitialized();
        break;
      case GetLocationEvent:
//        bool setLocation = await LocalStorage.setLocation();
//        print(setLocation);
        break;
      case SetUiSettingEvent:
        try {
          print("SetUiSettingEvent");

          String mobileGetLearningPortalInfoResponsStr = await _getLocalData(mobileGetLearningPortalInfoKey);
          MyPrint.logOnConsole("mobileGetLearningPortalInfoResponsStr:${mobileGetLearningPortalInfoResponsStr}");

          try {
            MobileGetLearningPortalInfoResponse mobileGetLearningPortalInfoResponse = mobileGetLearningPortalInfoResponseFromJson(
              mobileGetLearningPortalInfoResponsStr.isNotEmpty ? mobileGetLearningPortalInfoResponsStr : "{}"
            );
            setUiSettingFromMobileGetLearningPortalInfo(mobileGetLearningPortalInfoResponse);
          }
          catch(e, s) {
            print("Error in AppBloc.mapEventToState.SetUiSettingEvent.mobileGetLearningPortalInfoResponseFromJson():${e}");
            print(s);
          }
          uiSettingModel.setappname('in');
          uiSettingModel.setExpiredBGColor("#b3b0b8");
          String mobileGetNativeMenusResponseStr = await _getLocalData(mobileGetNativeMenusKey);
          developer.log("mobileGetNativeMenusResponseStr:$mobileGetNativeMenusResponseStr");
          MobileGetNativeMenusResponse mobileGetNativeMenusResponse = mobileGetNativeMenusResponseFromJson(
            mobileGetNativeMenusResponseStr.isNotEmpty ? mobileGetNativeMenusResponseStr : "{}"
          );
          MyPrint.printOnConsole("Menus :Length:${mobileGetNativeMenusResponse.table.length}");

          setNativeMenusModal(mobileGetNativeMenusResponse);
          sharePrefSaveString(sharedPref_appLogo, uiSettingModel.appLogoURl);

          String getJsonFileStr = await _getLocalData(getJsonfileKey);
          developer.log("App Bloc Json File Str:$getJsonFileStr");

          Map<String, dynamic> jsonData = json.decode(getJsonFileStr.isNotEmpty ? getJsonFileStr : "{}");

          localstr = LocalStr.fromJson(jsonData);

          savedThemes ? setDarkTheme() : print("obj ect");
        }
        catch(err, s) {
          MyPrint.logOnConsole("Error in Parsing:${err}");
          MyPrint.printOnConsole("Stack Trace:${s}");
        }

        yield SetUiSettingState(uiSettingModel, listNativeModel, localstr);
        break;
    }

    if (event is ChangeLanEvent) {
      appLocale = Locale(event.lanCode);
      sharePrefSaveString(sharedPref_AppLocale, event.lanCode);
      Response? getJsonfileResponse =
          await splashRepository.getLanguageJsonFile(event.lanCode);
      print(getJsonfileResponse?.body);
      await _saveLocally(getJsonfileResponse?.body ?? "{}", getJsonfileKey);

      String getJsonFileStr = await _getLocalData(getJsonfileKey);

      Map<String, dynamic> jsonData = json.decode(getJsonFileStr);

      localstr = LocalStr.fromJson(jsonData);

      yield ChangeLangState(appLocale: appLocale, localstr: localstr);
    }
    else if (event is ProfileImageUpdate) {
      imageUrl = await sharePrefGetString(sharedPref_tempProfileImage);
      yield ProfileImageState(imgUrl: imageUrl);
    }
    else if (event is WishlistCountEvent) {
      Response? apiResponse = await splashRepository.wishlistcount();
      if (apiResponse?.statusCode == 200) {
        wishlistResponse = wishlistCountResFromJson(apiResponse?.body ?? "{}");

        wishlistcount = wishlistResponse.wishlistCount.toString();

        print("sree : $wishlistcount");
        yield WishlistCountState();
      } else if (apiResponse?.statusCode == 401) {
        print("wishlist Error : ");
        //  yield NotificationCountState();
      } else {
        print("Error Error :");
        // yield NotificationCountState();
      }
    }
    else if (event is NotificationCountEvent) {
      Response? apiResponse = await splashRepository.notificationCount();
      if (apiResponse?.statusCode == 200) {
        notificationCountRes =
            notificationCountResFromJson(apiResponse?.body ?? "{}");

        notificationCountRes.table.forEach((element) {
          count = element.unReadCount.toString();
        });
        print("Aman : $count");
        yield NotificationCountState();
      } else if (apiResponse?.statusCode == 401) {
        print("Aman Error : ");
        //  yield NotificationCountState();
      } else {
        print("Error Error :");
        // yield NotificationCountState();
      }
    }
  }

  void _init() async {
    print("AppBloc Init Called");
    // savedThemes = await sharePref_getBool("SAVEDTHEME");

    var switchStr = await sharePrefGetString(savedTheme);

    switchStr == "true" ? savedThemes = true : savedThemes = false;

    // savedThemes ? setDarkTheme() : setDefaultTheme();

    var language = await sharePrefGetString(sharedPref_AppLocale);
    print("Language in AppBloc Init:$language");
    if (language.isEmpty) {
      print("Saving Language in AppBloc Init");
      await sharePrefSaveString(sharedPref_AppLocale, "en-us");
    }
    this.add(InitApp());
  }

  Future<void> _saveLocally(String response, String key) async {
    await _localHelper.localService(
      enumLocalDatabaseOperation: LocalDatabaseOperation.create,
      table: table_splash,
      values: {
        key: response,
      },
    );
  }

  Future<String> _getLocalData(String key) async {
    List<Map<String, dynamic>> response = await _localHelper.localService(
      enumLocalDatabaseOperation: LocalDatabaseOperation.read,
      table: table_splash,
      keys: [key],
    );
    MyPrint.printOnConsole("Data in Hive for Key ${key} is:${response}");

    Map<String, dynamic> data = response.isNotEmpty ? response.first : {};
    if (data.isEmpty) return "";

    dynamic value = data[key];
    print("Key:${key}------:$value");
    print("Type of Value:${value.runtimeType}");

    if (value == null) return "";
    String news = value;
    return news;
  }

  void setUiSettingFromMobileGetLearningPortalInfo(MobileGetLearningPortalInfoResponse response) {
//    print("App bloc response.table1 ---------- ${response.table1.length}");
//    print("App bloc response.table2 ---------- ${response.table2.length}");
//    print("App bloc response.table1 ---------- ${response.table1[0].csseditingpalceholderdisplayname}");
//

    String databody = mobileGetLearningPortalInfoResponseToJson(response);

    print("the uisettingmodel reponse is :  $databody");
    response.table.forEach((element) {
      sharePrefSaveString(sharedPref_siteid, element.siteid.toString());
    });

    response.table1.forEach((element) {
      //print(element.csseditingpalceholderdisplayname);
      // LightThemeColors lightThemeColors = new LightThemeColors();
      if (element.csseditingpalceholderdisplayname == "SITE BACKGROUND") {
        uiSettingModel
            .setappBGColor(element.bgcolor.toString().substring(0, 7));
        uiSettingModel
            .setappLoginBGColor(element.bgcolor.toString().substring(0, 7));
      }
      else if (element.csseditingpalceholderdisplayname == "SITE TEXT COLOR") {
        uiSettingModel.setappTextColor(element.textcolor.toString().substring(0, 7));
        uiSettingModel.setappLoginTextolor(element.textcolor.toString().substring(0, 7));
      }
      else if (element.csseditingpalceholderdisplayname == "HEADER BACKGROUND") {
        uiSettingModel.setappHeaderColor(element.bgcolor.toString().substring(0, 7));
      }
      else if (element.csseditingpalceholderdisplayname == "HEADER TEXT COLOR") {
        uiSettingModel.setappHeaderTextColor(element.textcolor.toString().substring(0, 7));
      }
      else if (element.csseditingpalceholderdisplayname == "MENU BACKGROUND") {
        uiSettingModel.setmenuBGColor(element.bgcolor.toString().substring(0, 7));
      }
      else if (element.csseditingpalceholderdisplayname == "MENU TEXT COLOR") {
        uiSettingModel.setmenuTextColor(element.textcolor.toString().substring(0, 7));
      }
      else if (element.csseditingpalceholderdisplayname == "MENU SEPARATOR COLOR") {}
      else if (element.csseditingpalceholderdisplayname == "SELECTED MENU BACKGROUND") {
        uiSettingModel.setselectedMenuBGColor(element.bgcolor.toString().substring(0, 7));
      }
      else if (element.csseditingpalceholderdisplayname == "SELECTED MENU TEXT COLOR") {
        uiSettingModel.setselectedMenuTextColor(element.textcolor.toString().substring(0, 7));
      }
      else if (element.csseditingpalceholderdisplayname == "BUTTON BACKGROUND") {
        uiSettingModel.setappButtonBgColor(element.bgcolor.toString().substring(0, 7));
      }
      else if (element.csseditingpalceholderdisplayname == "BUTTON TEXT COLOR") {
        print("color ---------- ${element.textcolor}");
        uiSettingModel.setappButtonTextColor(element.textcolor.toString().substring(0, 7));
      }
      else if (element.csseditingpalceholderdisplayname == "FOOTER BACKGROUND") {}
      else if (element.csseditingpalceholderdisplayname == "FOOTER TEXT COLOR") {}
      else if (element.csseditingpalceholderdisplayname == "MENU ALTERNATE COLOR") {}
    });

    response.table2.forEach((element) {
      print("ui setting model element name:${element.name}, value:${element.keyvalue}");
      if (element.name == "EnableMembership") {
        uiSettingModel.setEnableMembership(element.keyvalue.toString());
      }
      else if (element.name == "SelfRegistrationAllowed") {
        uiSettingModel.setSelfRegistrationAllowed(element.keyvalue.toString());
      }
      else if (element.name == "EnableEcommerce") {
        uiSettingModel.setEnableEcommerce(element.keyvalue.toString());
      }
      else if (element.name == "DateFormat") {
        uiSettingModel.setDateFormat(element.keyvalue.toString());
      }
      else if (element.name == "DateTimeFormat") {
        uiSettingModel.setDateTimeFormat(element.keyvalue.toString());
      }
      else if (element.name == "EventDateTimeFormat") {
        uiSettingModel.setEventDateTimeFormat(element.keyvalue.toString());
      }
      else if (element.name == "SiteLanguage") {
        uiSettingModel.setSiteLanguage(element.keyvalue.toString());
      }
      else if (element.name == "EnablePushNotification") {
        uiSettingModel.setEnablePushNotification(element.keyvalue.toString());
      }
      else if (element.name == "CommonPasswordValue") {
        uiSettingModel.setCommonPasswordValue(element.keyvalue.toString());
      }
      else if (element.name == "AutoLaunchFirstContentInMyLearning") {
        uiSettingModel
            .setAutoLaunchFirstContentInMyLearning(element.keyvalue.toString());
      }
      else if (element.name == "DiscussionForumFileTypes") {
        uiSettingModel.setDiscussionForumFileTypes(element.keyvalue.toString());
      }
      else if (element.name == "EnableSkillstobeMappedwithJobRoles") {
        uiSettingModel
            .setEnableSkillsToBeMappedWithJobRoles(element.keyvalue.toString());
      }
      else if (element.name == "UserUploadFileSize") {
        uiSettingModel.setUserUploadFileSize(element.keyvalue.toString());
      }
      else if (element.name == "ContentDownloadType") {
        uiSettingModel.setContentDownloadType(element.keyvalue.toString());
      }
      else if (element.name == "nativeapptype") {
        uiSettingModel.setNativeAppType(element.keyvalue.toString());
      }
      else if (element.name == "courseappcontent") {
        uiSettingModel.setCourseAppContent(element.keyvalue.toString());
      }
      else if (element.name == "EnableNativeCatlog") {
        uiSettingModel.setEnableNativeCatalog(element.keyvalue.toString());
      }
      else if (element.name == "autodownloadsizelimit") {
        uiSettingModel.setAutoDownloadSizeLimit(element.keyvalue.toString());
      }
      else if (element.name == "LearnerDefaultMenu") {
        uiSettingModel.setLearnerDefaultMenu(element.keyvalue.toString());
      }
      else if (element.name == "CCEventStartdate") {
        uiSettingModel.setCCEventStartDate(element.keyvalue.toString());
      }
      else if (element.name == "IsGlobasearch") {
        uiSettingModel.setIsGlobalSearch(element.keyvalue.toString());
      }
      else if (element.name == "Autocompletenontrackablecontent") {
        uiSettingModel
            .setAutocompleteNonTrackableContent(element.keyvalue.toString());
      }
      else if (element.name == "EnableAzureSSOForLearner") {
        uiSettingModel.setEnableAzureSSOForLearner(element.keyvalue.toString());
      }
      else if (element.name == "EnableContentEvaluation") {
        uiSettingModel.setEnableContentEvaluation(element.keyvalue.toString());
      }
      else if (element.name == "EnableDownLoadAudioVideoCloud") {
        uiSettingModel
            .setEnableDownLoadAudioVideoCloud(element.keyvalue.toString());
      }
      else if (element.name == "CatalogContentDownloadType") {
        uiSettingModel
            .setCatalogContentDownloadType(element.keyvalue.toString());
      }
      else if (element.name == "EnableNativeAppLoginSetting") {
        uiSettingModel
            .setEnableNativeAppLoginSetting(element.keyvalue.toString());
      }
      else if (element.name == "EnableNativeAppLoginSettingLogo") {
        uiSettingModel
            .setEnableNativeAppLoginSettingLogo(element.keyvalue.toString());
      }
      else if (element.name == "SelfRegistrationDisplayName") {
        uiSettingModel
            .setSelfRegistrationDisplayName(element.keyvalue.toString());
      }
      else if (element.name == "NativeAppLoginLogo") {
        int min = 100; //min and max values act as your 3 digit range
        int max = 999;
        var randomizer = new Random();
        var rNum = min + randomizer.nextInt(max - min);

        uiSettingModel.setNativeAppLoginLogo(element.keyvalue.toString());
        String applogoURL =
            "${response.table[0].siteurl}Content/SiteConfiguration/${response.table[0].siteid}/LoginSettingLogo/${element.keyvalue.toString()}";
        uiSettingModel.setappLogoURl(applogoURL + '?v=$rNum');
        print("App Logo URL ----------  $applogoURL");
      }
      else if (element.name == "NativeAppDarkThemeLogo") {
        int min = 100; //min and max values act as your 3 digit range
        int max = 999;
        var randomizer = new Random();
        var rNum = min + randomizer.nextInt(max - min);

        isValidString(element.keyvalue.toString())
            ? uiSettingModel.setNativeAppLoginLogo(element.keyvalue.toString())
            : uiSettingModel
                .setNativeAppLoginLogo(uiSettingModel.nativeAppLoginLogo);
        String applogoURL =
            "${response.table[0].siteurl}Content/SiteConfiguration/${response.table[0].siteid}/LoginSettingLogo/${element.keyvalue.toString()}";
        uiSettingModel.setDarkLogoURl(applogoURL + '?v=$rNum');
        print("App Logo URL ----------  $applogoURL");
      }
      else if (element.name == "EnableInAppPurchase") {
        uiSettingModel.setEnableInAppPurchase(element.keyvalue.toString());
      }
      else if (element.name == "EnableNativeSplashImage") {
        uiSettingModel.setEnableNativeSplashImage(element.keyvalue.toString());
      }
      else if (element.name == "AddProfileAdditionalTab") {
        uiSettingModel.setAddProfileAdditionalTab(element.keyvalue.toString());
      }
      else if (element.name == "EnableChatBot") {
        uiSettingModel.setEnableChatBot(element.keyvalue.toString());
      }
      else if (element.name.trim() == "BeforeLoginKnowledgeBaseID") {
        uiSettingModel.setBeforeLoginKnowledgeBaseID(element.keyvalue.toString());
      }
      else if (element.name == "InstancyBotEndPointURL") {
        uiSettingModel.setInstancyBotEndPointURL(element.keyvalue.toString());
      }
      else if (element.name == "BotChatIcon") {
        uiSettingModel.setBotChatIcon(element.keyvalue.toString());
      }
      else if (element.name == "BotGreetingContent") {
        uiSettingModel.setBotGreetingContent(element.keyvalue.toString());
      }
      else if (element.name == "AllowExpiredEventsSubscription") {
        uiSettingModel.setAllowExpiredEventsSubscription(element.keyvalue.toString());
      }
      else if (element.name == "NumberOfRatingsRequiredToShowRating") {
        uiSettingModel.setNumberOfRatingsRequiredToShowRating(element.keyvalue.toString());
      }
      else if (element.name == "MinimimRatingRequiredToShowRating") {
        uiSettingModel.setMinimumRatingRequiredToShowRating(element.keyvalue.toString());
      }
      else if (element.name == "NoOfDaysForCourseTargetDate") {
        uiSettingModel.setNoOfDaysForCourseTargetDate(element.keyvalue.toString());
      }
      else if (element.name == "EnableMultipleInstancesforEvent") {
        uiSettingModel.setEnableMultipleInstancesForEvent(element.keyvalue.toString());
      }
      else if (element.name == "ShowMembershipContentPricebyStrikeThrough") {
        uiSettingModel.setShowMembershipContentPriceByStrikeThrough(element.keyvalue.toString());
      }
      else if (element.name == "showEventAvailableFewSeatsLeft") {
        uiSettingModel.setShowEventAvailableFewSeatsLeft(element.keyvalue.toString());
      }
      else if (element.name == "EnableWishlist") {
        uiSettingModel.setEnableWishlist(element.keyvalue.toString());
      }
      else if (element.name == "dontallowPrerequitieDesiredContent") {
        uiSettingModel.setDoNotAllowPrerequisiteDesiredContent(element.keyvalue.toString());
      }
      else if (element.name == "MembershipExpiryAlertMessage") {
        uiSettingModel.setMembershipExpiryAlertMessage(element.keyvalue.toString());
      }
      //sreekanth commented
      //
      // else if (element.name == "AutocompleteDocumentionDownload") {
      //   uiSettingModel
      //       .setAutocompleteDocumentionDownload(element.keyvalue.toString());
      // }

      else if (element.name == "DaysBeforemembershipexpiry") {
        uiSettingModel.setDaysBeforeMembershipExpiry(element.keyvalue.toString());
      }
      else if (element.name == "MobileAppMenuPosition") {
        uiSettingModel.setMobileAppMenuPosition(element.keyvalue.toString());
      }
      else if (element.name == "ShowMoreActionforBottommenu") {
        uiSettingModel.setShowMoreActionForBottomMenu(element.keyvalue.toString());
      }
      else if (element.name == "isCloudStorageEnabled") {
        uiSettingModel.setIsCloudStorageEnabled(element.keyvalue.toString());
      }
      else if (element.name == "AzureRootPath") {
        uiSettingModel.setAzureRootPath(element.keyvalue.toString());
      }
      else if (element.name == "Isfeedbackredirection") {
        uiSettingModel.setIsFeedbackRedirection(element.keyvalue.toString());
      }
      else if (element.name == "FeedbackUrl") {
        uiSettingModel.setFeedbackUrl(element.keyvalue.toString());
      }
      else if (element.name == "EnableGamification") {
        uiSettingModel.setEnableGamification(element.keyvalue.toString());
      }
    });

    response.table4.forEach((element) {
      print('privilegeid' + element.privilegeid.toString());
      if (element.privilegeid == 908) {
        uiSettingModel.setIsFaceBook(element.ismobileprivilege);
      }
      else if (element.privilegeid == 911) {
        uiSettingModel.setIsTwitter(element.ismobileprivilege);
      }
      else if (element.privilegeid == 909) {
        uiSettingModel.setIsLinkedIn(element.ismobileprivilege);
      }
      else if (element.privilegeid == 910) {
        uiSettingModel.setIsGoogle(element.ismobileprivilege);
      }
      else if (element.privilegeid == 910) {}
    });

    List<LocalizationSelectionModel> localeList = [];
    response.table5.forEach((element) {
      LocalizationSelectionModel localizationSelectionModel =
          new LocalizationSelectionModel();
      if (element.languagename.isNotEmpty) {
        localizationSelectionModel.languagename = element.languagename;
      }
      if (element.locale.isNotEmpty) {
        localizationSelectionModel.locale = element.locale;
      }
      if (element.description.isNotEmpty) {
        localizationSelectionModel.description = element.description;
      }
      if (element.status) {
        localizationSelectionModel.status = element.status;
      }
      if (element.id != 0) {
        localizationSelectionModel.id = element.id;
      }
      if (element.countryflag.isNotEmpty) {
        localizationSelectionModel.countryflag = element.countryflag;
      }
      if (element.jsonfile.isNotEmpty) {
        localizationSelectionModel.jsonfile = element.jsonfile;
      }
      localeList.add(localizationSelectionModel);
    });
    uiSettingModel.setLocaleList(localeList);
  }

  bool isValidString(String str) {
    try {
      if (str.isEmpty ||
          str == "" ||
          str == "null" ||
          str == "undefined" ||
          str == "null\n") {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  void setNativeMenusModal(MobileGetNativeMenusResponse mobileGetNativeMenusResponse) {
    listNativeModel = [];

    mobileGetNativeMenusResponse.table.forEach((element) {
      developer.log("listNativeModel Title:${element.displayname}, Conditions:${element.conditions}, Id:${element.contextmenuid}");
      nativeMenuModel = new NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0);
      if (element.menuid != 0) {
        nativeMenuModel.setmenuid(element.menuid.toString());
      }
      if (element.displayname.isNotEmpty) {
        nativeMenuModel.setdisplayname(element.displayname.toString());
      }

      nativeMenuModel.setdisplayOrder(element.displayorder);

      if (element.image.isNotEmpty) {
        nativeMenuModel.setimage(element.image);
      }
      if (element.isofflinemenu) {
        nativeMenuModel.setisofflineMenu(element.isofflinemenu.toString());
      }
      if (element.isenabled) {
        nativeMenuModel.setisEnabled(element.isenabled.toString());
      }
      if (element.contexttitle.isNotEmpty) {
        nativeMenuModel.setcontextTitle(element.contexttitle.toString());
      }
      if (element.contextmenuid.isNotEmpty) {
        nativeMenuModel.setcontextmenuId(element.contextmenuid.toString());
      }

      nativeMenuModel.setrepositoryId(element.repositoryid.toString());

      nativeMenuModel.setlandingpageType(element.landingpagetype.toString());

      nativeMenuModel.setparentMenuId(element.parentmenuid.toString());

      nativeMenuModel.setcategoryStyle(element.categorystyle.toString());

      nativeMenuModel.setcomponentId(element.componentid.toString());

      nativeMenuModel.setcomponentId(element.componentid.toString());

      if (element.conditions.isNotEmpty) {
        nativeMenuModel.setconditions(element.conditions.toString());
      }

      nativeMenuModel.setwebMenuId(element.webmenuid);

      if (element.parameterstrings.isNotEmpty) {
        nativeMenuModel.setparameterString(element.parameterstrings);
      }

      listNativeModel.add(nativeMenuModel);
    });
  }

  void setDarkTheme() {
    sharePrefSaveString(setappBGColor, uiSettingModel.appBGColor);

    sharePrefSaveString(setappLoginBGColor, uiSettingModel.appLoginBGColor);

    sharePrefSaveString(setappTextColor, uiSettingModel.appTextColor);

    sharePrefSaveString(setappLoginTextolor, uiSettingModel.appLoginTextolor);

    sharePrefSaveString(setappHeaderColor, uiSettingModel.appHeaderColor);

    sharePrefSaveString(
        setappHeaderTextColor, uiSettingModel.appHeaderTextColor);

    sharePrefSaveString(setmenuBGColor, uiSettingModel.menuBGColor);

    sharePrefSaveString(setmenuTextColor, uiSettingModel.menuTextColor);

    sharePrefSaveString(
        setselectedMenuBGColor, uiSettingModel.selectedMenuBGColor);

    sharePrefSaveString(
        setselectedMenuTextColor, uiSettingModel.selectedMenuTextColor);

    // sharePref_saveString(
    //     setappButtonBgColor, appBloc.uiSettingModel.appButtonBgColor);
    //
    // sharePref_saveString(
    //     setappButtonTextColor, appBloc.uiSettingModel.appButtonTextColor);

    uiSettingModel.setappBGColor("#332940");
    uiSettingModel.setappLoginBGColor("#f5f5f5");

    uiSettingModel.setappTextColor("#f5f5f5");
    uiSettingModel.setappLoginTextolor("#f5f5f5");

    uiSettingModel.setappHeaderColor("#292134");
    uiSettingModel.setappHeaderTextColor("#f5f5f5");

    uiSettingModel.setmenuBGColor("#352b44");
    uiSettingModel.setmenuTextColor("#f5f5f5");

    uiSettingModel.setselectedMenuBGColor("#5a4973");
    uiSettingModel.setselectedMenuTextColor("#f5f5f5");

    uiSettingModel.setExpiredBGColor("#352b44");
    // appBloc.uiSettingModel.setappButtonBgColor("#201a28");
    // appBloc.uiSettingModel.setappButtonTextColor("#f5f5f5");

    saveThemetype(true);
  }

  saveThemetype([bool toggle = false]) async {
    // sharePref_saveBool(savedTheme, toggle);
    sharePrefSaveString(savedTheme, toggle ? "true" : "false");
  }

// setDefaultTheme() async {
//   uiSettingModel.setappBGColor(await sharePref_getString(setappBGColor));
//   uiSettingModel
//       .setappLoginBGColor(await sharePref_getString(setappLoginBGColor));
//   uiSettingModel.setappTextColor(await sharePref_getString(setappTextColor));
//   uiSettingModel
//       .setappLoginTextolor(await sharePref_getString(setappLoginTextolor));
//   uiSettingModel
//       .setappHeaderColor(await sharePref_getString(setappHeaderColor));
//   uiSettingModel.setappHeaderTextColor(
//       await sharePref_getString(setappHeaderTextColor));
//   uiSettingModel.setmenuBGColor(await sharePref_getString(setmenuBGColor));
//   uiSettingModel
//       .setmenuTextColor(await sharePref_getString(setmenuTextColor));
//   uiSettingModel.setselectedMenuBGColor(
//       await sharePref_getString(setselectedMenuBGColor));
//   uiSettingModel.setselectedMenuTextColor(
//       await sharePref_getString(setselectedMenuTextColor));
// }

}
