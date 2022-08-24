import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/controllers/my_learning_download_controller.dart';
import 'package:flutter_admin_web/framework/bloc/Splash/event/splash_event.dart';
import 'package:flutter_admin_web/framework/bloc/Splash/states/splash_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/data_provider.dart';
import 'package:flutter_admin_web/framework/dataprovider/helper/local_database_helper.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/database/database_handler.dart';
import 'package:flutter_admin_web/framework/helpers/sync_helper.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/contract/splash_repository.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/model/basicAuthResponse.dart';
import 'package:flutter_admin_web/utils/my_print.dart';

ApiEndpoints apiEndpoints = new ApiEndpoints();

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashRepository splashRepository;
  String appLogoUrl = "";
  String siteURL = "";

  SplashBloc({
    required this.splashRepository,
  }) : super(SplashState()) {
    on<GetFourApiCallEvent>(onEventHandler);
    on<GetAppLogoEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(SplashEvent event, Emitter emit) async {
    print("SplashBloc onEventHandler called for ${event.runtimeType}");
    Stream<SplashState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (SplashState authState) {
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

  final LocalDataProvider _localHelper = LocalDataProvider(localDataProviderType: LocalDataProviderType.hive);

  @override
  SplashState get initialState => IntitialSplashState();

  @override
  Stream<SplashState> mapEventToState(event) async* {
    try {
      if (event is GetAppLogoEvent) {
        appLogoUrl = await sharePrefGetString(sharedPref_appLogo);
        siteURL = await sharePrefGetString(sharedPref_siteURL);
        print("Bloc App logo $appLogoUrl");
        print("Splash Bloc siteURL $siteURL");
        if (siteURL.isEmpty) {
          apiEndpoints.setstrSiteUrl(ApiEndpoints.mainSiteURL);
        } else {
          apiEndpoints.setstrSiteUrl(siteURL);
        }
        print("Splash Bloc siteURL ${ApiEndpoints.strSiteUrl}");

        yield GetAppLogoState(url: appLogoUrl);
      }
      else if (event is GetFourApiCallEvent) {
        print("SAGAR.........SSSSS");
        bool networkAvailable = await AppDirectory.checkInternetConnectivity();
        if(!networkAvailable) {
          yield GetFourApiCallState(isSuccess: false);
          return;
        }

        {
          DateTime startTime = DateTime.now();
          MyPrint.printOnConsole("GetBasicAuth Api Call Started");

          BasicAuthResponce? loginResponce = await splashRepository.getBasicAuth();
          if (loginResponce != null) setBasicAuthPref(loginResponce);

          DateTime endTime = DateTime.now();

          MyPrint.printOnConsole("GetBasicAuth Api Call Finished");
          MyPrint.printOnConsole("Time For GetBasicAuth Api Call in SplashScreen:${endTime.difference(startTime).inMilliseconds} milliseconds");
        }

        DateTime startTime = DateTime.now();
        MyPrint.printOnConsole("SplashScreen Api Calls Started");

        String language = await sharePrefGetString(sharedPref_AppLocale);
        print("Language:$language");
        if (language.isEmpty) {
          language = "en-us";
          await sharePrefSaveString(sharedPref_AppLocale, language);
        }

        List<Future> futures = [
          splashRepository.getMobileGetLearningPortalInfo().then((Response? mobileGetLearningPortalInfoResponse) async {
            await _saveLocally(mobileGetLearningPortalInfoResponse?.body ?? "{}", mobileGetLearningPortalInfoKey);
          }),
          splashRepository.getMobileGetNativeMenus().then((Response? mobileGetNativeMenusResponse) async {
            await _saveLocally(mobileGetNativeMenusResponse?.body ?? "{}", mobileGetNativeMenusKey);
          }),
          splashRepository.getMobileTinCanConfigurations().then((Response? mobileTinCanConfigurationsResponse) async {
            await _saveLocally(mobileTinCanConfigurationsResponse?.body ?? "{}", mobileTinCanConfigurationsKey);
          }),
          splashRepository.getLanguageJsonFile(language).then((Response? getJsonfileResponse) async {
            await _saveLocally(getJsonfileResponse?.body ?? "{}", getJsonfileKey);
          }),
          MyLearningDownloadController().extractContentZipFile(),
        ];

        if(!kIsWeb) {
          futures.addAll([
            SqlDatabaseHandler.init(),
            SyncData().syncData(),
          ]);
        }

        await Future.wait(futures);

        DateTime endTime = DateTime.now();

        MyPrint.printOnConsole("SplashScreen Api Calls Finished");
        MyPrint.printOnConsole("Time For Api Calls in SplashScreen:${endTime.difference(startTime).inMilliseconds} milliseconds");

        yield GetFourApiCallState(isSuccess: true);
      }
    } catch (e, s) {
      print("Error in SplashBloc.mapEventToState():$e");
      MyPrint.printOnConsole(s);
    }
  }

  void setBasicAuthPref(BasicAuthResponce loginResponce) {
    sharePrefSaveString(sharedPref_basicAuth, loginResponce.basicAuth);
    sharePrefSaveString(sharedPref_uniqueId, loginResponce.uniqueId);
    sharePrefSaveString(sharedPref_webApiUrl, loginResponce.webApiUrl);

    apiEndpoints.setStrBaseUrl(loginResponce.webApiUrl);
    MyPrint.printOnConsole("setBasicAuthPref loginResponce.webApiUrl ${loginResponce.webApiUrl} ");
    sharePrefSaveString(sharedPref_lmsUrl, loginResponce.lmsUrl);
    sharePrefSaveString(sharedPref_learnerUrl, loginResponce.learnerUrl);
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

  Future<String> _getLocalxData(String key) async {
    List<Map<String, dynamic>> response = await _localHelper.localService(
      enumLocalDatabaseOperation: LocalDatabaseOperation.read,
      table: table_splash,
      keys: [key],
    );

    Map<String, dynamic> data = response.isNotEmpty ? response.first : {};
    if (data.keys.isEmpty) return "";

    dynamic value = data[key];
    print("Key------$value");

    if (value == null) return "";
    String news = value;
    return news;
  }
}
