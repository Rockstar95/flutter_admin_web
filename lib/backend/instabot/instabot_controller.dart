import 'package:flutter/foundation.dart';

import '../../framework/helpers/ApiEndpoints.dart';
import '../../utils/my_print.dart';
import 'instabot_repository.dart';

class InstabotController extends ChangeNotifier {

  Future<String> getInstabotUrl() async {
    String guid = "", url = "";

    String ChatBotToken = await InstabotRepository().insertBotData();
    guid = ChatBotToken;

    if(guid.isEmpty) {
      return url;
    }

    url = "${ApiEndpoints.strSiteUrl}/chatbot.html?ChatBotToken=$guid";

    MyPrint.printOnConsole("Instabot Url:$url");
    return url;
    //return "https://www.google.com/";
  }
}