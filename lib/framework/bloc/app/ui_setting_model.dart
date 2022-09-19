import 'package:flutter_admin_web/framework/bloc/app/localization_selection_model.dart';

class UISettingModel {
  String _appname = "";

  String get appname => _appname;

  void setappname(String value) {
    _appname = value;
  }

  String _appLogoURl = "";

  String get appLogoURl => _appLogoURl;

  void setappLogoURl(String value) {
    _appLogoURl = value;
  }

  String _appDarkLogoURl = '';

  void setDarkLogoURl(String value) {
    _appDarkLogoURl = value;
  }

  String _enableInAppPurchase = '';

  String get enableInAppPurchase => _enableInAppPurchase;

  void setEnableInAppPurchase(String value) {
    _enableInAppPurchase = value;
  }

  String get appDarkLogoURl => _appDarkLogoURl == null ? "" : _appDarkLogoURl;

  String _appBGColor = "";

  String get appBGColor => _appBGColor;

  void setappBGColor(String value) {
    _appBGColor = value;
  }

  String _expiredBGColor = "";

  String get expiredBGColor => _expiredBGColor;

  void setExpiredBGColor(String value) {
    _expiredBGColor = value;
  }

  String _appTextColor = "";
  String _appLoginBGColor = "";
  String _appLoginTextolor = "";
  String _appButtonBgColor = "";
  String _menuBGColor = "";
  String _menuTextColor = "";
  String _selectedMenuBGColor = "";
  String _selectedMenuTextColor = "";
  String _menuBGSelectTextColor = "";
  String _appHeaderColor = "";
  String _menuHeaderBGColor = "";
  String _appHeaderTextColor = "";
  String _menuHeaderTextColor = "";
  String _menuBGAlternativeColor = "";
  String _fileUploadButtonColor = "";
  String _appButtonTextColor = "";
  String _appLogoBackgroundColor = "";

  String get appLoginTextolor => _appLoginTextolor;

  void setappLoginTextolor(String value) {
    _appLoginTextolor = value;
  }

  String get appLoginBGColor => _appLoginBGColor;

  void setappLoginBGColor(String value) {
    _appLoginBGColor = value;
  }

  String get appTextColor => _appTextColor;

  void setappTextColor(String value) {
    _appTextColor = value;
  }

  String get appButtonBgColor => _appButtonBgColor;

  void setappButtonBgColor(String value) {
    _appButtonBgColor = value;
  }

  String get menuBGColor => _menuBGColor;

  void setmenuBGColor(String value) {
    _menuBGColor = value;
  }

  String get menuTextColor => _menuTextColor;

  void setmenuTextColor(String value) {
    _menuTextColor = value;
  }

  String get selectedMenuBGColor => _selectedMenuBGColor;

  void setselectedMenuBGColor(String value) {
    _selectedMenuBGColor = value;
  }

  String get selectedMenuTextColor => _selectedMenuTextColor;

  void setselectedMenuTextColor(String value) {
    _selectedMenuTextColor = value;
  }

  String get menuBGSelectTextColor => _menuBGSelectTextColor;

  void setmenuBGSelectTextColor(String value) {
    _menuBGSelectTextColor = value;
  }

  String get appHeaderColor => _appHeaderColor;

  void setappHeaderColor(String value) {
    _appHeaderColor = value;
  }

  String get menuHeaderBGColor => _menuHeaderBGColor;

  void setmenuHeaderBGColor(String value) {
    _menuHeaderBGColor = value;
  }

  String get appHeaderTextColor => _appHeaderTextColor;

  void setappHeaderTextColor(String value) {
    _appHeaderTextColor = value;
  }

  String get menuHeaderTextColor => _menuHeaderTextColor;

  void setmenuHeaderTextColor(String value) {
    _menuHeaderTextColor = value;
  }

  String get menuBGAlternativeColor => _menuBGAlternativeColor;

  void setmenuBGAlternativeColor(String value) {
    _menuBGAlternativeColor = value;
  }

  String get fileUploadButtonColor => _fileUploadButtonColor;

  void setfileUploadButtonColor(String value) {
    _fileUploadButtonColor = value;
  }

  String get appButtonTextColor => _appButtonTextColor;

  void setappButtonTextColor(String value) {
    print("set value $value");
    _appButtonTextColor = value;
  }

  String get appLogoBackgroundColor => _appLogoBackgroundColor;

  void setappLogoBackgroundColor(String value) {
    _appLogoBackgroundColor = value;
  }

  String _enableMembership = "";
  String _selfRegistrationAllowed = "";
  String _enableEcommerce = "";
  String _dateFormat = "";
  String _dateTimeFormat = "";
  String _eventDateTimeFormat = "";
  String _siteLanguage = "";
  String _enablePushNotification = "";
  String _commonPasswordValue = "";
  String _autoLaunchFirstContentInMyLearning = "";
  String _discussionForumFileTypes = "";
  String _enableSkillsToBeMappedWithJobRoles = "";
  String _userUploadFileSize = "";
  String _contentDownloadType = "";
  String _nativeAppType = "";
  String _courseAppContent = "";
  String _enableNativeCatalog = "";
  String _autoDownloadSizeLimit = "";
  String _learnerDefaultMenu = "";
  String _ccEventStartdate = "";
  String _isGlobalsearch = "";
  String _autocompleteNonTrackableContent = "";
  String _enableAzureSSOForLearner = "";
  String _enableContentEvaluation = "";
  String _enableDownLoadAudioVideoCloud = "";
  String _catalogContentDownloadType = "";
  String _enableNativeAppLoginSetting = "";
  String _enableNativeAppLoginSettingLogo = "";
  String _selfRegistrationDisplayName = "";
  String _nativeAppLoginLogo = "";
  String _enableNativeSplashImage = "";
  String _allowExpiredEventsSubscription = "";
  String _numberOfRatingsRequiredToShowRating = "";
  String _minimumRatingRequiredToShowRating = "";
  String _noOfDaysForCourseTargetDate = "";
  String _enableMultipleInstancesForEvent = "";
  String _showMembershipContentPriceByStrikeThrough = "";
  String _showEventAvailableFewSeatsLeft = "";
  String _enableWishlist = "";
  String _doNotAllowPrerequisiteDesiredContent = "";
  String _membershipExpiryAlertMessage = "";

  //sreekanth commented
  //String _AutocompleteDocumentionDownload;
  String _daysBeforeMembershipExpiry = "";
  String _mobileAppMenuPosition = "";
  String _showMoreActionForBottomMenu = "";
  String _isCloudStorageEnabled = "";
  String _azureRootPath = "";
  String _isFeedbackRedirection = "";
  String _enableGamification = "";
  String _addProfileAdditionalTab = "";
  String _enableChatBot = "";
  String _beforeLoginKnowledgeBaseID = "";
  String _botChatIcon = "";
  String _instancyBotEndPointURL = "";
  String _botGreetingContent = "";
  bool _isFromPush = false;

  bool get isFromPush => _isFromPush;

  void setIsFromPush(bool value) {
    _isFromPush = value;
  }

  String get enableGamification => _enableGamification;

  void setEnableGamification(String value) {
    _enableGamification = value;
  }

  String get addProfileAdditionalTab => _addProfileAdditionalTab;

  void setAddProfileAdditionalTab(String value) {
    _addProfileAdditionalTab = value;
  }

  String get enableChatBot => _enableChatBot;
  void setEnableChatBot(String value) {
    _enableChatBot = value;
  }

  String get beforeLoginKnowledgeBaseID => _beforeLoginKnowledgeBaseID;
  void setBeforeLoginKnowledgeBaseID(String value) {
    _beforeLoginKnowledgeBaseID = value;
  }

  String get botChatIcon => _botChatIcon;
  void setBotChatIcon(String value) {
    _botChatIcon = value;
  }

  String get instancyBotEndPointURL => _instancyBotEndPointURL;
  void setInstancyBotEndPointURL(String value) {
    _instancyBotEndPointURL = value;
  }

  String get botGreetingContent => _botGreetingContent;
  void setBotGreetingContent(String value) {
    _botGreetingContent = value;
  }

  String get isFeedbackRedirection => _isFeedbackRedirection;

  void setIsFeedbackRedirection(String value) {
    _isFeedbackRedirection = value;
  }

  String _feedbackUrl = "";

  String get feedbackUrl => _feedbackUrl;

  void setFeedbackUrl(String value) {
    _feedbackUrl = value;
  }

  String get enableMembership => _enableMembership;

  void setEnableMembership(String value) {
    _enableMembership = value;
  }

  String get selfRegistrationAllowed => _selfRegistrationAllowed;

  void setSelfRegistrationAllowed(String value) {
    _selfRegistrationAllowed = value;
  }

  String get enableEcommerce => _enableEcommerce;

  void setEnableEcommerce(String value) {
    _enableEcommerce = value;
  }

  String get dateFormat => _dateFormat;
  void setDateFormat(String value) {
    _dateFormat = value;
  }

  String get dateTimeFormat => _dateTimeFormat;
  void setDateTimeFormat(String value) {
    _dateTimeFormat = value;
  }

  String get eventDateTimeFormat => _eventDateTimeFormat;
  void setEventDateTimeFormat(String value) {
    _eventDateTimeFormat = value;
  }

  String get siteLanguage => _siteLanguage;

  void setSiteLanguage(String value) {
    _siteLanguage = value;
  }

  String get enablePushNotification => _enablePushNotification;

  void setEnablePushNotification(String value) {
    _enablePushNotification = value;
  }

  String get commonPasswordValue => _commonPasswordValue;

  void setCommonPasswordValue(String value) {
    _commonPasswordValue = value;
  }

  String get autoLaunchFirstContentInMyLearning =>
      _autoLaunchFirstContentInMyLearning;

  void setAutoLaunchFirstContentInMyLearning(String value) {
    _autoLaunchFirstContentInMyLearning = value;
  }

  String get discussionForumFileTypes => _discussionForumFileTypes;

  void setDiscussionForumFileTypes(String value) {
    _discussionForumFileTypes = value;
  }

  String get enableSkillsToBeMappedWithJobRoles =>
      _enableSkillsToBeMappedWithJobRoles;

  void setEnableSkillsToBeMappedWithJobRoles(String value) {
    _enableSkillsToBeMappedWithJobRoles = value;
  }

  String get userUploadFileSize => _userUploadFileSize;

  void setUserUploadFileSize(String value) {
    _userUploadFileSize = value;
  }

  String get contentDownloadType => _contentDownloadType;

  void setContentDownloadType(String value) {
    _contentDownloadType = value;
  }

  String get nativeAppType => _nativeAppType;

  void setNativeAppType(String value) {
    _nativeAppType = value;
  }

  String get courseAppContent => _courseAppContent;

  void setCourseAppContent(String value) {
    _courseAppContent = value;
  }

  String get enableNativeCatalog => _enableNativeCatalog;

  void setEnableNativeCatalog(String value) {
    _enableNativeCatalog = value;
  }

  String get autoDownloadSizeLimit => _autoDownloadSizeLimit;

  void setAutoDownloadSizeLimit(String value) {
    _autoDownloadSizeLimit = value;
  }

  String get learnerDefaultMenu => _learnerDefaultMenu;

  void setLearnerDefaultMenu(String value) {
    _learnerDefaultMenu = value;
  }

  String get cCEventStartDate => _ccEventStartdate;

  void setCCEventStartDate(String value) {
    _ccEventStartdate = value;
  }

  String get isGlobalSearch => _isGlobalsearch;

  void setIsGlobalSearch(String value) {
    _isGlobalsearch = value;
  }

  String get autocompleteNonTrackableContent =>
      _autocompleteNonTrackableContent;

  void setAutocompleteNonTrackableContent(String value) {
    _autocompleteNonTrackableContent = value;
  }

  String get enableAzureSSOForLearner => _enableAzureSSOForLearner;

  void setEnableAzureSSOForLearner(String value) {
    _enableAzureSSOForLearner = value;
  }

  String get enableContentEvaluation => _enableContentEvaluation;

  void setEnableContentEvaluation(String value) {
    _enableContentEvaluation = value;
  }

  String get enableDownLoadAudioVideoCloud => _enableDownLoadAudioVideoCloud;

  void setEnableDownLoadAudioVideoCloud(String value) {
    _enableDownLoadAudioVideoCloud = value;
  }

  String get catalogContentDownloadType => _catalogContentDownloadType;

  void setCatalogContentDownloadType(String value) {
    _catalogContentDownloadType = value;
  }

  String get enableNativeAppLoginSetting => _enableNativeAppLoginSetting;

  void setEnableNativeAppLoginSetting(String value) {
    _enableNativeAppLoginSetting = value;
  }

  String get enableNativeAppLoginSettingLogo =>
      _enableNativeAppLoginSettingLogo;

  void setEnableNativeAppLoginSettingLogo(String value) {
    _enableNativeAppLoginSettingLogo = value;
  }

  String get selfRegistrationDisplayName => _selfRegistrationDisplayName;

  void setSelfRegistrationDisplayName(String value) {
    _selfRegistrationDisplayName = value;
  }

  String get nativeAppLoginLogo => _nativeAppLoginLogo;

  void setNativeAppLoginLogo(String value) {
    _nativeAppLoginLogo = value;
  }

  String get enableNativeSplashImage => _enableNativeSplashImage;

  void setEnableNativeSplashImage(String value) {
    _enableNativeSplashImage = value;
  }

  String get allowExpiredEventsSubscription => _allowExpiredEventsSubscription;

  void setAllowExpiredEventsSubscription(String value) {
    _allowExpiredEventsSubscription = value;
  }

  String get numberOfRatingsRequiredToShowRating =>
      _numberOfRatingsRequiredToShowRating;

  void setNumberOfRatingsRequiredToShowRating(String value) {
    _numberOfRatingsRequiredToShowRating = value;
  }

  String get minimumRatingRequiredToShowRating =>
      _minimumRatingRequiredToShowRating;

  void setMinimumRatingRequiredToShowRating(String value) {
    _minimumRatingRequiredToShowRating = value;
  }

  String get noOfDaysForCourseTargetDate => _noOfDaysForCourseTargetDate;

  void setNoOfDaysForCourseTargetDate(String value) {
    _noOfDaysForCourseTargetDate = value;
  }

  String get enableMultipleInstancesForEvent =>
      _enableMultipleInstancesForEvent;

  void setEnableMultipleInstancesForEvent(String value) {
    _enableMultipleInstancesForEvent = value;
  }

  String get showMembershipContentPriceByStrikeThrough =>
      _showMembershipContentPriceByStrikeThrough;

  void setShowMembershipContentPriceByStrikeThrough(String value) {
    _showMembershipContentPriceByStrikeThrough = value;
  }

  String get showEventAvailableFewSeatsLeft => _showEventAvailableFewSeatsLeft;

  void setShowEventAvailableFewSeatsLeft(String value) {
    _showEventAvailableFewSeatsLeft = value;
  }

  String get enableWishlist => _enableWishlist;

  void setEnableWishlist(String value) {
    _enableWishlist = value;
  }

  String get doNotAllowPrerequisiteDesiredContent =>
      _doNotAllowPrerequisiteDesiredContent;

  void setDoNotAllowPrerequisiteDesiredContent(String value) {
    _doNotAllowPrerequisiteDesiredContent = value;
  }

  String get membershipExpiryAlertMessage => _membershipExpiryAlertMessage;

  void setMembershipExpiryAlertMessage(String value) {
    _membershipExpiryAlertMessage = value;
  }

  //sreekanth commented

  // String get AutocompleteDocumentionDownload =>
  //     _AutocompleteDocumentionDownload;
  //
  // void setAutocompleteDocumentionDownload(String value) {
  //   _AutocompleteDocumentionDownload = value;
  // }

  String get daysBeforeMembershipExpiry => _daysBeforeMembershipExpiry;

  void setDaysBeforeMembershipExpiry(String value) {
    _daysBeforeMembershipExpiry = value;
  }

  String get mobileAppMenuPosition => _mobileAppMenuPosition;

  void setMobileAppMenuPosition(String value) {
    _mobileAppMenuPosition = value;
  }

  String get showMoreActionForBottomMenu => _showMoreActionForBottomMenu;

  void setShowMoreActionForBottomMenu(String value) {
    _showMoreActionForBottomMenu = value;
  }

  String get isCloudStorageEnabled => _isCloudStorageEnabled;

  void setIsCloudStorageEnabled(String value) {
    _isCloudStorageEnabled = value;
  }

  String get azureRootPath => _azureRootPath;

  void setAzureRootPath(String value) {
    _azureRootPath = value;
  }

  bool _isFaceBook = false;

  bool get isFaceBook => _isFaceBook;

  void setIsFaceBook(bool value) {
    _isFaceBook = value;
  }

  bool _isGoogle = false;

  bool _isTwitter = false;
  bool _isLinkedIn = false;

  bool get isGoogle => _isGoogle;

  void setIsGoogle(bool value) {
    _isGoogle = value;
  }

  bool get isTwitter => _isTwitter;

  void setIsTwitter(bool value) {
    _isTwitter = value;
  }

  bool get isLinkedIn => _isLinkedIn;

  void setIsLinkedIn(bool value) {
    _isLinkedIn = value;
  }

  List<LocalizationSelectionModel> _localeList = [];

  List<LocalizationSelectionModel> get localeList => _localeList;

  void setLocaleList(List<LocalizationSelectionModel> value) {
    _localeList = value;
  }

  bool _isMsgMenuExist = false;

  bool get isMsgMenuExist => _isMsgMenuExist;

  void setIsMsgMenuExist(bool value) {
    _isMsgMenuExist = value;
  }
}
