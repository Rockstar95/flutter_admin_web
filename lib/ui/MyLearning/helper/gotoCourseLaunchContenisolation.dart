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

class GotoCourseLaunchContentisolation {
  final LocalDataProvider _localHelper =
      LocalDataProvider(localDataProviderType: LocalDataProviderType.hive);

  DummyMyCatelogResponseTable2 myLearningModel;
  BuildContext context;
  bool isIconEnabled = false;

  UISettingModel uiSettingModel;

  String urlForView = "";
  Logger logger = Logger();

  List<DummyMyCatelogResponseTable2> list;

  factory GotoCourseLaunchContentisolation(
      BuildContext context,
      DummyMyCatelogResponseTable2 myLearningModel,
      UISettingModel uiSettingModel,
      List<DummyMyCatelogResponseTable2> list) {
    return GotoCourseLaunchContentisolation._internal(
        context, myLearningModel, uiSettingModel, list);
  }

  GotoCourseLaunchContentisolation._internal(this.context, this.myLearningModel, this.uiSettingModel, this.list) {
    print("i am in it of GotoCourseLaunch");
  }

  Future<String> getCourseUrl() async {
    String retUrl = "";

    String strUserID = await sharePrefGetString(sharedPref_LoginUserID);
    String userName = await sharePrefGetString(sharedPref_LoginUserName);
    String password = await sharePrefGetString(sharedPref_LoginPassword);
    print("Password:$password");

    String objecttypeid = myLearningModel.objecttypeid.toString();
    // String siteurl = ApiEndpoints.strSiteUrl;
    String scoid = myLearningModel.scoid.toString();
    String contentid = myLearningModel.contentid.toString();
    String userid = myLearningModel.userid.toString();
    String folderpath = myLearningModel.folderpath.toString();
    String startpage = myLearningModel.startpage.toString();
    String courseName = myLearningModel.name.toString();
    String jwvideokey = myLearningModel.jwvideokey.toString();
    String siteid = myLearningModel.siteid.toString();
    String activityid = myLearningModel.activityid.toString();
    String folderid = myLearningModel.folderid.toString();
    String startPage = myLearningModel.startpage.toString();
    String endDuarationDate = myLearningModel.durationenddate.toString();

    String mobileGetNativeMenusResponseStr = await _getLocalData(mobileTinCanConfigurationsKey);
    String tempTinCanData = mobileGetNativeMenusResponseStr.replaceAll("'", '"');
    if (tempTinCanData.startsWith('"')) tempTinCanData = tempTinCanData.substring(1);
    if (tempTinCanData.endsWith('"')) tempTinCanData = tempTinCanData.substring(0, tempTinCanData.length - 1);

    log("TinCanData:$tempTinCanData");

    TinCanData tinCanData = tinCanDataFromJson(tempTinCanData);

    String authKey = tinCanData.lrsauthorization;
    String authPassword = tinCanData.lrsauthorizationpassword;

    String base64lrsAuthKey = authKey + ":" + authPassword;

    // String dir = await AppDirectory.getDocumentsDirectory();

    // String downloadDestFolderPath = dir + "/.Mydownloads/Contentdownloads" + "/" + contentid;
    //
    // String finalDownloadedFilePath = downloadDestFolderPath + "/" + startPage;
    //
    // print('downlaodedfile $finalDownloadedFilePath');
    //
    // File myFile = new File(finalDownloadedFilePath);
    // bool isDownloadFileExists = await myFile.exists();
    bool isDownloadFileExists = false;
    String offlinePath = "";

    /// need to ask what we need to do here and when this condition accours
    if (isValidString(endDuarationDate)) {
      bool isCompleted = await isCourseEndDateCompleted(endDuarationDate);

      if (isCompleted) {
        //return null;
      }
    }

    if (isDownloadFileExists && objecttypeid != "70") {
    //   print('if___course_launch_ogjtypr $objecttypeid');
    //
    //   ///TIN CAN OPTIONS
    //
    //   String lrsEndPoint = "";
    //
    //   String lrsActor = "{\"name\":[\"" +
    //       userName +
    //       "\"],\"account\":[{\"accountServiceHomePage\":\"" +
    //       ApiEndpoints.mainSiteURL +
    //       "\",\"accountName\":\"" +
    //       password +
    //       "|" +
    //       strUserID +
    //       "\"}],\"objectType\":\"Agent\"}&activity_id=" +
    //       activityid +
    //       "&grouping=" +
    //       activityid;
    //
    //   String lrsAuthorizationKey = "";
    //
    //   String enabletincanSupportforco = "";
    //
    //   String enabletincanSupportforao = "";
    //
    //   String enabletincanSupportforlt = "";
    //
    //   String isTinCan = "";
    //
    //   String autKey = "";
    //
    //   try {
    //     if (tinCanData != null) {
    //       lrsEndPoint = tinCanData.lrsendpoint;
    //       autKey = base64lrsAuthKey;
    //       enabletincanSupportforco = tinCanData.enabletincansupportforco;
    //       enabletincanSupportforao = tinCanData.enabletincansupportforao;
    //       enabletincanSupportforlt = tinCanData.enabletincansupportforlt;
    //       isTinCan = tinCanData.istincan;
    //     }
    //   } catch (e) {
    //     //e.printStackTrace();
    //   }
    //
    //   Uint8List encrpt = utf8.encode(autKey) as Uint8List;
    //   String base64 = base64Encode(encrpt);
    //   lrsAuthorizationKey = "Basic%20" + base64;
    //
    //   ///End TIN CAN OPTIONS
    //
    //   /// Generate Offline Path
    //
    //   if (objecttypeid == "8" || objecttypeid == "9" || objecttypeid == "10") {
    //     /// get something from database is pending
    //
    //     /// Remove this line
    //     offlinePath = "file://" + finalDownloadedFilePath;
    //   }
    //   else if (objecttypeid == "102") {
    //     String encodedString = lrsActor;
    //
    //     offlinePath = "file://" + offlinePath;
    //     offlinePath = offlinePath +
    //         "?&endpoint=" +
    //         lrsEndPoint +
    //         "&auth=" +
    //         lrsAuthorizationKey +
    //         "&actor=" +
    //         encodedString +
    //         "&cid=0&nativeappURL=true&IsInstancyContent=true";
    //   }
    //   else if (objecttypeid == "688") {
    //   }
    //   else if (objecttypeid == "26") {
    //     offlinePath = "file://" +
    //         dir +
    //         "/Mydownloads/Content/LaunchCourse.html?contentpath=file://" +
    //         offlinePath;
    //   }
    //   else if (objecttypeid == "52") {
    //     String cerName = contentid + "/Certificate";
    //
    //     offlinePath = offlinePath + "/" + userid + "/" + cerName + ".pdf";
    //   }
    //   else if (objecttypeid == "11" || objecttypeid == "14" || objecttypeid == "21" || objecttypeid == "36" || objecttypeid == "28") {
    //     offlinePath = "file://" + offlinePath;
    //
    //     /// CMIModel ,LearnerSessionModel
    //
    //     if (myLearningModel.actualstatus == "Not Started" ||
    //         myLearningModel.actualstatus == "") {
    //       // need to save CMI model
    //
    //       CMIModel model = CMIModel(
    //           datecompleted: "",
    //           siteId: myLearningModel.siteid.toString(),
    //           userId: myLearningModel.userid,
    //           startdate: await getCurrentDateTimeInStr(),
    //           scoId: myLearningModel.scoid,
    //           isupdate: "false",
    //           status: "incomplete",
    //           seqNum: "0",
    //           percentageCompleted: "50",
    //           timespent: "",
    //           objecttypeid: myLearningModel.objecttypeid.toString(),
    //           sitrurl: myLearningModel.siteurl);
    //
    //       ///databaseH.injectIntoCMITable(model, "false");
    //
    //       /// need to find getLatestAttempt
    //       //int attempts = databaseH.getLatestAttempt(myLearningModel);
    //
    //       int attempts = 0;
    //
    //       LearnerSessionModel learnerSessionModel = new LearnerSessionModel(
    //         siteID: myLearningModel.siteid.toString(),
    //         userID: myLearningModel.userid.toString(),
    //         scoID: myLearningModel.scoid.toString(),
    //         attemptNumber: (attempts + 1).toString(),
    //         sessionDateTime: await getCurrentDateTimeInStr(),
    //       );
    //
    //       ///databaseH.insertUserSession(learnerSessionModel);
    //
    //     }
    //   }
    //   else {
    //     offlinePath = "file://" + finalDownloadedFilePath;
    //   }
    //
    //   String offlinePathEncode = offlinePath.replaceAll(" ", "%20");
    //
    //   print("final....offlinePathEncode....path.....$offlinePathEncode");
    //   print("final....finalDownloadedFilePath....path.....$finalDownloadedFilePath");
    //
    //   if (finalDownloadedFilePath.contains(".mp4")) {
    //     Navigator.of(context).push(MaterialPageRoute(
    //         builder: (context) => VideoCourseLaunch(
    //               myFile: myFile,
    //               pdfBytes: myFile.readAsBytesSync(),
    //             )));
    //   }
    //   else if (finalDownloadedFilePath.toLowerCase().contains(".xlsx") ||
    //       finalDownloadedFilePath.toLowerCase().contains(".xls") ||
    //       finalDownloadedFilePath.toLowerCase().contains(".ppt") ||
    //       finalDownloadedFilePath.toLowerCase().contains(".pptx") ||
    //       finalDownloadedFilePath.toLowerCase().contains(".pdf") ||
    //       finalDownloadedFilePath.toLowerCase().contains(".doc") ||
    //       finalDownloadedFilePath.toLowerCase().contains(".docx")) {
    //     await openFile(finalDownloadedFilePath);
    //   } else {
    //     print('finalDownloadedFilePath $finalDownloadedFilePath');
    //
    //     alertDialog(context);
    //   }
    }

    /// this is offline part
    else {
      print('else___course_launch_ogjtypr GotoCourseLaunchContentisolation $objecttypeid');

      if (objecttypeid == "10" && myLearningModel.bit5) {
        // Need to open EventTrackListTabsActivity

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventTrackList(
                  myLearningModel,
                  true,
                  list,
                )));
      }
      else {
        if (objecttypeid == "11" || objecttypeid == "14" || objecttypeid == "21" || objecttypeid == "36" || objecttypeid == "28") {
          if (myLearningModel.actualstatus == "Not Started" ||
              myLearningModel.actualstatus == null ||
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
        }

        ///TIN CAN OPTIONS

        String lrsEndPoint = "";

        String lrsActor = "{\"name\":[\"" +
            userName +
            "\"],\"account\":[{\"accountServiceHomePage\":\"" +
            ApiEndpoints.mainSiteURL +
            //"https://enterprisedemo.instancy.com/" +
            "\",\"accountName\":\"" +
            authKey +
            "|" +
            strUserID +
            "\"}],\"objectType\":\"Agent\"}&activity_id=" +
            activityid +
            "&grouping=" +
            activityid;

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

        print("isTinCan:$isTinCan");
        print("enabletincanSupportforco:$enabletincanSupportforco");
        print("enabletincanSupportforao:$enabletincanSupportforao");
        print("enabletincanSupportforlt:$enabletincanSupportforlt");

        // Start of 8,9,10
        if (objecttypeid == "8" || objecttypeid == "9" || objecttypeid == "10") {
          urlForView = "Content/PublishFiles/" +
              (folderpath.isNotEmpty ? "$folderpath/" : "") +
              myLearningModel.startpage +
              "?nativeappURL=true&IsInstancyContent=true";

          if (isTinCan == "true") {
            if (objecttypeid == "8" && enabletincanSupportforco.toLowerCase() == "true") {
              urlForView = urlForView +
                  "&endpoint=" +
                  lrsEndPoint +
                  "&auth=" +
                  lrsAuthorizationKey +
                  "&actor=" +
                  lrsActor;
            }
            else if (objecttypeid == "9" && enabletincanSupportforao.toLowerCase() == "true") {
              urlForView = urlForView +
                  "&endpoint=" +
                  lrsEndPoint +
                  "&auth=" +
                  lrsAuthorizationKey +
                  "&actor=" +
                  lrsActor;
            }
            else if (objecttypeid == "10" && enabletincanSupportforlt.toLowerCase() == "true") {
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

        else if (objecttypeid == "11" || objecttypeid == "14" || objecttypeid == "21" || objecttypeid == "36") {
          if (objecttypeid == "11" && isValidString(jwvideokey)) {
            String jwstartpage = "";
            if (isValidString(myLearningModel.jwstartpage)) {
              jwstartpage = myLearningModel.jwstartpage;
            } else {
              jwstartpage = startpage;
            }

            jwstartpage = jwstartpage.replaceAll("/", "/");

            urlForView = "/Content/PublishFiles/" +
                folderpath +
                "/" +
                jwstartpage +
                "?nativeappURL=true/JWVideoParentID/" +
                contentid +
                "/jwvideokey/" +
                jwvideokey;
          } else {
            urlForView =
                "/Content/PublishFiles/" + folderpath + "/" + startpage;
            if (uiSettingModel.isCloudStorageEnabled == "true") {
              urlForView = uiSettingModel.azureRootPath +
                  "Content/PublishFiles/" +
                  folderpath +
                  "/" +
                  startpage;
              urlForView = urlForView.toLowerCase();
            }
          }
        } // End of 11,14,21,36

        else if (objecttypeid == "28") {
          urlForView = startpage;
        }
        else if (objecttypeid == "26") {
          // scorm content

          String startPage = startpage.replaceAll("/", "/");

          urlForView = "/Content/PublishFiles/" +
              folderpath +
              "/" +
              startPage +
              "?nativeappurl=true";
        }
        else if (objecttypeid == "27") {
          urlForView = startpage + "?nativeappurl=true";
        }

        /// need to fix after TinConfig

        else if (objecttypeid == "102") {
          String encodedString = "";

          encodedString = lrsActor.replaceAll(" ", "%20");

          if (isValidString(folderid) && folderid != "0") {
            urlForView = "Content/PublishFiles/" +
                folderpath +
                "/" +
                startpage +
                "?endpoint=" +
                lrsEndPoint +
                "&auth=" +
                lrsAuthorizationKey +
                "&actor=" +
                encodedString +
                "&registration=" +
                folderid +
                "&ContentID=" +
                contentid +
                "&ObjectTypeID=" +
                objecttypeid +
                "&CanTrack=YES";
          }
          else {
            urlForView = "Content/PublishFiles/" +
                folderpath +
                "/" +
                startpage +
                "?endpoint=" +
                lrsEndPoint +
                "&auth=" +
                lrsAuthorizationKey +
                "&actor=" +
                encodedString +
                "&ContentID=" +
                contentid +
                "&ObjectTypeID=" +
                objecttypeid +
                "&CanTrack=YES";
          }

          print("isCloudStorageEnabled:${uiSettingModel.isCloudStorageEnabled}");
          if (uiSettingModel.isCloudStorageEnabled == "true") {
            urlForView = "Content/PublishFiles/" +
                folderpath +
                "/" +
                startpage +
                "?endpoint=" +
                lrsEndPoint +
                "&auth=$lrsAuthorizationKey" +
                "" +
                "&actor=" +
                encodedString +
                "&ContentID=" +
                contentid +
                "&ObjectTypeID=" +
                objecttypeid +
                "&CanTrack=NO" +
                "&nativeappURL=true";

            /*urlForView = "Content/PublishFiles/" +
                folderpath +
                "/" +
                startpage +
                "?endpoint=" +
                "" +
                "&auth=${lrsAuthorizationKey}" +
                "" +
                "&actor=" +
                encodedString;*/
          }
        }
        else if (objecttypeid == "52") {
          String cerName = contentid + "/Certificate";
          urlForView = "/content/sitefiles/" +
              siteid +
              "/UserCertificates/" +
              userid +
              "/" +
              cerName +
              ".pdf";
        }
        else if (objecttypeid == "688") {
        }
        else if (objecttypeid == "20") {
          urlForView =
              "/content/PublishFiles/" + folderpath + "/glossary_english.html";

          /// uiSettingsModel
          if (uiSettingModel.isCloudStorageEnabled == "true") {
            urlForView = uiSettingModel.azureRootPath +
                "content/publishfiles/" +
                folderpath +
                "/glossary_english.html";
          }
        }
        else {}

        if (objecttypeid != "102" && !urlForView.toLowerCase().contains("coursemedium") && uiSettingModel.isCloudStorageEnabled != "true") {
          urlForView = urlForView.replaceAll("\\?", "%3F");
        }

        if (objecttypeid == "11" || objecttypeid == "14" || objecttypeid == "20" || objecttypeid == "36" && uiSettingModel.isCloudStorageEnabled != "true") {
          urlForView = urlForView + "?fromNativeapp=true";
        }

        String encodedStr = "";
        if (objecttypeid == "102" || objecttypeid == "28") {
          encodedStr = replace(urlForView);
        } else {
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
          encodedStr =
              "https://docs.google.com/gview?embedded=true&url=" + encodedStr;
        }

        print("..............this is final URL..........");
        print("..............SAGAR..........");
        print("......$objecttypeid.......................");
        print("...URL...$encodedStr");

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
          title: Text("Comming Soon"),
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
