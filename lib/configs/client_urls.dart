class ClientUrls {
  static const String elearningClientUrl = "https://elearning.instancy.net/";
  static const String enterpriseDemoClientUrl = "https://enterprisedemo.instancy.com/";
  static const String franklinClientUrl = "https://tfr.franklincoveysa.co.za/";
  static const String instancyLearningClientUrl = "https://learning.instancy.com/";
  static const String upgradedEnterpriseClientUrl = "https://upgradedenterprise.instancy.com/";
  static const String qaLearningClientUrl = "https://qalearning.instancy.com/";

  static const String LIVE_APP_AUTH_URL = "https://masterapilive.instancy.com/api/";
  static const String STAGING_APP_AUTH_URL = "https://newazureplatform.instancy.com/api/";

  static String getAuthUrl(String clientUrl) {
    String authUrl = '';

    List<String> productionSites = [
      elearningClientUrl,
      enterpriseDemoClientUrl,
      franklinClientUrl,
      instancyLearningClientUrl,
      upgradedEnterpriseClientUrl,
    ];

    List<String> stagingSites = [
      qaLearningClientUrl,
    ];

    if(productionSites.contains(clientUrl)) authUrl = LIVE_APP_AUTH_URL;
    else if(stagingSites.contains(clientUrl)) authUrl = STAGING_APP_AUTH_URL;

    return authUrl;
  }
}
