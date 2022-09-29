class ClientUrls {
  //Staging Sites
  static const String elearningStagingClientUrl = "https://elearning.instancy.net/";

  //Production Sites
  static const String elearningProductionClientUrl = "https://elearning.instancy.com/";
  static const String enterpriseDemoClientUrl = "https://enterprisedemo.instancy.com/";
  static const String franklinClientUrl = "https://tfr.franklincoveysa.co.za/";
  static const String instancyLearningClientUrl = "https://learning.instancy.com/";
  static const String upgradedEnterpriseClientUrl = "https://upgradedenterprise.instancy.com/";
  static const String qaLearningClientUrl = "https://qalearning.instancy.com/";

  static const String LIVE_APP_AUTH_URL = "https://masterapilive.instancy.com/api/";
  static const String LIVE_APP_AUTH_URL2 = "https://newazureplatform.instancy.com/api/";

  static const String STAGING_APP_AUTH_URL = "https://masterapi.instancy.net/api/";

  static String getAuthUrl(String clientUrl) {
    String authUrl = '';

    List<String> stagingSites = [
      elearningStagingClientUrl,
    ];

    List<String> productionSites1 = [
      elearningProductionClientUrl,
      enterpriseDemoClientUrl,
      franklinClientUrl,
      instancyLearningClientUrl,
      upgradedEnterpriseClientUrl,
    ];

    List<String> productionSites2 = [
      qaLearningClientUrl,
    ];

    if(stagingSites.contains(clientUrl)) authUrl = STAGING_APP_AUTH_URL;
    else if(productionSites1.contains(clientUrl)) authUrl = LIVE_APP_AUTH_URL;
    else if(productionSites2.contains(clientUrl)) authUrl = LIVE_APP_AUTH_URL2;


    return authUrl;
  }
}
