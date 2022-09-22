import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/ui_setting_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/data_provider.dart';
import 'package:flutter_admin_web/framework/dataprovider/helper/local_database_helper.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/model/tincandata.dart';
import 'package:flutter_admin_web/framework/repository/general/model/CMIModel.dart';
import 'package:flutter_admin_web/framework/repository/general/model/LearnerSessionModel.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/video_launch.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';

class GotoCourseLaunch {
  final LocalDataProvider _localHelper =
      LocalDataProvider(localDataProviderType: LocalDataProviderType.hive);

  DummyMyCatelogResponseTable2 myLearningModel;
  BuildContext context;
  bool isIconEnabled;

  UISettingModel uiSettingModel;

  String urlForView = "";
  Logger logger = Logger();

  List<DummyMyCatelogResponseTable2> list;

  factory GotoCourseLaunch(
      BuildContext context,
      DummyMyCatelogResponseTable2 myLearningModel,
      bool isIconEnabled,
      UISettingModel uiSettingModel,
      List<DummyMyCatelogResponseTable2> list) {
    return GotoCourseLaunch._internal(
        context, myLearningModel, isIconEnabled, uiSettingModel, list);
  }

  GotoCourseLaunch._internal(this.context, this.myLearningModel,
      this.isIconEnabled, this.uiSettingModel, this.list) {
    print("i am in it of GotoCourseLaunch");
  }

  Future<String> getCourseUrl() async {
    print("getCourseUrl called From GotoCourseLaunch");

    String retUrl = "";

    String strUserID = await sharePrefGetString(sharedPref_LoginUserID);
    String userName = await sharePrefGetString(sharedPref_LoginUserName);
    String password = await sharePrefGetString(sharedPref_LoginPassword);

    String objectTypeId = myLearningModel.objecttypeid.toString();
    String siteUrl = ApiEndpoints.strSiteUrl;
    String scoId = myLearningModel.scoid.toString();
    String contentId = myLearningModel.contentid.toString();
    String userid = myLearningModel.userid.toString();
    String folderPath = myLearningModel.folderpath.toString();
    String startPage = myLearningModel.startpage.toString();
    String courseName = myLearningModel.name.toString();
    String jwVideoKey = myLearningModel.jwvideokey.toString();
    String siteId = myLearningModel.siteid.toString();
    String activityId = myLearningModel.activityid.toString();
    String folderId = myLearningModel.folderid.toString();
    //String startPage = myLearningModel.startpage.toString();
    // String endDurationDate = myLearningModel.durationenddate.toString();

    if(myLearningModel.objecttypeid == 28) {
      return startPage;
    }

    String mobileGetNativeMenusResponseStr = await _getLocalData(mobileTinCanConfigurationsKey);
    String tempTinCanData = mobileGetNativeMenusResponseStr.replaceAll("'", '"');
    if (tempTinCanData.startsWith('"')) tempTinCanData = tempTinCanData.substring(1);
    if (tempTinCanData.endsWith('"')) tempTinCanData = tempTinCanData.substring(0, tempTinCanData.length - 1);
    /*print("tempTinCanData:${tempTinCanData}");
    print("tempTinCanData Map:${jsonDecode(tempTinCanData)}");*/

    log("TinCanData:$tempTinCanData");
    TinCanData tinCanData = tinCanDataFromJson(tempTinCanData);

    String authKey = tinCanData.lrsauthorization;
    String authPassword = tinCanData.lrsauthorizationpassword;

    String base64lrsAuthKey = authKey + ":" + authPassword;

    String dir = await AppDirectory.getDocumentsDirectory();

    String downloadDestFolderPath = dir + "/.Mydownloads/Contentdownloads/" + contentId;

    String finalDownloadedFilePath = downloadDestFolderPath + "/" + startPage;
    //String finalDownloadedFilePath = downloadDestFolderPath + "/" + "hello.html";

    print('downlaodedfile:$finalDownloadedFilePath');

    File myFile = new File(finalDownloadedFilePath);
    bool isDownloadFileExists = await myFile.exists();
    String offlinePath = "";

    /// commented due to image not loading
    // if (isValidString(endDuarationDate)) {
    //   bool isCompleted = await isCourseEndDateCompleted(endDuarationDate);
    //
    //   if (isCompleted) {
    //     //return null;
    //   }
    // }

    if (isDownloadFileExists && objectTypeId != "70") {
      print('if___course_launch_ogjtypr $objectTypeId');

      ///TIN CAN OPTIONS

      String lrsEndPoint = "";

      String lrsActor = "{\"name\":[\"" +
          userName +
          "\"],\"account\":[{\"accountServiceHomePage\":\"" +
          ApiEndpoints.mainSiteURL +
          "\",\"accountName\":\"" +
          password +
          "|" +
          strUserID +
          "\"}],\"objectType\":\"Agent\"}&activity_id=" +
          activityId +
          "&grouping=" +
          activityId;

      String lrsAuthorizationKey = "";

      String enabletincanSupportforco = "";

      String enabletincanSupportforao = "";

      String enabletincanSupportforlt = "";

      String isTinCan = "";

      String autKey = "";

      try {
        if (tinCanData != null) {
          lrsEndPoint = tinCanData.lrsendpoint;
          autKey = base64lrsAuthKey;
          enabletincanSupportforco = tinCanData.enabletincansupportforco;
          enabletincanSupportforao = tinCanData.enabletincansupportforao;
          enabletincanSupportforlt = tinCanData.enabletincansupportforlt;
          isTinCan = tinCanData.istincan;
        }
      } catch (e) {
        //e.printStackTrace();
      }

      Uint8List encrpt = utf8.encode(autKey) as Uint8List;
      String base64 = base64Encode(encrpt);
      lrsAuthorizationKey = "Basic%20" + base64;

      ///End TIN CAN OPTIONS

      /// Generate Offline Path

      if (objectTypeId == "8" || objectTypeId == "9" || objectTypeId == "10") {
        /// get something from database is pending
        //databaseH.preFunctionalityBeforeNonLRSOfflineContentPathCreation(myLearningModel, context);

        //offlinePath = databaseH.generateOfflinePathForCourseView(myLearningModel, context);

        /// Remove this line
        offlinePath = "file://" + finalDownloadedFilePath;
      } else if (objectTypeId == "102") {
        String encodedString = lrsActor;

        offlinePath = "file://" + offlinePath;
        offlinePath = offlinePath +
            "?&endpoint=" +
            lrsEndPoint +
            "&auth=" +
            lrsAuthorizationKey +
            "&actor=" +
            encodedString +
            "&cid=0&nativeappURL=true&IsInstancyContent=true";
      } else if (objectTypeId == "688") {
      } else if (objectTypeId == "26") {
        offlinePath = "file://" +
            dir +
            "/Mydownloads/Content/LaunchCourse.html?contentpath=file://" +
            offlinePath;
      } else if (objectTypeId == "52") {
        String cerName = contentId + "/Certificate";

        offlinePath = offlinePath + "/" + userid + "/" + cerName + ".pdf";
      } else if (objectTypeId == "11" ||
          objectTypeId == "14" ||
          objectTypeId == "21" ||
          objectTypeId == "36" ||
          objectTypeId == "28") {
        offlinePath = "file://" + offlinePath;

        /// CMIModel ,LearnerSessionModel

        if (myLearningModel.actualstatus == "Not Started" ||
            myLearningModel.actualstatus == "") {
          // need to save CMI model

          CMIModel model = CMIModel(
              datecompleted: "",
              siteId: myLearningModel.siteid.toString(),
              userId: myLearningModel.userid,
              startdate: await getCurrentDateTimeInStr(),
              scoId: myLearningModel.scoid,
              isupdate: "false",
              status: "incomplete",
              seqNum: "0",
              percentageCompleted: "50",
              timespent: "",
              objecttypeid: myLearningModel.objecttypeid.toString(),
              sitrurl: myLearningModel.siteurl);

          ///databaseH.injectIntoCMITable(model, "false");

          /// need to find getLatestAttempt
          //int attempts = databaseH.getLatestAttempt(myLearningModel);

          int attempts = 0;

          LearnerSessionModel learnerSessionModel = new LearnerSessionModel(
            siteID: myLearningModel.siteid.toString(),
            userID: myLearningModel.userid.toString(),
            scoID: myLearningModel.scoid.toString(),
            attemptNumber: (attempts + 1).toString(),
            sessionDateTime: await getCurrentDateTimeInStr(),
          );

          ///databaseH.insertUserSession(learnerSessionModel);

        }
      } else {
        offlinePath = "file://" + finalDownloadedFilePath;
      }

      String offlinePathEncode = offlinePath.replaceAll(" ", "%20");

      print("final....offlinePathEncode....path.....$offlinePathEncode");
      print(
          "final....finalDownloadedFilePath....path.....$finalDownloadedFilePath");

      /*if(finalDownloadedFilePath.contains(".pdf"))
        {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              PdfCourseLaunch(isOffline: true,
                url: offlinePathEncode,
                myFile: myFile,finalDownloadedFilePath: finalDownloadedFilePath,
                myLearningModel: myLearningModel,
              )));
        }
      else*/
      if (finalDownloadedFilePath.contains(".mp4")) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoCourseLaunch(
                  myFile: myFile,
                  pdfBytes: myFile.readAsBytesSync(),
                )));
      } else if (finalDownloadedFilePath.toLowerCase().contains(".xlsx") ||
          finalDownloadedFilePath.toLowerCase().contains(".xls") ||
          finalDownloadedFilePath.toLowerCase().contains(".ppt") ||
          finalDownloadedFilePath.toLowerCase().contains(".pptx") ||
          finalDownloadedFilePath.toLowerCase().contains(".pdf") ||
          finalDownloadedFilePath.toLowerCase().contains(".doc") ||
          finalDownloadedFilePath.toLowerCase().contains(".docx")) {
        await openFile(finalDownloadedFilePath);
      } else {
        print('finalDownloadedFilePath $finalDownloadedFilePath');
        return offlinePath +
            "?nativeappURL=true&cid=12855&stid=316&lloc=1&lstatus=incomplete&susdata=%23pgvs_start%231;2;3;4;5;6;%23pgvs_end%23&quesdata=&sname=vinoth%20instancy&IsInstancyContent=true";
        //alertDialog(context);
      }
    }

    /// this is offline part
    else {
      print('else___course_launch_ogjtypr GotoCourseLaunch $objectTypeId');

      if (objectTypeId == "10" && myLearningModel.bit5) {
        // Need to open EventTrackListTabsActivity

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventTrackList(
                  myLearningModel,
                  true,
                  list,
                )));
      }
      else {
        if (["11", "14", "21", "36", "28"].contains(objectTypeId)) {
          if (myLearningModel.actualstatus == "Not Started" ||
              myLearningModel.actualstatus.isEmpty) {
            // need to save CMI model

            CMIModel model = CMIModel(
              datecompleted: "",
              siteId: myLearningModel.siteid.toString(),
              // userId: myLearningModel.userid, Commented or int type by Upendra
              startdate: await getCurrentDateTimeInStr(),
              scoId: myLearningModel.scoid,
              isupdate: "false",
              status: "incomplete",
              seqNum: "0",
              percentageCompleted: "50",
              timespent: "",
              objecttypeid: myLearningModel.objecttypeid.toString(),
              contentId: myLearningModel.contentid,
              sitrurl: myLearningModel.siteurl,
            );

            //databaseH.injectIntoCMITable(model, "false");
            // need to find getLatestAttempt
            //int attempts = databaseH.getLatestAttempt(myLearningModel);

            int attempts = 0;

            LearnerSessionModel learnerSessionModel = new LearnerSessionModel(
              siteID: myLearningModel.siteid.toString(),
              userID: myLearningModel.userid.toString(),
              scoID: myLearningModel.scoid.toString(),
              attemptNumber: (attempts + 1).toString(),
              sessionDateTime: await getCurrentDateTimeInStr(),
            );

            ///databaseH.insertUserSession(learnerSessionModel);

          }
        }

        ///TIN CAN OPTIONS

        String lrsEndPoint = "";

        String lrsActor = "{\"name\":[\"" +
            userName +
            "\"],\"account\":[{\"accountServiceHomePage\":\"" +
            ApiEndpoints.mainSiteURL +
            "\",\"accountName\":\"" +
            password +
            "|" +
            strUserID +
            "\"}],\"objectType\":\"Agent\"}&activity_id=" +
            activityId +
            "&grouping=" +
            activityId;

        String lrsAuthorizationKey = "";
        String enabletincanSupportforco = "";
        String enabletincanSupportforao = "";
        String enabletincanSupportforlt = "";
        String isTinCan = "";
        String autKey = "";

        try {
          if (tinCanData != null) {
            lrsEndPoint = tinCanData.lrsendpoint;
            autKey = base64lrsAuthKey;
            enabletincanSupportforco = tinCanData.enabletincansupportforco;
            enabletincanSupportforao = tinCanData.enabletincansupportforao;
            enabletincanSupportforlt = tinCanData.enabletincansupportforlt;
            isTinCan = tinCanData.istincan;
          }
        } catch (e) {
          //e.printStackTrace();
        }

        Uint8List encrpt = utf8.encode(autKey) as Uint8List;
        String base64 = base64Encode(encrpt);
        lrsAuthorizationKey = "Basic%20" + base64;

        ///End TIN CAN OPTIONS

        // Start of 8,9,10
        if (objectTypeId == "8" || objectTypeId == "9" || objectTypeId == "10") {
          urlForView = siteUrl +
              "ajaxcourse/ScoID/" +
              scoId +
              "/ContentTypeId/" +
              objectTypeId +
              "/ContentID/" +
              contentId +
              "/AllowCourseTracking/true/trackuserid/" +
              userid +
              "/ismobilecontentview/true/ContentPath/~Content~PublishFiles~" +
              folderPath +
              "~" +
              myLearningModel.startpage +
              "?nativeappURL=true";

          if (isTinCan == "true") {
            if (objectTypeId == "8" &&
                enabletincanSupportforco.toLowerCase() == "true") {
              urlForView = urlForView +
                  "&endpoint=" +
                  lrsEndPoint +
                  "&auth=" +
                  lrsAuthorizationKey +
                  "&actor=" +
                  lrsActor;
            } else if (objectTypeId == "9" &&
                enabletincanSupportforao.toLowerCase() == "true") {
              urlForView = urlForView +
                  "&endpoint=" +
                  lrsEndPoint +
                  "&auth=" +
                  lrsAuthorizationKey +
                  "&actor=" +
                  lrsActor;
            } else if (objectTypeId == "10" &&
                enabletincanSupportforlt.toLowerCase() == "true") {
              urlForView = urlForView +
                  "&endpoint=" +
                  lrsEndPoint +
                  "&auth=" +
                  lrsAuthorizationKey +
                  "&actor=" +
                  lrsActor;
            }
          }
        } // End of 8,9,10

        // Start of 11,14,21,36
        else if (objectTypeId == "11" || objectTypeId == "14" || objectTypeId == "21" || objectTypeId == "36") {
          if (objectTypeId == "11" && isValidString(jwVideoKey)) {
            String jwstartpage = "";
            if (isValidString(myLearningModel.jwstartpage)) {
              jwstartpage = myLearningModel.jwstartpage;
            } else {
              jwstartpage = startPage;
            }

            jwstartpage = jwstartpage.replaceAll("/", "~");

            urlForView = siteUrl +
                "ajaxcourse/ScoID/" +
                scoId +
                "/ContentTypeId/" +
                objectTypeId +
                "/ContentID/" +
                contentId +
                "/AllowCourseTracking/true/trackuserid/" +
                userid +
                "/ismobilecontentview/true/ContentPath/~Content~PublishFiles~" +
                folderPath +
                "~" +
                jwstartpage +
                "?JWVideoParentID/" +
                contentId +
                "/jwvideokey/" +
                jwVideoKey;
          }
          else {
            urlForView = siteUrl +
                "/content/publishfiles/" +
                folderPath.toLowerCase() +
                "/" +
                startPage;
            if (uiSettingModel.isCloudStorageEnabled == "true") {
              urlForView = uiSettingModel.azureRootPath +
                  "content/publishfiles/" +
                  folderPath.toLowerCase() +
                  "/" +
                  startPage;
              //urlForView = urlForView.toLowerCase();
            }
            // if (uiSettingModel.isCloudStorageEnabled == "true") {
            //   urlForView = uiSettingModel.AzureRootPath +
            //       "Content/PublishFiles/" +
            //       folderpath +
            //       "/";
            //   urlForView = urlForView.toLowerCase() + startpage;
            // } commented as per ajay only that content have that issue
          }
        } // End of 11,14,21,36

        else if (objectTypeId == "28") {
          urlForView = startPage;
        }
        else if (objectTypeId == "26") {
          // scorm content

          String startPage2 = startPage.replaceAll("/", "~");

          urlForView = siteUrl +
              "ajaxcourse/CourseName/" +
              courseName +
              "/ScoID/" +
              scoId +
              "/ContentID/" +
              contentId +
              "/ContentTypeId/" +
              objectTypeId +
              "/AllowCourseTracking/true/trackuserid/" +
              userid +
              "/eventkey//eventtype//ismobilecontentview/true/ContentPath/~Content~PublishFiles~" +
              folderPath +
              "~" +
              startPage2 +
              "?nativeappurl=true";
        }
        else if (objectTypeId == "27") {
          urlForView = siteUrl +
              "/ajaxcourse/CourseName/" +
              courseName +
              "/ContentID/" +
              contentId +
              "/ContentTypeId/" +
              objectTypeId +
              "/AllowCourseTracking/true/trackuserid/" +
              userid +
              "/eventkey//eventtype//ismobilecontentview/true/ContentPath/~" +
              startPage +
              "?nativeappurl=true";
        }

        /// need to fix after TinConfig
        else if (objectTypeId == "102") {
          String encodedString = "";

          encodedString = lrsActor.replaceAll(" ", "%20");

          if (isValidString(folderId) && folderId != "0") {
            urlForView = ApiEndpoints.mainSiteURL +
                "Content/PublishFiles/" +
                folderPath +
                "/" +
                startPage +
                "?endpoint=" +
                lrsEndPoint +
                "&auth=" +
                lrsAuthorizationKey +
                "&actor=" +
                encodedString +
                "&registration=" +
                folderId +
                "&ContentID=" +
                contentId +
                "&ObjectTypeID=" +
                objectTypeId +
                "&CanTrack=YES";
          }
          else {
            urlForView = ApiEndpoints.mainSiteURL +
                "Content/PublishFiles/" +
                folderPath +
                "/" +
                startPage +
                "?endpoint=" +
                lrsEndPoint +
                "&auth=" +
                lrsAuthorizationKey +
                "&actor=" +
                encodedString +
                "&ContentID=" +
                contentId +
                "&ObjectTypeID=" +
                objectTypeId +
                "&CanTrack=YES";
          }

          print("isCloudStorageEnabled:${uiSettingModel.isCloudStorageEnabled}");
          if (uiSettingModel.isCloudStorageEnabled == "true") {
            urlForView = uiSettingModel.azureRootPath +
                "Content/PublishFiles/" +
                folderPath +
                "/" +
                startPage +
                "?endpoint=" +
                "&auth=" +
                "&actor=" +
                encodedString +
                "&ContentID=" +
                contentId +
                "&ObjectTypeID=" +
                objectTypeId +
                "&CanTrack=NO" +
                "&nativeappURL=true";
          }
        }
        else if (objectTypeId == "52") {
          String cerName = contentId + "/Certificate";
          urlForView = siteUrl +
              "/content/sitefiles/" +
              siteId +
              "/UserCertificates/" +
              userid +
              "/" +
              cerName +
              ".pdf";
        }
        else if (objectTypeId == "688") {
        }
        else if (objectTypeId == "20") {
          urlForView = siteUrl +
              "/content/PublishFiles/" +
              folderPath +
              "/glossary_english.html";

          /// uiSettingsModel
          if (uiSettingModel.isCloudStorageEnabled == "true") {
            urlForView = uiSettingModel.azureRootPath +
                "content/publishfiles/" +
                folderPath +
                "/glossary_english.html";
          }
        }
        else {}

        if (objectTypeId != "102" && !urlForView.toLowerCase().contains("coursemedium") && uiSettingModel.isCloudStorageEnabled != "true") {
          urlForView = urlForView.replaceAll("\\?", "%3F");
        }

        if (objectTypeId == "11" || objectTypeId == "14" || objectTypeId == "20" || objectTypeId == "36" && uiSettingModel.isCloudStorageEnabled != "true") {
          urlForView = urlForView + "?fromNativeapp=true";
        }

        String encodedStr = "";
        if (objectTypeId == "102" || objectTypeId == "28") {
          encodedStr = replace(urlForView);
        }
        else {
          encodedStr = replace(urlForView);
        }

        if (encodedStr.toLowerCase().contains(".xlsx") ||
            encodedStr.toLowerCase().contains(".xls") ||
            encodedStr.toLowerCase().contains(".ppt") ||
            encodedStr.toLowerCase().contains(".pptx") ||
            encodedStr.toLowerCase().contains(".pdf") ||
            encodedStr.toLowerCase().contains(".doc") ||
            encodedStr.toLowerCase().contains(".docx")) {
          print("......xxxxxxx.....");
          encodedStr = "https://docs.google.com/gview?embedded=true&url=" + encodedStr;
          //encodedStr = "https://docs.google.com/gview?embedded=true&url=" + encodedStr.toLowerCase();
        }

        print("..............this is final URL..........");
        print("..............SAGAR..........");
        print("......$objectTypeId.......................");
        print("...URL...$encodedStr");

/*
          if( encodedStr.toLowerCase().contains(".pdf") )
            {


             // encodedStr = "http://africau.edu/images/default/sample.pdf";

              http.Response response = await http.get(encodedStr);
              Uint8List pdfBytes =response.bodyBytes; //Uint8List

             // print("......responce.statusCode..${response.statusCode}");
             // print("......responce...${pdfBytes}");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfCourseLaunch(url: encodedStr,pdfBytes: pdfBytes,isOffline: false,)));
            }
          else{
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(encodedStr)));
          }*/

        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(encodedStr,myLearningModel)));
        //await Navigator.of(context).push(MaterialPageRoute(builder: (context) => InAppWebCourseLaunch(encodedStr,myLearningModel)));
        //logger.e(".......i am back.....");

        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoCourseLaunch(myFile: myFile,)));

        ///return string value

        retUrl = encodedStr;
      }
    }

    /// this is online part

    return retUrl;
  }

  bool isValidString(String str) {
    try {
      if (str.isEmpty ||
          str == null ||
          str == "" ||
          str == "null" ||
          str == "undefined" ||
          str == "null\n") {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  String replace(String str) {
    return str.replaceAll(" ", "%20");
  }

  Future<String> _getLocalData(String key) async {
    List<Map<String, dynamic>> response = await _localHelper.localService(
      enumLocalDatabaseOperation: LocalDatabaseOperation.read,
      table: table_splash,
      keys: [key],
    );

    Map<String, dynamic>? data = response.isNotEmpty ? response.first : null;
    if (data == null) return "";

    dynamic value = data[key];
    //print("Key------$value");

    if (value == null) return "";
    String news = value;
    return news;
  }

  Future<DateTime?> convertToDate(String dateString) async {
    DateTime? convertedDate;
    if (!isValidString(dateString)) return convertedDate;
    try {
      convertedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);
    } catch (e) {
      // TODO Auto-generated catch block
      //e.printStackTrace();
    }
    return convertedDate;
  }

  Future<bool> isCourseEndDateCompleted(String endDate) async {
    bool isCompleted = true;

    DateTime? strDate = await convertToDate(endDate);

    if (strDate != null) {
      if (DateTime.now().isAfter(strDate)) {
// today is after date 2
        isCompleted = true;
      } else {
        isCompleted = false;
      }
    }

    return isCompleted;
  }

  Future<String> getCurrentDateTimeInStr() async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat("yyyy-MM-dd hh:mm:ss");
    String formatted = formatter.format(now);

    return formatted;
  }

  Future<void> openFile(String path) async {
    final result = await OpenFile.open(path);

    print(".....file...open....$result");
  }

  alertDialog(BuildContext context) {
    // This is the ok button
    Widget ok = FlatButton(
      child: Text("Okay"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // show the alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Comming Soon", style: TextStyle(color: Colors.black),),
          content: Text("Offline HTML content will not load  "),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }
}
