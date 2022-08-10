import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_review_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning_details_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/mylearning_details_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_details_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/database/hivedb_handler.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/general/model/content_status_response.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/contract/mylearning_repositry.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_public.dart';

class MyLearningDetailsBloc extends Bloc<MyLearningDetailsEvent, MyLearningDetailsState> {
  MyLearningRepository myLearningRepository;
  ContentstatusResponse contentResponse = ContentstatusResponse(contentstatus: []);

  MyLearningDetailsModel myLearningDetailsModel = MyLearningDetailsModel();
  List<EditRating> userRatingDetails = [];

  MyLearningDetailsBloc({
    required this.myLearningRepository,
  }) : super(MyLearningDetailsState.completed(null)) {
    on<GetLearningDetails>(onEventHandler);
    on<GetDetailsReviewEvent>(onEventHandler);
    on<SetCompleteEvent>(onEventHandler);
    on<GetCerificateEvent>(onEventHandler);
    on<GetContentStatus>(onEventHandler);
  }

  FutureOr<void> onEventHandler(MyLearningDetailsEvent event, Emitter emit) async {
    print("MyLearningDetailsBloc onEventHandler called for ${event.runtimeType}");
    Stream<MyLearningDetailsState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (MyLearningDetailsState authState) {
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
  MyLearningDetailsState get initialState => IntitialDetailsState.completed("Intitalized");

  @override
  Stream<MyLearningDetailsState> mapEventToState(event) async* {
    try {
      if (event is GetLearningDetails) {
        yield GetLearningDetailsState.loading('Please wait');

        Response? apiResponse = await myLearningRepository.getMyLearningDetails(event.myLearningDetailsRequest);

        if (apiResponse?.statusCode == 200) {
          MyLearningDetailsResponse response = myLearningDetailsResponseFromJson(apiResponse?.body ?? "{}");

          //TODO: Change The Above Api Call with this new one
          //We Are calling this api because we are not getting Google and Apple Product ids in the above api
          Response? apiResponse2 = await MyLearningRepositoryPublic().getMyLearningDetails2(event.myLearningDetailsRequest.contentId);
          //print("getMyLearningDetails2 status code:${apiResponse2?.statusCode}");
          //log("getMyLearningDetails2 Body:${apiResponse2?.body}");
          if(apiResponse2?.statusCode == 200) {
            try {
              Map<String, dynamic> json = jsonDecode(apiResponse2!.body);

              List<Map> table = List.castFrom(json['Table'] ?? []);
              if(table.isNotEmpty) {
                Map<String, dynamic> map = Map.castFrom<dynamic, dynamic, String, dynamic>(table.first);
                response.googleProductID = map['GoogleProductID']?.toString() ?? "";
                response.itunesProductID = map['ItunesProductID']?.toString() ?? "";
              }
            }
            catch(e, s) {
              print("Error in parsing data in getMyLearningDetails2:$e");
              print(s);
            }
          }

          setDetailsData(response);
          yield GetLearningDetailsState.completed(data: response);
        } else if (apiResponse?.statusCode == 401) {
          yield GetLearningDetailsState.error('401');
        } else {
          yield GetLearningDetailsState.error('Something went wrong');
        }
        print('apiresposne $apiResponse');
      }
      else if (event is GetDetailsReviewEvent) {
        print("Enter GetCurrentUserReviewEvent");
        yield GetReviewsDetailstate.loading('Loading...please wait');
        try {
          Response? response = await myLearningRepository
              .getUserRatingsOfTheContent(event.contentId, event.skippedRows);

          print("GetCurrentUserReviewEvent response :- ${response?.body}");
          print(
              "GetCurrentUserReviewEvent responseCode :- ${response?.statusCode}");

          if (response?.statusCode == 200) {
            GetReviewResponse getReviewResponse =
                getReviewResponseFromJson(response?.body ?? "{}");
            if (userRatingDetails.isEmpty) {
              userRatingDetails = getReviewResponse.userRatingDetails;
            } else {
              getReviewResponse.userRatingDetails.forEach((element) {
                userRatingDetails.add(element);
              });
            }
            yield GetReviewsDetailstate.completed(
              review: getReviewResponse,
            );
          } else {
            print("object bloc else part ${response?.statusCode} ");
            yield GetReviewsDetailstate.error("${response?.statusCode}");
          }
        } catch (e, s) {
          print("log $e");
          print(s);
          yield GetReviewsDetailstate.error("Error  $e");
        }
      }
      else if (event is SetCompleteEvent) {
        yield SetCompleteState.loading('Loading...please wait');

        try {
          bool networkAvailable = await AppDirectory.checkInternetConnectivity();

          /// If network is not available, update local database
          if(!networkAvailable) {
            event.table2.corelessonstatus = 'Completed';
            event.table2.progress = '100';

            AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
            String hiveCollectionName = '';
            if(event.isTrackListItem) {
              hiveCollectionName = "$tracklistCollection-${event.eventTrackModel?.contentid}-${appBloc.userid}";
            } else {
              hiveCollectionName = "$myLearningCollection-${appBloc.userid}";
            }
            String completedCollectionName = "$completedOfflineCourses-${appBloc.userid}";
            await HiveDbHandler().createData(
              hiveCollectionName,
              event.table2.contentid,
              event.table2.toJson(),
            );
            await HiveDbHandler().createData(
              completedCollectionName,
              event.table2.contentid,
              event.table2.toJson(),
            );
            yield SetCompleteState.completed(isCompleted: true);
            return;
          }

          Response? response = await myLearningRepository.setCompleteStatus(
              event.table2.contentid, event.table2.scoid.toString());
          if (response?.statusCode == 200) {
            yield SetCompleteState.completed(isCompleted: true);
          } else if (response?.statusCode == 401) {
            yield SetCompleteState.error("401");
          } else {
            yield SetCompleteState.error("Something went wrong");
          }
        } catch (e, s) {
          print(s);
          yield SetCompleteState.error("Something went wrong");
        }
      }
      else if (event is GetCerificateEvent) {
        yield GetCertificateState.loading('Please wait...');
        Response? response = await myLearningRepository.getCertificate(
            event.certificateId,
            event.certificatePage,
            event.siteUrl,
            event.certificateId,
            event.contentId,
            event.scoId);
        if (response?.statusCode == 200) {
          yield GetCertificateState.completed(isCompleted: response?.body ?? "{}");
        } else if (response?.statusCode == 401) {
          yield GetCertificateState.error("401");
        } else {
          yield GetCertificateState.error("Something went wrong");
        }
      }
      else if (event is GetContentStatus) {
        yield GetContentStatusState.loading('Please wait...');
        Response? response = await myLearningRepository.getContentStatus(event.url);

        print('getcontentstatusres ${response?.body}');

        if (response?.statusCode == 200) {
          contentResponse = contentstatusResponseFromJson(response?.body ?? "{}");

          yield GetContentStatusState.completed(
              contentstatus: contentResponse.contentstatus.isNotEmpty
                  ? contentResponse.contentstatus[0]
                  : Contentstatus(),
              table2: event.table2 ?? DummyMyCatelogResponseTable2());
        }
        else if (response?.statusCode == 401) {
          yield GetContentStatusState.error("401");
        }
        else {
          yield GetContentStatusState.error("Something went wrong");
        }
      }
    }
    catch (e, s) {
      print("Error in MyLearningDetailsBloc.mapEventToState():$e");
      print(s);

      //yield GetListState.error("Error  $e");
    }
  }

  void setDetailsData(MyLearningDetailsResponse response) {
    print('responsedatt ${response.actualStatus}');
    myLearningDetailsModel.setActualStatus(response.actualStatus ?? "");
    myLearningDetailsModel.setLongDescription(response.longDescription);
    myLearningDetailsModel.setLocationName(response.longDescription);
    myLearningDetailsModel.setisContentEnrolled(response.isContentEnrolled);
    myLearningDetailsModel.setEventType(response.eventType);
    myLearningDetailsModel.setThumbnailVideoPath(response.thumbnailVideoPath);
    myLearningDetailsModel.setTableofContent(response.tableofContent);
    myLearningDetailsModel.setEventScheduleType(response.eventScheduleType);
    myLearningDetailsModel.setsiteName(response.siteName);
//    myLearningDetailsModel.setsiteurl(response.site);
    myLearningDetailsModel.setsiteid(response.siteId);
//    myLearningDetailsModel.setuserid(response.learningObjectives);
    myLearningDetailsModel.settitle(response.title);
    myLearningDetailsModel.setshortdes(response.shortDescription);
    myLearningDetailsModel.setauthorName(response.authorName);
    myLearningDetailsModel.setauthorDisplayName(response.authorDisplayName);
    myLearningDetailsModel.setcontentID(response.contentId);
    myLearningDetailsModel.setcreateddate(response.createdOn);
//    myLearningDetailsModel.setdisplayName(response.learningObjectives);
    myLearningDetailsModel.setdurationEndDate(response.durationEndDate);
//    myLearningDetailsModel.setisExpiry(false);
    myLearningDetailsModel.setthumbnailimagepath(response.thumbnailImagePath);

    var document = parse(response.thumbnailImagePath ?? '');
    String imagePathSet;
    String iageList = '';

    if (document != null) {
      var imgList = document.querySelectorAll("img");

      for (dom.Element img in imgList) {
        print(img.attributes["src"]);
        print(img.toString());
        iageList = img.attributes["src"] ?? "";
      }
    }

    imagePathSet = ApiEndpoints.strSiteUrl + iageList;
    print('imagepathset $imagePathSet');

    myLearningDetailsModel.setimageData(imagePathSet);
//    myLearningDetailsModel.setrelatedcontentcount(response.rela);
//    myLearningDetailsModel.setisdownloaded(response.do);
//    myLearningDetailsModel.setcourseattempts(response.att);
//    myLearningDetailsModel.setobjecttypeid(response.ob);
    myLearningDetailsModel.setscoid(response.scoId);
    myLearningDetailsModel.setstartpage(response.startpage);
//    myLearningDetailsModel.setstatusDisplay(response.);
    myLearningDetailsModel.setlongdes(response.longDescription);
    myLearningDetailsModel.settypeofevent(response.typeofEvent);
//    myLearningDetailsModel.setmedianame(response.learningObjectives);
    myLearningDetailsModel.setratingid(response.ratingId);
//    myLearningDetailsModel.setpublishedDate(response.learningObjectives);
    myLearningDetailsModel.seteventStartDateTime(response.eventStartDateTime);
    myLearningDetailsModel.seteventendTime(response.eventEndDateTime);
    myLearningDetailsModel.seteventstartUtcTime(response.eventStartDateTime);
    myLearningDetailsModel.seteventendUtcTime(response.eventEndDateTime);
    myLearningDetailsModel.setmediatypeid(response.mediaTypeId);
//    myLearningDetailsModel.setdateassigned(response.ass);
//    myLearningDetailsModel.setkeywords(response.key);
//    myLearningDetailsModel.seteventcontentid(response.eventC);
//    myLearningDetailsModel.seteventAddedToCalender(response.adde);
    myLearningDetailsModel.settimezone(response.timeZone);
//    myLearningDetailsModel.setparticipanturl(response.par);
//    myLearningDetailsModel.setpassword(response.pas);
//    myLearningDetailsModel.setisListView(response.isL);
    myLearningDetailsModel.setjoinurl(response.joinUrl);
//    myLearningDetailsModel.setofflinepath(response.learningObjectives);
//    myLearningDetailsModel.setwresult(response.wr);
//    myLearningDetailsModel.setwmessage(response.wm);
    myLearningDetailsModel.setpresenter(response.presentername);
//    myLearningDetailsModel.setprogress(response.pro);
//    myLearningDetailsModel.setmembershipname(response.m);
//    myLearningDetailsModel.setmembershiplevel(response.me);
    myLearningDetailsModel.setfolderPath(response.folderPath);
    myLearningDetailsModel.setisArchived(response.isArchived);
    myLearningDetailsModel.setjwvideokey(response.jwVideoKey);
//    myLearningDetailsModel.setcloudmediaplayerkey(response.cl);
//    myLearningDetailsModel.setcontentTypeImagePath(response.contenty);
//    myLearningDetailsModel.setisRequired(response.isr);
    myLearningDetailsModel.settotalratings(response.totalRatings);
    myLearningDetailsModel.setthumbnailIconPath(response.thumbnailIconPath);
    myLearningDetailsModel.setRescheduleEvent(response.reScheduleEvent);
    myLearningDetailsModel.setQrImageName(response.qrImageName ?? "");
    myLearningDetailsModel
        .seteventRecording(response.recordingDetails.eventRecording);
  }
}
