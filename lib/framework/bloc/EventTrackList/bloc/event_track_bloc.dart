import 'dart:async';
import 'dart:convert';
import 'dart:io';

//import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/EventTrackList/event/event_track_event.dart';
import 'package:flutter_admin_web/framework/bloc/EventTrackList/state/event_track_state.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/data_provider.dart';
import 'package:flutter_admin_web/framework/dataprovider/helper/local_database_helper.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/database/database_handler.dart';
import 'package:flutter_admin_web/framework/helpers/database/hivedb_handler.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/contract/event_track_repository.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/ResBlockTrack.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/ResBlockTrack2.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/ResEventTrackTabs.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/ResTrackList.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/glossary_local_model.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/glossary_tab_response.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/overview_response.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/resTrackBlock.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/model/resource_tab_response.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/related_content.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/model/content_status_response.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:logger/logger.dart';

import '../../../../controllers/my_learning_download_controller.dart';

class EventTrackBloc extends Bloc<EventTrackEvent, EventTrackState> {
  EventTrackListRepository eventTrackListRepository;

  Logger logger = Logger();

  List<DummyMyCatelogResponseTable2> trackListData = [];
  List<ResTrackBlocksList> trackBlockList = [];
  List<ReferenceItem> refItem = [];
  List<TrackListGlossaryTab> tabGlossary = [];
  List<GlossaryExpandable> glossaryExpandable = [];
  List<DummyMyCatelogResponseTable2> singleTempLATE = [];

  List<RelatedTag> relatedTag = [];
  String tag = '';

  // mylearning model variables

  DummyMyCatelogResponseTable2? myLearningModel;
  List<ResEventTrackTabs> resEventTrackTabs = [];
  List<ResEventTrackTabs> tempTabs = [];

  List<TracklistOverviewResponse> overviewResponse = [];

  String objecttypeid = "";
  String siteurl = "";
  String scoid = "";
  String contentid = "";
  String userid = "";
  String folderpath = "";
  String startpage = "";
  String courseName = "";
  String jwvideokey = "";
  String siteid = "";
  String activityid = "";
  String folderid = "";
  String startPage = "";
  String endDuarationDate = "";

  // local veribles

  String typeFrom = "track";
  String language = "";
  String webApiUrl = "";
  String strUserID = "";
  String strSiteID = "";

  String statusCode = '';
  bool isExpanded = false;

  final LocalDataProvider _localHelper =
      LocalDataProvider(localDataProviderType: LocalDataProviderType.hive);

  EventTrackBloc({
    required this.eventTrackListRepository,
  }) : super(EventTrackState.completed(null)) {
    on<GetTrackListData>(onEventHandler);
    on<TrackAddtoArchiveCall>(onEventHandler);
    on<TrackRemovetoArchiveCall>(onEventHandler);
    on<TrackCancelEnrollment>(onEventHandler);
    on<TrackRemoveFromMyLearning>(onEventHandler);
    on<TrackSetComplete>(onEventHandler);
    on<TrackListResources>(onEventHandler);
    on<TrackListGlossary>(onEventHandler);
    on<TrackListOverView>(onEventHandler);
    on<TrackGetContentStatus>(onEventHandler);
    on<ParentTrackGetContentStatus>(onEventHandler);
    on<BadCancelEnrollment>(onEventHandler);
    on<DownloadCompleteEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(EventTrackEvent event, Emitter emit) async {
    print("EVentTrackBloc onEventHandler called for ${event.runtimeType}");
    Stream<EventTrackState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (EventTrackState authState) {
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

  @override
  EventTrackState get initialState =>
      IntitialEventTrackStat.completed('Intitalized');

  @override
  Stream<EventTrackState> mapEventToState(event) async* {
    try {
      if (event is GetTrackListData) {
        myLearningModel = event.myLearningModel;
        objecttypeid = myLearningModel!.objecttypeid.toString();
        siteurl = myLearningModel!.siteurl;
        scoid = myLearningModel!.scoid.toString();
        contentid = myLearningModel!.contentid.toString();
        userid = myLearningModel!.userid.toString();
        folderpath = myLearningModel!.folderpath.toString();
        startpage = myLearningModel!.startpage.toString();
        courseName = myLearningModel!.name.toString();
        jwvideokey = myLearningModel!.jwvideokey.toString();
        siteid = myLearningModel!.siteid.toString();
        activityid = myLearningModel!.activityid.toString();
        folderid = myLearningModel!.folderid.toString();
        startPage = myLearningModel!.startpage.toString();
        endDuarationDate = myLearningModel!.durationenddate.toString();

        language = await sharePrefGetString(sharedPref_AppLocale);
        webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);
        //strUserID = await sharePref_getString(sharedPref_LoginUserID);
        strSiteID = await sharePrefGetString(sharedPref_siteid);

        logger.e("........hello...event...");

        yield GetTrackListState.loading('Please wait...');

        bool response = await getLearningTrackData(event.isTraxkList, event.appBloc);

        if (response) {
          yield GetTrackListState.completed(list: trackListData);
        }
        else if (statusCode == '401') {
          yield GetTrackListState.error('401');
        }
        else {
          yield GetTrackListState.error('Something went wrong');
        }

        /* if (objecttypeid.toString() == "70") {
            refreshMyLearning(false, true);
          } else {
            refreshMyLearning(false, false);
          }
*/

      }
      else if (event is TrackAddtoArchiveCall) {
        try {
          Response? response =
              await eventTrackListRepository.updateMyLearningArchive(
                  event.isArchive, event.strContentID);

          print("Sort Response ${response?.body.toString()}");

          if (response?.statusCode == 200) {
            yield TrackAddtoArchiveCallState.completed(isScusses: true);
          } else {
            print(response?.statusCode);
            yield TrackAddtoArchiveCallState.error("${response?.statusCode}");
          }
        } catch (e) {
          print("Error:$e");
          yield TrackAddtoArchiveCallState.error("Error  $e");
        }
      }
      else if (event is DownloadCompleteEvent) {
        try {
          Response? response =
              await eventTrackListRepository.downloadCompleteInfo(
                  event.contentId, event.scoID);

          print("Downloadcompleteinfo Response ${response?.body}");

          if (response?.statusCode == 200) {
            yield DownloadCompleteState.completed(isSuccess: true);
          } else {
            print(response?.statusCode);
            yield DownloadCompleteState.error("${response?.statusCode}");
          }
        } catch (e) {
          print("Error:$e");
          yield DownloadCompleteState.error("Error  $e");
        }
      }
      else if (event is TrackRemovetoArchiveCall) {
        try {
          Response? response =
              await eventTrackListRepository.updateMyLearningArchive(
                  event.isArchive, event.strContentID);

          print("UpdateMyLearningArchive Response ${response?.body}");

          if (response?.statusCode == 200) {
            yield TrackRemovetoArchiveCallState.completed(isScusses: true);
          } else {
            print(response?.statusCode);
            yield TrackRemovetoArchiveCallState.error(
                "${response?.statusCode}");
          }
        } catch (e) {
          print("Error:$e");
          yield TrackRemovetoArchiveCallState.error("Error  $e");
        }
      }
      else if (event is TrackRemoveFromMyLearning) {
        try {
          yield TrackRemoveFromMyLearningState.loading('Please wait...');

          var strUserID = await sharePrefGetString(sharedPref_userid);
          var strSiteID = await sharePrefGetString(sharedPref_siteid);

          String urlStr =
              "${ApiEndpoints.removeFromMyLearning(event.contentId, strUserID, strSiteID)}";

          Response? response = await RestClient.getPostData(urlStr);
          print('removeFrommyLearning $response');
          if (response?.statusCode == 200) {
            if ((response?.body ?? "") == 'true') {
              yield TrackRemoveFromMyLearningState.completed(response: true);
            } else {
              yield TrackRemoveFromMyLearningState.error("Error");
            }
          } else if (response?.statusCode == 401) {
            yield TrackRemoveFromMyLearningState.error("401");
          } else {
            yield TrackRemoveFromMyLearningState.error("Error");
          }
        } catch (e) {
          print("Error:$e");
          yield TrackRemoveFromMyLearningState.error("Error  $e");
        }
      }
      else if (event is TrackListResources) {
        try {
          refItem.clear();
          Response? response =
              await eventTrackListRepository.getTrackResources(event.contentId);
          if (response?.statusCode == 200) {
            TracklistTabResource tabResource =
                tracklistResourceFromJson(response?.body ?? "{}");
            refItem = tabResource.references.referenceItem;
            yield TrackListResourceState.completed(response: true);
          } else if (response?.statusCode == 401) {
            yield TrackListResourceState.error("401");
          } else {
            yield TrackListResourceState.error("Error ");
          }

          print('trackrespurceresponse ${response?.body}');
        } catch (e) {
          print("Error:$e");
          yield TrackListResourceState.error("Error  $e");
        }
      }
      else if (event is TrackListGlossary) {
        try {
          glossaryExpandable.clear();

          Response? response =
              await eventTrackListRepository.getTrackGlossary(event.contentId);

          if (response?.statusCode == 200) {
            tabGlossary = trackListGlossaryTabFromJson(response?.body ?? "[]");

            setGlossaryDynamiclist(tabGlossary);

            print('trackr_glossary ${tabGlossary.toString()}');

            yield TrackListGlossaryState.completed(response: true);
          } else if (response?.statusCode == 401) {
            yield TrackListGlossaryState.error("401");
          } else {
            yield TrackListGlossaryState.error("Error");
          }
        } catch (e) {
          print("Error:$e");
          yield TrackListGlossaryState.error("Error  $e");
        }
      }
      else if (event is TrackSetComplete) {
        yield TrackSetCompleteState.loading('Loading...please wait');

        try {
          Response? response = await eventTrackListRepository.setCompleteStatus(
              event.contentId, event.scoId);
          if (response?.statusCode == 200) {
            yield TrackSetCompleteState.completed(
                isCompleted: true, table2: event.table2);
          } else if (response?.statusCode == 401) {
            yield TrackSetCompleteState.error("401");
          } else {
            yield TrackSetCompleteState.error("Something went wrong");
          }
        } catch (e) {
          print("Error:$e");
          yield TrackSetCompleteState.error("Something went wrong");
        }
      }
      else if (event is TrackListOverView) {
        yield TrackListOverViewState.loading('Loading...please wait');
        bool response =
            await getOverviewData(event.contentId, event.objecttypeid);

        if (response) {
          yield TrackListOverViewState.completed(isCompleted: true);
        } else if (statusCode == '401') {
          yield TrackListOverViewState.error("401");
        } else {
          yield TrackListOverViewState.error("Something went wrong");
        }
      }
      else if (event is TrackGetContentStatus) {
        yield TrackGetContentStatusState.loading('Please wait...');
        Response? response;

        try {
          response = await RestClient.getPostData(event.url);
        } catch (e) {
          print("repo Error $e");
        }

        print('getcontentstatusres ${response?.body}');

        if (response?.statusCode == 200) {
          ContentstatusResponse contentResponse =
              contentstatusResponseFromJson(response?.body ?? "{}");

          yield TrackGetContentStatusState.completed(
              contentstatus: contentResponse.contentstatus[0],
              table2: event.table2);
        } else if (response?.statusCode == 401) {
          yield TrackGetContentStatusState.error("401");
        } else {
          yield TrackGetContentStatusState.error("Something went wrong");
        }
      }
      else if (event is ParentTrackGetContentStatus) {
        yield ParentTrackGetContentStatusState.loading('Please wait...');
        Response? response;

        try {
          response = await RestClient.getPostData(event.url);
        } catch (e) {
          print("repo Error $e");
        }

        print('getcontentstatusres ${response?.body}');

        if (response?.statusCode == 200) {
          ContentstatusResponse contentResponse =
              contentstatusResponseFromJson(response?.body ?? "{}");

          /*Map<String, dynamic> map = {};

          try {
            map = jsonDecode(response?.body ?? "{}");
          }
          catch(e, s) {
            print("Error in Decoding String to Map:${e}");
            print(s);
          }

          Contentstatus contentstatus = Contentstatus(
            progress: map['percentagecompleted'] ?? "0",
            status: map['ContentStatus'] ?? "",
            contentStatus: map['DisplayStatus'] ?? "",
          );*/

          yield ParentTrackGetContentStatusState.completed(
              contentstatus: contentResponse.contentstatus[0],
              table2: event.table2);
        } else if (response?.statusCode == 401) {
          yield ParentTrackGetContentStatusState.error("401");
        } else {
          yield ParentTrackGetContentStatusState.error("Something went wrong");
        }
      }
      else if (event is BadCancelEnrollment) {
        yield BadCancelEnrollmentState.loading('Please wait...');
        Response? response;

        try {
          response =
              await eventTrackListRepository.badCancelEnroll(event.contentid);
        } catch (e) {
          print("repo Error $e");
        }

        if (response?.statusCode == 200) {
          yield BadCancelEnrollmentState.completed(
              isSuccess: response?.toString() ?? "{}");
        } else if (response?.statusCode == 401) {
          yield BadCancelEnrollmentState.error("401");
        } else {
          yield BadCancelEnrollmentState.error("Something went wrong");
        }
      }
      else if (event is TrackCancelEnrollment) {
        yield CancelEnrollmentState.loading('Please wait...');
        Response? response;

        try {
          response = await eventTrackListRepository.cancelEnroll(
              event.strContentID, event.isBadCancel);
        } catch (e) {
          print("repo Error $e");
        }

        print('TrackCancelEnrollment $response  ${response?.statusCode}');

        if (response?.statusCode == 200) {
          yield CancelEnrollmentState.completed(
              isSuccess: response?.body ?? "{}");
        } else if (response?.statusCode == 401) {
          yield CancelEnrollmentState.error("401");
        } else {
          yield CancelEnrollmentState.error("Something went wrong");
        }
      }
    } catch (e, s) {
      print("Error in EVentTrackBloc.mapEventToState():$e");
      print(s);
    }
  }

  Future<bool> getLearningTrackData(bool isTraxkList, AppBloc appBloc) async {
    bool responseStatus = false;
    String paramsString = '';
    String url = '';
    String tabCollectionName = '$tracklistTabs-$contentid';
    String tracklistCollectionName = '$tracklistCollection-$contentid-${appBloc.userid}';

    try {
      if (isTraxkList) {
        paramsString = "SiteURL=" +
            siteurl +
            "&ContentID=" +
            contentid +
            "&UserID=" +
            userid +
            "&DelivoryMode=1&IsDownload=0&TrackObjectTypeID=" +
            objecttypeid +
            "&TrackScoID=" +
            scoid +
            "&SiteID=" +
            strSiteID +
            "&OrgUnitID=" +
            siteid +
            "&localeId=" +
            language;

        url = webApiUrl +
            "/MobileLMS/MobileGetMobileContentMetaData?" +
            paramsString;
      }
      else {
        paramsString = "contentId=" +
            contentid +
            "&userId=" +
            userid +
            "&locale=" +
            language +
            "&siteid=" +
            strSiteID +
            "&parentcomponentid=1&categoryid=-1";

//        contentId=c7d4993d-9a01-4e6e-8a2d-5fed54688eb6&userId=307&locale=en-us&siteid=374&parentcomponentid=1&categoryid=-1

        url = webApiUrl +
            "/MobileLMS/GetMobileEventRelatedContentMetadata?" +
            paramsString;
      }

      logger.e(".....MobileGetMobileContentMetaData....$url");

      ApiResponse? apiResponse =
          await eventTrackListRepository.mobileGetMobileContentMetaData(url);
      resEventTrackTabs.clear();
      tempTabs.clear();
      overviewResponse.clear();

      if (apiResponse?.status != 200) {
        throw new Exception('apiResponse error: ${apiResponse?.status}');
      }

      Response? responseTab = await getEventTrackTabs();

      print('restracktabs $responseTab');

      if (responseTab?.statusCode != 200) {
        throw new Exception('responseTab error: ${responseTab?.statusCode}');
      }

      tempTabs = resEventTrackTabsFromJson(responseTab?.body ?? "[]");

      /// delete track tabs from HiveDB
      // await HiveDbHandler().deleteData(tracklistTabs);

      if (tempTabs.length == 1 &&
          (tempTabs[0].tabId == 1 || tempTabs[0].tabidName.isEmpty)) {
        resEventTrackTabs.clear();
      } else {
        resEventTrackTabs = tempTabs;

        /// Save track tabs to HiveDB
        ResEventTrackTabsList trackTabsList =
            ResEventTrackTabsList(resEventTrackTabs);
        Map<String, dynamic> trackTabsListJson = trackTabsList.toJson();

        await HiveDbHandler().createData(
          tabCollectionName,
          contentid,
          trackTabsListJson,
        );
      }

      Response? response = apiResponse?.data;
      //MyPrint.logOnConsole("MobileGetMobileContentMetaData Data:${response?.body}");

      trackListData.clear();

      if (isTraxkList) {
        var map = json.decode(response?.body ?? "{}");

        ResBlockTrack resBlockTrack =
            resBlockTrackFromJson(json.encode(map ?? {}));

        ResTrackList resTrackList =
            resTrackListFromJson(json.encode(map ?? {}));

        List<Table5> table5 = resTrackList.table5;
        List<Table6> table6 = resBlockTrack.table6;

        trackBlockList.clear();

        //region To Add Content Data in SQL
        List courses = map["table5"];
        for (Map<String, dynamic> course in courses) {
          MyLearningModel myLearningModelTemp = MyLearningModel.fromJson(course);
          myLearningModelTemp.siteID = this.siteid;
          myLearningModelTemp.siteURL = this.siteurl;
          myLearningModelTemp.trackOrRelatedContentID = this.contentid;
          myLearningModelTemp.trackScoid = this.scoid;
          myLearningModelTemp.courseAttempts = myLearningModel?.noofattempts.toString() ?? '';
          myLearningModelTemp.userID = userid;

          await SqlDatabaseHandler().injectTrackListIntoTable(myLearningModelTemp);
        }
        //endregion

        if (table5.length > 0) {
          table5.forEach((element) {
            DummyMyCatelogResponseTable2 item = DummyMyCatelogResponseTable2();

            item.objectid = element.objectid;
            item.contentid = element.contentid;
            item.objecttypeid = element.objecttypeid;
            item.mediatypeid = element.mediatypeid;
            item.folderpath = element.folderpath;
            item.startpage = element.startpage;
            item.name = element.name;
            item.userid = int.parse(userid);
            item.iconpath =
                "Content/SiteFiles/ContentTypeIcons/" + element.iconpath;
            item.siteid = int.parse(this.siteid);

            item.downloadable = element.downloadable;
            item.viewtype = element.viewtype;
            item.saleprice = element.saleprice;
            item.scoid = element.scoid;
            item.thumbnailimagepath = element.thumbnailimagepath;
            item.contenttypethumbnail = element.contenttypethumbnail;
            item.medianame = element.medianame;
            item.version = element.version;
            item.author = element.author;
            item.devicetypeid = element.devicetypeid;
            item.listprice = element.listprice;
            item.currency = element.currency;
            item.shortdescription = element.shortdescription;

            item.longdescription = element.longdescription?.toString() ?? "";
            //item.createddate=element.createddate;

            item.eventstartdatetime = element.eventstartdatetime;
            item.eventenddatetime = element.eventenddatetime;
            item.bit5 = element.bit5;

            item.participanturl = element.participanturl;
            item.timezone = element.timezone;

            //item.eventfulllocation=element.eventfulllocation;

            //  item.objectfolderid=element.objectfolderid;

            // item.parentid=element.parentid;

            // item.sequencenumber=element.sequencenumber;

            item.jwvideokey = element.jwvideokey;
            item.cloudmediaplayerkey = element.cloudmediaplayerkey;
            item.ratingid = element.ratingid;
            // item.presentername=element.presentername;

            item.percentcompleted = element.percentcompleted;
            item.corelessonstatus = element.corelessonstatus;
            item.actualstatus = element.actualstatus;
            item.jwstartpage = element.jwstartpage;
            //tem.eventid=element.eventid;

            item.eventtype = element.eventtype;
            item.typeofevent = element.typeofevent;
            item.activityid = element.activityid;

            item.progress = element.progress;
            // item.actionviewqrcode=element.actionviewqrcode;
            item.qrimagename = element.qrimagename;
            item.parentid = element.parentid;

            item.allowednavigation = element.allowednavigation;
            item.wstatus = element.wstatus;

            trackListData.add(item);
          });
        }

        if (table6.isNotEmpty) {
          List<ResTrackBlocksList> blockList = [];
          // List<DummyMyCatelogResponseTable2> blockChildList = [];

          logger.e(
              ".....i am block data please make me in list...${table6.length}....");

          for (Table6 blocks in table6) {
            for (DummyMyCatelogResponseTable2 content in trackListData) {
              if (content.parentid == blocks.blockid) {
                content.blockName = blocks.blockname;
              }
            }
          }

          singleTempLATE.clear();
          for (Table6 blocks in table6) {
            //print('allblockss ${blocks.blockname} ${trackListData.length}');

            for (DummyMyCatelogResponseTable2 content in trackListData) {
              //print('mycontentBlock ${content.blockName} ');

              if (content.blockName.isNotEmpty) {
                singleTempLATE.add(content);
              }
            }
          }

          //print('singletemplatelength ${singleTempLATE.length}');

          final blc = table6.map((e) => e.blockname).toSet();
          table6.retainWhere((x) => blc.remove(x.blockname));

          print('table6_length ${table6.length}');

          for (Table6 blocks in table6) {
            print('allblockss ${blocks.blockname} ${trackListData.length}');
            List<DummyMyCatelogResponseTable2> blockChildList = [];

            for (DummyMyCatelogResponseTable2 content in trackListData) {
              print('mycontentBlock ${content.blockName} ');

              if (content.blockName == blocks.blockname) {
                blockChildList.add(content);
              }
            }

            print('blocklisr $blockChildList');

            blockList.add(ResTrackBlocksList(
                block: blocks.blockname, data: blockChildList));
//
          }

          trackBlockList = blockList;
        }
      }
      else {
        RelatedContentEventResponse relatedContentEventResponse =
            relatedContentEventResponseFromJson(response?.body ?? "{}");
        List<Eventrelatedcontentdatum> contentData =
            relatedContentEventResponse.eventrelatedcontentdata;

        if (contentData.length > 0) {
          contentData.forEach((element) {
            DummyMyCatelogResponseTable2 item = DummyMyCatelogResponseTable2();

            item.objectid = element.objectid;
            item.contentid = element.contentid;
            item.objecttypeid = element.objecttypeid;
            item.mediatypeid = element.mediatypeid;
            item.folderpath = element.folderpath;
            item.startpage = element.startpage;
            item.name = element.name;
            item.userid = int.parse(userid);
            item.iconpath = element.iconpath;

            item.downloadable = element.downloadable;
            item.viewtype = element.viewtype;
//              item.saleprice = element.saleprice;
            item.scoid = element.scoid;
            item.thumbnailimagepath = element.thumbnailimagepath;
            item.contenttypethumbnail = element.contenttypethumbnail;
            item.medianame = element.medianame;
            item.version = element.version;
            item.author = element.author;
            item.devicetypeid = element.devicetypeid;
//              item.listprice = element.listprice;
//              item.currency = element.currency;
            item.shortdescription = element.shortdescription;

            item.longdescription = element.longdescription;
            //item.createddate=element.createddate;

//              item.eventstartdatetime = element.eventstartdatetime;
//              item.eventenddatetime = element.eventenddatetime;
            item.bit5 = element.bit5 ?? false;

//              item.participanturl = element.participanturl;
//              item.timezone = element.timezone;

            //item.eventfulllocation=element.eventfulllocation;

            //  item.objectfolderid=element.objectfolderid;

            // item.parentid=element.parentid;

            // item.sequencenumber=element.sequencenumber;

            item.jwvideokey = element.jwvideokey;
            item.cloudmediaplayerkey = element.cloudmediaplayerkey;
            item.ratingid = element.ratingid;
            // item.presentername=element.presentername;

            item.percentcompleted = element.percentcompleted;
            item.corelessonstatus = element.corelessonstatus;
            item.actualstatus = element.actualstatus;
//              item.jwstartpage = element.jwstartpage;
            //tem.eventid=element.eventid;

//              item.eventtype = element.eventtype;
//              item.typeofevent = element.typeofevent;
            item.activityid = element.activityid;

//              item.progress = element.progress;
            // item.actionviewqrcode=element.actionviewqrcode;
//              item.qrimagename = element.qrimagename;
//              item.parentid = element.parentid;

            trackListData.add(item);
          });
        }
      }

      /// add track course data to offline
      {
        List<Future> futures = [];
        for(DummyMyCatelogResponseTable2 tempTable2 in trackListData) {
          futures.add(HiveDbHandler().createData(
            tracklistCollectionName,
            tempTable2.contentid,
            tempTable2.toJson(),
          ));
        }
        await Future.wait(futures);
      }

      List<String> contentOrder = trackListData.map((e) => e.contentid).toList();
      Map<String, dynamic> contentOrderMap = {'data': jsonEncode(contentOrder)};
      await HiveDbHandler().createData(tracklistCollectionName, 'contentOrder', contentOrderMap);

      await setImageData(trackListData, isTraxkList, appBloc);
      print("Checking Files:${trackListData.length}");
      await checkifFileExist(contentid, trackListData, appBloc);
      print("Check Finished");

      await callMobileGetContentTrackedData(myLearningModel!);

      responseStatus = true;
    } catch (e, s) {
      // network or 401 error
      statusCode = '401';
      MyPrint.printOnConsole("Error:$e");
      MyPrint.printOnConsole(s);

      /// get track tabs
      var tabData = await HiveDbHandler().readData(tabCollectionName);

      var courseData = await HiveDbHandler().readData(tracklistCollectionName);


      /// by default, hive will return an empty object.
      /// If there is cached data, it will be returned data.
      /// If there is nothing, then it will yeild an error
      if(tabData.isNotEmpty) {
        /// Set track tab data
        Map<String, dynamic> trackTabsMap = Map.castFrom(tabData[0]);
        tempTabs = ResEventTrackTabsList.fromJson(trackTabsMap).tabList;
        resEventTrackTabs = tempTabs;
      }
      if (courseData.isNotEmpty) {
        /// Set track course data
        trackListData.clear();
        List<dynamic> contentOrder = [];
        List<DummyMyCatelogResponseTable2> trackListTemp = [];
        for(Map<String, dynamic> item in courseData) {
          if(item.containsKey('data')) {
            contentOrder = jsonDecode(item['data']);
          } else {
            DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
            table2.fromJson(item);
            if(table2.contentid.isNotEmpty) {
              trackListTemp.add(table2);
            }
            else {
              HiveDbHandler().deleteData(tracklistCollectionName, keys: [""]);
            }
          }
        }
        contentOrder.forEach((element) {
          int index = trackListTemp.indexWhere((item) => item.contentid == element);
          if(index != -1) {
            trackListData.add(trackListTemp[index]);
          }
        });
        // trackListData.sort((a, b) => a.name.compareTo(b.name));
        await setImageData(trackListData, isTraxkList, appBloc);
        await checkifFileExist(contentid, trackListData, appBloc);

        responseStatus = true;
      }
    }

    return responseStatus;
  }

  Future<bool> getLearningTrackData2(bool isTraxkList, AppBloc appBloc) async {
    bool responseStatus = false;
    String paramsString = '';
    String url = '';
    String tabCollectionName = '$tracklistTabs-$contentid';
    String tracklistCollectionName = '$tracklistCollection-$contentid-${appBloc.userid}';

    try {
      if (isTraxkList) {
        var strComponentID = await sharePrefGetString(sharedPref_ComponentID);
        var strRepositoryId = await sharePrefGetString(sharedPref_RepositoryId);

        paramsString = "parentcontentID=$contentid&siteID=$strSiteID&userID=$userid&localeID=$language&compID$strComponentID=&"
            "compInsID=$strRepositoryId&objecttypeId=$objecttypeid&Trackscoid=$scoid&TRAutoshow=&lIndex=&SampleContentCount=&"
            "TrackFreeSample=false&isAssignmentTab=false&isAssignmentTabEnabled=false&wLaunchType=onlaunch";

        url = webApiUrl + "/TrackListView/GetTrackListViewData?" + paramsString;
      }
      else {
        paramsString = "contentId=" +
            contentid +
            "&userId=" +
            userid +
            "&locale=" +
            language +
            "&siteid=" +
            strSiteID +
            "&parentcomponentid=1&categoryid=-1";

//        contentId=c7d4993d-9a01-4e6e-8a2d-5fed54688eb6&userId=307&locale=en-us&siteid=374&parentcomponentid=1&categoryid=-1

        url = webApiUrl +
            "/MobileLMS/GetMobileEventRelatedContentMetadata?" +
            paramsString;
      }

      logger.e(".....MobileGetMobileContentMetaData....$url");

      ApiResponse? apiResponse = await eventTrackListRepository.mobileGetMobileContentMetaData(url);
      resEventTrackTabs.clear();
      tempTabs.clear();
      overviewResponse.clear();

      if (apiResponse?.status != 200) {
        throw new Exception('apiResponse error: ${apiResponse?.status}');
      }

      Response? responseTab = await getEventTrackTabs();

      print('restracktabs $responseTab');

      if (responseTab?.statusCode != 200) {
        throw new Exception('responseTab error: ${responseTab?.statusCode}');
      }

      tempTabs = resEventTrackTabsFromJson(responseTab?.body ?? "[]");

      /// delete track tabs from HiveDB
      // await HiveDbHandler().deleteData(tracklistTabs);

      if (tempTabs.length == 1 && (tempTabs[0].tabId == 1 || tempTabs[0].tabidName.isEmpty)) {
        resEventTrackTabs.clear();
      }
      else {
        resEventTrackTabs = tempTabs;

        /// Save track tabs to HiveDB
        ResEventTrackTabsList trackTabsList =
        ResEventTrackTabsList(resEventTrackTabs);
        Map<String, dynamic> trackTabsListJson = trackTabsList.toJson();

        await HiveDbHandler().createData(
          tabCollectionName,
          contentid,
          trackTabsListJson,
        );
      }

      //To Get Track List Data
      Response? response = apiResponse?.data;
      //MyPrint.logOnConsole("MobileGetMobileContentMetaData Data:${response?.body}");

      trackListData.clear();

      if (isTraxkList) {
        var map = json.decode(response?.body ?? "{}");

        TrackListViewModel resBlockTrack = trackListViewModelFromJson(json.encode(map ?? {}));

        trackBlockList.clear();

        //region To Add Content Data in SQL
        /*List courses = map["table5"];
        for (Map<String, dynamic> course in courses) {
          MyLearningModel myLearningModelTemp = MyLearningModel.fromJson(course);
          myLearningModelTemp.siteID = this.siteid;
          myLearningModelTemp.siteURL = this.siteurl;
          myLearningModelTemp.trackOrRelatedContentID = this.contentid;
          myLearningModelTemp.trackScoid = this.scoid;
          myLearningModelTemp.courseAttempts =
              myLearningModel?.noofattempts.toString() ?? '';
          myLearningModelTemp.userID = userid;

          await SqlDatabaseHandler().injectTrackListIntoTable(myLearningModelTemp);
        }*/
        //endregion

        resBlockTrack.tracklistData.forEach((TrackListViewTrackDataModel trackDataModel) {
          ResTrackBlocksList resTrackBlocksList = ResTrackBlocksList(data: [], block: trackDataModel.blockname);

          trackDataModel.trackList.forEach((TrackListModel element) {
            DummyMyCatelogResponseTable2 item = DummyMyCatelogResponseTable2();

            /*item.objectid = element.contentID;
            item.contentid = element.contentID;
            item.objecttypeid = element.objecttypeid;
            item.mediatypeid = element.mediatypeid;
            item.folderpath = element.folderpath;
            item.startpage = element.startpage;
            item.name = element.name;
            item.userid = int.parse(userid);
            item.iconpath =
                "Content/SiteFiles/ContentTypeIcons/" + element.iconpath;
            item.siteid = int.parse(this.siteid);

            item.downloadable = element.downloadable;
            item.viewtype = element.viewtype;
            item.saleprice = element.saleprice;
            item.scoid = element.scoid;
            item.thumbnailimagepath = element.thumbnailimagepath;
            item.contenttypethumbnail = element.contenttypethumbnail;
            item.medianame = element.medianame;
            item.version = element.version;
            item.author = element.author;
            item.devicetypeid = element.devicetypeid;
            item.listprice = element.listprice;
            item.currency = element.currency;
            item.shortdescription = element.shortdescription;

            item.longdescription = element.longdescription?.toString() ?? "";
            //item.createddate=element.createddate;

            item.eventstartdatetime = element.eventstartdatetime;
            item.eventenddatetime = element.eventenddatetime;
            item.bit5 = element.bit5;

            item.participanturl = element.participanturl;
            item.timezone = element.timezone;

            //item.eventfulllocation=element.eventfulllocation;

            //  item.objectfolderid=element.objectfolderid;

            // item.parentid=element.parentid;

            // item.sequencenumber=element.sequencenumber;

            item.jwvideokey = element.jwvideokey;
            item.cloudmediaplayerkey = element.cloudmediaplayerkey;
            item.ratingid = element.ratingid;
            // item.presentername=element.presentername;

            item.percentcompleted = element.percentcompleted;
            item.corelessonstatus = element.corelessonstatus;
            item.actualstatus = element.actualstatus;
            item.jwstartpage = element.jwstartpage;
            //tem.eventid=element.eventid;

            item.eventtype = element.eventtype;
            item.typeofevent = element.typeofevent;
            item.activityid = element.activityid;

            item.progress = element.progress;
            // item.actionviewqrcode=element.actionviewqrcode;
            item.qrimagename = element.qrimagename;
            item.parentid = element.parentid;
*/
            trackListData.add(item);
          });
        });
      }
      else {
        RelatedContentEventResponse relatedContentEventResponse =
        relatedContentEventResponseFromJson(response?.body ?? "{}");
        List<Eventrelatedcontentdatum> contentData =
            relatedContentEventResponse.eventrelatedcontentdata;

        if (contentData.length > 0) {
          contentData.forEach((element) {
            DummyMyCatelogResponseTable2 item = DummyMyCatelogResponseTable2();

            item.objectid = element.objectid;
            item.contentid = element.contentid;
            item.objecttypeid = element.objecttypeid;
            item.mediatypeid = element.mediatypeid;
            item.folderpath = element.folderpath;
            item.startpage = element.startpage;
            item.name = element.name;
            item.userid = int.parse(userid);
            item.iconpath = element.iconpath;

            item.downloadable = element.downloadable;
            item.viewtype = element.viewtype;
//              item.saleprice = element.saleprice;
            item.scoid = element.scoid;
            item.thumbnailimagepath = element.thumbnailimagepath;
            item.contenttypethumbnail = element.contenttypethumbnail;
            item.medianame = element.medianame;
            item.version = element.version;
            item.author = element.author;
            item.devicetypeid = element.devicetypeid;
//              item.listprice = element.listprice;
//              item.currency = element.currency;
            item.shortdescription = element.shortdescription;

            item.longdescription = element.longdescription;
            //item.createddate=element.createddate;

//              item.eventstartdatetime = element.eventstartdatetime;
//              item.eventenddatetime = element.eventenddatetime;
            item.bit5 = element.bit5 ?? false;

//              item.participanturl = element.participanturl;
//              item.timezone = element.timezone;

            //item.eventfulllocation=element.eventfulllocation;

            //  item.objectfolderid=element.objectfolderid;

            // item.parentid=element.parentid;

            // item.sequencenumber=element.sequencenumber;

            item.jwvideokey = element.jwvideokey;
            item.cloudmediaplayerkey = element.cloudmediaplayerkey;
            item.ratingid = element.ratingid;
            // item.presentername=element.presentername;

            item.percentcompleted = element.percentcompleted;
            item.corelessonstatus = element.corelessonstatus;
            item.actualstatus = element.actualstatus;
//              item.jwstartpage = element.jwstartpage;
            //tem.eventid=element.eventid;

//              item.eventtype = element.eventtype;
//              item.typeofevent = element.typeofevent;
            item.activityid = element.activityid;

//              item.progress = element.progress;
            // item.actionviewqrcode=element.actionviewqrcode;
//              item.qrimagename = element.qrimagename;
//              item.parentid = element.parentid;

            trackListData.add(item);
          });
        }
      }

      /// add track course data to offline
      for(DummyMyCatelogResponseTable2 tempTable2 in trackListData) {
        await HiveDbHandler().createData(
          tracklistCollectionName,
          tempTable2.contentid,
          tempTable2.toJson(),
        );
      }
      List<String> contentOrder = trackListData.map((e) => e.contentid).toList();
      Map<String, dynamic> contentOrderMap = {'data': jsonEncode(contentOrder)};
      await HiveDbHandler().createData(tracklistCollectionName, 'contentOrder', contentOrderMap);

      await setImageData(trackListData, isTraxkList, appBloc);
      print("Checking Files:${trackListData.length}");
      await checkifFileExist(contentid, trackListData, appBloc);
      print("Check Finished");

      await callMobileGetContentTrackedData(myLearningModel!);

      responseStatus = true;
    }
    catch (e, s) {
      // network or 401 error
      statusCode = '401';
      MyPrint.printOnConsole("Error:$e");
      MyPrint.printOnConsole(s);

      /// get track tabs
      var tabData = await HiveDbHandler().readData(tabCollectionName);

      var courseData = await HiveDbHandler().readData(tracklistCollectionName);


      /// by default, hive will return an empty object.
      /// If there is cached data, it will be returned data.
      /// If there is nothing, then it will yeild an error
      if(tabData.isNotEmpty) {
        /// Set track tab data
        Map<String, dynamic> trackTabsMap = Map.castFrom(tabData[0]);
        tempTabs = ResEventTrackTabsList.fromJson(trackTabsMap).tabList;
        resEventTrackTabs = tempTabs;
      }
      if (courseData.isNotEmpty) {
        /// Set track course data
        trackListData.clear();
        List<dynamic> contentOrder = [];
        List<DummyMyCatelogResponseTable2> trackListTemp = [];
        for(Map<String, dynamic> item in courseData) {
          if(item.containsKey('data')) {
            contentOrder = jsonDecode(item['data']);
          } else {
            DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
            table2.fromJson(item);
            if(table2.contentid.isNotEmpty) {
              trackListTemp.add(table2);
            }
            else {
              HiveDbHandler().deleteData(tracklistCollectionName, keys: [""]);
            }
          }
        }
        contentOrder.forEach((element) {
          int index = trackListTemp.indexWhere((item) => item.contentid == element);
          if(index != -1) {
            trackListData.add(trackListTemp[index]);
          }
        });
        // trackListData.sort((a, b) => a.name.compareTo(b.name));
        await setImageData(trackListData, isTraxkList, appBloc);
        await checkifFileExist(contentid, trackListData, appBloc);

        responseStatus = true;
      }
    }

    return responseStatus;
  }

  Future<bool> getOverviewData(String contentId, int objecttypeid) async {
    bool responseStatus = false;
    String collectionName = '$trackOverviewData-$contentid';

    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      Response? response = await eventTrackListRepository.getOverview(
          contentId, objecttypeid, strUserID);

      if (response?.statusCode != 200) {
        throw new Exception('apiResponse error: ${response?.statusCode}');
      }
      String data = response?.body ?? "[]";

      overviewResponse = tracklistOverviewResponseFromJson(data);
      tag = '';

      Map<String, dynamic> mappedData = {};
      for (int i = 0; i < overviewResponse.length; i++) {
        mappedData['$i'] = overviewResponse[i].toJson();
      }

      /// add track course data to offline
      await _localHelper.localService(
        enumLocalDatabaseOperation: LocalDatabaseOperation.delete,
        table: collectionName,
      );
      await _localHelper.localService(
        enumLocalDatabaseOperation: LocalDatabaseOperation.create,
        table: collectionName,
        values: mappedData,
      );

      responseStatus = true;
    } catch (err) {
      // network or 401 error
      statusCode = '401';

      /// get track tabs
      var overviewData = await _localHelper.localService(
        enumLocalDatabaseOperation: LocalDatabaseOperation.read,
        table: collectionName,
      );

      if (overviewData.isNotEmpty) {
        Map<String, dynamic> data = overviewData[0] as Map<String, dynamic>;
        List<TracklistOverviewResponse> listdata = data.values
            .map((e) => TracklistOverviewResponse.fromJson(e))
            .toList();
        overviewResponse = listdata;
      }
    }

    if (overviewResponse.isNotEmpty &&
        overviewResponse[0].relatedTags.isNotEmpty) {
      relatedTag = overviewResponse[0].relatedTags;

      for (RelatedTag relatedTag in relatedTag) {
        tag = tag + relatedTag.tag;
      }
    }

    return responseStatus;
  }

  /// need to check when working in Events

/*
  Future<void> refreshMyLearning(bool isRefreshed, bool isEvent) async {

    if (isEvent)
    {
      String paramsString = "contentId=" + contentid
          + "&userId=" + userid
          + "&locale=" + language + "&siteid=" + siteid
          + "&parentcomponentid=1&categoryid=-1";

      String url = webApiUrl + "/MobileLMS/GetMobileEventRelatedContentMetadata?" + paramsString;

      logger.e(".....GetMobileEventRelatedContentMetadata....$url");
    }
    else
    {
      String paramsString = "SiteURL=" + siteurl + "&ContentID=" + contentid + "&UserID="
          + userid + "&DelivoryMode=1&IsDownload=0&TrackObjectTypeID=" + objecttypeid + "&TrackScoID=" + scoid
          + "&SiteID=" + strSiteID + "&OrgUnitID=" + siteid + "&localeId=" + language;

      String url = webApiUrl + "/MobileLMS/MobileGetMobileContentMetaData?" + paramsString;

      logger.e(".....MobileGetMobileContentMetaData....$url");




    }



  }*/

  Future<void> setImageData(List<DummyMyCatelogResponseTable2> list, bool isTraxkList, AppBloc appBloc) async {
    if (isTraxkList) {
      for (DummyMyCatelogResponseTable2 table2 in list) {
        table2.imageData = ApiEndpoints.strSiteUrl + table2.thumbnailimagepath;
      }
    }
    else {
      String imagePathSet = '';
      if (appBloc.uiSettingModel.isCloudStorageEnabled == 'true') {
        imagePathSet =
            appBloc.uiSettingModel.azureRootPath + "content/sitefiles/Images/";
      } else {
        imagePathSet = ApiEndpoints.strSiteUrl + "/content/sitefiles/Images/";
      }

      for (DummyMyCatelogResponseTable2 table2 in list) {
        table2.imageData = imagePathSet + table2.contenttypethumbnail.trim();
      }
    }
  }

  //region file actions
  Future<void> checkifFileExist(String parentContentId, List<DummyMyCatelogResponseTable2> list, AppBloc appBloc) async {
    Map<String, bool> removedFromDownloadsMap = await MyLearningDownloadController().getRemovedFromDownloadMap();
    MyPrint.printOnConsole("removedFromDownloadsMap:$removedFromDownloadsMap");

    for (DummyMyCatelogResponseTable2 table2 in list) {
      String contentId = "${parentContentId}_${table2.contentid}";
      //MyPrint.printOnConsole("checkifFileExist called for contentid:${contentId}");
      if(removedFromDownloadsMap[contentId] != true) {
        // String downloadDestFolderPath = await generateDownloadPath(parentContentId, table2, appBloc);
        //MyPrint.printOnConsole("checking exist for downloadDestFolderPath:${downloadDestFolderPath}");
        // table2.isdownloaded = await checkFile(downloadDestFolderPath);
        table2.isdownloaded = false;
        //MyPrint.printOnConsole("isdownloaded for ${contentId} with name:${table2.name}:${table2.isdownloaded}");
      }
      else {
        table2.isdownloaded = false;
      }
    }
  }

  Future<String> generateDownloadPath(String parentId, DummyMyCatelogResponseTable2 table2, AppBloc appBloc) async {
    String pathSeparator = MyLearningDownloadController().pathSeparator;
    String downloadDestFolderPath = await AppDirectory.getDocumentsDirectory()
        + "$pathSeparator.Mydownloads${pathSeparator}Contentdownloads$pathSeparator"
        + "$parentId$pathSeparator${table2.contentid}-${appBloc.userid}";

    return downloadDestFolderPath;
  }

  Future<bool> checkFile(String path) async {
    final savedDir = Directory(path);
    return await savedDir.exists();
  }

  Future<bool> deleteFile(String downloadDestFolderPath) async {
    try {
      final savedDir = Directory(downloadDestFolderPath);
      bool exists = await savedDir.exists();
      if (exists) {
        await savedDir.delete(recursive: true);
      }
      return exists;
    } catch (e) {
      return false;
    }
  }

  //endregion file actions

  Future<Response?> getEventTrackTabs() async {
    // List<ResEventTrackTabs> resEventTrackTabs = [];
    String paramsString = "parentcontentID=" +
        contentid +
        "&siteID=" +
        strSiteID +
        "&userID=" +
        userid +
        "&localeID=" +
        language +
        "&compID=3&compInsID=3134" +
        "&objecttypeid=" +
        objecttypeid +
        "&isRelatedContent=true";

    String url = webApiUrl + "EventTrackTabs/GetEventTrackTabs?" + paramsString;

    logger.e("......getEventTrackTabs...$url");
    Response? response = await eventTrackListRepository.getEventTrackTabs(url);

    return response;
  }

  Future<void> callMobileGetContentTrackedData(
      DummyMyCatelogResponseTable2 myLearningModel) async {
    String paramsString = "_studid=" +
        myLearningModel.userid.toString() +
        "&_scoid=" +
        myLearningModel.scoid.toString() +
        "&_SiteURL=" +
        myLearningModel.siteurl +
        "&_contentId=" +
        myLearningModel.contentid +
        "&_trackId=";

    String url =
        webApiUrl + "/MobileLMS/MobileGetContentTrackedData?" + paramsString;

    print("......callMobileGetContentTrackedData........");
    print("......$url........");

    GeneralRepository generalRepository = GeneralRepositoryBuilder.repository();
    ApiResponse? apiResponse =
        await generalRepository.getContentTrackedData(url);

    // ResCmiData? resCmiData = apiResponse?.data;

    // List<Cmi> jsonCMiAry = resCmiData?.cmi ?? [];
    // List<Learnersession> jsonLearnerSessionAry =
    //     resCmiData?.learnersession ?? [];
    // List<Studentresponse> jsonStudentAry = resCmiData?.studentresponse ?? [];

    logger.e(
        "....callMobileGetContentTrackedData...status...${apiResponse?.status}");
  }

  void setGlossaryDynamiclist(List<TrackListGlossaryTab> tabGlossary) {
    for (TrackListGlossaryTab val in tabGlossary) {
      glossaryExpandable
          .add(GlossaryExpandable(charName: val.type, glossaryitem: []));
    }

    for (GlossaryExpandable expandable in glossaryExpandable) {
      List<GlossaryItem> glossaryList = [];

      for (TrackListGlossaryTab val in tabGlossary) {
        if (val.type == expandable.charName) {
          glossaryList
              .add(GlossaryItem(title: val.text, description: val.meaning));
        }
        expandable.glossaryitem = glossaryList;
      }
    }

    for (GlossaryItem expandable in glossaryExpandable[1].glossaryitem) {
      print('expandedlistdata ${expandable.title} ${expandable.description}');
    }
  }
}
