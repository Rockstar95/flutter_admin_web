import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/progressReport/progress_report_repositry_builder.dart';

class ProgressReportRepositoryPublic extends ProgressReportRepository {
  @override
  Future<Response?> getConsolidatePRT({
    int aintComponentID = 0,
    int aintCompInsID = 0,
    int aintSelectedGroupValue = 0,
  }) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      Map<String, dynamic> progressReportRequest = {
        'aintComponentID': aintComponentID,
        'aintCompInsID': aintCompInsID,
        'aintSelectedGroupValue': aintSelectedGroupValue,
        'aintSiteID': int.parse(strSiteID),
        'aintUserID': int.parse(strUserID),
        'astrLocale': strLanguage,
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.getConsolidateRPT(), progressReportRequest);
    } catch (e) {
      print('Error in ProgressReportRepositoryPublic.getConsolidatePRT():$e');
    }
    return response;
  }

  @override
  Future<Response?> getCourseSummary({
    int userID = 0,
    String cID = "",
    int objectTypeId = 0,
    String startDate = "",
    String endDate = "",
    String seqID = "",
    String trackID = "",
  }) async {
    // TODO: implement getCourseSummary
    Response? response;
    try {
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      Map<String, dynamic> courseSummaryRequest = {
        'CID': cID,
        'ObjectTypeId': objectTypeId,
        'UserID': userID,
        'StartDate': startDate,
        'EndDate': endDate,
        'SeqID': seqID,
        'TrackID': trackID,
        'SiteID': int.parse(strSiteID),
        'Locale': strLanguage
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.getCourseSummary(), courseSummaryRequest);
    } catch (e) {
      print('Error in ProgressReportRepositoryPublic.getCourseSummary():$e');
    }
    return response;
  }

  @override
  Future<Response?> getProgressDetailData(
      {int userID = 0,
      String cID = "",
      int objectTypeId = 0,
      String startDate = "",
      String endDate = "",
      String seqID = "",
      String trackID = ""}) async {
    // TODO: implement getCourseSummary
    Response? response;
    try {
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);

      Map<String, dynamic> progressDetailDataRequest = {
        'CID': cID,
        'ObjectTypeId': objectTypeId,
        'UserID': userID,
        'StartDate': startDate,
        'EndDate': endDate,
        'SeqID': seqID,
        'TrackID': trackID,
        'SiteID': int.parse(strSiteID),
        'Locale': strLanguage
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.getProgressDetailDataDetails(),
          progressDetailDataRequest);
    } catch (e) {
      print(
          'Error in ProgressReportRepositoryPublic.getProgressDetailData():$e');
    }
    return response;
  }

  @override
  Future<Response?> viewQuestion(
      {String contentId = "",
      int qNo = 0,
      String trackId = "",
      String trackSeqId = "",
      String folderpath = "",
      String eventSCOId = ""}) async {
    // TODO: implement viewQuestion
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map<String, dynamic> progressDetailDataRequest = {
        'ContentId': contentId,
        'QNo': qNo,
        'userid': int.parse(strUserID),
        'TrackId': trackId,
        'TrackSeqId': trackSeqId,
        'folderpath': folderpath,
        'EventSCOId': eventSCOId
      };
      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.getViewQuestion(), progressDetailDataRequest);
    } catch (e) {
      print('Error in ProgressReportRepositoryPublic.viewQuestion():$e');
    }
    return response;
  }
}
