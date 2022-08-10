import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/ui_setting_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/dataprovider/data_provider.dart';
import 'package:flutter_admin_web/framework/dataprovider/helper/local_database_helper.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';

class GotoCourseLaunchCatalog {
  final LocalDataProvider _localHelper =
      LocalDataProvider(localDataProviderType: LocalDataProviderType.hive);

  DummyMyCatelogResponseTable2 myLearningModel;
  BuildContext context;
  bool isIconEnabled;

  UISettingModel uiSettingModel;

  String urlForView = "";
  bool isAngularLaunch = false;
  Logger logger = Logger();

  List<DummyMyCatelogResponseTable2> list;

  factory GotoCourseLaunchCatalog(
      BuildContext context,
      DummyMyCatelogResponseTable2 myLearningModel,
      bool isIconEnabled,
      UISettingModel uiSettingModel,
      List<DummyMyCatelogResponseTable2> list) {
    return GotoCourseLaunchCatalog._internal(
        context, myLearningModel, isIconEnabled, uiSettingModel, list);
  }

  GotoCourseLaunchCatalog._internal(this.context, this.myLearningModel,
      this.isIconEnabled, this.uiSettingModel, this.list) {
    print("i am in it of GotoCourseLaunchCatalog");
  }

  Future<String> getCourseUrl() async {
    String retUrl = "";

    isAngularLaunch = true;

    String objecttypeid = myLearningModel.objecttypeid.toString();
    String siteurl = ApiEndpoints.strSiteUrl;
    String scoid = myLearningModel.scoid.toString();
    String contentid = myLearningModel.contentid.toString();
    String userid = myLearningModel.userid.toString();
    String folderpath = myLearningModel.folderpath.toString();
    String startpage = myLearningModel.startpage.toString();
    String courseName = myLearningModel.name.toString();
    String jwvideokey = myLearningModel.jwvideokey.toString();
    String siteid = myLearningModel.siteid.toString();
    String folderid = myLearningModel.folderid.toString();
    String startPage = myLearningModel.startpage.toString();

    if (objecttypeid == "10" && myLearningModel.bit5) {
      // Need to open EventTrackListTabsActivity

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventTrackList(
                myLearningModel,
                true,
                list,
              )));
    } else {
      // Start of 8,9,10
      if (objecttypeid == "8" || objecttypeid == "9" || objecttypeid == "10") {
        urlForView = siteurl +
            "ajaxcourse/ScoID/" +
            scoid +
            "/ContentTypeId/" +
            objecttypeid +
            "/ContentID/" +
            contentid +
            "/AllowCourseTracking/false/trackuserid/" +
            userid +
            "/ismobilecontentview/true/ContentPath/~Content~PublishFiles~" +
            folderpath +
            "~" +
            myLearningModel.startpage +
            "?nativeappURL=true";
      } // End of 8,9,10

      else if (objecttypeid == "11") {
        if (objecttypeid == "11" &&
            isValidString(myLearningModel.jwvideokey ?? "")) {
          urlForView = "http://content.jwplatform.com/players/" +
              jwvideokey +
              "-" +
              myLearningModel.cloudmediaplayerkey +
              ".html";
        } else {
          urlForView =
              siteurl + "/Content/PublishFiles/" + folderpath + "/" + startPage;

          urlForView =
              siteurl + "/Content/PublishFiles/" + folderpath + "/" + startpage;
          if (uiSettingModel.isCloudStorageEnabled == "true") {
            urlForView = uiSettingModel.azureRootPath +
                "Content/PublishFiles/" +
                folderpath +
                "/" +
                startpage;
            urlForView = urlForView.toLowerCase();
          }
        }
      } else if (objecttypeid == "14" ||
          objecttypeid == "21" ||
          objecttypeid == "36") {
        urlForView =
            siteurl + "/Content/PublishFiles/" + folderpath + "/" + startpage;
        if (uiSettingModel.isCloudStorageEnabled == "true") {
          urlForView = uiSettingModel.azureRootPath +
              "Content/PublishFiles/" +
              folderpath +
              "/" +
              startpage;
          urlForView = urlForView.toLowerCase();
        }
      } else if (objecttypeid == "28") {
        urlForView = startpage;
      } else if (objecttypeid == "26") {
        // scorm content

        if (isAngularLaunch) {
          String startPage = startpage.replaceAll("/", "~");

          urlForView = siteurl +
              "ajaxcourse/CourseName/" +
              courseName +
              "/ScoID/" +
              scoid +
              "/ContentID/" +
              contentid +
              "/ContentTypeId/" +
              objecttypeid +
              "/AllowCourseTracking/false/trackuserid/" +
              userid +
              "/eventkey//eventtype//ismobilecontentview/true/ContentPath/~Content~PublishFiles~" +
              folderpath +
              "~" +
              startPage +
              "?nativeappurl=true";
        } else {
          // normal launch
          urlForView = siteurl +
              "/remote/AJAXLaunchPage.aspx?path=/Content/PublishFiles/" +
              folderpath +
              "/" +
              startpage +
              "&CourseName=" +
              courseName +
              "&ContentID=" +
              contentid +
              "&ObjectTypeID=" +
              objecttypeid +
              "&CanTrack=Yes&SCOID=" +
              scoid +
              "&eventkey=&eventtype=" +
              "&trackinguserid=" +
              userid;
        }
      } else if (objecttypeid == "27") {
        if (isAngularLaunch) {
          urlForView = siteurl +
              "/ajaxcourse/CourseName/" +
              courseName +
              "/ContentID/" +
              contentid +
              "/ContentTypeId/" +
              objecttypeid +
              "/AllowCourseTracking/false/trackuserid/" +
              userid +
              "/eventkey//eventtype//ismobilecontentview/true/ContentPath/~" +
              startpage +
              "?nativeappurl=true";
        } else {
          // normal launch
          urlForView = siteurl +
              "/remote/AJAXLaunchPage.aspx?Path=" +
              startpage +
              "&CourseName=" +
              courseName +
              "&ContentID=" +
              contentid +
              "&CanTrack=Yes" +
              "&ObjectTypeID=" +
              objecttypeid +
              "&SCOID=" +
              scoid +
              "&eventkey=&eventtype=" +
              "&trackinguserid=" +
              userid;
        }
      } else if (objecttypeid == "102") {
        String encodedString = "";

        urlForView = ApiEndpoints.mainSiteURL +
            "Content/PublishFiles/" +
            folderpath +
            "/" +
            startpage +
            "?endpoint=" +
            "" +
            "&auth=" +
            "" +
            "&actor=" +
            encodedString +
            "&registration=" +
            folderid +
            "&ContentID=" +
            contentid +
            "&ObjectTypeID=" +
            objecttypeid +
            "&CanTrack=No" +
            "&nativeappURL=true";

        if (uiSettingModel.isCloudStorageEnabled == "true") {
          urlForView = uiSettingModel.azureRootPath +
              "Content/PublishFiles/" +
              folderpath +
              "/" +
              startpage +
              "?endpoint=" +
              "" +
              "&auth=" +
              "" +
              "&actor=" +
              encodedString +
              "&ContentID=" +
              contentid +
              "&ObjectTypeID=" +
              objecttypeid +
              "&CanTrack=NO" +
              "&nativeappURL=true";
        }
      } else if (objecttypeid == "52") {
        String cerName = contentid + "/Certificate";
        urlForView = siteurl +
            "/content/sitefiles/" +
            siteid +
            "/UserCertificates/" +
            userid +
            "/" +
            cerName +
            ".pdf";
      } else if (objecttypeid == "688") {
      } else if (objecttypeid == "20") {
        urlForView = siteurl +
            "/content/PublishFiles/" +
            folderpath +
            "/glossary_english.html";

        /// uiSettingsModel
        if (uiSettingModel.isCloudStorageEnabled == "true") {
          urlForView = uiSettingModel.azureRootPath +
              "content/publishfiles/" +
              folderpath +
              "/glossary_english.html";
        }
      } else {}

      if (objecttypeid != "102" &&
          !urlForView.toLowerCase().contains("coursemedium") &&
          uiSettingModel.isCloudStorageEnabled != "true") {
        urlForView = urlForView.replaceAll("\\?", "%3F");
      }

      if (objecttypeid == "11" ||
          objecttypeid == "14" ||
          objecttypeid == "20" ||
          objecttypeid == "36" &&
              uiSettingModel.isCloudStorageEnabled != "true") {
        urlForView = urlForView + "?fromNativeapp=true";
      }

      String encodedStr = "";
      if (objecttypeid == "102" || objecttypeid == "28") {
        encodedStr = replace(urlForView);
      } else {
//
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
      }

      print("..............this is final URL..........");
      print("..............SAGAR..........");
      print("......$objecttypeid.......................");
      print("...URL...$encodedStr");

      retUrl = encodedStr;
    }

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

    Map<String, dynamic> data = response.isNotEmpty ? response.first : {};
    if (data.isEmpty) return "";

    dynamic value = data[Key];
    //print("Key------$value");

    if (value == null) return "";
    String news = value;
    return news;
  }

  Future<DateTime?> convertToDate(String dateString) async {
    DateTime? convertedDate;
    if (!isValidString(dateString)) return convertedDate;
    try {
      convertedDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);
    } catch (e) {
      //e.printStackTrace();
    }
    return convertedDate;
  }

  Future<bool> isCourseEndDateCompleted(String endDate) async {
    bool isCompleted = true;

    DateTime? strDate = await convertToDate(endDate);

    if (strDate != null && DateTime.now().isAfter(strDate)) {
// today is after date 2
      isCompleted = true;
    } else {
      isCompleted = false;
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
