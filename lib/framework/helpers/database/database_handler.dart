import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/general/model/CMIModel.dart';
import 'package:flutter_admin_web/framework/repository/general/model/LearnerSessionModel.dart';
import 'package:flutter_admin_web/framework/repository/general/model/StudentResponseModel.dart';
import 'package:flutter_admin_web/models/track/track_object_model.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../../bloc/mylearning/model/dummy_my_catelog_response_entity.dart';

class SqlDatabaseHandler {
  //region tables
  static const String TBL_DOWNLOAD_DATA_REPORTS = 'DOWNLOADDATAREPORTS';

  /// TO store the my learning content metadata details
  static const String TBL_DOWNLOAD_DATA = 'DOWNLOADDATA';

  /// To store the catalog content metadata details
  static const String TBL_CATALOG_DATA = 'CATALOGDATA';

  /// To store the  content view metadata details
  static const String TBL_CONTENT_VIEW = 'CONTENTVIEW';

  /// To store the  session view metadata details
  static const String TBL_SESSION_VIEW = 'SESSIONVIEW';

  /// To store the user session details which tracked in offline course viewing
  static const String TBL_USER_SESSION = 'USERSESSION';

  /// To store the student responses which tracked in offline course viewing
  static const String TBL_STUDENT_RESPONSES = 'STUDENTRESPONSES';

  /// To store the question details of an assessment when downloaded
  static const String TBL_QUESTIONS = 'QUESTIONS';

  /// To store the offline tracking data
  static const String TBL_CMI = 'CMI';

  /// To store the track list content object details(track & content relation)
  static const String TBL_TRACK_OBJECTS = 'TRACKOBJECTS';

  /// To store the track list content metadata details
  static const String TBL_TRACKLIST_DATA = 'TRACKLISTDATA';

  static const String TBL_RELATED_CONTENT_DATA = 'RELATEDCONTENTDATA';

  static const String TBL_EVENT_CONTENT_DATA = 'EVENTCONTENTDATA';

  static const String TBL_TRACKLIST_TABS = 'TRACKLISTTABS';

  static const String TBL_LRS_DATA = 'LRSDATA';
  static const String TBL_SITE_TINCAN_CONFIG = 'SITETINCANCONFIG';
  static const String TBL_CATEGORY = 'CATEGORY';

  static const String TBL_MY_LEARNING_FILTER = 'MYLEARNINGFILTER';

  static const String TBL_JOB_ROLES = 'JOBROLES';
  static const String TBL_CONTENT_TYPES = 'CONTENTTYPES';
  static const String TBL_CATEGORY_CONTENT = 'CATEGORYCONTENT';
  static const String TBL_JOB_ROLE_CONTENT = 'JOBROLECONTENT';

  static const String TBL_NOTIFICATION_SETTINGS = 'NOTIFICATIONSETTINGS';
  static const String TBL_USER_SETTINGS = 'USERSETTINGS';
  static const String TBL_AUTO_DOWNLOAD_SETTINGS = 'AUTODOWNLOADSETTINGS';
  static const String TBL_USER_PAGE_NOTES = 'UserPageNotes';

  /// To store the drawer menu details
  static const String TBL_NATIVE_MENUS = 'NATIVEMENUS';
  static const String TBL_NATIVE_SETTINGS = 'NATIVESETTINGS';

  // ////////////////////////////USER
  // RELATED/////////////////////////////////////////
  static const String USERPROFILE = 'UserProfile';

  /// To store the User settings details
  static const String TBL_USER_PREFERENCES = 'USERPREFERENCES';

  /// To store the the user action privileges/rights
  static const String TBL_USER_PRIVILEGES = 'USERPRIVILEGES';

  /// This table is to store all the user profile field details from here ---------------------
  static const String TBL_USER_PROFILE_FIELDS = 'USERPROFILEFIELDS';

  /// This table is to store the user profile groups/sections details
  static const String TBL_USER_PROFILE_GROUPS = 'USERPROFILEGROUPS';

  /// This table is to store the user profile groups/sections and its related
  /// profile fields details
  static const String TBL_USER_PROFILE_CONFIGS = 'USERPROFILECONFIGS';

  /// This is to store the options to show for user profile fields in editing
  /// mode
  static const String TBL_USER_PROFILE_FIELD_OPTIONS = 'USERPROFILEFIELDOPTIONS';

  /// This is to store the options to show for user profile fields in editing to here ------------------------
  /// mode
  static const String TBL_CALENDAR_ADDED_EVENTS = 'CALENDERADDEDEVENTS';

  // ////////////////////////////DISCUSSION
  // FORUMS/////////////////////////////////////////
  /// To store the discussion forum details
  static const String TBL_FORUMS = 'FORUMDETAILS';

  /// To store the discussion forum topic details
  static const String TBL_FORUM_TOPICS = 'FORUMTOPICDETAILS';

  /// To store the discussion forum comment details
  static const String TBL_TOPIC_COMMENTS = 'FORUMTOPICCOMMENTSDETAILS';

  // //////////////////////////////ASKE THE
  // EXPERT/////////////////////////////////////////
  /// To store Ask the expert Question details
  static const String TBL_ASK_QUESTIONS = 'ASKQUESTIONS';

  /// To store Ask the expert Response details
  static const String TBL_ASK_RESPONSES = 'ASKRESPONSES';

  static const String TBL_ASK_QUESTION_CATEGORIES = 'ASKQUESTIONCATEGORIES';

  static const String TBL_ASK_QUESTION_CATEGORY_MAPPING =
      'ASKQUESTIONCATEGORYMAPPING';

  static const String TBL_ASK_QUESTION_SKILLS = 'ASKQUESTIONSKILLS';

  static const String TBL_ASK_COMMENTS = 'ASKCOMMENTS';

  ///////////////////////////////////////////////////////////////////////

  /// To store Ask the expert for only digimedica

  static const String TBL_ASK_QUESTIONS_DIGI = 'ASKQUESTIONSDIGI';

  static const String TBL_ASK_RESPONSES_DIGI = 'ASKRESPONSESDIGI';

  static const String TBL_ASK_QUESTION_CATEGORIES_DIGI =
      'ASKQUESTIONCATEGORIESDIGI';

  static const String TBL_ASK_QUESTION_CATEGORY_MAPPING_DIGI =
      'ASKQUESTIONCATEGORYMAPPINGDIGI';

  static const String TBL_ASK_QUESTION_SKILLS_DIGI = 'ASKQUESTIONSKILLSDIGI';

  static const String TBL_ASK_COMMENTS_DIGI = 'ASKCOMMENTSDIGI';

  static const String TBL_ASK_UPVOTERS_DIGI = 'ASKUPVOTERSDIGI';

  static const String TBL_FORUMS_DIGI = 'FORUMDETAILSDIGI';

  static const String TBL_ASK_SORT = 'TBL_ASKSORT';

  /// To store the discussion forum topic details
  static const String TBL_FORUM_TOPICS_DIGI = 'FORUMTOPICDETAILSDIGI';

  /// To store the discussion forum comment details
  static const String TBL_TOPIC_COMMENTS_DIGI = 'FORUMTOPICCOMMENTSDETAILSDIGI';

  static const String TBL_TOPIC_REPLY = 'FORUMTOPICREPLY';

  static const String TBL_FORUM_CATEGORIES = 'TBLFORUMCATEGORIES';

  ///////////////////////////////////////////////////////////////////////

  /// To store the user details who is currently or previously logged in for
  /// offline login verification
  static const String TBL_OFFLINE_USERS = 'OFFLINEUSERS';

  /// To store the details of the users who involved in forums/ask the expert
  static const String TBL_ALL_USERS_INFO = 'ALLUSERSINFO';

  static const String TBL_CATEGORIES = 'CATEGORIES';
  static const String TBL_SUBCATEGORIES = 'SUBCATEGORIES';
  static const String TBL_CATEGORIES_CONTENT = 'CATEGORIESCONTENT';
  static const String TBL_SKILLS = 'SKILLS';
  static const String TBL_SUB_SKILLS = 'SUBSKILLS';
  static const String TBL_SKILL_CONTENT = 'SKILLCONTENT';
  static const String TBL_JOB_ROLES_NEW = 'JOBROLESNEW';
  static const String TBL_SUB_JOB_ROLES_NEW = 'SUBJOBROLESNEW';
  static const String TBL_JOB_ROLE_CONTENT_NEW = 'JOBROLECONTENTNEW';

  static const String TBL_COMMUNITY_LISTING = 'COMMUNITYLISTING';
  static const String TBL_CATEGORY_COMMUNITY_LISTING = 'COMMUNITYCATEGORYLISTING';

  static const String TBL_APP_SETTINGS = 'APPSETTINGS';

  static const String TBL_TINCAN = 'TINCAN';

  static const String USER_EDUCATION_DETAILS = 'USER_EDUCATION_DETAILS';
  static const String USER_EXPERIENCE_DETAILS = 'USER_EXPERIENCE_DETAILS';
  static const String USER_MEMBERSHIP_DETAILS = 'USER_MEMBERSHIP_DETAILS';

  static const String TBL_SUBSITE_SETTINGS = 'TBL_SUBSITESETTINGS';

  static const String TBL_PEOPLE_LISTING = 'TBL_PEOPLELISTING';

  static const String TBL_PEOPLE_LISTING_TABS = 'TBL_PEOPLELISTINGTABS';

  static const String TBL_NOTIFICATIONS = 'TBL_NOTIFICATIONS';

  static const String TBL_NATIVE_SIGNUP = 'TBL_NATIVESIGNUP';

  static const String TBL_COMPETENCY_JOB_ROLES = 'TBL_COMPETENCYJOBROLES';

  static const String TBL_COMPETENCY_CATEGORY_LIST = 'TBL_COMPETENCYCATEGORYLIST';

  static const String TBL_COMPETENCY_SKILL_LIST = 'TBL_COMPETENCYSKILLLIST';

  // gamification tables

  static const String TBL_GAMIFICATION_GAMES = 'TBL_GAMIFICATIONGAMES';

  static const String TBL_ACHIEVEMENTS_DATA = 'TBL_ACHIEVEMENTSDATA';

  static const String TBL_ACHIEVEMENT_USER_OVERALL_DATA =
      'TBL_ACHIEVEMENTUSEROVERALLDATA';

  static const String TBL_ACHIEVEMENT_USER_LEVEL = 'TBL_ACHIEVEMENTUSERLEVEL';

  static const String TBL_ACHIEVEMENT_USER_POINTS = 'TBL_ACHIEVEMENTUSERPOINTS';

  static const String TBL_ACHIEVEMENT_USER_BADGES = 'TBL_ACHIEVEMENTUSERBADGES';

  // leadershiptables

  static const String TBL_LEADERBOARD_DATA = 'TBL_LEADERBOARDDATA';

  static const String TBL_LEADERBOARD_LIST_DATA = 'TBL_LEADERBOARDLISTDATA';

  static const String TBL_MY_SKILLS = 'MYSKILLS';

  static const String TBL_LOCALIZATION = 'LOCALIZATION';

  static const String TBL_DETAILS_SCHEDULE = 'TBLDETAILSSCHEDULE';

  static const String MEMBERSHIP_TABLE = 'MEMBERSHIPTABLE';
  //endregion tables

  static SqlDatabaseHandler? _databaseHandler;
  static late Database _database;

  factory SqlDatabaseHandler() {
    if (_databaseHandler == null) {
      _databaseHandler = SqlDatabaseHandler._internal();
      init();
    }
    return _databaseHandler!;
  }

  SqlDatabaseHandler._internal();

  static Future<void> init() async {
    _database = await openDatabase(
      path.join(await getDatabasesPath(), 'instancy_mylearning.db'),
      onOpen: (database) async =>
          await database.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_APP_SETTINGS (ID INTEGER PRIMARY KEY AUTOINCREMENT, appTextColor TEXT, appBGColor TEXT, menuTextColor TEXT, menuBGColor TEXT, selectedMenuTextColor TEXT, selectedMenuBGColor TEXT, listBGColor TEXT, listBorderColor TEXT, menuHeaderBGColor TEXT, menuHeaderTextColor TEXT, menuBGAlternativeColor TEXT, menuBGSelectTextColor TEXT, appButtonBGColor TEXT, appButtonTextColor TEXT, appHeaderTextColor TEXT, appHeaderColor TEXT, appLoginBGColor TEXT,appLoginPGTextColor TEXT,appLoginLogoBackgroundcolorColor TEXT, selfRegistrationAllowed TEXT, contentDownloadType TEXT, courseAppContent TEXT, enableNativeCatlog TEXT, enablePushNotification TEXT, nativeAppType TEXT, autodownloadsizelimit TEXT, catalogContentDownloadType TEXT, fileUploadButtonColor TEXT, firstTarget TEXT, secondTarget TEXT, thirdTarget TEXT, contentAssignment TEXT, newContentAvailable TEXT, contentUnassigned TEXT,enableNativeLogin TEXT, nativeAppLoginLogo TEXT,enableBranding TEXT,selfRegDisplayName TEXT,AutoLaunchFirstContentInMyLearning TEXT, firstEvent TEXT, isFacebook  TEXT, isLinkedin TEXT, isGoogle TEXT, isTwitter TEXT, siteID TEXT, siteURL TEXT, AddProfileAdditionalTab TEXT,EnableContentEvaluation INTEGER,CommonPasswordValue TEXT,EnableAzureSSOForLearner INTEGER,AllowExpiredEventsSubscription INTEGER, CCEventStartdate TEXT,isGlobalSearch INTEGER,enableMemberShipConfig  INTEGER,enableIndidvidualPurchaseConfig  INTEGER,enableSkillstobeMappedwithJobRoles  INTEGER,EnableMultipleInstancesforEvent BOOLEAN,NumberOfRatingsRequiredToShowRating INTEGER,MinimimRatingRequiredToShowRating String,NoOfDaysForCourseTargetDate INTEGER,showEventAvailableFewSeatsLeft INTEGER,EnableEcommerce INTEGER,pricebyStrikeThrough INTEGER,DiscussionForumFileTypes TEXT,UserUploadFileSize TEXT,Autocompletenontrackablecontent BOOLEAN,CloudDownloadURL TEXT,LearnerDefaultMenu TEXT,EnableWishlist TEXT,ApplicationSSL TEXT, MembershipExpiryAlertMessage TEXT, DaysBeforemembershipexpiry INTEGER,isCloudStorageEnabled TEXT, AzureRootPath TEXT,ShowMoreActionforBottommenu TEXT,MobileAppMenuPosition  TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_LOCALIZATION (ID INTEGER PRIMARY KEY AUTOINCREMENT, locale TEXT, languageName TEXT, status TEXT,description TEXT,siteId TEXT,languageID INT,countryflag TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_NATIVE_MENUS (ID INTEGER PRIMARY KEY AUTOINCREMENT, menuid TEXT, displayname TEXT, displayorder INTEGER, image TEXT, isofflinemenu TEXT, isenabled TEXT, contexttitle TEXT, contextmenuid TEXT, repositoryid TEXT, landingpagetype TEXT, categorystyle TEXT, componentid TEXT, conditions TEXT, parentmenuid TEXT, parameterstrings TEXT, siteid TEXT, siteurl TEXT,webmenuid INT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_DOWNLOAD_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT,userid TEXT,siteid TEXT,siteurl TEXT,sitename TEXT,contentid TEXT,objectid TEXT,coursename TEXT,author TEXT,shortdes TEXT,longdes TEXT,imagedata TEXT,medianame TEXT,createddate TEXT,startpage TEXT,eventstarttime TEXT,eventendtime TEXT,objecttypeid TEXT,locationname TEXT,timezone TEXT,scoid TEXT,participanturl TEXT,status TEXT,displaystatus TEXT,password TEXT,displayname TEXT,islistview TEXT,isdownloaded TEXT,courseattempts TEXT,eventcontentid TEXT,relatedcontentcount TEXT,durationenddate TEXT,ratingid TEXT,publisheddate TEXT,isExpiry TEXT, mediatypeid TEXT, dateassigned TEXT, keywords TEXT,tagname TEXT, downloadurl TEXT, offlinepath TEXT, presenter TEXT, eventaddedtocalender TEXT, joinurl TEXT, typeofevent TEXT,progress TEXT, membershiplevel INTEGER, membershipname TEXT ,folderpath TEXT,jwvideokey TEXT, cloudmediaplayerkey TEXT,eventstartUtctime TEXT,eventendUtctime TEXT,isarchived BOOLEAN,isRequired BOOLEAN,contentTypeImagePath TEXT,EventScheduleType INTEGER,LearningObjectives TEXT,TableofContent TEXT,LongDescription TEXT,ThumbnailVideoPath TEXT,totalratings INTEGER,groupName TEXT,activityid TEXT,cancelEventEnabled BOOLEAN,removeFromMylearning BOOLEAN,reSheduleEvent TEXT,isBadCancellationEnabled BOOLEAN,isEnrollFutureInstance BOOLEAN,percentcompleted TEXT,certificateaction TEXT,certificateid TEXT,certificatepage TEXT,windowproperties TEXT,bit4 BOOLEAN,qrCodeImagePath TEXT,QRImageName TEXT,offlineQrCodeImagePath TEXT,viewprerequisitecontentstatus TEXT,credits TEXT,decimal2 TEXT,duration TEXT ,recordingmsg  TEXT,eventrecording  TEXT,recordingcontentid TEXT,recordingurl TEXT,fileSize INTEGER,jwstartPage TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_DOWNLOAD_DATA_REPORTS (ID INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT,userid TEXT,siteid TEXT,siteurl TEXT,sitename TEXT,contentid TEXT,objectid TEXT,coursename TEXT,author TEXT,shortdes TEXT,longdes TEXT,imagedata TEXT,medianame TEXT,createddate TEXT,startpage TEXT,eventstarttime TEXT,eventendtime TEXT,objecttypeid TEXT,locationname TEXT,timezone TEXT,scoid TEXT,participanturl TEXT,status TEXT,displaystatus TEXT,password TEXT,displayname TEXT,islistview TEXT,isdownloaded TEXT,courseattempts TEXT,eventcontentid TEXT,relatedcontentcount TEXT,durationenddate TEXT,ratingid TEXT,publisheddate TEXT,isExpiry TEXT, mediatypeid TEXT, dateassigned TEXT, keywords TEXT, downloadurl TEXT, offlinepath TEXT, presenter TEXT, eventaddedtocalender TEXT, joinurl TEXT, typeofevent TEXT,progress TEXT, membershiplevel INTEGER, membershipname TEXT ,folderpath TEXT,jwvideokey TEXT, cloudmediaplayerkey TEXT,eventstartUtctime TEXT,eventendUtctime TEXT)');

        //used upto here

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_CATALOG_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT,siteid TEXT,siteurl TEXT,sitename TEXT,displayname TEXT, username TEXT, password TEXT, userid TEXT, contentid TEXT,coursename TEXT,author TEXT,shortdes TEXT,longdes TEXT,imagedata TEXT,medianame TEXT,createddate TEXT,startpage TEXT,objecttypeid TEXT,locationname TEXT,timezone TEXT,scoid TEXT,participanturl TEXT,viewtype TEXT, price TEXT, islistview TEXT, ratingid TEXT,publisheddate TEXT, mediatypeid TEXT, keywords TEXT,tagname TEXT, googleproductid TEXT, currency TEXT,itemtype TEXT,categorycompid TEXT, downloadurl TEXT, offlinepath TEXT, isaddedtomylearning INTEGER, membershiplevel INTEGER, membershipname TEXT,folderpath TEXT,jwvideokey TEXT, cloudmediaplayerkey TEXT,presenter  TEXT,eventstarttime TEXT,eventendtime TEXT,relatedconentcount TEXT,eventstartUtctime TEXT,eventendUtctime TEXT,iswishlisted BOOLEAN,contentTypeImagePath TEXT,EventScheduleType INTEGER,LearningObjectives TEXT,TableofContent TEXT,LongDescription TEXT,totalratings INTEGER,groupName TEXT,activityid TEXT,cancelEventEnabled BOOLEAN,viewprerequisitecontentstatus TEXT,credits TEXT,decimal2 TEXT,duration TEXT,isContentEnrolled TEXT,instanceparentcontentid TEXT,recordingmsg  TEXT,eventrecording  TEXT,recordingcontentid TEXT,recordingurl TEXT,jwstartPage TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_USER_SESSION (sessionid INTEGER PRIMARY KEY AUTOINCREMENT,userid INTEGER,scoid INTEGER,siteid INTEGR,attemptnumber INTEGER,sessiondatetime DATETIME,timespent TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_STUDENT_RESPONSES (RESPONSEID INTEGER PRIMARY KEY AUTOINCREMENT,siteid INTEGER,scoid INTEGER,userid INTEGER,questionid INTEGER,assessmentattempt INTEGER,questionattempt INTEGER,attemptdate DATETIME,studentresponses TEXT,result TEXT,attachfilename TEXT,attachfileid TEXT,rindex INTEGER,attachedfilepath TEXT,optionalNotes TEXT,capturedVidFileName TEXT,capturedVidId TEXT,capturedVidFilepath TEXT,capturedImgFileName TEXT,capturedImgId TEXT,capturedImgFilepath TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_QUESTIONS (RESPONSEID INTEGER PRIMARY KEY AUTOINCREMENT,siteid INTEGER,scoid INTEGER,userid INTEGER,questionid INTEGER,quesname TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_CMI (ID INTEGER PRIMARY KEY AUTOINCREMENT,siteid INTEGER,scoid INTEGER,userid INTEGER,location TEXT,status TEXT,suspenddata TEXT,isupdate TEXT,siteurl TEXT,datecompleted DATETIME,noofattempts INTEGER,score TEXT,sequencenumber INTEGER,startdate DATETIME,timespent TEXT,coursemode TEXT,scoremin TEXT,scoremax TEXT,submittime TEXT,randomquesseq TEXT,pooledquesseq TEXT,textResponses TEXT, objecttypeid TEXT,percentageCompleted TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_TRACK_OBJECTS (RESPONSEID INTEGER PRIMARY KEY AUTOINCREMENT,trackscoid INTEGER,scoid INTEGER,sequencenumber INTEGER,siteid INTEGER,userid INTEGER,objecttypeid INTEGER,name TEXT,mediatypeid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_TINCAN (ID INTEGER PRIMARY KEY AUTOINCREMENT, istincan TEXT, lrsendpoint TEXT, lrsauthorization TEXT, lrsauthorizationpassword TEXT, enabletincansupportforco TEXT, enabletincansupportforao TEXT, enabletincansupportforlt TEXT, base64lrsAuthKey TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_MY_LEARNING_FILTER (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT,siteurl TEXT, userid TEXT, jsonobject BLOB, pageType int)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_TRACKLIST_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT,userid INTEGER,siteid INTEGER,siteurl TEXT,sitename TEXT,contentid TEXT,coursename TEXT,author TEXT,shortdes TEXT,longdes TEXT,imagedata TEXT,medianame TEXT,createddate DATE,startpage TEXT,eventstarttime DATE,eventendtime DATE,objecttypeid INTEGER,locationname TEXT,timezone TEXT,scoid INTEGER,participanturl TEXT,courselaunchpath TEXT,status TEXT,displaystatus TEXT,password TEXT,eventid TEXT,displayname TEXT,trackscoid TEXT,parentid TEXT,blockname TEXT,showstatus TEXT,timedelay TEXT,isdiscussion TEXT,eventcontentid TEXT, sequencenumber TEXT,courseattempts TEXT,mediatypeid TEXT, relatedcontentcount INTEGER, downloadurl TEXT,eventaddedtocalender TEXT, joinurl TEXT,offlinepath TEXT, typeofevent INTEGER,presenter TEXT,isdownloaded TEXT, progress TEXT, stepid  TEXT, ruleid  TEXT,wmessage TEXT,trackContentId TEXT,folderpath TEXT,jwvideokey TEXT, cloudmediaplayerkey TEXT,eventstartUtctime TEXT,eventendUtctime TEXT,contentTypeImagePath TEXT,activityid TEXT,bookmarkid INTEGER,recordingmsg  TEXT,eventrecording  TEXT,recordingcontentid TEXT,recordingurl TEXT,jwstartPage TEXT,objectfolderid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_RELATED_CONTENT_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT,userid TEXT,siteid TEXT,siteurl TEXT,sitename TEXT,contentid TEXT,coursename TEXT,author TEXT,shortdes TEXT,longdes TEXT,imagedata TEXT,medianame TEXT,createddate TEXT,startpage TEXT,eventstarttime TEXT,eventendtime TEXT,objecttypeid TEXT,locationname TEXT,timezone TEXT,scoid TEXT,participanturl TEXT,status TEXT,displaystatus TEXT,password TEXT,displayname TEXT,islistview TEXT,isdiscussion TEXT,isdownloaded TEXT,courseattempts TEXT,eventcontentid TEXT,wresult TEXT, wmessage TEXT, durationenddate TEXT, isExpiry TEXT, ratingid TEXT, publisheddate TEXT,mediatypeid TEXT,dateassigned TEXT, keywords TEXT,tagname TEXT, downloadurl TEXT, offlinepath TEXT, presenter TEXT, joinurl TEXT,blockname TEXT,trackscoid TEXT, progress TEXT, showstatus TEXT,trackContentId TEXT, stepid  TEXT, ruleid  TEXT,folderpath TEXT,jwvideokey TEXT, cloudmediaplayerkey TEXT,eventstartUtctime TEXT,eventendUtctime TEXT,contentTypeImagePath TEXT,activityid TEXT,recordingmsg  TEXT,eventrecording  TEXT,recordingcontentid TEXT,recordingurl TEXT,jwstartPage TEXT,objectfolderid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_EVENT_CONTENT_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT,siteid TEXT,siteurl TEXT,sitename TEXT, displayname TEXT, username TEXT, password TEXT, userid TEXT, contentid TEXT,coursename TEXT,author TEXT,shortdes TEXT,longdes TEXT,imagedata TEXT,medianame TEXT,createddate TEXT,startpage TEXT,eventstarttime TEXT,eventendtime TEXT,objecttypeid TEXT,locationname TEXT,timezone TEXT,scoid TEXT,participanturl TEXT,viewtype TEXT,eventcontentid TEXT,price TEXT,islistview TEXT, ratingid TEXT,publisheddate TEXT, mediatypeid TEXT, keywords TEXT,tagname TEXT, googleproductid TEXT, currency TEXT, itemtype TEXT, categorycompid TEXT, presenter TEXT, relatedcontentcount INTEGER, availableseats INTEGER, isaddedtomylearning INTEGER, joinurl TEXT,folderpath TEXT,typeofevent TEXT,eventTabValue TEXT,eventstartUtctime TEXT,eventendUtctime TEXT,waitlistenrolls INTEGER,waitlistlimit INTEGER,cancelevent INTEGER,enrollmentlimit INTEGER, noofusersenrolled INTEGER,contentTypeImagePath TEXT,EventScheduleType INTEGER,LearningObjectives TEXT,TableofContent TEXT,LongDescription TEXT,groupName TEXT,cancelEventEnabled BOOLEAN,actionwaitlist TEXT,isBadCancellationEnabled BOOLEAN,iswishlisted BOOLEAN,instanceparentcontentid TEXT,recordingmsg  TEXT,eventrecording  TEXT,recordingcontentid TEXT,recordingurl TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_LRS_DATA (lrsid INTEGER PRIMARY KEY AUTOINCREMENT,LRS TEXT,url TEXT,method TEXT,data TEXT,auth TEXT,callback TEXT,lrsactor TEXT,extraHeaders TEXT,siteid INTEGER,scoid INTEGER,userid INTEGER,isupdate TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_SITE_TINCAN_CONFIG (configid INTEGER PRIMARY KEY AUTOINCREMENT ,configkeyvalue TEXT,configkey TEXT,siteid INTEGER,userid INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_CATEGORY (ID INTEGER PRIMARY KEY AUTOINCREMENT,parentid INTEGER,categoryname TEXT,categoryid INTEGER,categoryicon TEXT,contentcount INTEGER,siteid INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_JOB_ROLES (ID INTEGER PRIMARY KEY AUTOINCREMENT,categoryid INTEGER,categoryname TEXT,parentid INTEGER,contentcount INTEGER,siteid INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_CONTENT_TYPES (ID INTEGER PRIMARY KEY AUTOINCREMENT,attributeconfigid INTEGER,objecttypeid INTEGER,endUservisibility TEXT,displayorder INTEGER,localename TEXT,displaytext TEXT,siteid INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_CATEGORY_CONTENT (ID INTEGER PRIMARY KEY AUTOINCREMENT,categoryid INTEGER,contentid TEXT,displayorder INTEGER,modifieddate DATE,siteid INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_JOB_ROLE_CONTENT (ID INTEGER PRIMARY KEY AUTOINCREMENT,contentid TEXT,categoryid INTEGER,modifieddate DATE,assignedby TEXT,siteid INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_NOTIFICATION_SETTINGS (ID INTEGER PRIMARY KEY AUTOINCREMENT,siteid INTEGER,notificationid TEXT,notificationname TEXT,notificationstatus TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_USER_SETTINGS (ID INTEGER PRIMARY KEY AUTOINCREMENT,userid INTEGER,siteid INTEGER,notificationid TEXT,notificationstatus TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_AUTO_DOWNLOAD_SETTINGS (ID INTEGER PRIMARY KEY AUTOINCREMENT,userid INTEGER,siteid INTEGER,enableautodownload Text,usingmobiledata TEXT,autodownloadstatus TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_USER_PAGE_NOTES (ID INTEGER PRIMARY KEY AUTOINCREMENT,ContentID TEXT,PageID TEXT,UserID TEXT,Usernotestext TEXT,TrackID TEXT,SequenceID TEXT,NoteDate TEXT,Notecount TEXT,ModifiedNotedate TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $USERPROFILE (ID INTEGER PRIMARY KEY AUTOINCREMENT,userID TEXT,siteId INTEGER,FirstName TEXT,LastName TEXT,DisplayName TEXT,Organization TEXT,Email TEXT,StreetAddress TEXT,City TEXT,State TEXT,Phone TEXT,isUpdated TEXT,DOB TEXT)');

        // await db.execute('CREATE TABLE IF NOT EXISTS '
        // + TBL_NATIVEMENUS
        // +
        // '(ID INTEGER PRIMARY KEY AUTOINCREMENT,menuID INTEGER,menuContextName TEXT,menuDisplayName TEXT,menuImage TEXT,siteid INTEGER,menuDisplayOrder TEXT,isOfflineMenu TEXT,isEnabled TEXT)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_USER_PREFERENCES (userid INTEGER,siteid INTEGER, keyname TEXT, prefvalue TEXT,PRIMARY KEY(siteid,userid,keyname))');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_NATIVE_SETTINGS (siteid INTEGER, prefid INTEGER, keyname TEXT, defaultvalue TEXT, displaytext TEXT, PRIMARY KEY(siteid,keyname))');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_USER_PROFILE_FIELDS (ID INTEGER PRIMARY KEY AUTOINCREMENT, objectid TEXT,accounttype TEXT,orgunitid TEXT, siteid TEXT, approvalstatus TEXT, firstname TEXT, lastname TEXT, displayname TEXT, organization TEXT, email TEXT, usersite TEXT, supervisoremployeeid TEXT, addressline1 TEXT, addresscity TEXT, addressstate TEXT, addresszip TEXT , addresscountry TEXT, phone TEXT, mobilephone TEXT, imaddress TEXT,dateofbirth TEXT, gender TEXT, nvarchar6 TEXT, paymentmode TEXT, nvarchar7 TEXT, nvarchar8 TEXT, nvarchar9 TEXT, securepaypalid TEXT, nvarchar10 TEXT, picture TEXT, highschool TEXT, college TEXT, highestdegree TEXT, jobtitle TEXT, businessfunction TEXT, primaryjobfunction TEXT, payeeaccountno TEXT, payeename TEXT, paypalaccountname TEXT, paypalemail TEXT, shipaddline1 TEXT, shipaddcity TEXT, shipaddstate TEXT, shipaddzip TEXT, shipaddcountry TEXT, shipaddphone TEXT, firsttimeautodownloadpopup TEXT, isupdated TEXT, nvarchar103 TEXT, nvarchar105 TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_USER_PROFILE_GROUPS (ID INTEGER PRIMARY KEY AUTOINCREMENT, groupid  TEXT,groupname TEXT, objecttypeid TEXT, siteid TEXT,showinprofile TEXT, userid TEXT, localeid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_USER_PROFILE_CONFIGS (ID INTEGER PRIMARY KEY AUTOINCREMENT, datafieldname TEXT, aliasname TEXT, attributedisplaytext TEXT, groupid TEXT, displayorder INTEGER, attributeconfigid TEXT, isrequired TEXT, iseditable TEXT, enduservisibility TEXT, uicontroltypeid TEXT, name TEXT, userid TEXT,maxlength INTEGER, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_USER_PROFILE_FIELD_OPTIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, choiceid TEXT, attributeconfigid TEXT, choicetext TEXT, choicevalue TEXT, localename TEXT, parenttext TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_CALENDAR_ADDED_EVENTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, userid INTEGER,siteid INTEGER,scoid INTEGER,eventid INTEGER, eventname TEXT, reminderid INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_FORUMS (ID INTEGER PRIMARY KEY AUTOINCREMENT,forumname TEXT,forumid TEXT,name TEXT,createddate TEXT,author TEXT,nooftopics TEXT,totalposts TEXT,existing TEXT,description TEXT,isprivate TEXT, active TEXT, siteid TEXT, createduserid TEXT,parentforumid TEXT,displayorder TEXT,requiressubscription TEXT,createnewtopic TEXT,attachfile TEXT,likeposts TEXT, sendemail TEXT, moderation TEXT,imagedata TEXT)');

//                + '(forumname TEXT,forumid INTEGER,name TEXT, createddate TEXT,author TEXT,nooftopics TEXT,totalposts TEXT,existing TEXT,description TEXT,isprivate TEXT,active TEXT,siteid TEXT,createduserid TEXT,parentforumid TEXT,displayorder TEXT,requiressubscription TEXT,createnewtopic TEXT,attachfile TEXT,likeposts TEXT,sendemail TEXT,moderation TEXT,siteurl TEXT, PRIMARY KEY(siteurl,forumid))');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_FORUM_TOPICS (ID INTEGER PRIMARY KEY AUTOINCREMENT, topicid TEXT,forumid TEXT,name TEXT, createddate TEXT,latestreplyby TEXT,noofreplies TEXT,noofviews TEXT,siteid TEXT,longdescription TEXT,createduserid TEXT,imagedata TEXT, attachment TEXT)');

//                + '(contentid TEXT,forumid TEXT,name TEXT, createddate TEXT,createduserid TEXT,noofreplies TEXT,noofviews TEXT,siteid INTEGER, longdescription TEXT,uploadfilename TEXT, siteurl TEXT, PRIMARY KEY(siteurl,forumid,contentid))');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_TOPIC_COMMENTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, commentid TEXT, topicid TEXT, forumid TEXT, message TEXT,posteddate TEST, postedby TEXT,replyid TEXT,siteid TEXT, attachment TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_OFFLINE_USERS (userid TEXT, orgunitid TEXT, userstatus TEXT, displayname TEXT, siteid TEXT, username TEXT, password TEXT, siteurl TEXT )');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ALL_USERS_INFO (picture TEXT,userid TEXT,displayname TEXT,email TEXT,profileimagepath TEXT, siteid TEXT, PRIMARY KEY(userid, siteid))');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_USER_PRIVILEGES (userid TEXT,privilegeid TEXT,componentid TEXT,parentprivilegeid TEXT, objecttypeid TEXT, roleid TEXT,siteid TEXT, siteurl TEXT, PRIMARY KEY(userid, privilegeid, roleid, siteurl))');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_QUESTIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, questionid INTEGER, userid TEXT, username TEXT, userquestion TEXT, posteddate TEXT, createddate TEXT, answers TEXT, questioncategories TEXT, siteid TEXT, posteduserid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_RESPONSES (ID INTEGER PRIMARY KEY AUTOINCREMENT, questionid INTEGER, responseid TEXT, response TEXT, respondeduserid TEXT, respondedusername, respondeddate TEXT, responsedate TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_QUESTION_SKILLS (ID INTEGER PRIMARY KEY AUTOINCREMENT,orgunitid TEXT, preferrenceid TEXT, preferrencetitle TEXT, shortskillname, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_QUESTION_CATEGORIES (ID INTEGER PRIMARY KEY AUTOINCREMENT, categoryid TEXT, category TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_QUESTION_CATEGORY_MAPPING (ID INTEGER PRIMARY KEY AUTOINCREMENT, questionid INTEGER, categoryid TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_COMMENTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, questionID INTEGER, siteID TEXT, userID TEXT, commentAction TEXT, commentDate TEXT,commentDescription TEXT,commentID INTEGER,commentImage TEXT, commentQuestionID INTEGER, commentResponseID INTEGER, commentUserID INTEGER, commentedDate TEXT, commentedUserName TEXT, isLiked INTEGER, userImage TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_CATEGORIES (parentid TEXT, categoryname TEXT, categoryid TEXT, categoryicon TEXT, contentcount TEXT, column1 TEXT, siteid TEXT, componentid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_SUBCATEGORIES (parentid TEXT, categoryname TEXT, categoryid TEXT, subcategoryicon TEXT, contentcount TEXT, column1 TEXT, siteid TEXT, componentid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_CATEGORIES_CONTENT (categoryid TEXT, contentid TEXT, displayorder TEXT, modifieddate TEXT, siteid TEXT, componentid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_SKILLS (categoryid TEXT, categoryname TEXT, categoryicon TEXT, coursecount TEXT, siteid TEXT, componentid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_SUB_SKILLS (subcategoryid TEXT, subcategoryname TEXT, categoryid TEXT, subcategoryicon TEXT, siteid TEXT, componentid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_SKILL_CONTENT (contentid TEXT, preferenceid TEXT, dateassigned TEXT, assignedby TEXT, siteid TEXT, componentid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_JOB_ROLES_NEW (jobroleid TEXT, jobroleparentid TEXT, jobrolename TEXT, shortjobrolename TEXT, siteid TEXT, componentid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_JOB_ROLE_CONTENT_NEW (contentid TEXT, jobroleid TEXT, dateassigned TEXT, assignedby TEXT, siteid TEXT, componentid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_COMMUNITY_LISTING (ID INTEGER PRIMARY KEY AUTOINCREMENT, learningportalid INTEGER, learningprovidername TEXT, communitydescription TEXT, keywords TEXT, userid INTEGER, siteid INTEGER, siteurl TEXT, parentsiteid INTEGER, parentsiteurl TEXT, orgunitid INTEGER, objectid INTEGER, name TEXT, categoryid INTEGER, imagepath TEXT, actiongoto INTEGER, labelalreadyamember TEXT, actionjoincommunity INTEGER, labelpendingrequest TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_CATEGORY_COMMUNITY_LISTING (ID INTEGER PRIMARY KEY AUTOINCREMENT, categoryid INTEGER, name TEXT, shortcategoryname TEXT, categorydescription TEXT, parentid INTEGER, displayorder INTEGER, componentid INTEGER, parentsiteid INTEGER, userid INTEGER, parentsiteurl TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $USER_EDUCATION_DETAILS (ID INTEGER PRIMARY KEY AUTOINCREMENT, titleeducation TEXT, totalperiod TEXT, fromyear TEXT, degree TEXT, titleid TEXT, userid TEXT, displayno TEXT, description TEXT, toyear TEXT, country TEXT, school TEXT, isupdated TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $USER_EXPERIENCE_DETAILS (ID INTEGER PRIMARY KEY AUTOINCREMENT,  title TEXT, location TEXT, companyname TEXT, fromdate TEXT, todate TEXT, userid TEXT, description TEXT, difference TEXT, tilldate INTEGER, displayno TEXT, isupdated TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $USER_MEMBERSHIP_DETAILS (ID INTEGER PRIMARY KEY AUTOINCREMENT, status TEXT, expirydate TEXT, renewaltype TEXT, usermembership TEXT, expirystatus TEXT, startdate TEXT,membershiplevel INTEGER,siteid INTEGER, userid INTEGER, siteurl TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_SUBSITE_SETTINGS (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT, siteurl TEXT, authid TEXT, authpwd TEXT, userid TEXT, sitename TEXT, parentsiteid TEXT, parentsiteurl TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_PEOPLE_LISTING (ID INTEGER PRIMARY KEY AUTOINCREMENT, connectionuserid INTEGER, userid TEXT, jobtitle TEXT, mainofficeaddress TEXT, memberprofileimage TEXT, userdisplayname TEXT, connectionstate TEXT, connectionstateaccept TEXT, viewprofileaction TEXT, acceptaction TEXT, ignoreaction TEXT, viewcontentaction TEXT, sendmessageaction TEXT, addtomyconnectionaction TEXT, removefrommyconnectionaction TEXT, interestareas TEXT, notamember INTEGER, siteurl TEXT, siteid TEXT, tabid TEXT, mainsiteuserid TEXT,askaquestion TEXT,groupByActionName TEXT,groupByActionValue TEXT, connectedDays TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_PEOPLE_LISTING_TABS (ID INTEGER PRIMARY KEY AUTOINCREMENT, tabid TEXT, displayname TEXT, mobiledisplayname TEXT, displayicon TEXT, siteurl TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_NOTIFICATIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, usernotificationid INTEGER, fromuserid INTEGER, fromusername TEXT, fromuseremail TEXT, touserid INTEGER, subject TEXT, message TEXT, notificationstartdate TEXT, notificationenddate TEXT, notificationid INTEGER, ounotificationid INTEGER, contentid TEXT, markasread TEXT, notificationtitle TEXT, groupid INTEGER, contenttitle TEXT, forumname TEXT, forumid TEXT, username TEXT, notificationsubject TEXT, membershipexpirydate TEXT, passwordexpirtydays TEXT, durationenddate TEXT, publisheddate TEXT, assigneddate TEXT, siteid INTEGER, userid INTEGER, siteurl TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_NATIVE_SIGNUP (ID INTEGER PRIMARY KEY AUTOINCREMENT, datafieldname TEXT, aliasname TEXT, displaytext TEXT, groupid TEXT, displayorder INTEGER, attributeconfigid TEXT, isrequired TEXT, iseditable TEXT, enduservisibility TEXT, uicontroltypeid TEXT, siteid TEXT, ispublicfield TEXT, minlength TEXT, maxlength TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_COMPETENCY_JOB_ROLES (jobrolename TEXT, jobroleid INTEGER, description TEXT, userid TEXT, siteid TEXT,tag TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_COMPETENCY_CATEGORY_LIST (prefcategorytitle TEXT, prefcategoryid INTEGER, jobroleid INTEGER, userid TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_COMPETENCY_SKILL_LIST (skillname TEXT, skillid INTEGER, prefcategoryid INTEGER, jobroleid INTEGER, description TEXT, gap TEXT, userevaluation TEXT, managerevaluation TEXT, contentevaluation TEXT, weightedaverage TEXT, requiredproficiency TEXT, requiredprofvalues BLOB, userid TEXT, siteid TEXT)');

        // Gamification tables

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_GAMIFICATION_GAMES (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT, userid TEXT, gamename TEXT, gameid INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ACHIEVEMENTS_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT, userid TEXT, showlevelsection INTEGER, showpointsection INTEGER, showbadgesection INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ACHIEVEMENT_USER_OVERALL_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT, badges INTEGER, gameid INTEGER, userid INTEGER, overallpoints INTEGER, userlevel TEXT, neededlevel TEXT, neededpoints INTEGER, userprofilepath TEXT, userdisplayname TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ACHIEVEMENT_USER_LEVEL (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT, levelid INTEGER, levelreceiveddate TEXT, userid INTEGER, levelname TEXT, gameid INTEGER, levelpoints INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ACHIEVEMENT_USER_POINTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT, points INTEGER, gameid INTEGER, userid INTEGER, userreceiveddate TEXT, actionid INTEGER, pointsdescription TEXT, actionname TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ACHIEVEMENT_USER_BADGES (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT, gameid INTEGER, userid INTEGER, badgedescription TEXT, badgeid INTEGER, badgename TEXT, badgereceiveddate TEXT, badgeimage TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_LEADERBOARD_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT, userid TEXT, showbadges INTEGER, showlevels INTEGER, showpoints INTEGER, showloggedusertop INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_LEADERBOARD_LIST_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT, userid TEXT, badges INTEGER, gameid INTEGER, gamename TEXT, levelname TEXT, points INTEGER, profileaction TEXT, rank INTEGER, userdisplayname TEXT, userpicturepath TEXT, intsiteid INTEGER, intuserid INTEGER)');

        /// ASKEXPERTFORDIGIMEDICA

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_QUESTIONS_DIGI (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteID INTEGER, questionID INTEGER,userID INTEGER, createduserID INTEGER, userName TEXT, userQuestion TEXT, postedDate TEXT, createdDate TEXT, totalAnswers INTEGER,questionCategories TEXT, userQuestionDescription TEXT, userQuestionImage TEXT, lastActivatedDate TEXT, totalViews INTEGER,objectID TEXT,userImage TEXT,actionsLink TEXT,userQuestionImagePath TEXT,answerBtnWithLink TEXT,actionSharewithFriends TEXT,actionSuggestConnection TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_RESPONSES_DIGI (ID INTEGER PRIMARY KEY AUTOINCREMENT, questionid INTEGER, responseid INTEGER, commentCount INTEGER, upvotesCount INTEGER, isLiked BOOLEAN,commentAction BOOLEAN, respondedUserId INTEGER, siteid INTEGER,userId INTEGER,response TEXT,respondedDate TEXT,respondedUserName TEXT,respondeDate TEXT,userResponseImage TEXT,picture TEXT,userResponseImagePath TEXT,daysAgo TEXT,responseUpVoters TEXT,isLikedStr TEXT, actionSharewithFriends TEXT, actionSuggestConnection TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_QUESTION_SKILLS_DIGI (ID INTEGER PRIMARY KEY AUTOINCREMENT,orgunitid TEXT, preferrenceid TEXT, preferrencetitle TEXT, shortskillname, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_QUESTION_CATEGORIES_DIGI (ID INTEGER PRIMARY KEY AUTOINCREMENT, categoryid TEXT, category TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_QUESTION_CATEGORY_MAPPING_DIGI (ID INTEGER PRIMARY KEY AUTOINCREMENT, questionid INTEGER, categoryid TEXT, siteid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_COMMENTS_DIGI (ID INTEGER PRIMARY KEY AUTOINCREMENT, questionID INTEGER, siteID TEXT, userID TEXT, commentAction TEXT, commentDate TEXT,commentDescription TEXT,commentID INTEGER,commentImage TEXT, commentQuestionID INTEGER, commentResponseID INTEGER, commentUserID INTEGER, commentedDate TEXT, commentedUserName TEXT, isLiked INTEGER, userImage TEXT, userCommentImagePath TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_UPVOTERS_DIGI (ID INTEGER PRIMARY KEY AUTOINCREMENT, objectId INTEGER, siteID INTEGER, likeID INTEGER, userID INTEGER, isLiked BOOLEAN, jobTitle TEXT, picture TEXT, userName TEXT)');

        // {'ID':462,'SiteID':374,'ComponentID':161,'LocalID':'en-us','OptionText':'Recently Added','OptionValue':'LastActiveDate Desc','EnableColumn':null}

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_ASK_SORT (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteID INTEGER, ComponentID INTEGER, LocalID TEXT, OptionText TEXT, OptionValue TEXT, sortID INTEGER,EnableColumn TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_FORUMS_DIGI (ID INTEGER PRIMARY KEY AUTOINCREMENT,forumID INTEGER,name TEXT,description TEXT,parentForumID INTEGER,displayOrder INTEGER,siteID INTEGER,createdUserID INTEGER,createdDate TEXT,active BOOLEAN,requiresSubscription BOOLEAN, createNewTopic BOOLEAN, attachFile BOOLEAN, likePosts BOOLEAN,sendEmail BOOLEAN,moderation BOOLEAN,isPrivate BOOLEAN,author TEXT,noOfTopics INTEGER,totalPosts INTEGER, existing INTEGER, totalLikes INTEGER,dfProfileImage TEXT,dfUpdateTime TEXT,dfChangeUpdateTime TEXT,forumThumbnailPath TEXT,descriptionWithLimit TEXT,moderatorID TEXT,updatedAuthor TEXT,updatedDate TEXT,moderatorName TEXT,allowShare BOOLEAN,descriptionWithoutLimit TEXT,categoryIDs TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_FORUM_TOPICS_DIGI (ID INTEGER PRIMARY KEY AUTOINCREMENT,contentID TEXT,forumId INTEGER,name TEXT,createdUserID INTEGER,noOfReplies INTEGER,noOfViews INTEGER,createdDate TEXT,longDescription TEXT,latestReplyBy TEXT, author TEXT, uploadFileName TEXT, updatedTime TEXT,createdTime TEXT,modifiedUserName TEXT,uploadedImageName TEXT,likes INTEGER,likeState BOOLEAN,topicUserProfile TEXT, isPin BOOLEAN, pinID INTEGER,commentsCount INTEGER,siteId INTEGER,userId INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_TOPIC_COMMENTS_DIGI (ID INTEGER PRIMARY KEY AUTOINCREMENT,commentID INTEGER,topicID TEXT,forumID TEXT,message TEXT,postedDate TEXT,postedBy INTEGER,siteID INTEGER,replyID TEXT,commentedBy TEXT, commentedFromDays TEXT, commentFileUploadPath TEXT, commentFileUploadName TEXT,commentVideoUploadName TEXT,commentAudioUploadName TEXT,commentApplicationUploadName TEXT,likeState BOOLEAN,commentLikes INTEGER,commentRepliesCount INTEGER, commentUserProfile TEXT,userID INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_TOPIC_REPLY (ID INTEGER PRIMARY KEY AUTOINCREMENT,siteID INTEGER,userID TEXT,topicID TEXT,replyID INTEGER,commentID INTEGER,forumID INTEGER,message TEXT,postedDate TEXT,postedBy INTEGER, replyBy TEXT, picture TEXT, likeState BOOLEAN,replyProfile TEXT,dtPostedOnDate TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_FORUM_CATEGORIES (ID INTEGER PRIMARY KEY AUTOINCREMENT,siteID INTEGER,userID INTEGER,ids INTEGER,categoryName TEXT,fullName TEXT,categoryID INTEGER,parentId TEXT,iconpath TEXT,agreementDocId INTEGER, contentCount INTEGER, refParentID INTEGER, displayOrder INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_MY_SKILLS (ID INTEGER PRIMARY KEY AUTOINCREMENT, siteid TEXT, userid TEXT, skillcountObj BLOB,skillname TEXT,skillcontentviewlink TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_DETAILS_SCHEDULE (ID INTEGER PRIMARY KEY AUTOINCREMENT, EventID TEXT, ContentID TEXT, Name TEXT, Duration TEXT, EventStartDateTime TEXT,EventEndDateTime TEXT,Location TEXT,TimeZone TEXT, PresenterID TEXT, Email TEXT, AccountType TEXT, Picture TEXT, DisplayName TEXT, About TEXT, Bit4 TEXT, AuthorName TEXT, EnrollmentLimit TEXT, AvailableSeats TEXT, TotalEnrolls TEXT, WaitListEnrolls TEXT, LocationImage TEXT,alreadyexist TEXT,showenroll TEXT,showwaitlis TEXT,WaitListLimit TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_CONTENT_VIEW (id INTEGER PRIMARY KEY AUTOINCREMENT, coursename TEXT, authorname TEXT, contenttype TEXT, shortdesc TEXT, thumbnailimage TEXT, thumbnailicon TEXT, scoid TEXT, siteid TEXT, userid TEXT,medianame TEXT,parentscoid TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_SESSION_VIEW (id INTEGER PRIMARY KEY AUTOINCREMENT, eventname TEXT, startdate TEXT, enddate TEXT, timezone TEXT, thumbnailimage TEXT, thumbnailicon TEXT, instructors TEXT, location TEXT, contentid TEXT, userid TEXT, siteid TEXT,parentscoid TEXT, authorname TEXT, contenttype TEXT, shortdesc TEXT, status TEXT, jsonobjectRecording BLOB)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $MEMBERSHIP_TABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, MemberShipID TEXT, MemberShipName TEXT, DisplayText TEXT, MemberShipLevel TEXT, MemberShipShortDesc TEXT, MemberShipDurationID TEXT,ExpiryDate TEXT,CouponType  TEXT,MembershipActive TEXT,SubscriptionTypeID TEXT,MemberShipPlans TEXT,siteid INTEGER, userid INTEGER, siteurl TEXT)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $TBL_TRACKLIST_TABS (ID INTEGER PRIMARY KEY AUTOINCREMENT, tabName TEXT, tabID TEXT, tabidName TEXT, TGlossary TEXT,siteid INTEGER, userid INTEGER, siteurl TEXT)');

        print('init:  TABLES CREATED');
      },
      version: 1,
    );
  }

  Future<Map<String, dynamic>> generateOfflinePathForCourseView(MyLearningModel mylearningModel) async {
    try {
      // String downloadDestFolderPath = mylearningModel.offlinepath ?? '';

      // String offlineCourseLaunch = "";

      // if (downloadDestFolderPath.contains("file:")) {
      //   offlineCourseLaunch = downloadDestFolderPath;
      // } else {
      //   offlineCourseLaunch = "file://" + downloadDestFolderPath;
      // }

      String requestString = "";
      String query = "";
      String question = "";
      String locationValue = "";
      String statusValue = "";
      String suspendDataValue = "";
      String sequenceNumberValue = "1";
      int flag = 0;

      String getCourseProgress =
          "SELECT location,status,suspenddata,sequencenumber,CourseMode "
                  "FROM CMI WHERE siteid =" +
              mylearningModel.siteID.toString() +
              " AND scoid = " +
              mylearningModel.scoId.toString() +
              " AND userid = " +
              mylearningModel.userID.toString();
      MyPrint.printOnConsole("getCourseProgress query:$getCourseProgress");
      List<Map<String, dynamic>> data =
          await _database.rawQuery(getCourseProgress);

      MyPrint.printOnConsole("getCourseProgress data:$data");

      if (data.length > 0) {
        for (Map<String, dynamic> item in data) {
          flag = 1;
          locationValue = '${item['location']}';
          statusValue = '${item['status']}';
          suspendDataValue = '${item['suspenddata']}';
          sequenceNumberValue = '${item['sequencenumber']}';

          if (!AppDirectory.isValidString(sequenceNumberValue)) {
            sequenceNumberValue = "1";
          }
        }
        suspendDataValue = suspendDataValue.replaceAll("#", "%23");

        if (flag == 1) {
          String objectTypeId = mylearningModel.objecttypeId.toString();
          if (equalsIgnoreCase(objectTypeId, "10")) {
            query = await getTrackObjectList(mylearningModel, statusValue, suspendDataValue, sequenceNumberValue);
          }
          else if (equalsIgnoreCase(objectTypeId, "8") || equalsIgnoreCase(objectTypeId, "9")) {
            String assessmentAttempt = "";
            try {
              String sqlQuery = "SELECT noofattempts FROM CMI WHERE SITEID = " +
                  mylearningModel.siteID +
                  " AND SCOID = " +
                  mylearningModel.scoId +
                  " AND USERID = " +
                  mylearningModel.userID;

              List<Map<String, dynamic>> data =
                  await _database.rawQuery(sqlQuery);

              if (data.isNotEmpty) {
                for (Map<String, dynamic> item in data) {
                  assessmentAttempt = '${item['noofattempts']}';
                  if (equalsIgnoreCase(assessmentAttempt, "0") ||
                      assessmentAttempt.isEmpty) {
                    assessmentAttempt = "1";
                  }
                }
              }
            } catch (e) {
              print('generateOfflinePathForCourseView failed: $e');
            }

            if (!equalsIgnoreCase(assessmentAttempt, "0")) {
              try {
                String sqlQuery =
                    "select QUESTIONID,studentresponses,Result,attachfilename,attachfileid,optionalNotes,capturedVidFileName,capturedVidId,"
                        "capturedImgFileName,capturedImgId from " +
                        TBL_STUDENT_RESPONSES +
                        " WHERE SITEID = " +
                        mylearningModel.siteID +
                        " AND SCOID = " +
                        mylearningModel.scoId +
                        " AND USERID = " +
                        mylearningModel.userID +
                        " AND QuestionAttempt = 1";

                List<Map<String, dynamic>> data =
                    await _database.rawQuery(sqlQuery);

                if (data.isNotEmpty) {
                  for (Map<String, dynamic> item in data) {
                    if (question.isNotEmpty) {
                      question = question + "\$";
                    }

                    String questionID = '${item['questionid']}';

                    if (!equalsIgnoreCase(questionID, "null") &&
                        questionID.isNotEmpty) {
                      question = '$question$questionID@';
                    }

                    String studentResponse = "";
                    String studentresp = item['studentresponses'];

                    if (!equalsIgnoreCase(studentresp, "null") &&
                        studentresp.isNotEmpty) {
                      if ((equalsIgnoreCase(studentresp, "undefined")) ||
                          equalsIgnoreCase(studentResponse, "null")) {
                        studentResponse = "";
                      } else {
                        studentResponse = studentresp;
                      }
                    }
                    question = '$question$studentResponse@';

                    String result = item['result'];

                    if (!equalsIgnoreCase(result, "null") &&
                        result.isNotEmpty) {
                      question = '$question$result@';
                    }

                    String attachFile = item['attachfilename'];

                    if (!equalsIgnoreCase(attachFile, "null") &&
                        attachFile.isNotEmpty) {
                      question = '$question$attachFile@';
                    }

                    String attachFileID = item['attachfileid'];

                    if (!equalsIgnoreCase(attachFileID, "null") &&
                        attachFileID.isNotEmpty) {
                      question = '$question$attachFileID@';
                    }

                    String optionalNotes = item['optionalNotes'];

                    if (!equalsIgnoreCase(optionalNotes, "null") &&
                        optionalNotes.isNotEmpty) {
                      question = '$question$optionalNotes@';
                    }

                    String capturedVidFileName = item['capturedVidFileName'];

                    if (!equalsIgnoreCase(capturedVidFileName, "null") &&
                        capturedVidFileName.isNotEmpty) {
                      question = '$question$capturedVidFileName@';
                    }

                    String capturedVidID = item['capturedVidId'];

                    if (!equalsIgnoreCase(capturedVidID, "null") &&
                        capturedVidID.isNotEmpty) {
                      question = '$question$capturedVidID@';
                    }

                    String capturedImgFileName = item['capturedImgFileName'];

                    if (!equalsIgnoreCase(capturedImgFileName, "null") &&
                        capturedImgFileName.isNotEmpty) {
                      question = '$question$capturedImgFileName@';
                    }

                    String capturedImgID = item['capturedImgId'];

                    if (!equalsIgnoreCase(capturedImgID, "null") &&
                        capturedImgID.isNotEmpty) {
                      question = '$question$capturedImgID@';
                    }
                  }
                }
              } catch (e) {
                print('generateOfflinePathForCourseView $e');
              }
              question = question.replaceAll("null", "");

              query = "cid=" +
                  mylearningModel.scoId +
                  "&stid=" +
                  mylearningModel.userID +
                  "&lloc=" +
                  locationValue +
                  "&lstatus=" +
                  statusValue +
                  "&susdata=" +
                  suspendDataValue +
                  "&quesdata=" +
                  question +
                  "&sname=" +
                  mylearningModel.userName;
            }
            else {
              query = "cid=" +
                  mylearningModel.scoId +
                  "&stid=" +
                  mylearningModel.userID +
                  "&lloc=" +
                  locationValue +
                  "&lstatus=" +
                  statusValue +
                  "&susdata=" +
                  suspendDataValue +
                  "&sname=" +
                  mylearningModel.userName;
            }
          }
        }
        else {
          sequenceNumberValue = "1";
          query = "cid=" +
              mylearningModel.scoId.toString() +
              "&stid=" +
              mylearningModel.userID.toString() +
              "&lloc=" +
              locationValue +
              "&lstatus=" +
              statusValue +
              "&susdata=" +
              suspendDataValue +
              "&quesdata=" +
              question +
              "&sname=" +
              mylearningModel.userName;
        }
      }
      //      not required for now
      bool isSessionExists = false;
      int numberOfAttemptsInt = 0;
//            var timeSpent = "00:00:00"
      String sqlQuery = "SELECT count(sessionid) as attemptscount FROM " +
          TBL_USER_SESSION +
          " WHERE siteid = " +
          mylearningModel.siteID +
          " AND scoid = '" +
          mylearningModel.scoId +
          "' AND userid = " +
          mylearningModel.userID;

      List<Map<String, dynamic>> data2 = await _database.rawQuery(sqlQuery);
      try {
        if (data2.isNotEmpty) {
          for (Map<String, dynamic> item in data2) {
            isSessionExists = true;
            String counts = '${item['attemptscount']}';
            numberOfAttemptsInt = int.parse(counts);
            numberOfAttemptsInt = numberOfAttemptsInt + 1;
          }
        }
      }
      catch (e) {
        print('failed to parse attemptscount $e');
      }

      LearnerSessionModel? learnersessionTb;

      if (isSessionExists) {
        learnersessionTb = LearnerSessionModel();
        String objectTypeId = mylearningModel.objecttypeId;
        if (equalsIgnoreCase(objectTypeId, "10")) {
          List<String> tupleValues = await getTrackObjectTypeIDAndScoidBasedOnSequenceNumber(
            mylearningModel.scoId,
            sequenceNumberValue,
            mylearningModel.siteID,
            mylearningModel.userID,
          );
          String objectScoidValue = tupleValues[0];

          int latestAttemptNo = await getLatestAttempt(
            objectScoidValue,
            mylearningModel.userID,
            mylearningModel.siteID,
          );

          learnersessionTb.scoID = objectScoidValue;

          learnersessionTb.attemptNumber = latestAttemptNo.toString();
        }
        else {
          learnersessionTb.scoID = mylearningModel.scoId;
          learnersessionTb.attemptNumber = numberOfAttemptsInt.toString();
        }

        learnersessionTb.siteID = mylearningModel.siteID;
        learnersessionTb.userID = mylearningModel.userID;
        learnersessionTb.sessionDateTime = getCurrentDateTime();

        await insertUserSession(learnersessionTb);
      }

      query = query.replaceAll("#", "%23");
      String instancyContent = 'IsInstancyContent=true';
      if(mylearningModel.objecttypeId == '26') {
        instancyContent = 'IsInstancyContent=false';
      }

      if (query.isNotEmpty) {
        requestString = "$query&$instancyContent&nativeappURL=true";
      }
      else {
        requestString = 'nativeappURL=true&'
            '$instancyContent&'
            'cid=${mylearningModel.scoId}&'
            'stid=${mylearningModel.userID}&'
            'tbookmark=&'
            'lloc=&'
            'lstatus=&'
            'susdata=&'
            'quesdata=null&'
            'score=&'
            'LtSusdata=&'
            'LtStatus=&'
            'LtQuesData=&'
            'sname=';
      }

      print("generateOfflinePathForCourseView requestString: $requestString");

      return {
        "requestString" : requestString,
        "learnersessionTb" : learnersessionTb,
      };
    }
    catch (e) {
      print('generateOfflinePathForCourseView failed: $e');
      return {};
    }
  }

  Future<void> injectMyLearningIntoTable(MyLearningModel myLearningModel) async {
    try {
      bool isExists = await isContentExists(myLearningModel, TBL_DOWNLOAD_DATA);
      if (isExists) return;

      String query = 'INSERT INTO $TBL_DOWNLOAD_DATA ('
          'username,'
          'userid,'
          'siteid,'
          'siteurl,'
          'sitename,'
          'contentid,'
          'objectid,'
          'coursename,'
          'author,'
          'shortdes,'
          'longdes,'
          'imagedata,'
          'medianame,'
          'createddate,'
          'startpage,'
          'eventstarttime,'
          'eventendtime,'
          'objecttypeid,'
          'locationname,'
          'timezone,'
          'scoid,'
          'participanturl,'
          'status,'
          'displaystatus,'
          'password,'
          'displayname,'
          'islistview,'
          'isdownloaded,'
          'courseattempts,'
          'eventcontentid,'
          'relatedcontentcount,'
          'durationenddate,'
          'ratingid,'
          'publisheddate,'
          'isExpiry,'
          'mediatypeid,'
          'dateassigned,'
          'keywords,'
          'tagname,'
          'downloadurl,'
          'offlinepath,'
          'presenter,'
          'eventaddedtocalender,'
          'joinurl,'
          'typeofevent,'
          'progress,'
          'membershiplevel,'
          'membershipname ,'
          'folderpath,'
          'jwvideokey,'
          'cloudmediaplayerkey,'
          'eventstartUtctime,'
          'eventendUtctime,'
          'isarchived,'
          'isRequired,'
          'contentTypeImagePath,'
          'EventScheduleType,'
          'LearningObjectives,'
          'TableofContent,'
          'LongDescription,'
          'ThumbnailVideoPath,'
          'totalratings,'
          'groupName,'
          'activityid,'
          'cancelEventEnabled,'
          'removeFromMylearning,'
          'reSheduleEvent,'
          'isBadCancellationEnabled,'
          'isEnrollFutureInstance,'
          'percentcompleted,'
          'certificateaction,'
          'certificateid,'
          'certificatepage,'
          'windowproperties,'
          'bit4,'
          'qrCodeImagePath,'
          'QRImageName,'
          'offlineQrCodeImagePath,'
          'viewprerequisitecontentstatus,'
          'credits,'
          'decimal2,'
          'duration,'
          'recordingmsg,'
          'eventrecording,'
          'recordingcontentid,'
          'recordingurl,'
          'fileSize,'
          'jwstartPage'
          ') VALUES ('
          '\'${myLearningModel.userName}\','
          '\'${myLearningModel.userID}\','
          '\'${myLearningModel.siteID}\','
          '\'${myLearningModel.siteURL}\','
          '\'${myLearningModel.siteName}\','
          '\'${myLearningModel.contentID}\','
          '\'${myLearningModel.objectId}\','
          '\'${myLearningModel.courseName}\','
          '\'${myLearningModel.author}\','
          '\'${myLearningModel.shortDes}\','
          '\'${myLearningModel.longDes}\','
          '\'${myLearningModel.imageData}\','
          '\'${myLearningModel.mediaName}\','
          '\'${myLearningModel.createdDate}\','
          '\'${myLearningModel.startPage}\','
          '\'${myLearningModel.eventstartTime}\','
          '\'${myLearningModel.eventendTime}\','
          '\'${myLearningModel.objecttypeId}\','
          '\'${myLearningModel.locationName}\','
          '\'${myLearningModel.timeZone}\','
          '\'${myLearningModel.scoId}\','
          '\'${myLearningModel.participantUrl}\','
          '\'${myLearningModel.statusActual}\','
          '\'${myLearningModel.statusDisplay}\','
          '\'${myLearningModel.password}\','
          '\'${myLearningModel.displayName}\','
          '\'${myLearningModel.isListView}\','
          '\'${myLearningModel.isDownloaded}\','
          '\'${myLearningModel.courseAttempts}\','
          '\'${myLearningModel.eventContentid}\','
          '\'${myLearningModel.relatedContentCount}\','
          '\'${myLearningModel.durationEndDate}\','
          '\'${myLearningModel.ratingId}\','
          '\'${myLearningModel.publishedDate}\','
          '\'${myLearningModel.isExpiry}\','
          '\'${myLearningModel.mediatypeId}\','
          '\'${myLearningModel.dateAssigned}\','
          '\'${myLearningModel.keywords}\','
          '\'${myLearningModel.tagname}\','
          '\'${myLearningModel.downloadURL}\','
          '\'${myLearningModel.offlinepath}\','
          '\'${myLearningModel.presenter}\','
          '\'${myLearningModel.eventAddedToCalender}\','
          '\'${myLearningModel.joinurl}\','
          '\'${myLearningModel.typeofevent}\','
          '\'${myLearningModel.progress}\','
          '${myLearningModel.memberShipLevel},'
          '\'${myLearningModel.membershipname}\','
          '\'${myLearningModel.folderPath}\','
          '\'${myLearningModel.jwvideokey}\','
          '\'${myLearningModel.cloudmediaplayerkey}\','
          '\'${myLearningModel.eventstartUtcTime}\','
          '\'${myLearningModel.eventendUtcTime}\','
          '${myLearningModel.isArchived},'
          '${myLearningModel.isRequired},'
          '\'${myLearningModel.contentTypeImagePath}\','
          '${myLearningModel.EventScheduleType},'
          '\'${myLearningModel.LearningObjectives}\','
          '\'${myLearningModel.TableofContent}\','
          '\'${myLearningModel.longDes}\','
          '\'${myLearningModel.thumbnailVideoPath}\','
          '${myLearningModel.totalratings},'
          '\'${myLearningModel.groupName}\','
          '\'${myLearningModel.activityId}\','
          '${myLearningModel.cancelEventEnabled},'
          '${myLearningModel.removeFromMylearning},'
          '\'${myLearningModel.reScheduleEvent}\','
          '${myLearningModel.isBadCancellationEnabled},'
          '${myLearningModel.isEnrollFutureInstance},'
          '\'${myLearningModel.percentCompleted}\','
          '\'${myLearningModel.CertificateAction}\','
          '\'${myLearningModel.CertificateId}\','
          '\'${myLearningModel.CertificatePage}\','
          '\'${myLearningModel.WindowProperties}\','
          '${myLearningModel.bit4},'
          '\'${myLearningModel.qrCodeImagePath}\','
          '\'${myLearningModel.QRImageName}\','
          '\'${myLearningModel.offlineQrCodeImagePath}\','
          '\'${myLearningModel.viewprerequisitecontentstatus}\','
          '\'${myLearningModel.credits}\','
          '\'${myLearningModel.decimal2}\','
          '\'${myLearningModel.duration}\','
          '\'${myLearningModel.recordingmsg}\','
          '\'${myLearningModel.eventrecording}\','
          '\'${myLearningModel.recordingcontentid}\','
          '\'${myLearningModel.recordingurl}\','
          '${myLearningModel.fileSize},'
          '\'${myLearningModel.jwStartPage}\''
          ')';
      await _database.rawQuery(query);
    } catch (e) {
      print('injectMyLearningIntoTable failed: $e');
    }
  }

  Future<void> injectTrackListIntoTable(MyLearningModel trackListModel) async {
    try {
      bool isExists = await isContentExists(trackListModel, TBL_TRACKLIST_DATA);
      if (isExists) return;

      String query = 'INSERT INTO $TBL_TRACKLIST_DATA ('
          'username,'
          'siteid,'
          'userid,'
          'scoid,'
          'siteurl,'
          'sitename,'
          'contentid,'
          'coursename,'
          'author,'
          'shortdes,'
          'longdes,'
          'imagedata,'
          'medianame,'
          'createddate,'
          'startpage,'
          'eventstarttime,'
          'eventendtime,'
          'objecttypeid,'
          'locationname,'
          'timezone,'
          'participanturl,'
          'trackscoid,'
          'status,'
          'displaystatus,'
          'eventid,'
          'password,'
          'displayname,'
          'isdownloaded,'
          'courseattempts,'
          'eventcontentid,'
          'relatedcontentcount,'
          'mediatypeid,'
          'downloadurl,'
          'progress,'
          'presenter,'
          'eventaddedtocalender,'
          'joinurl,'
          'typeofevent,'
          'blockname,'
          'showstatus,'
          'parentid,'
          'timedelay,'
          'isdiscussion,'
          'sequencenumber,'
          'courseattempts,'
          'offlinepath,'
          'trackContentId,'
          'ruleid,'
          'stepid,'
          'wmessage,'
          'folderpath,'
          'jwvideokey,'
          'cloudmediaplayerkey,'
          'eventstartUtctime,'
          'eventendUtctime,'
          'contentTypeImagePath,'
          'activityid,'
          'bookmarkid,'
          'recordingmsg,'
          'eventrecording,'
          'recordingcontentid,'
          'recordingurl,'
          'objectfolderid'
          ') VALUES ('
          '\'${trackListModel.userName}\','
          '\'${trackListModel.siteID}\','
          '\'${trackListModel.userID}\','
          '\'${trackListModel.scoId}\','
          '\'${trackListModel.siteURL}\','
          '\'${trackListModel.siteName}\','
          '\'${trackListModel.contentID}\','
          '\'${trackListModel.courseName}\','
          '\'${trackListModel.author}\','
          '\'${trackListModel.shortDes}\','
          '\'${trackListModel.longDes}\','
          '\'${trackListModel.imageData}\','
          '\'${trackListModel.mediaName}\','
          '\'${trackListModel.createdDate}\','
          '\'${trackListModel.startPage}\','
          '\'${trackListModel.eventstartTime}\','
          '\'${trackListModel.eventendTime}\','
          '\'${trackListModel.objecttypeId}\','
          '\'${trackListModel.locationName}\','
          '\'${trackListModel.timeZone}\','
          '\'${trackListModel.participantUrl}\','
          '\'${trackListModel.trackScoid}\','
          '\'${trackListModel.statusActual}\','
          '\'${trackListModel.statusDisplay}\','
          '\'${trackListModel.eventID}\','
          '\'${trackListModel.password}\','
          '\'${trackListModel.displayName}\','
          '\'${trackListModel.isDownloaded}\','
          '\'${trackListModel.courseAttempts}\','
          'false,'
          '\'${trackListModel.relatedContentCount}\','
          '\'${trackListModel.mediatypeId}\','
          '\'${trackListModel.downloadURL}\','
          '\'${trackListModel.progress}\','
          '\'${trackListModel.presenter}\','
          '\'${trackListModel.eventAddedToCalender}\','
          '\'${trackListModel.joinurl}\','
          '\'${trackListModel.typeofevent}\','
          '\'${trackListModel.blockName}\','
          '\'${trackListModel.showStatus}\','
          '\'${trackListModel.parentID}\','
          '\'${trackListModel.timeDelay}\','
          '\'${trackListModel.isDiscussion}\','
          '\'${trackListModel.sequenceNumber}\','
          '\'${trackListModel.courseAttempts}\','
          '\'${trackListModel.offlinepath}\','
          '\'${trackListModel.trackOrRelatedContentID}\','
          '0,'
          '0,'
          '\'\','
          '\'${trackListModel.folderPath}\','
          '\'${trackListModel.jwvideokey}\','
          '\'${trackListModel.cloudmediaplayerkey}\','
          '\'${trackListModel.eventstartUtcTime}\','
          '\'${trackListModel.eventendUtcTime}\','
          '\'${trackListModel.contentTypeImagePath}\','
          '\'${trackListModel.activityId}\','
          '\'${trackListModel.bookmarkID}\','
          '\'${trackListModel.recordingmsg}\','
          '\'${trackListModel.eventrecording}\','
          '\'${trackListModel.recordingcontentid}\','
          '\'${trackListModel.recordingurl}\','
          '\'${trackListModel.objectfolderid}\''
          ')';

      await _database.rawQuery(query);
      print('success');
    } catch (e) {
      print('injectTrackListIntoTable failed: $e');
    }
  }

  Future<void> injectCMIDataInto(Map<String, dynamic> jsonObjectCMI,
      DummyMyCatelogResponseTable2 learningModel) async {
    try {
      List<dynamic> jsonCMiArray = jsonObjectCMI['cmi'];
      List<dynamic> jsonStudentAry = jsonObjectCMI['studentresponse'];
      List<dynamic> jsonLearnerSessionAry = jsonObjectCMI['learnersession'];

      /// Delete all existing records irrespective of whether there is data coming from the server or not.
      /// If there's no data on the server, then there should not be data on the local DB as well.
      /// Usage: In cases where the course has been unassigned earlier but is now reassigned
      /// When the course is unassigned, track data is cleared on the server
      ejectRecordsinCmi(learningModel);
      insertCMIData(jsonCMiArray, learningModel);

      ejectRecordsinStudentResponse(learningModel);
      insertStudentResponsData(jsonStudentAry, learningModel);

      ejectRecordsinLearnerSession(learningModel);
      insertLearnerSession(jsonLearnerSessionAry, learningModel);
    } catch (err) {
      print('injectCMIDataInto failed $err');
    }
  }

  Future<void> insertTrackObjects(Map<String, dynamic> jsonResponse,
      DummyMyCatelogResponseTable2 myLearningModel) async {
    try {
      AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
      List<dynamic> jsonTrackObjects = jsonResponse["table3"];
      List<dynamic> jsonTrackList = jsonResponse["table5"];

      if (jsonTrackObjects.length > 0) {
        ejectRecordsinTrackObjDb(myLearningModel);

        TrackObjectsModel trackObjectsModel = TrackObjectsModel();
        for (int i = 0; i < jsonTrackObjects.length; i++) {
          Map<dynamic, dynamic> jsonTrackObj = jsonTrackObjects[i];
          print("insertTrackObjects: $jsonTrackObj");

          if (jsonTrackObj.containsKey("name")) {
            trackObjectsModel.name = jsonTrackObj["name"];
          }
          if (jsonTrackObj.containsKey("objecttypeid")) {
            trackObjectsModel.objTypeId = jsonTrackObj["objecttypeid"];
          }
          if (jsonTrackObj.containsKey("scoid")) {
            trackObjectsModel.scoId = jsonTrackObj["scoid"];
          }

          if (jsonTrackObj.containsKey("sequencenumber")) {
            trackObjectsModel.sequenceNumber = jsonTrackObj["sequencenumber"];
          }

          if (jsonTrackObj.containsKey("trackscoid")) {
            trackObjectsModel.trackSoId = jsonTrackObj["trackscoid"];
          }
          trackObjectsModel.userID = myLearningModel.userid;
          trackObjectsModel.siteID = myLearningModel.siteid.toString();

          injectIntoTrackObjectsTable(trackObjectsModel);
        }
      }

      if (jsonTrackList.length > 0) {
        ejectRecordsinTracklistTable(myLearningModel.siteid.toString(),
            myLearningModel.scoid.toString(), myLearningModel.userid.toString(), true);
        for (int i = 0; i < jsonTrackList.length; i++) {
          Map<dynamic, dynamic> jsonMyLearningColumnObj = jsonTrackList[i];

          MyLearningModel trackLearningModel = new MyLearningModel();
          // trackscoid
          trackLearningModel.trackScoid = myLearningModel.scoid.toString();

          // userid
          trackLearningModel.userID = myLearningModel.userid.toString();

          // username

          trackLearningModel.userName = await sharePrefGetString(sharedPref_username);

          // password
          trackLearningModel.password = await sharePrefGetString(sharedPref_LoginPassword);

          //sitename

          trackLearningModel.siteName = myLearningModel.sitename;
          // siteurl

          trackLearningModel.siteURL = myLearningModel.siteurl;

          // siteid

          trackLearningModel.siteID = myLearningModel.siteid.toString();

          // parentid
          if (jsonMyLearningColumnObj.containsKey("parentid")) {
            trackLearningModel.parentID = jsonMyLearningColumnObj["parentid"].toString();
          }

          //showstatus
          if (jsonMyLearningColumnObj.containsKey("showstatus")) {
            trackLearningModel.showStatus = jsonMyLearningColumnObj["showstatus"].toString();
          } else {
            trackLearningModel.showStatus = "show";
          }
          //timedelay
          if (jsonMyLearningColumnObj.containsKey("timedelay")) {
            trackLearningModel.showStatus = jsonMyLearningColumnObj["timedelay"].toString();
          }
          //isdiscussion
          if (jsonMyLearningColumnObj.containsKey("isdiscussion")) {
            trackLearningModel.isDiscussion = jsonMyLearningColumnObj["isdiscussion"].toString();
          }

          //eventcontendid
          if (jsonMyLearningColumnObj.containsKey("eventcontentid")) {
            trackLearningModel.eventContentid = jsonMyLearningColumnObj["eventcontentid"].toString();
          }

          //eventid
          if (jsonMyLearningColumnObj.containsKey("eventid")) {
            trackLearningModel.eventID = jsonMyLearningColumnObj["eventid"].toString();
          }

          //sequencenumber
          if (jsonMyLearningColumnObj.containsKey("sequencenumber")) {
            int parseInteger = int.parse(
                jsonMyLearningColumnObj["sequencenumber"].toString());
            trackLearningModel.sequenceNumber = parseInteger;
          }
          // mediatypeid
          if (jsonMyLearningColumnObj.containsKey("mediatypeid")) {
            trackLearningModel.mediatypeId =
                jsonMyLearningColumnObj["mediatypeid"].toString();
          }
          // relatedcontentcount
          if (jsonMyLearningColumnObj.containsKey("relatedcontentcount")) {
            trackLearningModel.relatedContentCount =
                jsonMyLearningColumnObj["relatedcontentcount"].toString();
          }

          // coursename
          if (jsonMyLearningColumnObj.containsKey("name")) {
            trackLearningModel.courseName = jsonMyLearningColumnObj["name"].toString();
          }
          // shortdes
          if (jsonMyLearningColumnObj.containsKey("shortdescription")) {
            // Spanned result = fromHtml(
            //     jsonMyLearningColumnObj["shortdescription"].toString());

            trackLearningModel.shortDes = jsonMyLearningColumnObj["shortdescription"].toString();
          }
          // author
          if (jsonMyLearningColumnObj.containsKey("author")) {
            trackLearningModel.author =
                jsonMyLearningColumnObj["author"].toString();
          }
          // contentID
          if (jsonMyLearningColumnObj.containsKey("contentid")) {
            trackLearningModel.contentID =
                jsonMyLearningColumnObj["contentid"].toString();
          }
          // createddate
          if (jsonMyLearningColumnObj.containsKey("createddate")) {
            trackLearningModel.createdDate =
                jsonMyLearningColumnObj["createddate"].toString();
          }
          // displayName
          trackLearningModel.displayName = appBloc.nativeMenuModel.displayname;

          // thumbnailimagepath
          if (jsonMyLearningColumnObj.containsKey("thumbnailimagepath")) {
            String imageurl =
                jsonMyLearningColumnObj["thumbnailimagepath"];

            if (AppDirectory.isValidString(imageurl)) {
              trackLearningModel.thumbnailImagePath = imageurl;

              String imagePathSet = "";

              if (appBloc.uiSettingModel.isCloudStorageEnabled == 'true') {
                imagePathSet = imageurl;
              } else {
                imagePathSet = trackLearningModel.siteURL + imageurl;
              }

              trackLearningModel.imageData = imagePathSet;
            } else {
              if (jsonMyLearningColumnObj.containsKey("contenttypethumbnail")) {
                String imageurlContentType =
                    jsonMyLearningColumnObj["contenttypethumbnail"];
                if (AppDirectory.isValidString(imageurlContentType)) {
                  String imagePathSet = "";

                  if (appBloc.uiSettingModel.isCloudStorageEnabled == 'true') {
                    imagePathSet = imageurlContentType;
                  } else {
                    imagePathSet = trackLearningModel.siteURL +
                        "/content/sitefiles/Images/" +
                        imageurlContentType;
                  }

                  trackLearningModel.imageData = imagePathSet;
                }
              }
            }
          }
          if (jsonMyLearningColumnObj.containsKey("objecttypeid") &&
              jsonMyLearningColumnObj.containsKey("startpage")) {
            String objtId =
                jsonMyLearningColumnObj["objecttypeid"].toString();
            String startPage =
                jsonMyLearningColumnObj["startpage"].toString();
            String contentid =
                jsonMyLearningColumnObj["contentid"].toString();
            String downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
                "/.Mydownloads/Contentdownloads" +
                "/$contentid-${appBloc.userid}";

            String finalDownloadedFilePath =
                downloadDestFolderPath + "/" + startPage;

            trackLearningModel.offlinepath = finalDownloadedFilePath;
          }

          // relatedcontentcount
          if (jsonMyLearningColumnObj.containsKey("relatedconentcount")) {
            trackLearningModel.relatedContentCount =
                jsonMyLearningColumnObj["relatedconentcount"].toString();
          }
          // isDownloaded
          if (jsonMyLearningColumnObj.containsKey("isdownloaded")) {
            trackLearningModel.isDownloaded =
                jsonMyLearningColumnObj["isdownloaded"].toString();
          }
          // courseattempts
          if (jsonMyLearningColumnObj.containsKey("courseattempts")) {
            trackLearningModel.courseAttempts =
                jsonMyLearningColumnObj["courseattempts"].toString();
          }
          // objecttypeid
          if (jsonMyLearningColumnObj.containsKey("objecttypeid")) {
            trackLearningModel.objecttypeId =
                jsonMyLearningColumnObj["objecttypeid"].toString();
          }
          // scoid
          if (jsonMyLearningColumnObj.containsKey("scoid")) {
            trackLearningModel.scoId = jsonMyLearningColumnObj["scoid"].toString();
          }
          // startpage
          if (jsonMyLearningColumnObj.containsKey("startpage")) {
            trackLearningModel.startPage =
                jsonMyLearningColumnObj["startpage"].toString();
          }
          // status
          if (jsonMyLearningColumnObj.containsKey("actualstatus")) {
            trackLearningModel.statusActual =
                jsonMyLearningColumnObj["actualstatus"].toString();
          }

          if (jsonMyLearningColumnObj.containsKey("corelessonstatus")) {
            trackLearningModel.statusDisplay =
                jsonMyLearningColumnObj["corelessonstatus"].toString();
          }

          // longdes
          if (jsonMyLearningColumnObj.containsKey("longdescription")) {
            // Spanned result = fromHtml(
            //     jsonMyLearningColumnObj["longdescription"].toString());

            trackLearningModel.longDes = jsonMyLearningColumnObj["longdescription"].toString();
          }
          // typeofevent
          if (jsonMyLearningColumnObj.containsKey("typeofevent")) {
            int typeoFEvent = int.parse(
                jsonMyLearningColumnObj["typeofevent"].toString());

            trackLearningModel.typeofevent = typeoFEvent;
          }

          // medianame
          if (jsonMyLearningColumnObj.containsKey("medianame")) {
            String medianame = jsonMyLearningColumnObj["medianame"];

            if (!(trackLearningModel.objecttypeId.toLowerCase() == "70")) {
              if (jsonMyLearningColumnObj["medianame"].toString().toLowerCase() == "test") {
                medianame = "Assessment(Test)";
              } else {
                medianame = jsonMyLearningColumnObj["medianame"].toString();
              }
            } else {
              if (trackLearningModel.typeofevent == 2) {
                medianame = "Event (Online)";
              } else if (trackLearningModel.typeofevent == 1) {
                medianame = "Event (Face to Face)";
              }
            }

            trackLearningModel.mediaName = medianame;
          }

          if (jsonMyLearningColumnObj.containsKey("contenttype")) {
            trackLearningModel.mediaName =
                jsonMyLearningColumnObj["contenttype"].toString();
          }

          // eventstarttime
          if (jsonMyLearningColumnObj.containsKey("eventstartdatedisplay")) {
            trackLearningModel.eventstartTime =
                jsonMyLearningColumnObj["eventstartdatedisplay"].toString();
          }
          // eventenddatedisplay
          if (jsonMyLearningColumnObj.containsKey("eventenddatedisplay")) {
            trackLearningModel.eventendTime =
                jsonMyLearningColumnObj["eventenddatedisplay"].toString();
          }

          // mediatypeid
          if (jsonMyLearningColumnObj.containsKey("mediatypeid")) {
            trackLearningModel.mediatypeId =
                jsonMyLearningColumnObj["mediatypeid"].toString();
          }
          // eventcontentid
          if (jsonMyLearningColumnObj.containsKey("eventcontentid")) {
            trackLearningModel.eventContentid =
                jsonMyLearningColumnObj["eventcontentid"].toString();
          }
          // eventAddedToCalender
          trackLearningModel.eventAddedToCalender = false;

          // eventfulllocation
          if (jsonMyLearningColumnObj.containsKey("eventfulllocation")) {
            trackLearningModel.locationName =
                jsonMyLearningColumnObj["eventfulllocation"].toString();
          }
          // timezone
          if (jsonMyLearningColumnObj.containsKey("timezone")) {
            trackLearningModel
                .timeZone = jsonMyLearningColumnObj["timezone"].toString();
          }
          // participanturl
          if (jsonMyLearningColumnObj.containsKey("participanturl")) {
            trackLearningModel.participantUrl =
                jsonMyLearningColumnObj["participanturl"].toString();
          }

          // isListView
          if (jsonMyLearningColumnObj.containsKey("bit5")) {
            trackLearningModel
                .isListView = jsonMyLearningColumnObj["bit5"].toString();
          }

          // joinurl
          if (jsonMyLearningColumnObj.containsKey("joinurl")) {
            trackLearningModel
                .joinurl = jsonMyLearningColumnObj["joinurl"].toString();
          }

          // presenter
          if (jsonMyLearningColumnObj.containsKey("presentername")) {
            trackLearningModel.presenter =
                jsonMyLearningColumnObj["presentername"].toString();
          }

          //sitename
          if (jsonMyLearningColumnObj.containsKey("progress")) {
            trackLearningModel
                .progress = jsonMyLearningColumnObj["progress"].toString();
          }

          trackLearningModel.recordingmsg = jsonMyLearningColumnObj["recordingmsg"] ?? '';
          trackLearningModel.eventrecording = jsonMyLearningColumnObj["eventrecording"] ?? '';
          trackLearningModel.recordingcontentid = jsonMyLearningColumnObj["recordingcontentid"];
          trackLearningModel.recordingurl = jsonMyLearningColumnObj["recordingurl"] ?? '';

          trackLearningModel.blockName = "";
          trackLearningModel.trackOrRelatedContentID = myLearningModel.contentid;

          injectIntoTrackTable(trackLearningModel);
        }
      }
    } catch (err) {
      print('insertTrackObjects failed: $err');
    }
  }

  Future<void> insertCMIData(List<dynamic> jsonArray,
      DummyMyCatelogResponseTable2 learningModel) async {
    try {
      for (int i = 0; i < jsonArray.length; i++) {
        Map<dynamic, dynamic> jsonCMiColumnObj = jsonArray[i];
        print('injectINTCMI: $jsonCMiColumnObj');

        CMIModel cmiModel = new CMIModel();


        if (jsonCMiColumnObj.containsKey("corelessonstatus")) {
          String string = jsonCMiColumnObj["corelessonstatus"].toString();
          cmiModel.status = AppDirectory.isValidString(string) ? string : '';
        }

        // scoid
        if (jsonCMiColumnObj.containsKey("scoid")) {
          int scoID = int.parse(jsonCMiColumnObj["scoid"].toString());
          cmiModel.scoId = scoID;
        }
        // userid
        if (jsonCMiColumnObj.containsKey("userid")) {
          int userID = int.parse(
              jsonCMiColumnObj["userid"].toString());
          cmiModel.userId = userID;
        }
        // corelessonlocation
        if (jsonCMiColumnObj.containsKey("corelessonlocation")) {
          String string = jsonCMiColumnObj["corelessonlocation"].toString();
          cmiModel.location = AppDirectory.isValidString(string) ? string : '';
        }

        // author
        if (jsonCMiColumnObj.containsKey("totalsessiontime")) {
          String string = jsonCMiColumnObj["totalsessiontime"].toString();
          cmiModel.timespent =
          AppDirectory.isValidString(string) ? string : "0:00:00";
        }
        // scoreraw
        if (jsonCMiColumnObj.containsKey("scoreraw")) {
          String string = jsonCMiColumnObj["scoreraw"].toString();
          cmiModel.score = AppDirectory.isValidString(string) ? string : '';
        }
        // sequencenumber
        if (jsonCMiColumnObj.containsKey("sequencenumber")) {
          String string = jsonCMiColumnObj["sequencenumber"].toString();
          cmiModel.seqNum = AppDirectory.isValidString(string) ? string : '';
        }
        // durationEndDate
        if (jsonCMiColumnObj.containsKey("corelessonmode")) {
          String string = jsonCMiColumnObj["corelessonmode"].toString();
          cmiModel.coursemode = AppDirectory.isValidString(string) ? string : '';
        }
        // scoremin
        if (jsonCMiColumnObj.containsKey("scoremin")) {
          String string = jsonCMiColumnObj["scoremin"].toString();
          cmiModel.scoremin = AppDirectory.isValidString(string) ? string : '';
        }

        // scoremax
        if (jsonCMiColumnObj.containsKey("scoremax")) {
          String string = jsonCMiColumnObj["scoremax"].toString();
          cmiModel.scoremax = AppDirectory.isValidString(string) ? string : '';
        }

        cmiModel.startdate ="";

        // datecompleted
        if (jsonCMiColumnObj.containsKey("datecompleted")) {
          String s = jsonCMiColumnObj["datecompleted"].toString().toUpperCase();

          if (!(s.toLowerCase() == "null")) {
            String dateStr = s.substring(0, 19);

            DateTime dateObj;
            try {
              dateObj = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').parse(dateStr);
              DateFormat("yyyy-MM-dd hh:mm:ss");
              String strCreatedDate1 = DateFormat("yyyy-MM-dd hh:mm:ss").format(dateObj);
              cmiModel.datecompleted = strCreatedDate1;
            }
            catch (err) {
              print('insertCMIData DateFormat failed: $err');
            }
          } else {
            cmiModel.datecompleted = "";
          }
        }
        // objecttypeid
        if (jsonCMiColumnObj.containsKey("suspenddata")) {
          cmiModel.suspenddata = jsonCMiColumnObj["suspenddata"].toString();
        }
        // scoid
        if (jsonCMiColumnObj.containsKey("textresponses")) {
          String string = jsonCMiColumnObj["textresponses"].toString();
          cmiModel.textResponses = AppDirectory.isValidString(string) ? string : '';
        }
        cmiModel.siteId = learningModel.siteid.toString();
        cmiModel.sitrurl = learningModel.siteurl;
        cmiModel.isupdate = "true";
        // status
        if (jsonCMiColumnObj.containsKey("noofattempts") &&
            !(jsonCMiColumnObj["noofattempts"] == null)) {
          int numberAtmps = int.parse(
              jsonCMiColumnObj["noofattempts"].toString());
          cmiModel.noofattempts = numberAtmps;
        }
        injectIntoCMITable(cmiModel, "true");
      }
    } catch (err) {
      print('insertCMIData failed: $err');
    }
  }

  Future<void> injectIntoCMITable(CMIModel cmiModel, String isviewd) async {
    try {
      String query = 'INSERT INTO $TBL_CMI('
          'siteid,'
          'scoid,'
          'userid,'
          'location,'
          'status,'
          'suspenddata,'
          'isupdate,'
          'siteurl,'
          'datecompleted,'
          'noofattempts,'
          'score,'
          'sequencenumber,'
          'startdate,'
          'timespent,'
          'coursemode,'
          'scoremin,'
          'scoremax,'
          'submittime,'
          'randomquesseq,'
          'pooledquesseq,'
          'textResponses,'
          'percentageCompleted)VALUES('
          '\'${cmiModel.siteId}\','
          '\'${cmiModel.scoId}\','
          '\'${cmiModel.userId}\','
          '\'${cmiModel.location}\','
          '\'${cmiModel.status}\','
          '\'${cmiModel.suspenddata}\','
          '\'$isviewd\','
          '\'${cmiModel.sitrurl}\','
          '\'${cmiModel.datecompleted}\','
          '\'${cmiModel.noofattempts}\','
          '\'${cmiModel.score}\','
          '\'${cmiModel.seqNum}\','
          '\'${cmiModel.startdate}\','
          '\'${cmiModel.timespent}\','
          '\'${cmiModel.coursemode}\','
          '\'${cmiModel.scoremin}\','
          '\'${cmiModel.scoremax}\','
          '\'${cmiModel.submittime}\','
          '\'${cmiModel.qusseq}\','
          '\'${cmiModel.pooledqusseq}\','
          '\'${cmiModel.textResponses}\','
          '\'${cmiModel.percentageCompleted}\')';
      await _database.rawQuery(query);
    } catch (err) {
      print('injectIntoCMITable failed: $err');
    }
  }

  Future<void> insertStudentResponsData(List<dynamic> jsonArray,
      DummyMyCatelogResponseTable2 learningModel) async {
    try {
      for (int i = 0; i < jsonArray.length; i++) {
        Map<dynamic, dynamic> jsonCMiColumnObj = jsonArray[i];

        print("injectINTCMI: $jsonCMiColumnObj");

        StudentResponseModel studentResponseModel = new StudentResponseModel();

        //userid
        if (jsonCMiColumnObj.containsKey("userid")) {
          int userID = int.parse(
              jsonCMiColumnObj["userid"].toString());
          studentResponseModel.userId = userID;
        }
        // statusdisplayname
        if (jsonCMiColumnObj.containsKey("studentresponses")) {
          String checkForNull = jsonCMiColumnObj["studentresponses"].toString();

          if (AppDirectory.isValidString(checkForNull)) {
            // Replace "@" with "#^#"
            if (checkForNull.contains("@")) {
              checkForNull = checkForNull.replaceAll("@", "#^#^");
            }

            // Replace "&&**&&" with "##^^##"
            if (checkForNull.contains("&&**&&")) {
              checkForNull = checkForNull.replaceAll("&&\\*\\*&&", "##^^##^^");
            }

            studentResponseModel.studentresponses = checkForNull;
          } else {
            studentResponseModel.studentresponses = "";
          }
        }
        // scoid
        if (jsonCMiColumnObj.containsKey("scoid")) {
          int scoID = int.parse(jsonCMiColumnObj["scoid"].toString());
          studentResponseModel.scoId = scoID;
        }
        // userid
        if (jsonCMiColumnObj.containsKey("result")) {
          studentResponseModel.result = jsonCMiColumnObj["result"].toString();
        }

        // author
        if (jsonCMiColumnObj.containsKey("questionid") &&
            !(jsonCMiColumnObj["questionid"] == null)) {
          int questionID = -1;
          try {
            questionID =
                int.parse(jsonCMiColumnObj["questionid"].toString());
          } catch (numberEx) {
            print('insertStudentResponsData failed: $numberEx');
            questionID = -1;
          }

          studentResponseModel.questionid = questionID;
        }
        // scoreraw
        if (jsonCMiColumnObj.containsKey("questionattempt") &&
            !(jsonCMiColumnObj["questionattempt"] == null)) {
          int questionattempts = int.parse(
              jsonCMiColumnObj["questionattempt"].toString());
          studentResponseModel.questionattempt = questionattempts;
        }
        // sequencenumber
        if (jsonCMiColumnObj.containsKey("optionalnotes")) {
          studentResponseModel.optionalNotes = jsonCMiColumnObj["optionalnotes"].toString();
        }

        // indexs
        if (jsonCMiColumnObj.containsKey("index")) {
          int indexs = int.parse(jsonCMiColumnObj["index"].toString());
          studentResponseModel.rindex = indexs;
        }

        // scoremax
        if (jsonCMiColumnObj.containsKey("capturedvidid")) {
          studentResponseModel.capturedVidId = jsonCMiColumnObj["capturedvidid"].toString();
        }
        // startdate
        if (jsonCMiColumnObj.containsKey("capturedvidfilename")) {
          studentResponseModel.capturedVidFileName = jsonCMiColumnObj["capturedvidfilename"].toString();
        }
        // datecompleted
        if (jsonCMiColumnObj.containsKey("capturedimgid")) {
          studentResponseModel.capturedImgId = jsonCMiColumnObj["capturedimgid"].toString();
        }
        // objecttypeid
        if (jsonCMiColumnObj.containsKey("capturedimgfilename")) {
          studentResponseModel.capturedImgFileName = jsonCMiColumnObj["capturedimgfilename"].toString();
        }
        // scoid
        if (jsonCMiColumnObj.containsKey("attemptdate")) {
          studentResponseModel.attemptdate = jsonCMiColumnObj["attemptdate"].toString();
        }
        studentResponseModel.siteId = learningModel.siteid.toString();
        // status
        if (jsonCMiColumnObj.containsKey("attachfileid") &&
            !(jsonCMiColumnObj["attachfileid"] == null)) {
          studentResponseModel.attachfileid = jsonCMiColumnObj["attachfileid"].toString();
        }

        // status
        if (jsonCMiColumnObj.containsKey("attachfilename") &&
            !(jsonCMiColumnObj["attachfilename"] == null)) {
          studentResponseModel.attachfilename = jsonCMiColumnObj["attachfilename"].toString();
        }
        // status
        if (jsonCMiColumnObj.containsKey("assessmentattempt") &&
            !(jsonCMiColumnObj["assessmentattempt"] == null)) {
          int numberAtmps = int.parse(
              jsonCMiColumnObj["assessmentattempt"].toString());
          studentResponseModel.assessmentattempt = numberAtmps;
        }
        injectIntoStudentResponseTable(studentResponseModel);
      }
    } catch (err) {
      print('insertStudentResponsData failed: $err');
    }
  }


  Future<void> injectIntoStudentResponseTable(
      StudentResponseModel studentResponseModel) async {
    try {
      String query = 'INSERT INTO $TBL_STUDENT_RESPONSES('
          'siteid,'
          'scoid,'
          'userid,'
          'questionid,'
          'assessmentattempt,'
          'questionattempt,'
          'attemptdate,'
          'studentresponses,'
          'result,'
          'attachfilename,'
          'attachfileid,'
          'rindex,'
          'attachedfilepath,'
          'optionalNotes,'
          'capturedVidFileName,'
          'capturedVidId,'
          'capturedVidFilepath,'
          'capturedImgFileName,'
          'capturedImgId,'
          'capturedImgFilepath'
          ')VALUES ('
          '\'${studentResponseModel.siteId}\','
          '\'${studentResponseModel.scoId}\','
          '\'${studentResponseModel.userId}\','
          '\'${studentResponseModel.questionid}\','
          '\'${studentResponseModel.assessmentattempt}\','
          '\'${studentResponseModel.questionattempt}\','
          '\'${studentResponseModel.attemptdate}\','
          '\'${studentResponseModel.studentresponses}\','
          '\'${studentResponseModel.result}\','
          '\'${studentResponseModel.attachfilename}\','
          '\'${studentResponseModel.attachfileid}\','
          '\'${studentResponseModel.rindex}\','
          '\'${studentResponseModel.attachfilename}\','
          '\'${studentResponseModel.optionalNotes}\','
          '\'${studentResponseModel.capturedImgFileName}\','
          '\'${studentResponseModel.capturedVidId}\','
          '\'${studentResponseModel.capturedVidFilepath}\','
          '\'${studentResponseModel.capturedImgFileName}\','
          '\'${studentResponseModel.capturedImgId}\','
          '\'${studentResponseModel.capturedImgFilepath}\')';
      await _database.rawQuery(query);
    } catch (err) {
      print('injectIntoStudentResponseTable failed $err');
    }
  }

  Future<void> insertLearnerSession(List<dynamic> jsonArray,
      DummyMyCatelogResponseTable2 learningModel) async {
    try {
      for (int i = 0; i < jsonArray.length; i++) {
        Map<dynamic, dynamic> jsonCMiColumnObj = jsonArray[i];
        print("injectINTCMI: $jsonCMiColumnObj");

        LearnerSessionModel learnerSessionTable = new LearnerSessionModel();


        learnerSessionTable.siteID = learningModel.siteid.toString();
        //userid
        if (jsonCMiColumnObj.containsKey("userid")) {
          learnerSessionTable.userID = jsonCMiColumnObj["userid"].toString();
        }
        // timespent
        if (jsonCMiColumnObj.containsKey("timespent")) {
          String string = jsonCMiColumnObj["timespent"].toString();
          learnerSessionTable.timeSpent =
          AppDirectory.isValidString(string) ? string : '0:00:00';
        }
        // sessionid
        if (jsonCMiColumnObj.containsKey("sessionid")) {
          learnerSessionTable.sessionID = jsonCMiColumnObj["sessionid"].toString();
        }
        // sessiondatetime
        if (jsonCMiColumnObj.containsKey("sessiondatetime")) {
          String s = jsonCMiColumnObj["sessiondatetime"].toUpperCase();
          if (!(s.toLowerCase() == "null")) {
            String dateStr = s.substring(0, 19);
            DateTime dateObj;
            try {
              dateObj = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').parse(dateStr);
              String strCreatedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(dateObj);
              learnerSessionTable.sessionDateTime = strCreatedDate;
            } catch (err) {
              print('insertLearnerSession failed: $err');
            }
          } else {
            learnerSessionTable.sessionDateTime = "";
          }
        }

        // scoID
        if (jsonCMiColumnObj.containsKey("scoid")) {
          learnerSessionTable.scoID = jsonCMiColumnObj["scoid"].toString();
        }

        // attemptnumber

        int attemptnumber = 0;
        if (jsonCMiColumnObj.containsKey("attemptnumber") &&
            !(jsonCMiColumnObj["attemptnumber"] == null)) {
          attemptnumber = jsonCMiColumnObj["attemptnumber"];

          learnerSessionTable.attemptNumber =  attemptnumber.toString();
        }

        if (attemptnumber == 1) {
          String startDate = "";
          if (AppDirectory.isValidString(learnerSessionTable.sessionDateTime)) {
            startDate = learnerSessionTable.sessionDateTime;
          }
          updateCMIStartDate(learnerSessionTable.scoID, startDate,
              learnerSessionTable.userID);
        }
        injectIntoLearnerTable(learnerSessionTable);
      }
    } catch (err) {
      print('insertLearnerSession failed $err');
    }
  }

  Future<void> injectIntoLearnerTable(LearnerSessionModel learnerSessionModel) async {
    try {
      String query = 'INSERT INTO $TBL_USER_SESSION('
          'userid,'
          'scoid,'
          'siteid,'
          'attemptnumber,'
          'sessiondatetime,'
          'timespent'
          ')VALUES('
          '\'${learnerSessionModel.userID}\','
          '\'${learnerSessionModel.scoID}\','
          '\'${learnerSessionModel.siteID}\','
          '\'${learnerSessionModel.attemptNumber}\','
          '\'${learnerSessionModel.sessionDateTime}\','
          '\'${learnerSessionModel.timeSpent}\''
          ')';
      await _database.rawQuery(query);
    }
    catch (err) {
      print('injectIntoLearnerTable failed $err');
    }
  }

  Future<void> injectIntoTrackObjectsTable(
      TrackObjectsModel trackObjModel) async {
    try {
      String query = 'INSERT INTO $TBL_TRACK_OBJECTS('
          'trackscoid,'
          'scoid,'
          'sequencenumber,'
          'siteid,'
          'userid,'
          'objecttypeid,'
          'name,'
          'mediatypeid'
          ')VALUES('
          '${trackObjModel.trackSoId},'
          '${trackObjModel.scoId},'
          '${trackObjModel.sequenceNumber},'
          '${trackObjModel.siteID},'
          '${trackObjModel.userID},'
          '${trackObjModel.objTypeId},'
          '${trackObjModel.name},'
          '${trackObjModel.mediaTypeId},'
          ')';

      await _database.rawQuery(query);
    } catch (err) {
      print('injectIntoTrackObjectsTable failed: $err');
    }
  }

  Future<void> injectIntoTrackTable(MyLearningModel trackListModel) async {
    try {
      String query = 'INSERT INTO $TBL_TRACKLIST_DATA('
          'username,'
          'siteid,'
          'userid,'
          'scoid,'
          'siteurl,'
          'sitename,'
          'contentid,'
          'coursename,'
          'author,'
          'shortdes,'
          'longdes,'
          'imagedata,'
          'medianame,'
          'createddate,'
          'startpage,'
          'eventstarttime,'
          'eventendtime,'
          'objecttypeid,'
          'locationname,'
          'timezone,'
          'participanturl,'
          'trackscoid,'
          'status,'
          'displaystatus,'
          'eventid,'
          'password,'
          'displayname,'
          'isdownloaded,'
          'courseattempts,'
          'eventcontentid,'
          'relatedcontentcount,'
          'mediatypeid,'
          'downloadurl,'
          'progress,'
          'presenter,'
          'eventaddedtocalender,'
          'joinurl,'
          'typeofevent,'
          'blockname,'
          'showstatus,'
          'parentid,'
          'timedelay,'
          'isdiscussion,'
          'sequencenumber,'
          'courseattempts,'
          'offlinepath,'
          'trackContentId,'
          'ruleid,'
          'stepid,'
          'wmessage,'
          'folderpath,'
          'jwvideokey,'
          'cloudmediaplayerkey,'
          'eventstartUtctime,'
          'eventendUtctime,'
          'contentTypeImagePath,'
          'activityid,'
          'bookmarkid,'
          'recordingmsg,'
          'eventrecording,'
          'recordingcontentid,'
          'recordingurl,'
          'objectfolderid'
          ')VALUES('
          '${trackListModel.userName},'
          '${trackListModel.siteID},'
          '${trackListModel.userID},'
          '${trackListModel.scoId},'
          '${trackListModel.siteURL},'
          '${trackListModel.siteName},'
          '${trackListModel.contentID},'
          '${trackListModel.courseName},'
          '${trackListModel.author},'
          '${trackListModel.shortDes},'
          '${trackListModel.longDes},'
          '${trackListModel.imageData},'
          '${trackListModel.mediaName},'
          '${trackListModel.createdDate},'
          '${trackListModel.startPage},'
          '${trackListModel.eventstartTime},'
          '${trackListModel.eventendTime},'
          '${trackListModel.objecttypeId},'
          '${trackListModel.locationName},'
          '${trackListModel.timeZone},'
          '${trackListModel.participantUrl},'
          '${trackListModel.trackScoid},'
          '${trackListModel.statusActual},'
          '${trackListModel.statusDisplay},'
          '${trackListModel.eventID},'
          '${trackListModel.password},'
          '${trackListModel.displayName},'
          '${trackListModel.isDownloaded},'
          '${trackListModel.courseAttempts},'
          'false,'
          '${trackListModel.relatedContentCount},'
          '${trackListModel.mediatypeId},'
          '${trackListModel.downloadURL},'
          '${trackListModel.progress},'
          '${trackListModel.presenter},'
          '${trackListModel.eventAddedToCalender},'
          '${trackListModel.joinurl},'
          '${trackListModel.typeofevent},'
          '${trackListModel.blockName},'
          '${trackListModel.showStatus},'
          '${trackListModel.parentID},'
          '${trackListModel.timeDelay},'
          '${trackListModel.isDiscussion},'
          '${trackListModel.sequenceNumber},'
          '${trackListModel.courseAttempts},'
          '${trackListModel.offlinepath},'
          '${trackListModel.trackOrRelatedContentID},'
          '0,'
          '0,'
          '\'\','
          '${trackListModel.folderPath},'
          '${trackListModel.jwvideokey},'
          '${trackListModel.cloudmediaplayerkey},'
          '${trackListModel.eventstartUtcTime},'
          '${trackListModel.eventendUtcTime},'
          '${trackListModel.contentTypeImagePath},'
          '${trackListModel.activityId},'
          '${trackListModel.bookmarkID},'
          '${trackListModel.recordingmsg},'
          '${trackListModel.eventrecording},'
          '${trackListModel.recordingcontentid},'
          '${trackListModel.recordingurl},'
          '${trackListModel.objectfolderid}'
          ')';

      await _database.rawQuery(query);
    } catch (err) {
      print('injectIntoTrackTable failed: $err');
    }
  }

  Future<bool> isContentExists(MyLearningModel learningModel, String tableName) async {
    bool isRecordExists = false;
    try {
      String strExeQuery = "SELECT * FROM " +
          tableName +
          " WHERE siteid= " +
          learningModel.siteID +
          " AND userid= " +
          learningModel.userID +
          " AND contentid = '" +
          learningModel.contentID +
          "' ";
      List<Map<String, dynamic>> data = await _database.rawQuery(strExeQuery);

      isRecordExists = data.isNotEmpty;
    } catch (err) {
      print('isContentExists failed: $err');
    }

    return isRecordExists;
  }

  Future<void> ejectRecordsInTable(String tableName) async {
    try {
      String strDelete = 'DELETE FROM $tableName';
      await _database.rawQuery(strDelete);
    } catch (err) {
      print('ejectRecordsinTable failed: $err');
    }
  }

  Future<void> ejectRecordsinCmi(
      DummyMyCatelogResponseTable2 learnerModel) async {
    try {
      String strDelete = "DELETE FROM " +
          TBL_CMI +
          " WHERE siteid= '" +
          learnerModel.siteid.toString() +
          "' AND scoid= '" +
          learnerModel.scoid.toString() +
          "' AND userid= '" +
          learnerModel.userid.toString() +
          "'";
//            String strDelete = "DELETE FROM " + TBL_CMI + " WHERE siteid= '" + learnerModel.getSiteID() +
//                    "' AND userid= '" + learnerModel.getUserID() + "'";
      await _database.rawQuery(strDelete);
    } catch (err) {
      print('ejectRecordsinCmi failed: $err');
    }

    if (learnerModel.objecttypeid.toString() == '10') {
      try {
        String strDelete = "DELETE FROM " +
            TBL_CMI +
            " WHERE siteid= '" +
            learnerModel.siteid.toString() +
            "' AND scoid= '" +
            learnerModel.scoid.toString() +
            "' AND userid= '" +
            learnerModel.userid.toString() +
            "'";
        await _database.rawQuery(strDelete);
      } catch (err) {
        print('ejectRecordsinCmi failed: $err');
      }
    }
  }

  Future<void> ejectRecordsinStudentResponse(
      DummyMyCatelogResponseTable2 learnerModel) async {
    try {
      String strDelete = "DELETE FROM " +
          TBL_STUDENT_RESPONSES +
          " WHERE siteid= '" +
          learnerModel.siteid.toString() +
          "' AND scoid= '" +
          learnerModel.scoid.toString() +
          "' AND userid= '" +
          learnerModel.userid.toString() +
          "'";
      await _database.rawQuery(strDelete);
    } catch (err) {
      print('ejectRecordsinStudentResponse failed: $err');
    }
  }

  Future<void> ejectRecordsinLearnerSession(
      DummyMyCatelogResponseTable2 learnerModel) async {
    try {
      String strDelete = "DELETE FROM " +
          TBL_USER_SESSION +
          " WHERE siteid= '" +
          learnerModel.siteid.toString() +
          "' AND scoid= '" +
          learnerModel.scoid.toString() +
          "' AND userid= '" +
          learnerModel.userid.toString() +
          "'";
      await _database.rawQuery(strDelete);
    } catch (err) {
      print('ejectRecordsinLearnerSession failed: $err');
    }
  }

  Future<void> ejectRecordsinTrackObjDb(DummyMyCatelogResponseTable2 learningModel) async {
    try {
      String strDelete = "DELETE FROM $TBL_TRACK_OBJECTS "
          "WHERE siteid= '${learningModel.siteid}' "
          "AND trackscoid= '${learningModel.scoid}' "
          "AND userid= '${learningModel.userid}'";
      await _database.rawQuery(strDelete);
    } catch (err) {
      print('ejectRecordsinTrackObjDb failed: $err');
    }
  }

  Future<void> ejectRecordsinTracklistTable(
      String siteID, String trackscoID, String userID, bool isTrackList) async {
    String TBL_NAME;
    if (!isTrackList) {
      TBL_NAME = TBL_RELATED_CONTENT_DATA;
    } else {
      TBL_NAME = TBL_TRACKLIST_DATA;
    }

    try {
      String strDelete = "DELETE FROM $TBL_NAME "
          "WHERE siteid= '$siteID' "
          "AND trackscoid= '$trackscoID' "
          "AND userid= '$userID'";
      await _database.rawQuery(strDelete);
    } catch (err) {
      print('ejectRecordsinTracklistTable failed: $err');
    }
  }

  Future<List<CMIModel>> getAllCmiDownloadDataDetails() async {
    List<CMIModel> cmiList = <CMIModel>[];

    try {
      String selQuery =
          "SELECT C.location, C.status, C.suspenddata, C.datecompleted, C.noofattempts, C.score,C.percentageCompleted, D.objecttypeid, "
              "C.sequencenumber, C.scoid, C.userid, C.siteid, D.courseattempts, D.contentid, C.coursemode, C.scoremin, C.scoreMax, "
              "C.randomQuesSeq, C.textResponses, C.ID, C.siteurl, C.pooledquesseq FROM " +
              TBL_CMI +
              " C inner join " +
              TBL_DOWNLOAD_DATA +
              " D On D.userid = C.userid and D.scoid = C.scoid and D.siteid = C.siteid WHERE C.isupdate = 'false' ORDER BY C.sequencenumber";
      List<Map<String, dynamic>> data = await _database.rawQuery(selQuery);

      if (data.length > 0) {
        for (Map<String, dynamic> item in data) {
          String objecttypeId = item['objecttypeid'];

          if (equalsIgnoreCase(objecttypeId, "10")) {
            continue;
          }

          CMIModel cmiDetails = new CMIModel();
          cmiDetails.scoId = item['scoid'];
          cmiDetails.location = item['location'];

          cmiDetails.status = item['status'];

          cmiDetails.suspenddata = item['suspenddata'];
          cmiDetails.Id = item['ID'];
          cmiDetails.siteId = item['siteid'].toString();
          cmiDetails.score = item['score'] ?? '';
          cmiDetails.objecttypeid = item['objecttypeid'];
          cmiDetails.seqNum = item['sequencenumber'].toString();
          cmiDetails.userId = item['userid'];
          cmiDetails.datecompleted = item['datecompleted'];
          cmiDetails.noofattempts = item['noofattempts'];

          cmiDetails.qusseq = item['randomquesseq'];
          cmiDetails.sitrurl = item['siteurl'];
          cmiDetails.textResponses = item['textResponses'];
          cmiDetails.pooledqusseq = item['pooledquesseq'] ?? '';

          cmiDetails.contentId = item['contentid'];

          cmiDetails.coursemode = item['coursemode'];

          cmiDetails.scoremin = item['scoremin'];

          cmiDetails.scoremax = item['scoremax'];

          cmiDetails.percentageCompleted = item['percentageCompleted'];

          cmiDetails.parentObjTypeId = "";
          cmiDetails.parentContentId = "";
          cmiDetails.parentScoId = "";

          cmiList.add(cmiDetails);
        }
      }
    } catch (err) {
      print('getAllCmiDownloadDataDetails failed: $err');
    }
    return cmiList;
  }

  Future<List<CMIModel>> getAllCmiTrackListDetails() async {
    List<CMIModel> cmiList = <CMIModel>[];

    try {
      String selQuery =
          "SELECT C.location, C.status, C.suspenddata, C.datecompleted, C.noofattempts, C.score,C.sequencenumber,C.percentageCompleted, "
              "C.scoid, C.userid, D.siteid, D.courseattempts, D.objecttypeid, D.contentid, D.trackContentId, D.trackscoid, C.coursemode, "
              "C.scoremin, C.scoreMax, C.randomQuesSeq, C.textResponses, C.ID, D.siteurl, C.pooledquesseq FROM " +
              TBL_CMI +
              " C inner join " +
              TBL_TRACKLIST_DATA +
              " D On D.userid = C.userid and D.scoid = C.scoid and D.siteid = C.siteid WHERE C.isupdate = 'false' ORDER BY C.sequencenumber ";

      List<Map<String, dynamic>> data = await _database.rawQuery(selQuery);
      if (data.length > 0) {
        for (Map<String, dynamic> item in data) {
          String objecttypeId = item['objecttypeid'].toString();

          if (equalsIgnoreCase(objecttypeId, "10")) {
            continue;
          }

          CMIModel cmiDetails = new CMIModel();
          cmiDetails.scoId = item['scoid'];
          cmiDetails.location = item['location'];
          cmiDetails.status = item['status'];

          cmiDetails.suspenddata = item['suspenddata'];
          cmiDetails.Id = item['ID'];
          cmiDetails.siteId = item['siteid'].toString();

          cmiDetails.score = item['score'] ?? '';
          cmiDetails.objecttypeid = item['objecttypeid'].toString();
          cmiDetails.seqNum = item['sequencenumber'].toString();
          cmiDetails.userId = item['userid'];
          cmiDetails.datecompleted = item['datecompleted'];

          cmiDetails.noofattempts = item['noofattempts'];
//                cmiDetails.set_noofattempts(cursor.getInt(cursor
//                        .getColumnIndex("attemptnumber")));
          cmiDetails.coursemode = item['coursemode'];
          cmiDetails.qusseq = item['randomquesseq'];
          cmiDetails.sitrurl = item['siteurl'];

          cmiDetails.textResponses = item['textResponses'];
          cmiDetails.pooledqusseq = item['pooledquesseq'] ?? '';

          cmiDetails.contentId = item['contentid'];

          cmiDetails.parentObjTypeId = '10';
          cmiDetails.parentContentId = item['trackContentId'];
          cmiDetails.parentScoId = item['trackscoid'];

          cmiDetails.percentageCompleted = item['percentageCompleted'];
          cmiList.add(cmiDetails);
        }
      }
    } catch (err) {
      print('getAllCmiTrackListDetails failed: $err');
    }

    return cmiList;
  }

  Future<List<CMIModel>> getAllCmiRelatedContentDetails() async {
    List<CMIModel> cmiList = <CMIModel>[];

    try {
      String selQuery =
          "SELECT C.location, C.status, C.suspenddata,C.percentageCompleted, C.datecompleted, C.noofattempts, C.score, D.objecttypeid, "
              "C.sequencenumber, C.scoid, C.userid, C.siteid, D.courseattempts, D.contentid, D.trackcontentid, D.trackscoid, C.coursemode, "
              "C.scoremin, C.scoreMax, C.randomQuesSeq, C.textResponses, C.ID, C.siteurl,C.pooledquesseq FROM " +
              TBL_CMI +
              " C inner join " +
              TBL_RELATED_CONTENT_DATA +
              " D On D.userid = C.userid and D.scoid = C.scoid and D.siteid = C.siteid WHERE C.isupdate = 'false' ORDER BY C.sequencenumber";

      List<Map<String, dynamic>> data = await _database.rawQuery(selQuery);
      if (data.length > 0) {
        for (Map<String, dynamic> item in data) {
          String objecttypeId = item['objecttypeid'];

          if (equalsIgnoreCase(objecttypeId, "10")) {
            continue;
          }

          CMIModel cmiDetails = new CMIModel();
          cmiDetails.scoId = int.parse(item['scoid']);
          cmiDetails.location = item['location'];

          cmiDetails.status = item['status'];
          cmiDetails.suspenddata = item['suspenddata'];
          cmiDetails.Id = int.parse(item['ID']);
          cmiDetails.siteId = item['siteid'];

          cmiDetails.score = item['score'];
          cmiDetails.objecttypeid = item['objecttypeid'];
          cmiDetails.seqNum = item['sequencenumber'];
          cmiDetails.userId = int.parse(item['userid']);
          cmiDetails.datecompleted = item['datecompleted'];
          cmiDetails.noofattempts = int.parse(item['noofattempts']);

          cmiDetails.coursemode = item['coursemode'];
          cmiDetails.qusseq = item['randomquesseq'];
          cmiDetails.sitrurl = item['siteurl'];
          cmiDetails.textResponses = item['textResponses'];
          cmiDetails.pooledqusseq = item['pooledquesseq'];

          cmiDetails.parentObjTypeId = '10';
          cmiDetails.parentContentId = item['trackContentId'];
          cmiDetails.parentScoId = item['trackscoid'];

          cmiDetails.percentageCompleted = item['percentageCompleted'];

          cmiList.add(cmiDetails);
        }
      }
    } catch (err) {
      print('getAllCmiRelatedContentDetails failed: $err');
    }

    return cmiList;
  }

  Future<List<LearnerSessionModel>> getAllSessionDetails(String userId, String siteId, String scoid) async {
    List<LearnerSessionModel> sessionList = <LearnerSessionModel>[];

    try {
      String selQuery =
          "SELECT sessionid,scoid,attemptnumber,sessiondatetime,timespent FROM USERSESSION WHERE userid=" +
              userId +
              " AND siteid=" +
              siteId +
              " AND scoid=" +
              scoid;

      List<Map<String, dynamic>> data = await _database.rawQuery(selQuery);
      if (data.length > 0) {
        for (Map<String, dynamic> item in data) {
          LearnerSessionModel sesDetails = new LearnerSessionModel();
          sesDetails.sessionID = item['sessionid'].toString();
          sesDetails.scoID = item['scoid'].toString();
          sesDetails.attemptNumber = item['attemptnumber'].toString();
          sesDetails.sessionDateTime = item['sessiondatetime'];
          sesDetails.timeSpent = item['timespent']?.toString() ?? "";
          sessionList.add(sesDetails);
        }
      }
    } catch (err) {
      print('getAllSessionDetails failed: $err');
    }

    return sessionList;
  }

  Future<List<StudentResponseModel>> getAllResponseDetails(String userId, String siteId, String scoId) async {
    List<StudentResponseModel> responseList = <StudentResponseModel>[];

    try {
      String selQuery =
          "SELECT scoid,questionid,assessmentattempt,questionattempt,attemptdate,studentresponses,result,attachfilename,attachfileid,"
              "attachedfilepath,optionalNotes,capturedVidFileName,capturedVidId,capturedVidFilepath,capturedImgFileName,capturedImgId,"
              "capturedImgFilepath FROM studentresponses WHERE userid=" +
              userId +
              " AND siteid=" +
              siteId +
              " AND scoid=" +
              scoId;

      List<Map<String, dynamic>> data = await _database.rawQuery(selQuery);
      if (data.length > 0) {
        for (Map<String, dynamic> item in data) {
          StudentResponseModel resDetails = new StudentResponseModel();
          resDetails.scoId = item['scoid'];
          resDetails.questionid = item['questionid'];

          resDetails.assessmentattempt = item['assessmentattempt'];
          resDetails.questionattempt = item['questionattempt'];
          resDetails.attemptdate = item['attemptdate'];
          resDetails.studentresponses = item['studentresponses'];
          resDetails.result = item['result'];
          resDetails.attachfilename = item['attachfilename'];
          resDetails.attachfileid = item['attachfileid'];
          resDetails.attachedfilepath = item['attachedfilepath'];
          resDetails.optionalNotes = item['optionalNotes'];

          resDetails.capturedVidFileName = item['capturedVidFileName'];
          resDetails.capturedVidId = item['capturedVidId'];
          resDetails.capturedVidFilepath = item['capturedVidFilepath'];

          resDetails.capturedImgFileName = item['capturedImgFileName'];
          resDetails.capturedImgId = item['capturedImgId'];
          resDetails.capturedImgFilepath = item['capturedImgFilepath'];

          responseList.add(resDetails);
        }
      }
    }
    catch (e) {
      print('getAllResponseDetails failed $e');
    }

    return responseList;
  }

  Future<void> insertCMiIsViewed(CMIModel learningModel) async {
    try {
      String strExeQuery = "UPDATE " +
          TBL_CMI +
          " SET isupdate = 'true'" +
          " WHERE siteid ='" +
          learningModel.siteId +
          "' AND userid ='" +
          learningModel.userId.toString() +
          "' AND scoid='" +
          learningModel.scoId.toString() +
          "'";

      await _database.rawQuery(strExeQuery);
    } catch (e) {
      print('insertCMiIsViewed failed: $e');
    }
  }

  Future<String> saveResponseCMI(
      MyLearningModel cmiNew, String getname, String getvalue) async {
    try {
      String strExeQuery = '';

      strExeQuery = 'UPDATE $TBL_CMI SET '
          '$getname = \'$getvalue\','
          ' isupdate= \'false\''
          ' WHERE scoid=${cmiNew.scoId}'
          ' AND siteid=${cmiNew.siteID}'
          ' AND userid=${cmiNew.userID}';
      MyPrint.printOnConsole("saveResponseCMI Query:$strExeQuery");
      await _database.rawQuery(strExeQuery);
      return "true";
    } catch (e) {
      print('saveResponseCMI query failed: $e');
      return "false";
    }
  }

  Future<String> getResponseCMI(MyLearningModel cmiNew, String getname) async {
    try {
      String strExeQuery = '';

      strExeQuery = 'SELECT $getname from $TBL_CMI'
          ' WHERE scoid=${cmiNew.scoId}'
          ' AND siteid=${cmiNew.siteID}'
          ' AND userid=${cmiNew.userID}';
      MyPrint.printOnConsole("getResponseCMI Query:$strExeQuery");

      List<Map<String, dynamic>> data = await _database.rawQuery(strExeQuery);

      String response = "true";

      if (data.length > 0) {
        for (Map<String, dynamic> item in data) {
          response = item[getname]?.toString() ?? "";
        }
      }

      return response;
    } catch (e) {
      print('getResponseCMI query failed: $e');
      return "false";
    }
  }

  Future<String> checkCMIWithGivenQueryElement(String queryElement, DummyMyCatelogResponseTable2 learningModel) async {
    String returnStr = "";

    try {

      String strExeQuery = "SELECT " + queryElement + " FROM cmi WHERE scoid= "
          + learningModel.scoid.toString()
          + " AND userid= "
          + learningModel.userid.toString()
          + " AND siteid= "
          + learningModel.siteid.toString();
      List<dynamic> data = await _database.rawQuery(strExeQuery);

      if (data.isNotEmpty) {
        int len = data.length - 1;
        returnStr = data[len][queryElement];
      }
    } catch (err) {
      MyPrint.printOnConsole('checkCMIWithGivenQueryElement failed: $err');
    }
    return returnStr;
  }

  Future<void> UpdateScormCMI(CMIModel cmiNew, String getname,
      String getvalue) async {
    try {
      String strExeQuery = "";
      if (getname.toLowerCase() == "timespent") {
        String pretime;
        strExeQuery =
            "SELECT timespent,noofattempts,objecttypeid FROM cmi WHERE scoid="
                + cmiNew.scoId.toString()
                + " AND userid="
                + cmiNew.userId.toString()
                + " AND siteid="
                + cmiNew.siteId;
        List<dynamic> data = await _database.rawQuery(strExeQuery);

        if (data.isNotEmpty) {
          if (AppDirectory.isValidString(data[0]["timespent"])) {
            pretime = data[0]["timespent"];

            if (AppDirectory.isValidString(getvalue)) {
              List<String> strSplitvalues = pretime.split(":");
              List<String> strSplitvalues1 = getvalue.split(":");
              if (strSplitvalues.length == 3
                  && strSplitvalues1.length == 3) {
                try {
                  int hours1 = (int
                      .parse(strSplitvalues[0]) + int
                      .parse(strSplitvalues1[0])) * 3600;
                  int mins1 = (int
                      .parse(strSplitvalues[1]) + int
                      .parse(strSplitvalues1[1])) * 60;
                  int secs1 = (double
                      .parse(strSplitvalues[2]) + double
                      .parse(strSplitvalues1[2])).round();
                  int totaltime = hours1 + mins1 + secs1;
                  int longVal = totaltime;
                  int hours = (longVal / 3600).round();
                  int remainder = (longVal - hours * 3600).round();
                  int mins = (remainder / 60).round();
                  remainder = remainder - mins * 60;
                  int secs = remainder;

                  // cmiNew.set_timespent(hours+":"+mins+":"+secs);
                  getvalue = "$hours:$mins:$secs";
                } catch (err) {
                  MyPrint.printOnConsole("UpdateScormCMI failed $err");
                }
              }
            }
          }
          Map<String, dynamic> obj = data[0] as Map<String, dynamic>;
          String key = (obj.keys.toList())[1];
          if (['8', '9'].contains(data[0][key])) {
            if (!AppDirectory.isValidString(cmiNew.score)) {

            } else {
              int intNoAtt = int.parse(data[0][key]);

              intNoAtt = intNoAtt + 1;
              strExeQuery = "UPDATE CMI SET noofattempts="
                  + intNoAtt.toString() + ", isupdate= 'false'"
                  + " WHERE scoid=" + cmiNew.scoId.toString()
                  + " AND siteid=" + cmiNew.siteId
                  + " AND userid=" + cmiNew.userId.toString();

              await _database.rawQuery(strExeQuery);
            }
          }
        }
      }

      strExeQuery = "UPDATE CMI SET " + getname + "='" + getvalue + "'"
          + ", isupdate= 'false'" + " WHERE scoid="
          + cmiNew.scoId.toString() + " AND siteid=" + cmiNew.siteId
          + " AND userid=" + cmiNew.userId.toString();

      await _database.rawQuery(strExeQuery);
    } catch (err) {
      MyPrint.printOnConsole("UpdateScormCMI failed $err");
    }
  }

  Future<int> updateContentStatusFromLRSInterface(
      MyLearningModel myLearningModel, String percantageCompleted) async {
    int status = -1;
    try {
      String strUpdate = 'UPDATE $TBL_DOWNLOAD_DATA SET '
          'percentcompleted = \'$percantageCompleted\', '
          'progress = \'$percantageCompleted\' '
          'WHERE siteid = \'${myLearningModel.siteID}\' AND '
          'scoid= \'${myLearningModel.scoId}\' AND '
          'userid=\'${myLearningModel.userID}\'';
      await _database.rawQuery(strUpdate);
      status = 1;
    } catch (e) {
      status = -1;
      print('updateContentStatus query failed: $e');
    }

    return status;
  }

  Future<int> updateContentStatusInTrackListLRS(MyLearningModel myLearningModel,
      String updatedStatus, bool isEventList) async {
    int status = -1;
    String TBL_TYPE = TBL_TRACKLIST_DATA;

    if (isEventList) {
      TBL_TYPE = TBL_RELATED_CONTENT_DATA;
    }

    try {
      String strUpdate = 'UPDATE $TBL_TYPE SET '
          'progress = \'$updatedStatus\' '
          'WHERE siteid =\'${myLearningModel.siteID}\' AND '
          'scoid=\'${myLearningModel.scoId}\' AND '
          'userid=\'${myLearningModel.userID}\'';
      await _database.rawQuery(strUpdate);
      status = 1;
    } catch (e) {
      status = -1;
      print('updateContentStatusInTrackListLRS query 1 failed $e');
    }

    try {
      String status = 'In progress';
      if (updatedStatus.toLowerCase().contains("failed")) {
        status = 'failed';
      } else if (updatedStatus.toLowerCase().contains("passed")) {
        status = 'passed';
      } else if (updatedStatus.toLowerCase().contains("completed")) {
        status = 'completed';
      }
      String strUpdate = 'UPDATE $TBL_CMI SET '
          'status = \'$status\' '
          'WHERE siteid =\'${myLearningModel.siteID}\' AND '
          'scoid=\'${myLearningModel.scoId}\' AND '
          'userid=\'${myLearningModel.userID}\'';
      await _database.rawQuery(strUpdate);
    } catch (e) {
      print('updateContentStatusInTrackListLRS query 2 failed $e');
    }

    return status;
  }

  Future<String> savePercentCompletedInCMI(
      MyLearningModel cmiNew, String progressValue) async {
    bool isRecordExists = await isCMIRecordExists(cmiNew);
    try {
      String strExeQuery = "";
      if (isRecordExists) {
        strExeQuery = 'UPDATE CMI SET '
            'percentageCompleted = \'$progressValue\', '
            'isupdate= \'false\' '
            'WHERE scoid=\'${cmiNew.scoId}\' AND '
            'siteid=\'${cmiNew.siteID}\' AND '
            'userid=\'${cmiNew.userID}\'';
      } else {
        strExeQuery = "INSERT INTO " +
            TBL_CMI +
            "(siteid,scoid,userid,location,status,suspenddata,objecttypeid,datecompleted,noofattempts,percentageCompleted,sequencenumber,"
                "isupdate,startdate,timespent,coursemode,scoremin,scoremax,randomquesseq,siteurl,textResponses)" +
            " VALUES (" +
            cmiNew.siteID +
            "," +
            cmiNew.scoId +
            "," +
            cmiNew.userID +
            ",'" +
            "" +
            "','" +
            "incomplete" +
            "','" +
            "" +
            "','" +
            cmiNew.objecttypeId +
            "','" +
            "" +
            "'," +
            "1" +
            ",'" +
            progressValue +
            "','" +
            cmiNew.sequenceNumber.toString() +
            "','" +
            "false" +
            "','" +
            cmiNew.startDate +
            "','" +
            "" +
            "','" +
            "" +
            "','" +
            "" +
            "','" +
            "" +
            "','" +
            "" +
            "','" +
            cmiNew.siteURL +
            "','" +
            "" +
            "')";
      }
      await _database.rawQuery(strExeQuery);
    } catch (e) {
      print("savePercentCompletedInCMI failed: $e");
    }

    return "true";
  }

  Future<bool> isCMIRecordExists(MyLearningModel learningModel) async {
    bool isRecordExists = false;
    try {
      String strExeQuery = 'SELECT * FROM $TBL_CMI '
          'WHERE siteid= \'${learningModel.siteID}\' AND '
          'userid= \'${learningModel.userID}\' AND '
          'scoid = \'${learningModel.scoId}\'';
      List data = await _database.rawQuery(strExeQuery);

      isRecordExists = data.length > 0;
    } catch (e) {
      print('isCMIRecordExists query failed: $e');
    }

    return isRecordExists;
  }

  Future<void> updateCMIStartDate(String scoID, String startDate, String userID) async {
    try {
      String siteId = await sharePrefGetString(sharedPref_siteid);
      String strUpdate = "UPDATE $TBL_CMI SET "
          "startdate = '$startDate' "
          "WHERE scoid = $scoID and "
          "userid = $userID and "
          "siteid =$siteId";
      _database.rawQuery(strUpdate);
    } catch (err) {
      print('updateCMIStartDate failed $err');
    }
  }

  Future<String> saveQuestionDataWithQuestionDataMethod(MyLearningModel learningModel, String questionData, String seqID) async {
    try {
      String externalDirectory = await AppDirectory.getDocumentsDirectory();
      String uploadfilepath = '$externalDirectory/.Mydownloads';
      String strTempUploadPath = uploadfilepath.substring(1, uploadfilepath.lastIndexOf("/")) + "/Offline_Attachments";

      String tempStr = questionData.replaceAll("undefined", "");
      List<String> quesAry = tempStr.split("@");
      String scoID = learningModel.scoId;

      int assessmentAttempt = await getAssessmentAttempt(learningModel, "false");

      String objecTypeId = "";

      if (quesAry.length > 3) {
        if (equalsIgnoreCase(learningModel.objecttypeId, "10") && seqID.length != 0) {
          List<String> objectTypeIDScoid = await getTrackObjectTypeIDAndScoidBasedOnSequenceNumber(
            learningModel.scoId,
            seqID,
            learningModel.siteID,
            learningModel.userID,
          );

          if (objectTypeIDScoid.length > 1) {
            scoID = objectTypeIDScoid[0];
            objecTypeId = objectTypeIDScoid[1];
          }
        } else {
          objecTypeId = learningModel.objecttypeId;
        }
        StudentResponseModel studentResponse = StudentResponseModel();
        studentResponse.scoId = int.parse(scoID);
        studentResponse.siteId = learningModel.siteID;
        studentResponse.userId = int.parse(learningModel.userID);

        studentResponse.studentresponses = quesAry[2];
        studentResponse.result = quesAry[3];
        studentResponse.assessmentattempt = assessmentAttempt;
        String formattedDate = getCurrentDateTime();
        studentResponse.attemptdate = formattedDate;

        if (equalsIgnoreCase(objecTypeId, "8")) {
          studentResponse.questionid = int.parse(quesAry[0]) + 1;
        } else {
          studentResponse.questionid = int.parse(quesAry[0]);
        }

        if (quesAry.length > 4) {
          String tempOptionalNotes = quesAry[4];

          if (tempOptionalNotes.contains("^notes^")) {
            tempOptionalNotes = tempOptionalNotes.replaceAll("^notes^", "");
            studentResponse.optionalNotes = tempOptionalNotes;
          } else {
            if (quesAry.length > 5) {
              studentResponse.attachfilename = quesAry[4];
              studentResponse.attachfileid = quesAry[5];
              String strManyDirectories = strTempUploadPath.substring(
                      1, strTempUploadPath.lastIndexOf("/")) +
                  "/Offline_Attachments/";
              studentResponse.attachedfilepath =
                  strManyDirectories + quesAry[5];
            }
          }

          if (quesAry.length > 6) {
            if (quesAry[6].length == 0 && quesAry[6] == "undefined") {
              studentResponse.capturedVidFileName = "";
              studentResponse.capturedVidId = "";
              studentResponse.capturedVidFilepath = "";
            }

            studentResponse.capturedVidFileName = quesAry[6];
            studentResponse.capturedVidId = quesAry[7];
            String strManyDirectories = strTempUploadPath.substring(
                    1, strTempUploadPath.lastIndexOf("/")) +
                "/mediaresource/mediacapture/";
            studentResponse.capturedVidFilepath =
                strManyDirectories + quesAry[7];
          }

          if (quesAry.length > 8) {
            if (quesAry[8].length == 0 || quesAry[8] == "undefined") {
              studentResponse.capturedImgFileName = "";
              studentResponse.capturedImgId = "";
              studentResponse.capturedImgFilepath = "";
            }

            studentResponse.capturedImgFileName = quesAry[8];
            studentResponse.capturedImgId = quesAry[9];
            String strManyDirectories = strTempUploadPath.substring(
                    1, strTempUploadPath.lastIndexOf("/")) +
                "/mediaresource/mediacapture/";
            studentResponse.capturedImgFilepath =
                strManyDirectories + quesAry[9];
          }
        } else {
          studentResponse.attachfilename = "";
          studentResponse.attachfileid = "";
          studentResponse.attachedfilepath = "";
          studentResponse.rindex = 0;
          studentResponse.optionalNotes = "";

          studentResponse.capturedVidFileName = "";
          studentResponse.capturedVidId = "";

          studentResponse.capturedImgFileName = "";
          studentResponse.capturedImgId = "";
          studentResponse.capturedImgFilepath = "";
        }
        insertStudentResponses(studentResponse);
      }

      return "true";
    } catch (e) {
      print('SaveQuestionDataWithQuestionDataMethod failed: $e');
      return 'false';
    }
  }

  Future<int> getAssessmentAttempt(
      MyLearningModel learningModel, String reTake) async {
    int attempt = 1;
    try {
      String strSelQuery = "SELECT noofattempts FROM cmi  WHERE siteid=" +
          learningModel.siteID +
          " AND scoid=" +
          learningModel.scoId +
          " AND userid=" +
          learningModel.userID;
      List<dynamic> data = await _database.rawQuery(strSelQuery);
      if (data.length > 0) {
        attempt = data[0]['noofattempts'];
        if (attempt == 0) attempt = attempt + 1;

        if (reTake == "true") {
          String strDelQuery = "DELETE FROM STUDENTRESPONSES WHERE siteid=" +
              learningModel.siteID +
              " AND scoid=" +
              learningModel.scoId +
              " AND userid=" +
              learningModel.userID;
          _database.rawQuery(strDelQuery);
          attempt = 1;
        }
      }
    } catch (e) {
      print('Getassessmentattempt failed: $e');
    }
    return attempt;
  }

  Future<List<String>> getTrackObjectTypeIDAndScoidBasedOnSequenceNumber(
      String trackScoId, String seqNumber, String siteID, String userID) async {
    List<String> strAry = [];

    String sqlQuery = "SELECT scoid, objecttypeid FROM " +
        TBL_TRACK_OBJECTS +
        " WHERE siteid = " +
        siteID +
        " AND trackscoid = " +
        trackScoId +
        " AND sequencenumber = " +
        seqNumber +
        " AND userid = " +
        userID;

    List data = await _database.rawQuery(sqlQuery);

    try {
      if (data.length > 0) {
        for (dynamic item in data) {
          strAry.add(item['scoid']);
          strAry.add(item['objecttypeid']);
        }
      }
    } catch (e) {
      strAry = ['', ''];
      print('getTrackObjectTypeIDAndScoidBasedOnSequenceNumber failed: $e');
    }
    return strAry;
  }

  void insertStudentResponses(StudentResponseModel resDetails) async {
    if (!AppDirectory.isValidString(resDetails.attachfilename)) {
      resDetails.attachfileid = "";
      resDetails.attachfilename = "";
      resDetails.attachedfilepath = "";
    }

    if (!AppDirectory.isValidString(resDetails.optionalNotes)) {
      resDetails.optionalNotes = "";
    }

    if (!AppDirectory.isValidString(resDetails.capturedVidFileName)) {
      resDetails.capturedVidFileName = "";
      resDetails.capturedVidId = "";
      resDetails.capturedVidFilepath = "";
    }

    if (!AppDirectory.isValidString(resDetails.capturedImgFileName)) {
      resDetails.capturedImgFileName = "";
      resDetails.capturedImgId = "";
      resDetails.capturedImgFilepath = "";
    }

    bool isStudentResExist = false;

    try {
      String query1 =
          "SELECT MAX(AssessmentAttempt) AS assessmentnumber from studentresponses WHERE scoid=" +
              resDetails.scoId.toString() +
              " and userid=" +
              resDetails.userId.toString() +
              " and questionid=" +
              resDetails.questionid.toString() +
              " and siteid=" +
              resDetails.siteId;
      List<Map<String, dynamic>> data = await _database.rawQuery(query1);

      int assesmentNumber = 1;
      int quesAttempt = 1;

      if (data.length > 0) {
        String key1 = data.first.keys.first;
        if (data.first['$key1'] != null) {
          assesmentNumber = data.first['$key1'];
          print('insertStudentResponses assesmentNumber $assesmentNumber');
        }
      }

      String query2 = "SELECT QUESTIONID FROM studentresponses WHERE scoid=" +
          resDetails.scoId.toString() +
          " and userid=" +
          resDetails.userId.toString() +
          " and questionid=" +
          resDetails.questionid.toString() +
          " and siteid=" +
          resDetails.siteId +
          " and AssessmentAttempt=" +
          assesmentNumber.toString();

      List<Map<String, dynamic>> data2 = await _database.rawQuery(query2);

      if (data2.length > 0) {
        isStudentResExist = true;
      }

      String query3 = "";
      if (isStudentResExist) {
        query3 = "UPDATE studentresponses SET studentresponses ='" +
            resDetails.studentresponses +
            "',result='" +
            resDetails.result +
            "',attachfilename= '" +
            resDetails.attachfilename +
            "',attachfileid='" +
            resDetails.attachfileid +
            "' ,attachedfilepath='" +
            resDetails.attachedfilepath +
            "' ,optionalNotes='" +
            resDetails.optionalNotes +
            "' ,capturedVidFileName ='" +
            resDetails.capturedVidFileName +
            "' ,capturedVidId ='" +
            resDetails.capturedVidId +
            "' ,capturedVidFilepath ='" +
            resDetails.capturedVidFilepath +
            "' ,capturedImgFileName ='" +
            resDetails.capturedImgFileName +
            "' ,capturedImgId ='" +
            resDetails.capturedImgId +
            "' ,capturedImgFilepath ='" +
            resDetails.capturedImgFilepath +
            "' where scoid=" +
            resDetails.scoId.toString() +
            " and userid=" +
            resDetails.userId.toString() +
            " and questionid=" +
            resDetails.questionid.toString() +
            " and siteid=" +
            resDetails.siteId +
            " and assessmentattempt=" +
            assesmentNumber.toString();
      } else {
        query3 =
            "INSERT INTO STUDENTRESPONSES(siteid,scoid,userid,questionid,assessmentattempt,questionattempt,attemptdate,studentresponses,"
                "result,attachfilename,attachfileid,attachedfilepath,optionalNotes,capturedVidFileName,capturedVidId,capturedVidFilepath,"
                "capturedImgFileName,capturedImgId,capturedImgFilepath)" +
                " values (" +
                resDetails.siteId +
                "," +
                resDetails.scoId.toString() +
                "," +
                resDetails.userId.toString() +
                "," +
                resDetails.questionid.toString() +
                "," +
                assesmentNumber.toString() +
                "," +
                quesAttempt.toString() +
                ",'" +
                resDetails.attemptdate +
                "','" +
                resDetails.studentresponses +
                "','" +
                resDetails.result +
                "','" +
                resDetails.attachfilename +
                "','" +
                resDetails.attachfileid +
                "','" +
                resDetails.attachedfilepath +
                "','" +
                resDetails.optionalNotes +
                "','" +
                resDetails.capturedVidFileName +
                "','" +
                resDetails.capturedVidId +
                "','" +
                resDetails.capturedVidFilepath +
                "','" +
                resDetails.capturedImgFileName +
                "','" +
                resDetails.capturedImgId +
                "','" +
                resDetails.capturedImgFilepath +
                "')";
      }
      await _database.rawQuery(query3);
    } catch (e) {
      print('insertStudentResponses failed $e');
    }
  }

  Future<String> getTrackObjectList(MyLearningModel mylearningModel,
      String lStatusValue, String susData, String cmiSeqNumber) async {
    String query = "";
    String locationValue = "";
    String statusValue = "";
    String suspendDataValue = "";
    String question = "";
    String tempSeqNo = "";

    String sqlQuery =
        "SELECT C.status,C.suspenddata,C.location,T.sequencenumber FROM CMI C inner join " +
            TBL_TRACK_OBJECTS +
            " T on C.scoid=T.scoid AND C.userid=T.userid WHERE C.siteid =" +
            mylearningModel.siteID.toString() +
            " AND C.userid = " +
            mylearningModel.userID.toString() +
            " AND T.TrackSCOID =" +
            mylearningModel.scoId.toString() +
            " order by T.SequenceNumber ";
    try {
      List<Map<String, dynamic>> data = await _database.rawQuery(sqlQuery);

      if (data.length > 0) {
        for (Map<String, dynamic> item in data) {
          String status = "";
          String suspendData = "";
          String location = "";
          String sequenceNo = "";

          status = item['status'];
          suspendData = item['suspenddata'];
          location = item['location'];
          sequenceNo = item['sequencenumber'];

          if (!equalsIgnoreCase(statusValue, "null") &&
              statusValue.isNotEmpty) {
            statusValue = statusValue + "@" + status + "\$" + sequenceNo;
          } else {
            statusValue = status + "\$" + sequenceNo;
          }

          if (!equalsIgnoreCase(suspendDataValue, "null") &&
              suspendDataValue.isNotEmpty) {
            suspendDataValue =
                suspendDataValue + "@" + suspendData + "\$" + sequenceNo;
          } else {
            suspendDataValue = suspendData + "\$" + sequenceNo;
          }

          if (!equalsIgnoreCase(locationValue, "null") &&
              locationValue.isNotEmpty) {
            locationValue = locationValue + "@" + location + "\$" + sequenceNo;
          } else {
            locationValue = location + "\$" + sequenceNo;
          }
        }
      }
    } catch (e) {
      print('getTrackObjectList failed: $e');
    }

    try {
      String sqlQuery =
          "select S.QUESTIONID,S.StudentResponses,S.result,S.attachfilename,S.attachfileid,T.Sequencenumber,S.OptionalNotes,"
              "S.capturedVidFileName,S.capturedVidId,S.capturedImgFileName,S.capturedImgId from " +
              TBL_STUDENT_RESPONSES +
              " S inner join " +
              TBL_TRACK_OBJECTS +
              " T on S.scoid=T.scoid AND S.userid=T.userid WHERE S.SITEID =" +
              mylearningModel.siteID.toString() +
              " AND S.USERID =" +
              mylearningModel.userID.toString() +
              " AND T.TrackSCOID = " +
              mylearningModel.scoId.toString() +
              " AND S.assessmentattempt = (select max(assessmentattempt) from " +
              TBL_STUDENT_RESPONSES +
              " where scoid= T.scoid) order by T.SequenceNumber";

      List<Map<String, dynamic>> data = await _database.rawQuery(sqlQuery);

      if (data.length > 0) {
        for (Map<String, dynamic> item in data) {
          if (question.length != 0) {
            question = question + "\$";
          }

          String sqNO = "";
          String seqNo = item['sequencenumber'];

          if (!equalsIgnoreCase(seqNo, "null") && seqNo.isNotEmpty) {
            sqNO = seqNo;
          }

          if (!tempSeqNo.toLowerCase().contains(sqNO)) {
            if (!equalsIgnoreCase(question, "null") && question.isNotEmpty) {
              question = question + "~";
            }
            tempSeqNo = seqNo;
            question = question + seqNo + "-";
          }

          String questionID = item['questionid'];

          if (!equalsIgnoreCase(questionID, "null") && !questionID.isNotEmpty) {
            question = question + questionID;
            question = question + "@";
          }

          String studentResponse = "";
          String studentresp = item['studentresponses'];

          if (!equalsIgnoreCase(studentresp, "null") &&
              studentresp.isNotEmpty) {
            if ((equalsIgnoreCase(studentresp.toLowerCase(), "undefined")) ||
                equalsIgnoreCase(studentResponse, "null")) {
              studentResponse = "";
            } else {
              studentResponse = studentresp;
            }
          }
          question = question + studentResponse;
          question = question + "@";

          String result = item['result'];

          if (!equalsIgnoreCase(result, "null") && result.isNotEmpty) {
            question = question + result;
            question = question + "@";
          }

          String attachFile = item['attachfilename'];

          if (!equalsIgnoreCase(attachFile, "null") && attachFile.isNotEmpty) {
            question = question + attachFile;
            question = question + "@";
          }

          String attachFileID = item['attachfileid'];

          if (!equalsIgnoreCase(attachFileID, "null") &&
              attachFileID.isNotEmpty) {
            question = question + attachFileID;
            question = question + "@";
          }

          String optionalNotes = item['optionalNotes'];

          if (!equalsIgnoreCase(optionalNotes, "null") &&
              optionalNotes.isNotEmpty) {
            question = question + optionalNotes;
            question = question + "@";
          }

          String capturedVidFileName = item['capturedVidFileName'];

          if (!equalsIgnoreCase(capturedVidFileName, "null") &&
              capturedVidFileName.isNotEmpty) {
            question = question + capturedVidFileName;
            question = question + "@";
          }

          String capturedVidID = item['capturedVidId'];

          if (!equalsIgnoreCase(capturedVidID, "null") &&
              capturedVidID.isNotEmpty) {
            question = question + capturedVidID;
            question = question + "@";
          }

          String capturedImgFileName = item['capturedImgFileName'];

          if (!equalsIgnoreCase(capturedImgFileName, "null") &&
              capturedImgFileName.isNotEmpty) {
            question = question + capturedImgFileName;
            question = question + "@";
          }

          String capturedImgID = item['capturedImgId'];

          if (!equalsIgnoreCase(capturedImgID, "null") &&
              capturedImgID.isNotEmpty) {
            question = question + capturedImgID;
            question = question + "@";
          }
        }
      }
    } catch (e) {
      print('');
    }

    print('getTrackObjectList: $question');
    question = question.replaceAll("%25", "%");

    print('getTrackObjectList: $suspendDataValue');

    String displayName = mylearningModel.userName;

    String replaceString = displayName.replaceAll(" ", "%20");

    query = "?nativeappURL=true&cid=" +
        mylearningModel.scoId.toString() +
        "&stid=" +
        mylearningModel.userID +
        "&lloc=" +
        locationValue +
        "&lstatus=" +
        lStatusValue +
        "&susdata=" +
        susData +
        "&tbookmark=" +
        cmiSeqNumber +
        "&LtSusdata=" +
        suspendDataValue +
        "&LtQuesData=" +
        question +
        "&LtStatus=" +
        statusValue +
        "&sname=" +
        replaceString;

    query = query.replaceAll("null", "");

    String replaceStr = query.replaceAll(" ", "%20");
    return replaceStr;
  }

  Future<int> getLatestAttempt(String scoId, String userId, String siteID) async {
    String sqlQuery = "SELECT count(sessionid) as attemptscount FROM " +
        TBL_USER_SESSION +
        " WHERE siteid = " +
        siteID +
        " AND scoid = '" +
        scoId +
        "' AND userid = " +
        userId;

    List<Map<String, dynamic>> userSessionData = await _database.rawQuery(sqlQuery);

    int numberOfAttemptsInt = 0;
    try {
      if (userSessionData.isNotEmpty) {
        for (Map<String, dynamic> item in userSessionData) {
          String counts = item['attemptscount'];
          numberOfAttemptsInt = int.parse(counts);
        }
      }
    }
    catch (e) {
      print('getLatestAttempt failed: $e');
    }

    return numberOfAttemptsInt + 1;
  }

  Future<void> insertUserSession(LearnerSessionModel sessionDetails) async {
    String strExeQuery = "";
    if(sessionDetails.timeSpent.isEmpty) {
      sessionDetails.timeSpent = "00:00:00";
    }
    try {
      strExeQuery = "SELECT * FROM " +
          TBL_USER_SESSION +
          " WHERE scoid=" +
          sessionDetails.scoID +
          " AND userid=" +
          sessionDetails.userID +
          " AND attemptnumber=" +
          sessionDetails.attemptNumber +
          " AND siteid=" +
          sessionDetails.siteID;
      List<Map<String, dynamic>> data = await _database.rawQuery(strExeQuery);

      if (data.isNotEmpty) {
        try {
          strExeQuery = "UPDATE " +
              TBL_USER_SESSION +
              " SET timespent='" +
              sessionDetails.timeSpent +
              "' WHERE scoid=" +
              sessionDetails.scoID +
              " AND siteid=" +
              sessionDetails.siteID +
              " AND userid=" +
              sessionDetails.userID +
              " AND attemptnumber=" +
              sessionDetails.attemptNumber;
          await _database.execute(strExeQuery);
        }
        catch (e) {
          print("InsertUserSession failed: $e");
        }
      }
      else {
        try {
          strExeQuery = "INSERT INTO " +
              TBL_USER_SESSION +
              "(siteid,scoid,userid,attemptnumber,sessiondatetime,timespent)" +
              " VALUES (" +
              sessionDetails.siteID +
              "," +
              sessionDetails.scoID +
              "," +
              sessionDetails.userID +
              "," +
              sessionDetails.attemptNumber +
              ",'" +
              sessionDetails.sessionDateTime +
              "','${sessionDetails.timeSpent}')";
          await _database.execute(strExeQuery);
        }
        catch (e) {
          print("InsertUserSession failed: $e");
        }
      }
    }
    catch (e) {
      print("InsertUserSession failed: $e");
    }
  }

  Future<void> setCompleteMethods(
      MyLearningModel model, Map<String, String> queryParams) async {
    try {
      await insertCMI(model, {"suspenddata" : queryParams['susdata']!});
    } catch (e) {
      print('setCompleteMethods failed $e');
    }
  }

  Future<void> insertCMI(MyLearningModel model, Map<String, String> data) async {
    try {
      String updateKeyValues = "";
      data.forEach((key, value) {
        updateKeyValues += "$key='$value',";
      });
      if(updateKeyValues.isNotEmpty) {
        updateKeyValues = updateKeyValues.substring(0, updateKeyValues.length - 1);
      }

      String strExeQuery = "UPDATE " +
          TBL_CMI +
          " SET " +
          updateKeyValues +
          " WHERE scoid=" +
          model.scoId +
          " AND siteid=" +
          model.siteID +
          " AND userid=" +
          model.userID;

      await _database.rawQuery(strExeQuery);
    }
    catch (e) {
      print('insertCMI failed: $e');
    }
  }

  Future<void> updateCMIstatus(DummyMyCatelogResponseTable2 table2, String updatedStatus, int progressValue) async {
    try {
      MyLearningModel cmiNew = MyLearningModel();
      cmiNew.siteID = table2.siteid.toString();
      cmiNew.scoId = table2.scoid.toString();
      cmiNew.userID = table2.userid.toString();
      bool isRecordExists = await isCMIRecordExists(cmiNew);
      String query = '';
      if(!isRecordExists) {
        query = "INSERT INTO " +
            TBL_CMI +
            "(siteid,scoid,userid,location,status,suspenddata,objecttypeid,datecompleted,noofattempts,percentageCompleted,sequencenumber,"
                "isupdate,startdate,timespent,coursemode,scoremin,scoremax,randomquesseq,siteurl,textResponses)" +
            " VALUES (" +
            table2.siteid.toString() +
            "," +
            table2.scoid.toString() +
            "," +
            table2.userid.toString() +
            ",'" +
            "" +
            "','" +
            updatedStatus +
            "','" +
            "" +
            "','" +
            table2.objecttypeid.toString() +
            "','" +
            table2.datecompleted +
            "'," +
            "1" +
            ",'" +
            progressValue.toString() +
            "','" +
            "0" +
            "','" +
            "false" +
            "','" +
            table2.startdate +
            "','" +
            "" +
            "','" +
            "" +
            "','" +
            "" +
            "','" +
            "" +
            "','" +
            "" +
            "','" +
            table2.siteurl +
            "','" +
            "" +
            "')";
      } else {
        query = "UPDATE $TBL_CMI SET " +
            "status = '" + updatedStatus + "', isupdate= 'false', " +
            "datecompleted = '${table2.datecompleted}' "
            "WHERE siteid='${table2.siteid}' " +
            "AND scoid=" + "'${table2.scoid}' " +
            "AND userid=" + "'${table2.userid}'";
      }
      await _database.rawQuery(query);

    } catch (err) {
      print('updateCMIstatus failed: $err');
    }
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }


  //region Workflow Rules Related Methods
  Future<String> getTrackTemplateWorkflowResults(String trackID, MyLearningModel learningModel) async {
    String returnStr = "";

    String selQuery = "SELECT trackContentId, userid, showstatus, ruleid, stepid, contentid, wmessage FROM " + TBL_TRACKLIST_DATA + " WHERE trackContentId = '" + trackID + "' AND userid = '" + learningModel.userID + "' AND siteid = '" + learningModel.siteID + "'";

    List<Map<String, dynamic>> userSessionData = await _database.rawQuery(selQuery);

    List<Map<String, dynamic>> jsonArray = <Map<String, dynamic>>[];

    for(Map<String, dynamic> map in userSessionData) {
      String ruleID = map['ruleid']?.toString() ?? "";

      if (ruleID == "0") {
        break;
      }

      Map<String, dynamic> trackObj = <String, dynamic>{};
      try {

        trackObj["userid"] = map["userid"];
        trackObj["trackcontentid"] = map["trackContentId"];
        trackObj["trackobjectid"] = map["contentid"];
        trackObj["result"] = map["showstatus"];
        trackObj["wmessage"] = map["wmessage"];
        trackObj["ruleid"] = ruleID;
        trackObj["stepid"] = map["stepid"];
        jsonArray.add(trackObj);

      }
      catch (e, s) {
        MyPrint.printOnConsole("Error in getTrackTemplateWorkflowResults:$e");
        MyPrint.printOnConsole(s);
      }
    }

    if (jsonArray.isEmpty) {
      returnStr = "";
    }
    else {
      returnStr = jsonArray.toString();
    }

    return returnStr;
  }

  Future<void> updateWorkFlowRulesInDBForTrackTemplate(String trackID, String trackItemID, String trackItemState, String wmessage, String ruleID, String stepID, String siteID, String userID) async {

    try {
      String sqlQuery = "UPDATE " + TBL_TRACKLIST_DATA + " SET showstatus = '" + trackItemState + "' , ruleid = '" + ruleID + "' , stepid = '" + stepID + "', wmessage = '" + wmessage + "' WHERE trackContentId = '" + trackID + "'  AND contentid = '" + trackItemID + "'  AND siteid =' " + siteID + "'  AND userid =  '" + userID + "'";

      List<Map<String, dynamic>> userSessionData = await _database.rawQuery(sqlQuery);
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in updateWorkFlowRulesInDBForTrackTemplate:$e");
      MyPrint.printOnConsole(s);
    }
  }
  //endregion
}
