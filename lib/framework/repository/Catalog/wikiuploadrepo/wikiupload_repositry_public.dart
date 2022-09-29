import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/wikiuploadrepo/wikiupload_repositry_builder.dart';

class WikiUploadRepositoryPublic extends WikiUploadRepository {
  @override
  Future<Response?> uploadWikiFileData(
      {bool isUrl = false,
      dynamic fileBytes,
      int mediaTypeID = 0,
      int objectTypeID = 0,
      String title = "",
      String shortDesc = "",
      int userID = 0,
      int siteID = 0,
      String localeID = "",
      int componentID = 0,
      int cMSGroupId = 0,
      String keywords = "",
      int orgUnitID = 0,
      String eventCategoryID = "",
      String categoryIds = ""}) async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      // var strComponentID = await sharePref_getString(sharedPref_ComponentID);
      // var strRepositoryId = await sharePref_getString(sharedPref_RepositoryId);

      if (isUrl) {
        Map<String, String> formData = {
          "WebSiteURL": fileBytes,
          "MediaTypeID": mediaTypeID.toString(),
          "ObjectTypeID": objectTypeID.toString(),
          "Title": title,
          "ShortDesc": shortDesc,
          "UserID": strUserID,
          "SiteID": strSiteID,
          "ComponentID": componentID.toString(),
          "LocaleID": strLanguage,
          "CMSGroupId": cMSGroupId.toString(),
          "Keywords": keywords,
          "OrgUnitID": strSiteID,
          "EventContentid": eventCategoryID,
          "EventCategoryID" : eventCategoryID,
          "CategoryIds": categoryIds,
        };
        response = await RestClient.uploadFilesData(ApiEndpoints.postUploadWikiFiles(), formData);

        print("uploadWikiFileData Response Status:${response?.statusCode}, Body:${response?.body}");
      }
      else {
        //final file = await dio.MultipartFile.fromFile(filepath, filename: title);
        print("File Path:$fileBytes");
        List<MultipartFile> fileNames = [];
        if(fileBytes == Uint8List) {
          fileNames.add(MultipartFile.fromBytes("file", fileBytes));
        }

        Map<String, String> formData = {
          'locale': strLanguage,
          'MediaTypeID': mediaTypeID.toString(),
          'ObjectTypeID': objectTypeID.toString(),
          'Title': title,
          'ShortDesc': shortDesc,
          'UserID': strUserID,
          'SiteID': strSiteID,
          'ComponentID': componentID.toString(),
          'LocaleID': strLanguage,
          'CMSGroupId': cMSGroupId.toString(),
          'Keywords': keywords,
          'OrgUnitID': strSiteID,
          'EventCategoryID': eventCategoryID,
          'CategoryIds': "categoryIds",
        };

        /*var headers = {
          'ClientURL': 'https://upgradedenterprise.instancy.com/',
          'AllowWindowsandMobileApps': 'allow',
          'UserID': '363',
          'SiteID': '374',
          'Locale': 'en-us',
          'Authorization': 'Bearer 48mvZGg-kHktjYK0gujSY_ISO9i4ONZtLBD6apgqTDgHiVPDFS-apVJQ0p7g5GG3JZUgtnknIAAMeNS_9S1GRaG-cYIMex2vVIYJT4ssvvoskAXmLvFmBDRCkyDGAaKwFoFwE0zdMdwllmG37MMYVXLe6MUKvQfDhiLohVDRDzzxHhXb-GulTPIHXrtdA3Q0yAa20zEaW5FCcxqIbev62h3Exo5hcYKqcmI-CzW2mGpNnFwHYckaw5PrrtJp6BSP2Rn-fAQkFNbdoB4hu6CAqqKGQpV6SMlZh76U7S36zzPaXIDCJbaM2WicPC_3PNsJF8HpRhn53zR-HGHkMdseW6s8ri9_XQsc9rpFI2evMI2eYoyDhGTdo8fbJB9mf5n2pPXMwqWJ5oDPO70-tdhnQGkroByAWVPc6gBZLEhd8AZJNBTI1_XOdrKSpOsnwMeRQP9E7yvsZTeDndDgGHN_tuCITrdZr2EMTnn054_6bb_wU4fOMEzcrweY6ggorUsD'
        };
        var request = MultipartRequest('POST', Uri.parse('https://upgradedenterpriseapi.instancy.com/api/UploadFiles/UploadFilesAction'));
        request.fields.addAll(formData);
        request.files.add(await MultipartFile.fromPath('file', filepath));
        request.headers.addAll(headers);

        StreamedResponse response = await request.send();*/
        response = await RestClient.uploadFilesData(ApiEndpoints.postUploadWikiFiles(), formData, files: fileNames);

        print("uploadWikiFileData Response Status:${response?.statusCode}, Body:${response?.body}");
      }

      // String body = json.encode(formData);

    } catch (e) {
      print("repo Error $e");
    }

    return response;
  }

  @override
  Future<Response?> getWikiCategories(
      {int intUserID = 0,
      int intSiteID = 0,
      int intComponentID = 0,
      String locale = "",
      String strType = ""}) async {
    // TODO: implement getWikiCategories
    Response? response;
    try {
      print("......catalog....${ApiEndpoints.GetWikiCategories()}");

      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strComponentID = await sharePrefGetString(sharedPref_ComponentID);
      var strLanguage = await sharePrefGetString(sharedPref_AppLocale);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      Map data = {
        "intUserID": strUserID,
        "intSiteID": strSiteID,
        "intComponentID": 1,
        "Locale": strLanguage,
        "strType": 'cat',
      };

      String body = json.encode(data);
      print('GetWikiCategories $body');
      response = await RestClient.postMethodData(
          ApiEndpoints.GetWikiCategories(), body);

      print("Add to wish response ${response?.body.toString()}");
    } catch (e) {
      print("repo Error $e");
    }

    return response;
  }
}
