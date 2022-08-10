import 'package:flutter/cupertino.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';

const kMaxLocalDatabaseEmailLength = 50;
const kInternetDisconnected = 'Internet Disconnected';
const kAppFlavour = AppFlavour.marketPlace;

///Cell Thumbnail Height -> MyLearning, CatalogRefresh. etc.,
final kCellThumbHeight = 150; //ScreenUtil.screenWidth < 600 ? 150 : 150;

///Center icon for all thumbnail image. etc.,
const kShowContentTypeIcon = false;

//##########################  ------- Tables -------- ####################################
String table_splash = 'SplashTable';

//##########################  ------- Hive-Key -------- ####################################
String mobileGetNativeMenusKey = 'mobileGetNativeMenusKey';
String mobileGetLearningPortalInfoKey = 'mobileGetLearningPortalInfoKey';
String mobileTinCanConfigurationsKey = 'mobileTinCanConfigurationsKey';
String getJsonfileKey = 'getJsonfileKey';

//##########################  ------- IMAGES -------- ####################################
//String kPlaygroundLogo = 'assets/images/playgroundlogo.png'; // playground , enterprise , training company
// String kMarketPlaceLogo = 'assets/images/marketplacelogo.png'; // instancy

String kSplashLogo = 'assets/images/marketplacelogo.png';

//##########################  ------- SOCIAL LOGIN TYPES -------- ####################################
const kGoogle = 'google';
const kFacebook = 'facebook';
const kTwitter = 'twitter';
const kLinkedIN = 'linkedin';

//##########################  ------- SHAREPREFERENCE -------- ####################################
const String sharedPref_isLogin = "isLogin";
const String sharedPref_basicAuth = "basicAuth";
const String sharedPref_uniqueId = "uniqueId";
const String sharedPref_webApiUrl = "webApiUrl";
const String sharedPref_lmsUrl = "lmsUrl";
const String sharedPref_learnerUrl = "learnerUrl";
const String sharedPref_userid = "userid";
const String sharedPref_orgunitid = "orgunitid";
const String sharedPref_userstatus = "userstatus";
const String sharedPref_username = "username";
const String sharedPref_image = "image";

const String sharedPref_tempProfileImage = "profileImg";
const String sharedPref_siteid = "siteid";
const String sharedPref_tcapiurl = "tcapiurl";
const String sharedPref_hasscanprivilege = "hasscanprivilege";
const String sharedPref_sessionid = 'sessionid';
const String sharedPref_autolaunchcontent = "autolaunchcontent";
const String sharedPref_appLogo = "appLogo";
const String sharedPref_siteURL = "siteURL";
const String sharedPref_AppLocale = "AppLocale";
const String sharedPref_bearer = "Bearer";
const String sharedPref_ComponentID = "ComponentID";
const String sharedPref_LoginUserName = "loginUserName";
const String sharedPref_LoginPassword = "loginPassword";
const String sharedPref_LoginUserID = "loginUserId";
const String sharedPref_RepositoryId = "repositoryId";
const String sharedPref_landingpageType = "landingpageType";
const String sharedPref_previlige = 'privilege';

const String sharedPrefIsSubSiteEntered = "SUB_SITE_ENTERED";
const String sharedPrefSubSiteUserLoginId = "SUB_SITE_USER_LOGIN_ID";
const String sharedPrefSubSiteUserPassword = "SUB_SITE_USER_PASSWORD";
const String sharedPrefSubSiteUserId = "SUB_SITE_USER_ID";
const String sharedPrefSubSiteWebApiUrl = "SUB_SITE_WEB_API_URL";
const String sharedPrefSubSiteSiteUrl = "SUB_SITE_SITE_URL";
const String sharedPrefSubSiteAuthentication = "SUB_SITE_AUTHENTICATION";
const String sharedPrefSubSiteUserName = "SUB_SITE_USERNAME";
const String sharedPrefSubSiteSiteId = "SUB_SITE_SITE_ID";
const String sharedPrefSubSiteSiteName = "SUB_SITE_NAME";
const String sharedPrefSubSiteUserStatus = "SUB_SITE_USER_STATUS";
const String sharedPrefSubSiteUserProfileImage = "SUB_SITE_USER_PROFILE_IMAGE";
const String isAppLaunchFirstTime = "IS_APP_LAUNCH_FIRST_TIME";

const String sharedPref_main_siteurl = "MAIN_SITE_URL";
const String sharedPref_main_userid = "MAIN_SITE_USER_ID";
const String sharedPref_main_bearer = "MAIN_SITE_BREAR";
const String sharedPref_main_tempProfileImage = "MAIN_SITE_USER_PROFILE_IMAGE";

const String setappBGColor = "SETAPPBGCOLOR";
const String setappLoginBGColor = "SETAPPLOGINBGCOLOR";
const String setappTextColor = "SETAPPTEXTCOLOR";
const String setappLoginTextolor = "SETAPPLOGINTEXTOLOR";
const String setappHeaderColor = "SETAPPHEADERCOLOR";
const String setappHeaderTextColor = "SETAPPHEADERTEXTCOLOR";
const String setmenuBGColor = "SETMENUBGCOLOR";
const String setmenuTextColor = "SETMENUTEXTCOLOR";
const String setselectedMenuBGColor = "SETSELECTEDMENUBGCOLOR";
const String setselectedMenuTextColor = "SETSELECTEDMENUTEXTCOLOR";
const String setappButtonBgColor = "SETAPPBUTTONBGCOLOR";
const String setappButtonTextColor = "SETAPPBUTTONTEXTCOLOR";

const String savedTheme = "SAVEDTHEME";

//sreekanth

/// hivedb constants
const String myLearningCollection = 'myLearningCourses';
const String archiveList = 'archiveList';
const String tracklistTabs = 'trackListTabs';
const String trackOverviewData = 'trackOverviewData';
const String tracklistCollection = 'trackListCourses';
const String completedOfflineCourses = 'completedOfflineCourses';

/// end-region: hivedb constants

const String sharedPref_LoginEmailId = "loginUserEmailId";
const fileServerLocation = '/Content/SiteConfiguration/Message/';

basicDeviceHeightWidth(BuildContext context, double w, double h) {
  //ScreenUtil.init(BoxConstraints(maxWidth: w, minWidth: w, maxHeight: h, minHeight: h), context: context, designSize: Size(w, h));
}
