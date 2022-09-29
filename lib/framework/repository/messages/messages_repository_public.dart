import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:intl/intl.dart';

import 'messages_repository_builder.dart';

class MessagesRepositoryPublic extends MessagesRepository {
  Future<Response?> addConnectionResponseEvent(
      {int selectedObjectID = 0,
      String selectAction = "",
      String userName = "",
      int mainSiteUserID = 0}) async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          "......PeopleListingAction....${ApiEndpoints.peopleListingAction()}");

      var data = {
        'SelectedObjectID': selectedObjectID,
        'SelectAction': selectAction,
        'UserName': userName,
        'UserID': strUserID,
        'MainSiteUserID': strUserID,
        'SiteID': strSiteID,
        'Locale': language
      };
      print('Post Data of people list' + data.toString());
      response = await RestClient.postApiData(
          ApiEndpoints.peopleListingAction(), data);
    } catch (e) {
      print(
          "Error in MessagesRepositoryPublic.addConnectionResponseEvent():$e");
    }
    return response;
  }

  Future<Response?> getDynamicTabEvent() async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          "......DynamicTabs....${ApiEndpoints.getDynamicTabs(strUserID, strSiteID, language)}");

      response = await RestClient.getPostData(
          ApiEndpoints.getDynamicTabs(strUserID, strSiteID, language));
    } catch (e) {
      print("Error in MessagesRepositoryPublic.getDynamicTabEvent():$e");
    }
    return response;
  }

  @override
  Future<Response?> getChatConnectionUserList() async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      print(
          "......ChatConnectionUserList....${ApiEndpoints.getChatConnectionUserList(strUserID, strSiteID, language)}");
      var data = {'FromUserID': strUserID, 'intSiteiD': strSiteID};
      response = await RestClient.postApiData(
          ApiEndpoints.getChatConnectionUserList(
              strUserID, strSiteID, language),
          data);
    } catch (e) {
      print("Error in MessagesRepositoryPublic.getChatConnectionUserList():$e");
    }
    return response;
  }

  @override
  Future<List<Map<String, dynamic>>> getChatHistory(
      {String fromUserId = "",
      String toUserId = "",
      bool markAsRead = false}) async {
    // TODO: implement getMobileMyCatalogObjectsData

    List<Map<String, dynamic>> messages = [];
    // _fireStore.get().then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     // print(doc.data());
    //     messages.add(doc.data());
    //   });
    // });

    // await _fireStore.get().then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     //print(doc.data());
    //     messages.add(doc.data());
    //   });
    // });

    return messages;

    //Response response;
    // try {
    //   var strUserID = await sharePref_getString(sharedPref_userid);
    //   var strSiteID = await sharePref_getString(sharedPref_siteid);
    //   var language = await sharePref_getString(sharedPref_AppLocale);
    //
    //   print("......ChatConnectionUserList....${ApiEndpoints.getChatHistory()}");
    //   var data = {
    //     'FromUserID': strUserID,
    //     'ToUserID': toUserId,
    //     'MarkAsRead': markAsRead
    //   };
    //   print(data);
    //   response =
    //       await RestClient.postApiData(ApiEndpoints.getChatHistory(), data);
    // } catch (e) {
    //   print("repo Error $e");
    // }
    //return response;
  }

  @override
  Future<Response?> postChatMessage(
      {String fromUserId = "",
      String toUserId = "",
      String message = "",
      required DateTime dateTime,
      bool markAsRead = false,
      String chatRoom = ""}) async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      var _fireStore = FirebaseFirestore.instance
          .collection(kAppFlavour)
          .doc('messages')
          .collection(chatRoom);
      _fireStore.add({
        'text': message,
        'fileUrl': '',
        'msgType': 'Text',
        'fromUserId': strUserID,
        'toUserId': toUserId,
        'date': DateTime.now().toIso8601String(),
      });

      print("......SendChatMessage....${ApiEndpoints.postChatMessage()}");
      Map<String, String> data = {
        'FromUserID': strUserID,
        'ToUserID': toUserId,
        'Message': message,
        'SendDatetime': DateFormat('yyyy-MM-dd HH:mm:ss a').format(dateTime),
        'MarkAsRead': markAsRead.toString()
      };

      response = await RestClient.uploadFilesData(ApiEndpoints.postChatMessage(), data);
      // response = await RestClient.postApiData(ApiEndpoints.postChatMessage(), data);
      //response = await RestClient.uploadFilesData(ApiEndpoints.postChatMessage(), data);
      print('response:${response?.body}');
      //response = await RestClient.uploadFilesData(ApiEndpoints.postChatMessage(), data); // .postApiData(ApiEndpoints.postChatMessage(), data);
    }
    catch (e, s) {
      print("Error in MessagesRepositoryPublic.postChatMessage():$e");
      MyPrint.printOnConsole(s);
    }
    return response;
  }

  Future<Response?> uploadMessageFileData(
      {Uint8List? fileBytes,
      String fileName = "",
      String toUserId = "",
      MessageType msgType = MessageType.Doc,
      String chatRoom = ""}) async {
    // TODO: implement getMobileMyCatalogObjectsData
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      List<MultipartFile> files = [];

      if(fileBytes != null) {
        files.add(MultipartFile.fromBytes("Image", fileBytes, filename: fileName));
      }
      var response = await RestClient.uploadFilesData(ApiEndpoints.genericFileUpload(), {}, files: files);

      print(response?.body);

      if (response?.body == 'success') {}
      print('${ApiEndpoints.mainSiteURL}$fileServerLocation$fileName');
      var newFileUrl = '${ApiEndpoints.mainSiteURL}$fileServerLocation$fileName';

      var _fireStore = FirebaseFirestore.instance
          .collection(kAppFlavour)
          .doc('messages')
          .collection(chatRoom);

      await _fireStore.add({
        'fromUserId': strUserID,
        'toUserId': toUserId,
        'date': DateTime.now().toIso8601String().toString(),
        'text': '',
        'fileUrl': newFileUrl,
        'msgType': msgType.toString().split('.').last,
      });
    } catch (e) {
      print("Error in MessagesRepositoryPublic.uploadMessageFileData():$e");
    }

    return response;
  }
}
