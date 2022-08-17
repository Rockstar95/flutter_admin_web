import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';

import 'create_discussion_repository.dart';

class CreateDiscussionRepositryPublic extends CreateDiscussionRepositry {
  @override
  Future<Response?> createDiscussionData(
      bool likePosts,
      String description,
      bool moderation,
      String updatedDate,
      int forumID,
      String forumThumbnailName,
      String categoryIDs,
      String sendEmail,
      int parentForumID,
      String name,
      bool createNewTopic,
      bool attachFile,
      bool requiresSubscription,
      String moderatorID,
      String createdDate,
      bool allowShare,
      bool isPrivate,
      bool allowPinTopic,
      Uint8List? fileBytes,
      String fileName) async {
    // TODO: implement discussionforumdata
    Response? response;

    try {
      print("......create forum....${ApiEndpoints.apiDiscussionMainHome()}");

      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      if (fileBytes != null) {
        List<MultipartFile> files = [
          MultipartFile.fromBytes("Image", fileBytes, filename: fileName)
        ];
        //final file = await dio.MultipartFile.fromFile(filePath, filename: fileName);
        // File file = File();
        // List<MultipartFile> files = [];
        // files.add(MultipartFile("image", file.openRead(), file.lengthSync(), filename: fileName));

        Map<String, String> formData = {
          'locale': language,
          'ForumID': forumID.toString(),
          'Name': name,
          'Description': description,
          'SendEmail': sendEmail,
          'CreateNewTopic': createNewTopic.toString(),
          'ForumThumbnailName': forumThumbnailName,
          'AttachFile': attachFile.toString(),
          'ParentForumID': parentForumID.toString(),
          'SiteID': strSiteID,
          'IsPrivate': isPrivate.toString(),
          'RequiresSubscription': requiresSubscription.toString(),
          'LikePosts': likePosts.toString(),
          'Moderation': moderation.toString(),
          'CreatedUserID': strUserID,
          'CreatedDate': createdDate,
          'AllowShare': allowShare.toString(),
          'ModeratorID': moderatorID,
          'UpdatedUserID': strUserID,
          'UpdatedDate': updatedDate,
          'CategoryIDs': categoryIDs,
          'AllowPinTopic': allowPinTopic.toString(),
        };
        response = await RestClient.uploadFilesData(
            ApiEndpoints.apiCreateDiscussion(), formData,
            files: files);
      } else {
        Map<String, String> data = {
          'locale': language,
          'ForumID': forumID.toString(),
          'Name': name,
          'Description': description,
          'SendEmail': sendEmail,
          'CreateNewTopic': createNewTopic.toString(),
          'ForumThumbnailName': forumThumbnailName,
          'AttachFile': attachFile.toString(),
          'ParentForumID': parentForumID.toString(),
          'SiteID': strSiteID,
          'IsPrivate': isPrivate.toString(),
          'RequiresSubscription': requiresSubscription.toString(),
          'LikePosts': likePosts.toString(),
          'Moderation': moderation.toString(),
          'CreatedUserID': strUserID,
          'CreatedDate': createdDate,
          'AllowShare': allowShare.toString(),
          'ModeratorID': moderatorID,
          'UpdatedUserID': strUserID,
          'UpdatedDate': updatedDate,
          'CategoryIDs': categoryIDs,
          'AllowPinTopic': allowPinTopic.toString(),
          'image': ''
        };

        response = await RestClient.uploadFilesData(
            ApiEndpoints.apiCreateDiscussion(), data);
      }
      print(
          "discussionForunStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunObjectData Response :- ${response?.body}");
    } catch (e) {
      print("repo Error $e");
    }
    return response;
  }

  @override
  Future<Response?> getDiscussionTopicUserData(
      int userID, int siteID, String localeID) async {
    Response? response;
    try {
      String data =
          "${ApiEndpoints.strBaseUrl}/DiscussionForums/GetUserListBasedOnRoles?intUserID=$userID&intSiteID=$siteID&strLocale=$localeID";

      print("&***** : " + data);

      response = await RestClient.getPostData(data);

      print(
          "discussionForunTopicStateCode statusCode :- ${response?.statusCode.toString()}");
      print("discussionForunTopicObjectData Response :- ${response?.body}");
    } catch (e) {
      print("repo Error $e");
    }

    return response;
  }
}
