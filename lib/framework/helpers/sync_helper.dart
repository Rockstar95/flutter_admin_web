import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/database/database_handler.dart';
import 'package:flutter_admin_web/framework/helpers/database/hivedb_handler.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/general/model/CMIModel.dart';
import 'package:flutter_admin_web/framework/repository/general/model/LearnerSessionModel.dart';
import 'package:flutter_admin_web/framework/repository/general/model/StudentResponseModel.dart';
import 'package:flutter_admin_web/utils/my_print.dart';

class SyncData {
  SqlDatabaseHandler dbh = SqlDatabaseHandler();
  bool isSyncing = false;

  // ApiEndpoints.strSiteUrl;

  static SyncData? _syncData;

  factory SyncData() {
    if (_syncData == null) {
      _syncData = SyncData._internal();
    }
    return _syncData!;
  }

  SyncData._internal();

  Future<void> syncData() async {
    MyPrint.printOnConsole("Sync Offline To Online Called");

    try {
      if(isSyncing) return;

      isSyncing = true;
      AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
      String completedCollectionName = "$completedOfflineCourses-${appBloc.userid}";
      List<Map<String, dynamic>> completedCourses = await HiveDbHandler().readData(completedCollectionName);
      if(completedCourses.isNotEmpty) {
        List<String> completedSuccessfulSync = [];
        for(Map<String, dynamic> item in completedCourses) {
          DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
          table2.fromJson(item);
          Response? response = await setCompleteStatus(table2.contentid, table2.scoid.toString(), appBloc.userid);
          if(response?.statusCode == 200) {
            completedSuccessfulSync.add(table2.contentid);
          }
        }
        if(completedSuccessfulSync.isNotEmpty) {
          HiveDbHandler().deleteData(completedCollectionName, keys: completedSuccessfulSync);
        }
      }

      String bundlevalue1 = '';
      List<CMIModel> cmiList = <CMIModel>[];
      Set<CMIModel> hs = HashSet();

      List<CMIModel> cmiMylearningList = await dbh.getAllCmiDownloadDataDetails();
      MyPrint.printOnConsole("cmiMylearningList contents:${cmiMylearningList.map((e) => e.contentId)}");
      hs.addAll(cmiMylearningList);
      List<CMIModel> cmitrackList = await dbh.getAllCmiTrackListDetails();
      MyPrint.printOnConsole("cmitrackList contents:${cmitrackList.map((e) => e.contentId)}");
      cmiList.addAll(cmitrackList);
      List<CMIModel> cmiEventRelated = await dbh.getAllCmiRelatedContentDetails();
      MyPrint.printOnConsole("cmiEventRelated contents:${cmiEventRelated.map((e) => e.contentId)}");
      hs.addAll(cmiEventRelated);
      cmiList.addAll(hs);

      for (CMIModel tempCmi in cmiList) {
        bundlevalue1 = tempCmi.userId.toString();

        String sb = '';

        sb += '<TrackedData><CMI>';
        sb += '<ID>${tempCmi.Id.toString()}</ID>';
        sb += '<UserID>$bundlevalue1</UserID>';
        sb += '<SCOID>${tempCmi.scoId.toString()}</SCOID>';
        if (AppDirectory.isValidString(tempCmi.status)) {
          sb += '<CoreLessonStatus>${tempCmi.status}</CoreLessonStatus>';
        } else {
          sb += '<CoreLessonStatus></CoreLessonStatus>';
        }

        if (AppDirectory.isValidString(tempCmi.location)) {
          sb += '<CoreLessonLocation>${tempCmi.location}</CoreLessonLocation>';
        } else {
          sb += '<CoreLessonLocation></CoreLessonLocation>';
        }

        if (AppDirectory.isValidString(tempCmi.suspenddata)) {
          sb += '<SuspendData>${tempCmi.suspenddata}</SuspendData>';
        } else {
          sb += '<SuspendData></SuspendData>';
        }

        if (AppDirectory.isValidString(tempCmi.datecompleted)) {
          sb += '<DateCompleted>${tempCmi.datecompleted}</DateCompleted>';
        } else {
          sb += '<DateCompleted></DateCompleted>';
        }

        sb += '<NoOfAttempts>${tempCmi.noofattempts}</NoOfAttempts>';

        // need to send data  parentcontentid and parentscoid
        sb += '<TrackScoID>${tempCmi.parentScoId}</TrackScoID>';
        sb += '<TrackContentID>${tempCmi.parentContentId}</TrackContentID>';

        // need to send parent obj type id
        sb += '<TrackObjectTypeID>${tempCmi.parentObjTypeId}</TrackObjectTypeID>';

        sb += '<OrgUnitID>${tempCmi.siteId}</OrgUnitID>';

        if (tempCmi.score == '' || tempCmi.score == 'null') {
          sb += '<Score>0</Score>';
        } else {
          sb += '<Score>${tempCmi.score}</Score>';
        }

        if (AppDirectory.isValidString(tempCmi.percentageCompleted)) {
          sb +=
              '<PercentCompleted>${tempCmi.percentageCompleted}</PercentCompleted>';
        } else {
          sb += '<PercentCompleted>0</PercentCompleted>';
        }

        sb += '<ObjectTypeId>${tempCmi.objecttypeid}</ObjectTypeId>';

        if (AppDirectory.isValidString(tempCmi.seqNum)) {
          sb += '<SequenceNumber>${tempCmi.seqNum}</SequenceNumber>';
        } else {
          sb += '<SequenceNumber>0</SequenceNumber>';
        }

        if (AppDirectory.isValidString(tempCmi.attemptsleft)) {
          sb += '<AttemptsLeft>${tempCmi.attemptsleft}</AttemptsLeft>';
        } else {
          sb += '<AttemptsLeft></AttemptsLeft>';
        }

        if (AppDirectory.isValidString(tempCmi.coursemode)) {
          sb += '<CoreLessonMode>${tempCmi.coursemode}</CoreLessonMode>';
        } else {
          sb += '<CoreLessonMode></CoreLessonMode>';
        }

        if (AppDirectory.isValidString(tempCmi.scoremin)) {
          sb += '<ScoreMin>${tempCmi.scoremin}</ScoreMin>';
        } else {
          sb += '<ScoreMin></ScoreMin>';
        }

        if (AppDirectory.isValidString(tempCmi.scoremax)) {
          sb += '<ScoreMax>${tempCmi.scoremax}</ScoreMax>';
        } else {
          sb += '<ScoreMax></ScoreMax>';
        }

        if (AppDirectory.isValidString(tempCmi.qusseq)) {
          sb += '<RandomQuestionNos>${tempCmi.qusseq}</RandomQuestionNos>';
        } else {
          sb += '<RandomQuestionNos></RandomQuestionNos>';
        }

        if (AppDirectory.isValidString(tempCmi.textResponses)) {
          sb += '<TextResponses>${tempCmi.textResponses}</TextResponses>';
        } else {
          sb += '<TextResponses></TextResponses>';
        }

        if (AppDirectory.isValidString(tempCmi.pooledqusseq)) {
          sb +=
              '<PooledQuestionNos>${tempCmi.pooledqusseq}</PooledQuestionNos>';
        } else {
          sb += '<PooledQuestionNos></PooledQuestionNos>';
        }

        sb += '</CMI>';

        /// session details
        List<LearnerSessionModel> sesList = await dbh.getAllSessionDetails(bundlevalue1, tempCmi.siteId, tempCmi.scoId.toString());

        if (sesList.isNotEmpty) {
          for (LearnerSessionModel tempSession in sesList) {
            sb += '<LearnerSession>';

            sb += '<SessionID></SessionID>';

            sb += '<UserID>$bundlevalue1</UserID>';
            sb += '<SCOID>${tempSession.scoID}</SCOID>';
            sb += '<AttemptNumber>${tempSession.attemptNumber}</AttemptNumber>';
            sb +=
                '<SessionDateTime>${tempSession.sessionDateTime}</SessionDateTime>';

            MyPrint.printOnConsole("Time Spent For ${tempCmi.contentId}:${tempSession.timeSpent}");
            if (AppDirectory.isValidString(tempSession.timeSpent)) {
              sb += '<TimeSpent>${tempSession.timeSpent}</TimeSpent>';
            }
            else {
              sb += '<TimeSpent>0</TimeSpent>';
            }
            sb += '</LearnerSession>';
          }
        } else {
          sb += '<LearnerSession></LearnerSession>';
        }

        /// response data
        List<StudentResponseModel> resList = await dbh.getAllResponseDetails(bundlevalue1, tempCmi.siteId, tempCmi.scoId.toString());

        for (StudentResponseModel tempResponse in resList) {
          String sampleStdntResponse = tempResponse.studentresponses;
          sampleStdntResponse = sampleStdntResponse.replaceAll("\'", "\\\'");
          sampleStdntResponse = sampleStdntResponse.replaceAll("\"", "\\\"");
          sampleStdntResponse = sampleStdntResponse.replaceAll("%23", "#");
          sampleStdntResponse = sampleStdntResponse.replaceAll("%5E", "^");
          if (sampleStdntResponse.contains("#^#^")) {
            sampleStdntResponse = sampleStdntResponse.replaceAll("#^#^", "@");
          }
          if (sampleStdntResponse.contains("##^^##^^")) {
            sampleStdntResponse =
                sampleStdntResponse.replaceAll("##^^##^^", "&&**&&");
            sampleStdntResponse = "[CDATA[" + sampleStdntResponse + "]]";
          }

          sb += '<StudentResponse>';
          sb += '<UserID>$bundlevalue1</UserID>';
          sb += '<SCOID>${tempResponse.scoId}</SCOID>';
          sb += '<QuestionID>${tempResponse.questionid}</QuestionID>';
          sb +=
              '<AssessmentAttempt>${tempResponse.assessmentattempt}</AssessmentAttempt>';
          sb +=
              '<QuestionAttempt>${tempResponse.questionattempt}</QuestionAttempt>';
          sb += '<AttemptDate>${tempResponse.attemptdate}</AttemptDate>';
          sb += '<Response>$sampleStdntResponse</Response>';
          sb += '<Result>${tempResponse.result}</Result>';
          sb += '<OptionalNotes>${tempResponse.optionalNotes}</OptionalNotes>';

          if (AppDirectory.isValidString(tempResponse.attachfilename)) {
            sb +=
                '<AttachFileName>${tempResponse.attachfilename}</AttachFileName>';
          } else {
            sb += '<AttachFileName></AttachFileName>';
          }

          if (AppDirectory.isValidString(tempResponse.attachfileid)) {
            sb += '<AttachFileId>${tempResponse.attachfileid}</AttachFileId>';
          } else {
            sb += '<AttachFileId></AttachFileId>';
          }

          sb += bindXML(
              "CapturedVidFileName", tempResponse.capturedVidFileName, "");
          sb += bindXML("CapturedVidId", tempResponse.capturedVidId,
              tempResponse.capturedVidFilepath);

          sb += bindXML(
              "CapturedImgFileName", tempResponse.capturedImgFileName, "");
          sb += bindXML("CapturedImgId", tempResponse.capturedImgId,
              tempResponse.capturedImgFilepath);

          sb += '</StudentResponse>';
        }

        sb += '</TrackedData>';

        MyPrint.logOnConsole('SynchUpdateOffline: $sb');

        String appWebApiUrl = await sharePrefGetString(sharedPref_webApiUrl);
        String requestURL = appWebApiUrl +
            "MobileLMS/MobileUpdateOfflineTrackedData" +
            "?_studId=" +
            tempCmi.userId.toString() +
            "&_scoId=" +
            tempCmi.scoId.toString() +
            "&_siteURL=" +
            tempCmi.sitrurl +
            "&_siteID=" +
            tempCmi.siteId;

        MyPrint.logOnConsole('SyncData requestUrl: $requestURL');
        sb = '\"$sb\"';

        Response? response = await RestClient.postMethodData(requestURL, sb);
        if (response != null) {
          String body = response.body;
          print('Response For SyncHelper().syncData(): $body');
          dbh.insertCMiIsViewed(tempCmi);
        }
      }
      isSyncing = false;
    } catch (e) {
      MyPrint.printOnConsole('syncData failed: $e');
      isSyncing = false;
    }
  }

  Future<Response?> setCompleteStatus(String contentId, String scoId, String userId) async {
    Response? response;
    try {
      response = await RestClient.getPostData(
          ApiEndpoints.setStatusCompleted(
              contentId, userId.toString(), scoId, '374'));
    } catch (err) {
      MyPrint.printOnConsole(err);
    }
    return response;
  }

  String bindXML(String tag, String value, String filePath) {
    String sampleString = '';
    try {
      if (value == "" || value == "null" || value == "undefined")
        sampleString += '<$tag></$tag>';
      else
        sampleString += '<$tag>$value</$tag>';
    } catch (ex) {
      sampleString += '<$tag></$tag>';
    }

    return sampleString;
  }
}
