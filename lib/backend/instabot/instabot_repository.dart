import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../../configs/app_status_codes.dart';
import '../../controllers/navigation_controller.dart';
import '../../framework/bloc/app/bloc/app_bloc.dart';
import '../../framework/common/constants.dart';
import '../../framework/dataprovider/providers/rest_client.dart';
import '../../framework/helpers/ApiEndpoints.dart';
import '../../utils/my_print.dart';
import '../../utils/shared_pref_manager.dart';

class InstabotRepository {
  Future<String> insertBotData() async {
    String chatBotToken = "";

    try {
      String strUserID = (await SharedPrefManager().getString(sharedPref_userid)) ?? "";
      String strSiteID = (await SharedPrefManager().getString(sharedPref_siteid)) ?? "";
      String language = (await SharedPrefManager().getString(sharedPref_AppLocale)) ?? "";
      String token = (await SharedPrefManager().getString(sharedPref_bearer)) ?? "";
      String name = (await SharedPrefManager().getString(sharedPref_LoginUserName)) ?? "";
      String email = (await SharedPrefManager().getString(sharedPref_LoginEmailId)) ?? "";

      AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!);

      Map<String, String> data = {
        "authorizeToken": token,
        "strCategoryStyle": "true",
        "BotName": "InstaBot",
        "BotIcon": appBloc.uiSettingModel.botChatIcon,
        "BotChatIcon": "",
        "bubbleBackgroundColor": "#8ed52f",
        "userBubbleBackgroundColor": "",
        "clientUrl": ApiEndpoints.strSiteUrl,
        "apiEndPointURL": ApiEndpoints.strBaseUrl,
        "AzureRootPath": appBloc.uiSettingModel.azureRootPath,
        "UserID": strUserID,
        "userEmail": email,
        "userName": name,
        "userAvatarImage": "ProfileImages/1655357048476.jpg",
        "SiteID": strSiteID,
        "Locale": "en-us",
        "chatbottokenUrl": appBloc.uiSettingModel.instancyBotEndPointURL,
        "BotGreetingContent": appBloc.uiSettingModel.botGreetingContent,
        "_knowledgebaseId": appBloc.uiSettingModel.beforeLoginKnowledgeBaseID,
        "SiteConfigPath": "/content/siteconfiguration",
        "SiteFilesPath": "/content/sitefiles"
      };

      Response? response = await RestClient.postApiData(
        ApiEndpoints.GetInsertBotData(),
        data,
        isFetchDataFromSharedPreference: false,
        userid: strUserID,
        language: language,
        siteId: strSiteID,
        authtoken: token,
        siteUrl: ApiEndpoints.strSiteUrl,
      );

      if(response != null) {
        if(response.statusCode == AppApiStatusCodes.SUCCESS) {
          chatBotToken = response.body.replaceAll('"', "");
        }
        else if(response.statusCode == AppApiStatusCodes.TOKEN_EXPIRED) {
          NavigationController().sessionTimeOut();
        }
      }
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in InstabotRepository.insertBotData():$e");
      MyPrint.printOnConsole(s);
    }
    
    return chatBotToken;
  }
}