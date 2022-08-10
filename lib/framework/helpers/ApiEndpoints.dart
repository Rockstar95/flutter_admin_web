class ApiEndpoints {
// flutter client
  //static String mainSiteURL = "https://staging.yournextu.com/";
  // static String mainSiteURL = "https://flutter.instancy.com/";
  // static String mainSiteURL = "https://qalearning.instancy.com/";
  //static String mainSiteURL = "https://alwaysastudent.instancy.net/Sign-In";
  //static String mainSiteURL = "https://qanewdemo.instancy.com/";
  //static String mainSiteURL = "https://qaseac.instancy.com/";
  //static String mainSiteURL = "https://enterprisedemo.instancy.com/";
  static String mainSiteURL = "https://upgradedenterprise.instancy.com/";
  // //static String mainSiteURL = "https://learning.instancy.com/";
  // //static String mainSiteURL = "https://enterprisedemo.instancy.net/";

  // //static String mainSiteURL = "https://enterprisedemo.instancy.net/";
  // //static String appAuthURL = "https://newazureplatform.instancy.com/api/";
  static String appAuthURL = "https://masterapilive.instancy.com/api/";

  // //static String appWebApiUrl = "https://flutterapi.instancy.com/api";
  static String appWebApiUrl = "https://upgradedenterpriseapi.instancy.com/api/"; // Gayathri added
  //static String appWebApiUrl = "https://edemowebapi.instancy.com/api";

  //static String appAuthURL = "https://masterapi.instancy.net/api/";  // // Gayathri added

  //static String appWebApiUrl = "https://flutterapi.instancy.com/api";
  //static String appWebApiUrl = "https://elearningapi.instancy.net/api"; // Gayathri added

  //https://flutter.instancy.com/

  //https://qaseac.instancy.com/

  static String siteID = '374';

  static String saltKey = "gRBtUdz2KKLs7hFThDlxpQeKJeaSGouGP0epTeZEbrKsytseecDQxy3TItGpeGYuAegJATZALtvFNloYaAd2qopSVlzOAPatQKrCsKbACgb53cGam45bxafhLre1";
  static String securityKey = "4512631236589784";
  static String securityIv = '4512631236589784';

  static String allowfromExternalHostKey = "AllowWindowsandMobileApps";

  /// internal review site
  // static String mainSiteURL = "https://enterpriseflutter.instancy.com/";
  // static String appAuthURL = "https://masterapilive.instancy.com/api/";
  // static String appWebApiUrl = "https://enterpriseflutterapi.instancy.com/";

  // QA demo
  // static String mainSiteURL = "https://qanewdemo.instancy.com/";
  // static String appWebApiUrl = "https://qaapi.instancy.com/api/";
  // static String appAuthURL = "https://newazureplatform.instancy.com/api/";

  // // Instancy
  // static String mainSiteURL = "https://learning.instancy.com/";
  // static String appWebApiUrl = "https://learningapi.instancy.com/api/";
  // static String appAuthURL = "https://masterapilive.instancy.com/api/";

  // enterprise demo live
  // //static String mainSiteURL = "https://elearning.instancy.net/";
  // static String mainSiteURL = "https://enterprisedemo.instancy.com/";
  // static String appWebApiUrl = "https://edemowebapi.instancy.com/api/";
  // static String appAuthURL = "https://masterapilive.instancy.com/api/";

// // ecommerce demo
//   static String mainSiteURL = "https://ecommerce.instancy.com/";
//   static String appWebApiUrl = "https://edemowebapi.instancy.com/api/";
//   static String appAuthURL = "https://masterapi.instancy.com/api/";

  // Always a student
  // static String mainSiteURL = "https://www.iamalwaysastudent.com/";
  // static String appWebApiUrl = "https://api.iamalwaysastudent.com/api/";
  // static String appAuthURL = "https://masterapilive.instancy.com/api/";

  static String _strBaseUrl = "";

  static String get strBaseUrl => _strBaseUrl;

  void setStrBaseUrl(String value) {
    _strBaseUrl = value;
  }

  static String _strSiteUrl = "";

  static String get strSiteUrl => _strSiteUrl;

  void setstrSiteUrl(String value) {
    _strSiteUrl = value;
  }

//Splashscreen Api
  static String apiSplash() =>
      "${appAuthURL}Authentication/GetMobileAPIAuth?AppURL=$strSiteUrl";

  static String apiMobileGetLearningPortalInfo() =>
      "${strBaseUrl}MobileLMS/MobileGetLearningPortalInfo?SiteURL=$strSiteUrl";

  static String apiMobileGetNativeMenus(String locale) =>
      "${strBaseUrl}MobileLMS/MobileGetNativeMenus?SiteURL=$strSiteUrl&Locale=$locale";

  static String apiMobileTinCanConfigurations(String locale) =>
      "${strBaseUrl}MobileLMS/MobileTinCanConfigurations?SiteURL=$strSiteUrl&Locale=$locale";

  static String apiGetJsonFile(String locale, String siteid) =>
      "${strBaseUrl}MobileLMS/GetLocalizationFile?LocaleID=$locale&siteID=$siteid";

  //Login
  static String apiLogin() => "${strBaseUrl}MobileLMS/PostLoginDetails";
  static String apiSocialLogin() => "${strBaseUrl}SocialNetworkLink/SaveSocailNetworkUsers";

  static String apiGetLoginDetails(String authKey, String siteId) =>
      "${strBaseUrl}MobileLMS/SocialLogin?authKey=$authKey&siteId=$siteId";

  //Forgot password
  static String getUesrStatusAPI(String email, String siteUrl) =>
      "${strBaseUrl}MobileLMS/UserStatusForPasswordReset?Login=$email&SiteURL=$siteUrl";

  static String resetUserDataAPI(String userId, String uuid) =>
      "${strBaseUrl}MobileLMS/UsersPasswordResetDataFromMobile?Userid=$userId&ResetID=$uuid";

  static String sendPwdResetAPI(String siteId, String userId, String email,
          String contentURL, String uuid) =>
      "${strBaseUrl}User/SendPasswordResetEmail?SiteID=$siteId&Userid=$userId&ToEmailID=$email&newguId=$uuid"; //&PublicContentURL=$contentURL/PasswordRecovery/Gid/$uuid";

  //Signup
  static String getSignUpFieldsURL(
          String componentId,
          String componentInstanceid,
          String locale,
          String siteId,
          String sitrURL) =>
      '${strBaseUrl}MobileLMS/MobileGetSignUpDetails?ComponentID=$componentId&ComponentInstanceID=$componentInstanceid&Locale=$locale&SiteID=$siteId&SiteURL=$sitrURL';

//  'https://flutterapi.instancy.com/api//MobileLMS/MobileGetSignUpDetails?ComponentID=47&ComponentInstanceID=3104&Locale=en-us&SiteID=374&SiteURL=http://flutter.instancy.com/ ';

  static String doSignUpUser(String locale, String siteUrl) =>
      '${strBaseUrl}MobileLMS/MobileCreateSignUp?Locale=$locale&SiteURL=$strSiteUrl';
  static String apiMyLearning = "${strBaseUrl}MobileMyCatalogObjectsData";

  //Profile
  static String getUserInfo(String userId, String siteId, String locale) =>
      '${strBaseUrl}MobileLMS/MobileGetUserDetailsv1?UserID=$userId&siteURL=$strSiteUrl&SiteID=$siteId&strlocaleId=$locale';

  static String getProfileHeader() => '${strBaseUrl}UserProfile/GetProfileHeaderData';

  static String saveProfile() => '${strBaseUrl}UserProfile/SaveprofileData';

  static String processPayments() => '${strBaseUrl}Ecommerce/ProcessPayments';

  //My Learning

  static String getMobileMyCatalogObjectsData() =>
      '${strBaseUrl}MobileLMS/MobileMyCatalogObjectsData';

  // My Learning plus

  static String getMobileMyLearningPlusObjectsData() =>
      '${strBaseUrl}catalog/GetMyLearningObjects';

  static String getUserRatingsURL() => '${strBaseUrl}MobileLMS/GetUserRatings';

  static String deleteUserRatingsURL() => '${strBaseUrl}MobileLMS/DeleteRating';

  static String addUserRatingsURL() => '${strBaseUrl}MobileLMS/AddRatings';

  static String getMyLearningDetails = '${strBaseUrl}ContentDetails/GetContentDetails';
  static String getMyLearningDetails2 = '${strBaseUrl}ContentDetails/getContentDetails1';

  static String GetComponentSortOptionsURL() =>
      '${strBaseUrl}catalog/GetComponentSortOptions?';

  static String setStatusCompleted(
          String contentId, String userId, String scoId, String siteId) =>
      '${strBaseUrl}MobileLMS/MobileSetStatusCompleted?ContentID=$contentId&UserID=$userId&ScoId=$scoId&SiteID=$siteId';

  static String getCertificate(String contentId, String userId, String siteId,
          String certificateId, String certificatePage) =>
      '${strBaseUrl}MobileLMS/MobiledownloadHTMLasPDF?UserID=$userId&CID=$contentId&CertID=$certificateId&CertPage=$certificatePage&SiteID=$siteId&siteURL=$strSiteUrl&height=530&width=845';

  static String GetMyconnectionListForShareContentURL() =>
      '${strBaseUrl}AsktheExpert/GetMyconnectionListForShareContent?';

  static String GetUpdateDownloadCompleteStatus() =>
      '${strBaseUrl}CourseTracking/UpdateCompleteStatus?';

  static String cancelEnrollment(String contentId, String userId,
          bool isBadCancel, String locale, String strSiteID) =>
      '${strBaseUrl}MobileLMS/CancelEnrolledEvent?EventContentId=$contentId&UserID=$userId&SiteID=$strSiteID&isBadCancel=$isBadCancel&LocaleID=$locale';

  static String removeFromMyLearning(
          String contentId, String userId, String siteId) =>
      '${strBaseUrl}catalog/RemoveFromMyCatalog?ContentID=$contentId&UserID=$userId&SiteID=$siteId';

  static String GetCategoriesTreeURL() =>
      '${strBaseUrl}catalog/GetCategoriesTree?';

  static String GetLearningproviderURL(
          String instSiteID, String instUserID, String privacyType) =>
      '${strBaseUrl}catalog/GetLearningProviderForFilter?instSiteID=$instSiteID&instUserID=$instUserID&PrivacyType=$privacyType?';

  static String GetFilterDurationURL() =>
      '${strBaseUrl}Catalog/Getfilterdurationvalues';

  static String GetPrequisiteDetails(String contentId, String userId) =>
      '${strBaseUrl}catalog/GetPrequisiteDetails?ContentID=$contentId&UserID=$userId';

  static String associatedAddtoMyLearning() =>
      '${strBaseUrl}catalog/AssociatedAddtoMyLearning';

  static String getAssociatedContentApi(
          String contentID,
          String userID,
          String componentID,
          String componentInstanceID,
          String siteID,
          String instancedata,
          String preRequisiteSequncePathID,
          String locale) =>
      '${strBaseUrl}AssociatedContent/GetAssociatedContent?ContentID=$contentID&ComponentID=$componentID&ComponentInstanceID=$componentInstanceID&UserID=$userID&SiteID=$siteID&Instancedata=$instancedata&PreRequisiteSequncePathID=$preRequisiteSequncePathID&Locale=$locale';

  // https://flutterapi.instancy.com/api//AssociatedContent/GetAssociatedContent?ContentID=909d60e9-72e1-4d74-9553-390ceb7efd77&ComponentID=1&ComponentInstanceID=50044&UserID=352&SiteID=374&Instancedata=&PreRequisiteSequncePathID=10&Locale=en-us

  static String createExperience = '$strBaseUrl/MobileLMS/AddExperiencedata';
  static String removeExperience = '$strBaseUrl/MobileLMS/DeleteExperiencedata';
  static String updateExperience = '$strBaseUrl/MobileLMS/UpadteExperiencedata';
  static String createEducation = '$strBaseUrl/MobileLMS/AddEducationdata';
  static String removeEducation = '$strBaseUrl/MobileLMS/DeleteEducationdata';
  static String getEducationTitles =
      '$strBaseUrl/MobileLMS/GeteducationTitleList';
  static String updateEducation = '$strBaseUrl/MobileLMS/UpadteEducationdata';

  static String uploadImage(String filename, String userId) =>
      '${strBaseUrl}MobileLMS/MobileSyncProfileImage?fileName=$filename&siteURL=$strSiteUrl&UserID=$userId';

  static String updateProfile(String userId) =>
      '$strBaseUrl/MobileLMS/MobileUpdateUserProfile?studId=$userId&SiteURL=$strSiteUrl';

  static String fetchCountries(String userId, String siteId, String locale) =>
      '$strBaseUrl/MobileLMS/MobileGetUserDetails?UserID=$userId&siteURL=$strSiteUrl&siteid=$siteId&strlocaleId=$locale';

  static String updateMyLearningArchiveURL() =>
      '$strBaseUrl/catalog/UpdateMyLearningArchive';

  static String SendMailToPeopleURL() =>
      '${strBaseUrl}Generic/SendMailToPeople';

  //Catalog
  static String getCategoryForBrowseURL() =>
      '$strBaseUrl/Catalog/getCategoryForBrowse?';

  // static String getMobileCatalogObjectsDataURL() =>
  //     '${strBaseUrl}catalog/getCatalogObjects';

  static String getMobileCatalogObjectsDataURL() =>
      '${strBaseUrl}MobileLMS/MobileCatalogObjectsData';

  static String postUploadWikiFiles() =>
      '${strBaseUrl}UploadFiles/UploadFilesAction';

  static String GetWikiCategories() => '${strBaseUrl}Generic/GetWikiCategories';

  static String GetFeedBackData(
          String currentuserid, String siteid, String isAdmin) =>
      '$strBaseUrl/Feedback/GetFeedBackData?currentuserid=$currentuserid&siteid=$siteid&viewall=$isAdmin';

  static String DeleteFeedBack() => '$strBaseUrl/Feedback/DeleteFeedback';

  // static String AddtoMyLearning(
  //         String contentId, String userId, String siteId) =>
  //     '$strBaseUrl/MobileLMS/MobileAddtoMyCatalog?UserID=$userId&SiteURL=$strSiteUrl&ContentID=$contentId&SiteID=$siteId&targetDate=';

  static String addToMyLearning(String contentId, String userId, String siteId,
          String siteUrl, String dueDate) =>
      '$strBaseUrl/MobileLMS/MobileAddtoMyCatalog?UserID=$userId&SiteURL=$siteUrl&ContentID=$contentId&SiteID=$siteId&targetDate=$dueDate';

  static String mobileSaveInAppPurchaseDetails(
          String userId,
          String siteURl,
          String contentID,
          String orderId,
          String purchaseToken,
          String productId,
          String purchaseTime,
          String deviceType) =>
      '${strBaseUrl}MobileLMS/MobileSaveInAppPurchaseDetails?_userId=$userId&_siteURL=$siteURl&_contentId=$contentID&_transactionId=$orderId&_receipt=$purchaseToken&_productId=$productId&_purchaseDate=$purchaseTime&_devicetype=$deviceType';

  static String AddtoWishList() => '$strBaseUrl/Catalog/AddToWishList';

  static String RemoveWishListURl() =>
      '$strBaseUrl/WishList/DeleteItemFromWishList?';

  static String GetFileUploadControls(
          String locale, String siteID, String compInsId) =>
      '$strBaseUrl/SiteSettings/GetFileUploadControls?SiteId=$siteID&LocaleId=$locale&compInsId=$compInsId';

  //TrackList
  static String getTrackListResourceUrl(String contentId) =>
      '$strBaseUrl/MobileLMS/GetResourceJsonData?contentid=$contentId';

  static String getTrackListGlossaryUrl(String contentId) =>
      '$strBaseUrl/MobileLMS/GetglossaryJsonData?contentid=$contentId';

  static String getTrackListOverviewUrl(String contentId, String userId,
          String siteId, String locale, String objTypeId) =>
      '${strBaseUrl}EventTrackOverview/geteventtrackoverview?TrackingUserId=$userId&parentContentID=$contentId&objectTypeID=$objTypeId&iscontentenrolled=true&siteId=$siteId&localeId=$locale';

  //Event

  static String getPeopleTabList(String componentid, String componentInsId,
          String siteId, String locale, String userid) =>
      '$strBaseUrl/DynamicTab/GetDynamicTabs?ComponentID=$componentid&ComponentInsID=$componentInsId&SiteID=$siteId&Locale=$locale&aintUserID=$userid';

  static String getEventSessionData(
          String contentId, String userId, String siteId, String locale) =>
      '${strBaseUrl}EventTrackTabs/getEventSessionData?ContentID=$contentId&UserID=$userId&SiteID=$siteId&locale=$locale&multiLocation=';

  static String getEventRelatedMetadata(
          String contentId, String userId, String siteId, String locale) =>
      '${strBaseUrl}EventTrackTabs/getEventSessionData?ContentID=$contentId&UserID=$userId&SiteID=$siteId&locale=$locale&multiLocation=';

  static String badCancelEnrollment(String contentId, String strSiteID) =>
      '${strBaseUrl}EventSchedule/CheckIsFallUnderbadCancellation?EventID=$contentId&SiteID=$strSiteID';

  static String cancelEnroll(String contentId, String userId,
          String isBadCancel, String locale, String strSiteID) =>
      '$strBaseUrl/MobileLMS/CancelEnrolledEvent?EventContentId=$contentId&UserID=$userId&SiteID=$strSiteID&isBadCancel=$isBadCancel&LocaleID=$locale';

  static String expiryEvent =
      '${strBaseUrl}Catalog/AddExpiredContentToMyLearning';

  static String waitingList = '$strBaseUrl/MobileLMS/EnrollWaitListEvent';

  static String eventRecording(String contentId, String userId) =>
      '$strBaseUrl/MobileLMS/MobileGetEventrecordingDetails?UserID=$userId&ContentID=$contentId';

  // Discussion forum
  static String apiDiscussionMainHome() =>
      '${strBaseUrl}DiscussionForums/GetForumList';

  static String apiCreateDiscussion() =>
      '${strBaseUrl}DiscussionForums/CreateEditForum';

  static String apiDiscussionTopicComment() =>
      '${strBaseUrl}DiscussionForums/PostComment';

  static String apiDiscussionTopicCommentReply() =>
      '${strBaseUrl}DiscussionForums/PostReply';

  static String apiAddTopic() =>
      '${strBaseUrl}DiscussionForums/CreateForumTopic';

  static String apiEditTopic() =>
      '${strBaseUrl}DiscussionForums/EditForumTopic';

  static String apiDeleteForumTopic() =>
      '${strBaseUrl}DiscussionForums/DeleteForumTopic';

  static String apiReplyTopic() => '${strBaseUrl}DiscussionForums/GetReplies';

  static String apiDeleteReply() =>
      '${strBaseUrl}DiscussionForums/DeleteForumReply';

  static String apiDeleteComment() =>
      '${strBaseUrl}DiscussionForums/DeleteForumComment';

  static String apiPinTopic() => '${strBaseUrl}DiscussionForums/UpdatePinTopic';

  static String apiLikeUnLike() =>
      '${strBaseUrl}DiscussionForums/InsertAndGetContentLikes';

  static String apiLikeCount() =>
      '${strBaseUrl}DiscussionForums/GetTopicCommentLevelLikeList';

  static String submitFeedback() => '${strBaseUrl}Feedback/UploadFeedback';

  static String getEventResourceDetails() =>
      '${strBaseUrl}Resourcecontent/GetEventResourceDetails';

  static String uploadAttachment() =>
      '${strBaseUrl}DiscussionForums/UploadForumAttachment';

  //Preference
  static String getPreferenceTimeZone() =>
      '${strBaseUrl}UserProfile/GetTimeZoneInfo';

  static String getUserProfileSettings(
          String userId, String siteId, String locale) =>
      '${strBaseUrl}UserProfile/GetUserProfileSettingData?UserID=$userId&SiteID=$siteId&Locale=$locale';

  static String savePreference() =>
      '${strBaseUrl}UserProfile/SaveUserPreferences';

  static String sendviaemailmylearn() => '${strBaseUrl}Generic/SendMailToUser';

  //Payment History
  static String getPaymentHistory() =>
      '${strBaseUrl}Ecommerce/GetEcommerceOrderByUser';

  //Membership
  static String getActiveMembership() =>
      '${strBaseUrl}MemberShip/GetUserActiveMembership';

  static String getMembershipPlans() =>
      '${strBaseUrl}MemberShip/GetUpdateMemberShipDetails';

  static String getMemberShipDetails() =>
      '${strBaseUrl}MemberShip/GetMemberShipDetails';

  static String membershipRenewRedirectUrl(String memberShipDurationID) =>
      '${mainSiteURL}My-Cart/TransType/Membership/RenewType/Auto/DurationID/$memberShipDurationID/Rtype/upgrade/from/profile';

  static String getPaymentGateway(String currency, String siteId) =>
      '${strBaseUrl}Generic/GetPaymentGatway?strUserCurrency=$currency&intSiteID=$siteId';

  //MyConnections
  static String getDynamicTabs(String userId, String siteId, String locale) =>
      '${strBaseUrl}DynamicTab/GetDynamicTabs?ComponentID=78&ComponentInsID=3473&SiteID=$siteId&Locale=$locale&aintUserID=$userId';

  //myLearningPlus
  static String getDynamicTabsPlus(String userId, String siteId, String locale,
          String comid, String cominsid) =>
      '${strBaseUrl}DynamicTab/GetDynamicTabs?ComponentID=$comid&ComponentInsID=$cominsid&SiteID=$siteId&Locale=$locale&aintUserID=$userId&DontRemove=false';

  //myLearningPlus
  static String getMenuComponents(String userId, String menuid, String locale,
          String menuurl, String roleid) =>
      '${strBaseUrl}MenusAndComponents/GetMenuPageComponents?MenuID=$menuid&MenuURL=$menuurl&UserID=$userId&LocaleID=$locale&SiteID=$siteID&roleid=$roleid';

  static String getPeopleList() => '${strBaseUrl}PeopleListing/GetPeopleList';

  static String peopleListingAction() =>
      '${strBaseUrl}PeopleListing/doPeopleListingActions';

  // learning communities
  static String getportalListing(String recordCount, String componentID,
          String userId, String siteId, String componentInstanceID) =>
      '$strBaseUrl/PortalListing/getportal?FilterCondition=&SortCondition=&RecordCount=$recordCount&SearchText=&ComponentID=$componentID&SiteID=$siteId&ComponentInstanceID=$componentInstanceID&UserID=$userId';

  //Ask the Expert
  static String getUserQuestionsList() =>
      '${strBaseUrl}AsktheExpert/GetAsktheExpertData';

  static String addNewQuestion() =>
      '${strBaseUrl}AsktheExpert/InsertNewUserQuestion';

  static String viewAnswersList() =>
      '${strBaseUrl}AsktheExpert/GetUserQuestionsResponses';

  static String upAndDownVote() => '${strBaseUrl}Generic/InsertContentLikes';

  static String answerComment() =>
      '${strBaseUrl}AsktheExpert/InsertEditResponseComments';

  static String skillCategory() =>
      '${strBaseUrl}AsktheExpert/GetFilterUserSkills';

  static String viewComment() =>
      '${strBaseUrl}AsktheExpert/GetUserResponseComments';

  static String deleteComment() =>
      '${strBaseUrl}AsktheExpert/DeleteUserResponseComment';

  static String deleteQuestion() => '${strBaseUrl}AsktheExpert/DeleteQuestion';

  static String viewQuestion() =>
      '${strBaseUrl}AsktheExpert/getSetUserQuestionviews';

  static String sortMenuAskTheExpert() =>
      '${strBaseUrl}catalog/GetComponentSortOptions';

  static String addAnswerAskTheExpert() =>
      '${strBaseUrl}AsktheExpert/InsertEditQuestionResponse';

  static String deleteUserResponse() =>
      '${strBaseUrl}AsktheExpert/DeleteUserResponses';

  //My Competencies
  static String getJobRoleSkills() =>
      '${strBaseUrl}CompetencyManagement/GetUserJobRoleSkills';

  static String getPrefCatList() =>
      '${strBaseUrl}CompetencyManagement/GetUserPrefCatData';

  static String getUserSkills() =>
      '${strBaseUrl}CompetencyManagement/GetUserSkills';

  static String getUpdateUserEvalution() =>
      '${strBaseUrl}CompetencyManagement/UpdateUserEvaluation';

  static String getJobRoleData() =>
      '${strBaseUrl}CompetencyManagement/GetParentJobRolesData';

  static String getJobRoleSkillData() =>
      '${strBaseUrl}CompetencyManagement/GetJobRoleSkills';

  static String addJobRole() => '${strBaseUrl}CompetencyManagement/Addjobroles';

  static String getGameList() => '${strBaseUrl}LeaderBoard/GetGameList';

  static String getMyCreditCertificate(
          String userId, String siteId, String langStr) =>
      '${strBaseUrl}MyAchievementr/MyCreditCertificate?UserID=$userId&SiteID=$siteId&LocaleID=$langStr';

  //Progress Report
  static String getConsolidateRPT() =>
      '${strBaseUrl}ConsolidatedProgressReport/GetConsolidateRPT';

  static String getCourseSummary() =>
      '${strBaseUrl}Progressummary/getsummarydata';

  static String getProgressDetailDataDetails() =>
      '${strBaseUrl}Progressummary/getprogressdatadetails';

  static String getViewQuestion() =>
      '${strBaseUrl}Progressummary/getviewquestion';

  //Event enrollment
  static String getScheduleData() =>
      '${strBaseUrl}ContentDetails/getScheduleComponentScheduleData';

  static String addEnrollContent() => '${strBaseUrl}catalog/AddToMyLearning';

// Dashboard

  static String getUserAchievementData() => '${strBaseUrl}UserAchievement/GetUserAchievementData';

  static String getLeaderboardData() => '${strBaseUrl}LeaderBoard/GetLeaderboardData';

  // static String getGameList() => '${strBaseUrl}LeaderBoard/GetGameList';

  //Global Search
  static String getSearchComponentList(
          String userId, String siteId, String langStr) =>
      '${strBaseUrl}search/GetSearchComponentList?intUserID=$userId&intSiteID=$siteId&strLocale=$langStr';

  static String getGlobalSearchResults(
    int pageIndex,
    String searchStr,
    String userId,
    String siteId,
    String langStr,
    String cmpId,
    String cmpInsId,
    String cmpSiteId,
    String fType,
    String fValue,
  ) =>
      '${strBaseUrl}search/GetGlobalSearchResults?pageIndex=$pageIndex&pageSize=10&searchStr=$searchStr&source=0&type=0&fType=$fType&fValue=$fValue&sortBy=&sortType=&keywords=&AuthorID=-1&groupBy=&UserID=$userId&SiteID=$siteId&OrgUnitID=374&Locale=$langStr&ComponentID=225&ComponentInsID=4021&MultiLocation=&objComponentList=$cmpId&intComponentSiteID=$cmpSiteId';

  //Messages
  static String getChatConnectionUserList(
          String userId, String siteId, String langStr) =>
      '${strBaseUrl}Chat/GetChatConnectionUserList';

  static String deleteChatUser(String userId, String siteId, String langStr) =>
      '${strBaseUrl}Chat/DeleteChatConversation?FromUserID=$userId&intSiteiD=$siteId';

  static String getChatHistory() => '${strBaseUrl}Chat/GetUserChatHistory';

  static String postChatMessage() => '${strBaseUrl}Chat/InsertUserChatData';

  static String genericFileUpload() => '${strBaseUrl}Generic/SaveFiles';

  // Push Notification
  static String fcmRegister() =>
      '${strBaseUrl}MobileLMS/MobilePushMobileNotifications';

  static String getNotificationData() =>
      '${strBaseUrl}UserNotifications/getnotificationdata';

  static String clearAllNotification() =>
      '${strBaseUrl}UserNotifications/clearnotification';

  static String removeNotification() =>
      '${strBaseUrl}UserNotifications/Removenotificationcount';

  static String removeIndividualNotification(
          String userId, String notificationId) =>
      '${strBaseUrl}UserNotifications/Removeindividualnotificationcount?UserID=$userId&Notificationid=$notificationId';

  static String deleteNotification() =>
      '${strBaseUrl}UserNotifications/deletenotification';

  static String viewNotificationCount() =>
      '${strBaseUrl}UserNotifications/GetUserNotificationsCount';

  static String doPeopleListingAction() =>
      '${strBaseUrl}PeopleListing/doPeopleListingActions';

  /// Content isolation api calls

  /// String urlStr = appUserModel.getWebAPIUrl() + "CourseTracking/webAPIInitialiseTracking?userId=" + learningModel.getUserID() + "&scoId=" + learningModel.getScoId() + "&objectTypeID=" + learningModel.getObjecttypeId() + "&disbaleAdminViewTracking=false&contented=" + learningModel.getContentID() + "&siteid=" + appUserModel.getSiteIDValue();

  static String webAPIInitialiseTrackingApiCall(String userId, String scoID,
          String objectTypeID, String contentID, String steIDValue) =>
      '${strBaseUrl}CourseTracking/webAPIInitialiseTracking?userId=$userId&scoId=$scoID&objectTypeID=$objectTypeID&disbaleAdminViewTracking=false&contented=$contentID&siteid=$steIDValue';

  static String InsertCourseDataByTokenApiCall() =>
      '${strBaseUrl}CourseTracking/InsertCourseDataByToken';

  static String updateCompleteStatus() =>
      '${strBaseUrl}CourseTracking/InitializeTrackingforMediaObjects';

  //sreekanth api info
  static String GetWishListComponentDetails() => '$strBaseUrl/WishList/GetWishListComponentDetails?';

  //sreekanth
  static String GetPrivaryFields(String intUserID, String intSiteID, String strLocale) => '${strBaseUrl}UserProfile/GetPrivaryFields?intUserID=$intUserID&intSiteID=$intSiteID&strLocale=$strLocale&intCompID=160&intCompInsID=5001&intProfileUserID=0&intProfileSiteID=&viewconnection=true&Type=profile';

  static String SavePrivaryFields() => '${strBaseUrl}UserProfile/SavePrivaryFields';
}
