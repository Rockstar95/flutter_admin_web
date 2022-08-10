import 'package:flutter_admin_web/framework/repository/event_module/model/event_recording_resonse.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mylearning.g.dart';

@JsonSerializable()
class MyLearningModel {
  EventRecordingResponse? eventRecordingModel = EventRecordingResponse();

  String recordingDetailsStr;

  bool completedEvent;

  @JsonKey(name: 'removelink')
  bool removeFromMylearning;

  String reScheduleEvent;

  bool scheduleInstanceEvent;

  @JsonKey(name: 'viewprerequisitecontentstatus')
  String viewprerequisitecontentstatus;

  @JsonKey(name: 'certificateaction')
  String CertificateAction;

  bool isFromPrereq;

  int fileSize;

  @JsonKey(name: 'bit4')
  bool bit4;

  @JsonKey(name: 'certificateid')
  String CertificateId;

  @JsonKey(name: 'certificatepage')
  String CertificatePage;

  @JsonKey(name: 'windowproperties')
  String WindowProperties;

  @JsonKey(name: 'recordingmsg')
  String recordingmsg;

  @JsonKey(
    name: 'eventrecording',
    fromJson: boolToString,
    toJson: stringToBool,
  )
  String eventrecording;

  @JsonKey(name: 'recordingcontentid')
  String recordingcontentid;

  @JsonKey(name: 'recordingurl')
  String recordingurl;

  String eventViewlink;

  @JsonKey(name: 'qrimagename')
  String QRImageName;

  @JsonKey(name: 'qrcodeimagepath')
  String qrCodeImagePath;

  String offlineQrCodeImagePath;

  @JsonKey(name: 'bit2')
  bool cancelEventEnabled;

  @JsonKey(name: 'isarchived')
  bool isArchived;

  @JsonKey(name: 'isenrollfutureinstance')
  bool isEnrollFutureInstance;

  @JsonKey(name: 'isbadcancellationenabled')
  bool isBadCancellationEnabled = false;

  String actionWaitlist = "";

  @JsonKey(name: 'percentcompleted')
  String percentCompleted = "";

  @JsonKey(name: 'required')
  int isRequired = 0;

  bool eventCompletedOrNot = false;

  @JsonKey(name: 'waitlistlimit')
  int waitlistlimit;

  @JsonKey(name: 'waitlistenrolls')
  int waitlistenrolls;

  @JsonKey(name: 'enrollmentlimit')
  int enrollmentlimit;

  @JsonKey(name: 'noofusersenrolled')
  int noofusersenrolled;

  int cancelWaitList;

  @JsonKey(name: 'progress')
  String progress;

  String userName;

  @JsonKey(name: 'siteid', fromJson: stringVal)
  String siteID;

  @JsonKey(name: 'sitename')
  String siteName;

  @JsonKey(name: 'siteurl')
  String siteURL;

  @JsonKey(name: 'userid', fromJson: stringVal)
  String userID;

  @JsonKey(name: 'name')
  String courseName;

  @JsonKey(name: 'shortdescription')
  String shortDes;

  @JsonKey(name: 'authordisplayname')
  String author;

  @JsonKey(name: 'contentid')
  String contentID;

  @JsonKey(name: 'createddate')
  String createdDate;
  String displayName;

  @JsonKey(name: 'durationenddate')
  String durationEndDate;

  @JsonKey(name: 'objectid')
  String objectId;

  String imageData;

  @JsonKey(name: 'relatedconentcount', fromJson: stringVal)
  String relatedContentCount;

  @JsonKey(name: 'isdownloaded', fromJson: boolToString, toJson: stringToBool)
  String isDownloaded;

  @JsonKey(name: 'courseattempts')
  String courseAttempts;

  @JsonKey(name: 'objecttypeid', fromJson: stringVal, toJson: stringToDouble)
  String objecttypeId;

  @JsonKey(name: 'scoid', fromJson: stringVal, toJson: stringToDouble)
  String scoId;

  @JsonKey(name: 'startpage')
  String startPage;

  @JsonKey(name: 'actualstatus')
  String statusActual;

  @JsonKey(name: 'corelessonstatus')
  String statusDisplay;

  // @JsonKey(name: 'contenttype')
  String contentType;

  @JsonKey(name: 'longdescription')
  String longDes;

  @JsonKey(name: 'contenttype')
  String mediaName;

  @JsonKey(name: 'ratingid', fromJson: stringVal)
  String ratingId;

  @JsonKey(name: 'publisheddate')
  String publishedDate;

  @JsonKey(name: 'eventstartdatedisplay')
  String eventstartTime;

  @JsonKey(name: 'eventenddatedisplay')
  String eventendTime;

  @JsonKey(name: 'mediatypeid', fromJson: stringVal)
  String mediatypeId;

  @JsonKey(name: 'dateassigned')
  String dateAssigned;

  @JsonKey(name: 'keywords')
  String keywords;

  @JsonKey(name: 'eventcontentid')
  String eventContentid;
  bool eventAddedToCalender;
  String isExpiry;

  @JsonKey(name: 'eventfulllocation')
  String locationName;

  @JsonKey(name: 'timezone')
  String timeZone;

  @JsonKey(name: 'participanturl')
  String participantUrl;
  String password;

  @JsonKey(name: 'bit5', fromJson: boolToString)
  String isListView;
  String thumbnailImagePath;

  @JsonKey(name: 'eventscheduletype')
  int EventScheduleType;
  String TableofContent;
  String LearningObjectives;

  String objectfolderid;

  @JsonKey(name: 'tagname')
  String tagname;

  String instanceparentcontentid;

  String contentEnrolled;

  @JsonKey(name: 'duration')
  String duration;

  @JsonKey(name: 'credittypes')
  String credits;

  @JsonKey(name: 'decimal2', fromJson: stringVal, toJson: stringToDouble)
  String decimal2;

  int bookmarkID;

  @JsonKey(name: 'totalratings')
  int totalratings;

  @JsonKey(name: 'iconpath')
  String contentTypeImagePath;

  String eventType;

  String thumbnailVideoPath;

  String contentExpire;

  @JsonKey(name: 'joinurl')
  String joinurl;

  @JsonKey(name: 'typeofevent')
  int typeofevent;

  String downloadURL;
  String offlinepath;

  @JsonKey(name: 'wresult')
  String wresult;

  @JsonKey(name: 'wmessage')
  String wmessage;

  @JsonKey(name: 'presenter')
  String presenter;

  String startDate;

  @JsonKey(name: 'headerlocationname')
  String groupName;

  @JsonKey(name: 'activityid')
  String activityId;

  // Exclusive For Track List Model start
  String score;
  String timeDelay;
  String blockName;
  int sequenceNumber;
  String folderID;
  String parentID;
  String trackScoid;
  String showStatus;

  @JsonKey(name: 'folderpath')
  String folderPath;

  @JsonKey(name: 'eventstartdatetime')
  String eventstartUtcTime;

  @JsonKey(name: 'eventenddatetime')
  String eventendUtcTime;

  // membership level
  @JsonKey(name: 'membershiplevel')
  int memberShipLevel;

  @JsonKey(name: 'membershipname')
  String membershipname;

  String trackOrRelatedContentID;

  // Exclusive For Catalog Model start

  String googleProductID;

  String componentId;

  String price;

  int addedToMylearning;

  String itemType;

  String viewType;

  String currency;

  @JsonKey(name: 'jwvideokey')
  String jwvideokey;

  @JsonKey(name: 'jwstartpage')
  String jwStartPage;

  @JsonKey(name: 'cloudmediaplayerkey')
  String cloudmediaplayerkey;

  String aviliableSeats;

  String eventID;

  String isDiscussion;

  MyLearningModel({
    this.eventRecordingModel,
    this.recordingDetailsStr = "",
    this.completedEvent = false,
    this.removeFromMylearning = false,
    this.reScheduleEvent = "",
    this.scheduleInstanceEvent = false,
    this.viewprerequisitecontentstatus = "",
    this.CertificateAction = "",
    this.isFromPrereq = false,
    this.fileSize = 0,
    this.bit4 = false,
    this.CertificateId = "",
    this.CertificatePage = "",
    this.WindowProperties = "",
    this.recordingmsg = "",
    this.eventrecording = "",
    this.recordingcontentid = "",
    this.recordingurl = "",
    this.eventViewlink = "",
    this.QRImageName = "",
    this.qrCodeImagePath = "",
    this.offlineQrCodeImagePath = "",
    this.cancelEventEnabled = false,
    this.isArchived = false,
    this.isEnrollFutureInstance = false,
    this.isBadCancellationEnabled = false,
    this.actionWaitlist = "",
    this.percentCompleted = "",
    this.isRequired = 0,
    this.eventCompletedOrNot = false,
    this.waitlistlimit = -1,
    this.waitlistenrolls = -1,
    this.enrollmentlimit = 0,
    this.noofusersenrolled = 0,
    this.cancelWaitList = 0,
    this.progress = "",
    this.userName = "",
    this.siteID = "",
    this.siteName = "",
    this.siteURL = "",
    this.userID = "",
    this.courseName = "",
    this.shortDes = "",
    this.author = "",
    this.contentID = "",
    this.createdDate = "",
    this.displayName = "",
    this.durationEndDate = "",
    this.objectId = "",
    this.imageData = "",
    this.relatedContentCount = "0",
    this.isDownloaded = "",
    this.courseAttempts = "",
    this.objecttypeId = "",
    this.scoId = "",
    this.startPage = "",
    this.statusActual = "",
    this.statusDisplay = "",
    this.contentType = "",
    this.longDes = "",
    this.mediaName = "",
    this.ratingId = "",
    this.publishedDate = "",
    this.eventstartTime = "",
    this.eventendTime = "",
    this.mediatypeId = "",
    this.dateAssigned = "",
    this.keywords = "",
    this.eventContentid = "",
    this.eventAddedToCalender = false,
    this.isExpiry = "",
    this.locationName = "",
    this.timeZone = "",
    this.participantUrl = "",
    this.password = "",
    this.isListView = "",
    this.thumbnailImagePath = "",
    this.EventScheduleType = 0,
    this.TableofContent = "",
    this.LearningObjectives = "",
    this.objectfolderid = "",
    this.tagname = "",
    this.instanceparentcontentid = "",
    this.contentEnrolled = "false",
    this.duration = "",
    this.credits = "",
    this.decimal2 = "",
    this.bookmarkID = 0,
    this.totalratings = 0,
    this.contentTypeImagePath = "",
    this.eventType = "",
    this.thumbnailVideoPath = "",
    this.contentExpire = "",
    this.joinurl = "",
    this.typeofevent = 0,
    this.downloadURL = "",
    this.offlinepath = "",
    this.wresult = "",
    this.wmessage = "",
    this.presenter = "",
    this.startDate = "",
    this.groupName = "",
    this.activityId = "",
    this.score = "",
    this.timeDelay = "",
    this.blockName = "",
    this.sequenceNumber = 0,
    this.folderID = "",
    this.parentID = "",
    this.trackScoid = "",
    this.showStatus = "",
    this.folderPath = "",
    this.eventstartUtcTime = "",
    this.eventendUtcTime = "",
    this.memberShipLevel = 1,
    this.membershipname = "Free",
    this.trackOrRelatedContentID = "",
    this.googleProductID = "",
    this.componentId = "",
    this.price = "", // 120th var

    this.addedToMylearning = 0,
    this.itemType = "",
    this.viewType = "",
    this.currency = "",
    this.jwvideokey = "",
    this.jwStartPage = "",
    this.cloudmediaplayerkey = "",
    this.aviliableSeats = "",
    this.eventID = "",
    this.isDiscussion = "", // 130 variables!!
  });

  factory MyLearningModel.fromJson(Map<String, dynamic> data) => _$MyLearningModelFromJson(data);

  Map<String, dynamic> toJson() => _$MyLearningModelToJson(this);

  static String boolToString(bool? val) {
    if (val == null) {
      return 'false';
    } else {
      return val.toString();
    }
  }

  static bool stringToBool(String? val) {
    if (val == null) {
      return false;
    }
    return val == 'true';
  }

  static String stringVal(dynamic val) => (val == null) ? '' : val.toString();

  static double stringToDouble(String? val) =>
      (val == null) ? 0.0 : double.parse(val);
}
