import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/feedback/feedback_repositry_builder.dart';

class FeedbackRepositoryPublic extends FeedbackRepository {
  @override
  Future<Response?> feedbackSubmit({
    bool isUrl = false,
    String feedbackTitle = "",
    String imageFileName = "",
    String feedbackDesc = "",
    String currentUrl = "",
    Uint8List? image,
    String currentUserId = "",
    String date2 = "",
    String currentSiteId = "",
  }) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      List<MultipartFile> files = [];
      if (image != null) {
        //imageFile = await dio.MultipartFile.fromFile(image, filename: imageFileName);
        files.add(MultipartFile.fromBytes("Image", image),);
      }
      var nowDate = new DateTime.now();
      Map<String, String> formData = {
        "FeedbackTitle": feedbackTitle,
        "Feedbackdesc": feedbackDesc,
        "ImageFileName": '',
        "CurrentUrl": '${ApiEndpoints.strSiteUrl}/Catalog',
        "currentuserid": strUserID,
        "currentsiteid": strSiteID,
        "Date2": nowDate.toIso8601String(),
      };
      // FeedbackTitle: with out attachment
      // Feedbackdesc: asd
      // ImageFileName:
      // CurrentUrl: https://flutter.instancy.com/Catalog
      // currentuserid: 89
      // Date2: November 26, 2020 10:23 PM
      // currentsiteid: 374
      // FeedbackTitle: with attachmentok
      // Feedbackdesc: ok
      // ImageFileName: d33228dd741723a0c66b221e36f2aaaf.jpg
      // CurrentUrl: https://flutter.instancy.com/Catalog
      // Image: (binary)
      // currentuserid: 89
      // Date2: November 26, 2020 10:25 PM
      // currentsiteid: 374
      // String body = json.encode(data);
      print(formData.toString());
      response = await RestClient.uploadFilesData(
          ApiEndpoints.submitFeedback(), formData,
          files: files);
    } catch (e) {
      print("Error in FeedbackRepositoryPublic.feedbackSubmit():$e");
    }
    return response;
  }

  @override
  Future<Response?> deleteFeedbackEvent({int id = 0}) async {
    // TODO: implement getWikiCategories
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      print("......Feedback....${ApiEndpoints.DeleteFeedBack()}");
      var data = {"userid": strUserID, 'ID': id};
      response =
          await RestClient.postApiData(ApiEndpoints.DeleteFeedBack(), data);
      print("Feedback response ${response.toString()}");
    } catch (e) {
      print("Error in FeedbackRepositoryPublic.DeleteFeedbackEvent():$e");
    }
    return response;
  }

  @override
  Future<Response?> getFeedbackResponseEvent(String isAdmin) async {
    // TODO: implement GetFeedbackresponseEvent
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      // var strComponentID = await sharePref_getString(sharedPref_ComponentID);
      // var strLanguage = await sharePref_getString(sharedPref_AppLocale);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      print(
          "......catalog....${ApiEndpoints.GetFeedBackData(strUserID, strSiteID, isAdmin)}");
      response = await RestClient.getPostData(
          ApiEndpoints.GetFeedBackData(strUserID, strSiteID, isAdmin));
      print("Add to wish response ${response?.body.toString()}");
    } catch (e) {
      print("Error in FeedbackRepositoryPublic.GetFeedbackresponseEvent():$e");
    }
    return response;
  }
}
