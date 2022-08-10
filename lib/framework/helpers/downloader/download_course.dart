import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_admin_web/framework/bloc/app/ui_setting_model.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/file_course_downloader.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/zip_course_downloader.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/model/CMIModel.dart';
import 'package:flutter_admin_web/framework/repository/general/model/LearnerSessionModel.dart';
import 'package:flutter_admin_web/framework/repository/general/model/ResCmiData.dart';
import 'package:flutter_admin_web/framework/repository/general/model/StudentResponseModel.dart';
import 'package:flutter_admin_web/framework/repository/general/model/jwvideo.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:logger/logger.dart';
import 'package:xml2json/xml2json.dart';

class DownloadCourse {
  DummyMyCatelogResponseTable2 learningModel;
  BuildContext context;
  bool isIconEnabled = false;

  UISettingModel uiSettingsModel;
  int position = 0;
  String pathSeparator = "";
  late GeneralRepository generalRepository;

  ///Downloader
  ZipCourseDownloader? zipCourseDownloader;
  FileCourseDownloader? fileCourseDownloader;
  FileCourseDownloader? jwtCourseDownloader;
  int _downloadProgress = 0;
  bool _downloaded = false;
  String webApiUrl = "";

  Logger? logger;

  StreamController<int> streamController;
  final void Function(int, DummyMyCatelogResponseTable2, int) doSomething;

  factory DownloadCourse(
      BuildContext context,
      DummyMyCatelogResponseTable2 myLearningModel,
      bool isIconEnabled,
      UISettingModel uiSettingModel,
      int position,
      StreamController<int> streamController,
      Function(int i, DummyMyCatelogResponseTable2 table2, int j) doSomething) {
    return DownloadCourse._internal(context, myLearningModel, isIconEnabled,
        uiSettingModel, position, streamController, doSomething);
  }

  DownloadCourse._internal(
      this.context,
      this.learningModel,
      this.isIconEnabled,
      this.uiSettingsModel,
      this.position,
      this.streamController,
      this.doSomething) {
    print("i am in it of DownloadTheCourse $streamController");
    print(
        ".....learningModel.objecttypeid.......${learningModel.objecttypeid}");
    print(
        ".....learningModel.actualstatus.......${learningModel.actualstatus}");

    logger = Logger();
    if (pathSeparator == null || pathSeparator.trim().isEmpty) {
      pathSeparator = Platform.pathSeparator;
    }
    generalRepository = GeneralRepositoryBuilder.repository();
  }

  Future<void> downloadTheCourse() async {
    String objecttypeid = learningModel.objecttypeid.toString();
    String siteurl = learningModel.siteurl;
    String scoid = learningModel.scoid.toString();
    String contentid = learningModel.contentid.toString();
    String userid = learningModel.userid.toString();
    String folderpath = learningModel.folderpath.toString();
    String startpage = learningModel.startpage.toString();
    String courseName = learningModel.name.toString();
    String jwvideokey = learningModel.jwvideokey.toString();
    String siteid = learningModel.siteid.toString();
    String activityid = learningModel.activityid.toString();
    String folderid = learningModel.folderid.toString();
    String cloudmediaplayerkey = learningModel.cloudmediaplayerkey.toString();
    webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

    String tempUrl = ApiEndpoints.strSiteUrl;

    if (uiSettingsModel.isCloudStorageEnabled == "true") {
      tempUrl = uiSettingsModel.azureRootPath;
    }

    bool isZipFile = false;

    List<String> downloadSourcePath = [];

    String strdownloadSourcePath;

    switch (objecttypeid) {
      case "52":
        strdownloadSourcePath = tempUrl +
            "/content/sitefiles/" +
            siteurl +
            "/usercertificates/" +
            siteurl +
            "/" +
            contentid +
            ".pdf";
        isZipFile = false;
        downloadSourcePath.add(strdownloadSourcePath);
        break;
      case "11":
      case "14":
        if (objecttypeid == "11" &&
            jwvideokey.length > 0 &&
            cloudmediaplayerkey.length > 0) {
          //JW Standalone video content in offline mode.

          strdownloadSourcePath =
              "https://content.jwplatform.com/videos/" + jwvideokey + ".mp4";
          downloadSourcePath.add(strdownloadSourcePath);
        } else {
          strdownloadSourcePath =
              tempUrl + "content/publishfiles/" + folderpath + "/" + startpage;
          downloadSourcePath.add(strdownloadSourcePath);
        }
        isZipFile = false;
        break;
      case "8":
      case "9":
      case "10":
      default:
        strdownloadSourcePath = tempUrl +
            "content/publishfiles/" +
            folderpath +
            "/" +
            contentid +
            ".zip";
        isZipFile = true;
        downloadSourcePath.add(strdownloadSourcePath);
        break;
    }

    bool finalisZipFile = isZipFile;
    String finalTempUrl = tempUrl;

    if (finalisZipFile) {
      ApiResponse? apiResponse = await generalRepository.checkFileFoundOrNot(downloadSourcePath[0]);

      print("......XXXXXXX.......${apiResponse?.status}");

      if (apiResponse?.status == 404) {
        alertDialog(context);
      }
      else {
        if (apiResponse?.status != 200) {
          downloadSourcePath[0] = finalTempUrl + "/content/downloadfiles/" + contentid + ".zip";
          downloadThin(downloadSourcePath[0], learningModel, position, finalisZipFile);
        }
        else {
          downloadSourcePath[0] = finalTempUrl + "content/publishfiles/" + folderpath + "/" + contentid + ".zip";
          downloadThin(downloadSourcePath[0], learningModel, position, finalisZipFile);
        }
      }
    }
    else {
      downloadThin(downloadSourcePath[0], learningModel, position, finalisZipFile);
    }
  }

  Future<void> downloadThin(
      String downloadStruri,
      DummyMyCatelogResponseTable2 learningModel,
      int position,
      bool finalisZipFile) async {
    downloadStruri = downloadStruri.replaceAll(" ", "%20");
    String extensionStr = "";
    Uri downloadUri = Uri.parse(downloadStruri);

    switch (learningModel.objecttypeid.toString()) {
      case "52":
      case "11":
      case "14":
        //String[] startPage = null;
        List<String> startPage = [];
        if (learningModel.startpage.contains("/")) {
          startPage = learningModel.startpage.split("/");
          extensionStr = startPage[1];
        } else {
          extensionStr = learningModel.startpage;
        }
        break;
      case "8":
      case "9":
      case "10":
        extensionStr = learningModel.contentid + ".zip";
        break;
      default:
        extensionStr = learningModel.contentid + ".zip";
        break;
    }

    String localizationFolder = "";
    List<String> startPage = [];

    if (learningModel.startpage.contains("/")) {
      startPage = learningModel.startpage.split("/");
      localizationFolder = "/" + startPage[0];
    } else {
      localizationFolder = "";
    }
    String downloadDestFolderPath = "";
    if (extensionStr.contains(".zip")) {
      downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
          "/.Mydownloads/Contentdownloads" +
          pathSeparator +
          learningModel.contentid;
    } else {
      downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
          "/.Mydownloads/Contentdownloads" +
          pathSeparator +
          learningModel.contentid +
          localizationFolder;
    }

    bool isZipFile = await otherThanZip(learningModel);

    Directory savedDir = Directory(downloadDestFolderPath);

    print(
        ".....downloadDestFolderPath....not created path.....$downloadDestFolderPath");
    await savedDir.create(recursive: true);

    if (isZipFile) {
      zipCourseDownloader = ZipCourseDownloader(downloadUri.toString(),
          (CallbackParamZip callbackParam) {
        if (callbackParam != null) {
          _downloaderCallBackZip(callbackParam, context);
        }
      }, downloadDestFolderPath, pathSeparator, extensionStr);

      zipCourseDownloader?.startDownload();
    }
    else {
      fileCourseDownloader = FileCourseDownloader(downloadUri.toString(),
          (CallbackParam callbackParam) {
        if (callbackParam != null) {
          _downloaderCallBack(callbackParam, context);
        }
      }, downloadDestFolderPath, pathSeparator, extensionStr);

      fileCourseDownloader?.startDownload();
    }
  }

  Future<bool> otherThanZip(DummyMyCatelogResponseTable2 learningModel) async {
    bool isZipFile = false;

    switch (learningModel.objecttypeid.toString()) {
      case "52":
      case "11":
      case "14":
        isZipFile = false;
        break;
      case "8":
      case "9":
      case "10":
        // forZip
        isZipFile = true;
        break;
      default:
        isZipFile = false;
        break;
    }

    return isZipFile;
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

  // Update the progress on Zip
  Future<void> _downloaderCallBackZip(
      CallbackParamZip callbackParam, BuildContext context) async {
    _downloadProgress = callbackParam.progress;
    _downloaded = callbackParam.status == DownloadTaskStatus.complete &&
        callbackParam.isFileExtracted;
    doSomething(position, learningModel, _downloadProgress);

    if (_downloadProgress == -1) {
      //nextScreenNav(context, false);

      print("zip download have error ........");
    }

    if (_downloaded) {
      print("zip download completed........");

      checkAndDownloadJwVideos(learningModel);

      downloadComplate();
    }
  }

  Future<void> checkAndDownloadJwVideos(
      DummyMyCatelogResponseTable2 learningModel) async {
    String dir = await AppDirectory.getDocumentsDirectory();
    List<String> jwFileURLArray = [];
    List<String> jwFileLocalPathsArray = [];
    String downloadDestFolderPath =
        dir + "/.Mydownloads/Contentdownloads" + "/" + learningModel.contentid;
    String offlinePathWithLastSlash =
        downloadDestFolderPath + "/" + learningModel.startpage;
    int index = offlinePathWithLastSlash.lastIndexOf('/');
    String offlinePathWithoutStartPage =
        offlinePathWithLastSlash.substring(0, index);

    Directory fileDownDir = Directory(offlinePathWithoutStartPage);

    if (await fileDownDir.exists()) {
      jwFileLocalPathsArray = await getAllJwFileLocalPaths(fileDownDir);
      jwFileURLArray = await getAllJwUrlPath(jwFileLocalPathsArray);

      if (jwFileURLArray.length > 0 && jwFileLocalPathsArray.length > 0) {
        alertDialogJwt(context, jwFileURLArray, jwFileLocalPathsArray);
      }
    }
  }

  Future<List<String>> getAllJwFileLocalPaths(Directory fileDownDir) async {
    List<String> jwFileURLArray = [];

    List<FileSystemEntity> list = [];
    list = fileDownDir.listSync(recursive: true, followLinks: true);
    if (list == null) return jwFileURLArray;

    int count = 0;
    for (FileSystemEntity f in list) {
      String fileName = f.path.split('/').last;

      if (fileName == "jwvideoslist.xml") {
        logger?.e("......jwFileURLArray......$fileName");
        jwFileURLArray.add(f.path);
      }
    }
    return jwFileURLArray;
  }

  Future<List<String>> getAllJwUrlPath(List<String> xmlFilePaths) async {
    List<String> jwFileURLArray = [];

    if (xmlFilePaths != null && xmlFilePaths.length > 0) {
      for (int i = 0; i < xmlFilePaths.length; i++) {
        File fileAtPosition = new File(xmlFilePaths[i]);
        if (await fileAtPosition.exists()) {
          String fileText = await fileAtPosition.readAsString();
          final myTransformer = Xml2Json();
          myTransformer.parse(fileText);
          var json = myTransformer.toBadgerfish();
          final jwvideo = jwvideoFromJson(json);
          List<JwvideoElement> elementList = jwvideo.jwvideos?.jwvideo ?? [];
          for (JwvideoElement item in elementList) {
            String videoPath = item.empty;
            if (isValidString(videoPath)) {
              logger?.e("......jwFileURLArray......$videoPath");
              jwFileURLArray.add(videoPath);
            }
          }
        }
      } // end of loop
    }

    return jwFileURLArray;
  }

  Future<void> _downloaderCallBack(
      CallbackParam callbackParam, BuildContext context) async {
    try {
      _downloadProgress = callbackParam.progress;
      _downloaded = callbackParam.status == DownloadTaskStatus.complete;

      if (!streamController.isClosed) {
        if (_downloadProgress == 100) {
          if (streamController.onCancel != null) streamController.onCancel!();
        } else {
          streamController.add(_downloadProgress);
        }
      }
      doSomething(position, learningModel, _downloadProgress);

//      print('downloadprogress $_downloadProgress');

      if (_downloadProgress == -1) {
        //nextScreenNav(context, false);

        print("PDF download have error ........");
      }

      if (_downloaded) {
        print("....PDF download completed........");
        downloadComplate();
      }
    } catch (e) {
      streamController.close();
    }
  }

  Future<void> _downloaderCallBackJWT(
      CallbackParam callbackParam, BuildContext context) async {
    _downloadProgress = callbackParam.progress;
    _downloaded = callbackParam.status == DownloadTaskStatus.complete;

    doSomething(position, learningModel, _downloadProgress);

    if (_downloadProgress == -1) {
      //nextScreenNav(context, false);

      logger?.e("JWT download have error ........");
    }

    if (_downloaded) {
      logger?.e("....JWT download completed........");
      //  downloadComplate();

    }
  }

  void initialiseModelDownloadJWT() async {
    jwtCourseDownloader?.startDownload();
  }

  Future<void> downloadComplate() async {
    print('downloadcomplter');

    if (learningModel.objecttypeid == 10) {
      if (learningModel.actualstatus != "Not Started") {
        callMobileGetContentTrackedData();
        callMobileGetMobileContentMetaData();
        print(".......AAAAAA......1111111");
      } else {
        callMobileGetMobileContentMetaData();
        print(".......AAAAAA......2222222");
      }
    } else {
      if (learningModel.actualstatus != "Not Started") {
        callMobileGetContentTrackedData();
        print(".......AAAAAA......33333333");
      }
    }
  }

  Future<void> callMobileGetContentTrackedData() async {
    String paramsString = "_studid=" +
        learningModel.userid.toString() +
        "&_scoid=" +
        learningModel.scoid.toString() +
        "&_SiteURL=" +
        learningModel.siteurl +
        "&_contentId=" +
        learningModel.contentid +
        "&_trackId=";

    String url =
        webApiUrl + "/MobileLMS/MobileGetContentTrackedData?" + paramsString;

    print("......callMobileGetContentTrackedData........");
    print("......$url........");

    ApiResponse? apiResponse =
        await generalRepository.getContentTrackedData(url);

    ResCmiData resCmiData = apiResponse?.data;

    List<Cmi> jsonCMiAry = resCmiData.cmi;
    List<Learnersession> jsonLearnerSessionAry = resCmiData.learnersession;
    List<Studentresponse> jsonStudentAry = resCmiData.studentresponse;

    if (jsonCMiAry != null) {
      // Pending to Delete Data

      /// ejectRecordsinCmi(learningModel);

      ///  insertCMIData(jsonCMiAry, learningModel);

      insertCMIData(jsonCMiAry, learningModel);
    }

    if (jsonLearnerSessionAry != null) {
      ///ejectRecordsinLearnerSession(learningModel);

      insertLearnerSession(jsonLearnerSessionAry, learningModel);
    }

    if (jsonStudentAry != null) {
      ///ejectRecordsinStudentResponse(learningModel);

      insertStudentResponsData(jsonStudentAry, learningModel);
    }

    print("XXXXXXXXXX.......${apiResponse?.status}");
  }

  Future<void> callMobileGetMobileContentMetaData() async {
    var language = await sharePrefGetString(sharedPref_AppLocale);

    String paramsString = "SiteURL=" +
        learningModel.siteurl +
        "&ContentID=" +
        learningModel.contentid +
        "&userid=" +
        learningModel.userid.toString() +
        "&DelivoryMode=1&IsDownload=1&localeId=" +
        language;

    // need to get local like " en-us  "

    String metaDataUrl =
        webApiUrl + "/MobileLMS/MobileGetMobileContentMetaData?" + paramsString;

    print("......callMobileGetMobileContentMetaData........");
    print("......$metaDataUrl........");

    ApiResponse? apiResponse =
        await generalRepository.getMobileContentMetaData(metaDataUrl);

    print("......ZZZZZZZZZZZZZZZ........${apiResponse?.status}");

/*


    if (response != null) {
      try {
        db.insertTrackObjects(response, learningModel);
      } catch (JSONException e) {
    e.printStackTrace();
    svProgressHUD.dismiss();
    }
    } else {

    }
*/
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
          title: Text("Error"),
          content: Text("Please try after some time "),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }

  alertDialogJwt(BuildContext context, List<String> jwFileURLArray,
      List<String> jwFileLocalPathsArray) {
    // This is the ok button
    Widget ok = FlatButton(
      child: Text("Okay"),
      onPressed: () {
        Navigator.of(context).pop();
        logger?.e(".....Downloadin video ");

        if (jwFileLocalPathsArray.length > 0 && jwFileURLArray.length > 0) {
          startDownloadJWT(jwFileURLArray, jwFileLocalPathsArray);
        } else {
          // Toast.makeText(context, getLocalizationValue(JsonLocalekeys.error_alertsubtitle_somethingwentwrong), Toast.LENGTH_LONG).show();
        }
      },
    );
    // show the alert dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Download"),
          content: Text("Downloading JWT Dialog  "),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }

  Future<void> startDownloadJWT(
      List<String> jwFileURLArray, List<String> jwFileLocalPathsArray) async {
    logger?.d("jwFileURLArray: ....${jwFileURLArray.length}");
    logger?.d("jwFileLocalPathsArray: ....${jwFileLocalPathsArray.length}");

    for (int i = 0; i < jwFileURLArray.length; i++) {
      logger?.d("jwFileLocalPathsArray: ....${jwFileLocalPathsArray[0]}");
      logger?.d("jwFileURLArray: ....${jwFileURLArray[i]}");

      String jwUrlStr = jwFileURLArray[i];
      String fileName =
          jwUrlStr.substring(jwUrlStr.lastIndexOf('/') + 1, jwUrlStr.length);

      /// need to ask upendra for why he have only one video but xml file have 3
      String jwLocalPath = jwFileLocalPathsArray[0];

      int index = jwLocalPath.lastIndexOf('/');
      String offlinePathWithoutStartPage = jwLocalPath.substring(0, index) + "";

      String offlinePath = offlinePathWithoutStartPage + "/jwvideos";

      Directory savedDir = Directory(offlinePath);
      await savedDir.create(recursive: true);

      // logger.e("SWITY.......offlinePath.......JWT...${offlinePath}");
      //logger.e("SWITY.......jwUrlStr.......JWT...${jwUrlStr}");
      //logger.e("SWITY.......fileName.......JWT...${fileName}");

      jwtCourseDownloader =
          FileCourseDownloader(jwUrlStr, (CallbackParam callbackParam) {
        if (callbackParam != null) {
          _downloaderCallBackJWT(callbackParam, context);
        }
      }, offlinePath, pathSeparator, fileName);

      initialiseModelDownloadJWT();
    }
  }

  Future<void> insertCMIData(
      List<Cmi> jsonCMiAry, DummyMyCatelogResponseTable2 learningModel) async {
    for (Cmi jsonCMiColumnObj in jsonCMiAry) {
      CMIModel cmiModel = CMIModel(
        status: jsonCMiColumnObj.corelessonstatus,
        scoId: jsonCMiColumnObj.scoid,
        userId: jsonCMiColumnObj.userid,
        location: jsonCMiColumnObj.corelessonlocation,
        timespent: jsonCMiColumnObj.totalsessiontime,
        score: jsonCMiColumnObj.scoreraw,
        seqNum: jsonCMiColumnObj.sequencenumber,
        coursemode: jsonCMiColumnObj.corelessonmode,
        scoremin: jsonCMiColumnObj.scoremin,
        scoremax: jsonCMiColumnObj.scoremax,
        startdate: "",
        datecompleted: jsonCMiColumnObj.datecompleted,
        suspenddata: jsonCMiColumnObj.suspenddata,
        textResponses: jsonCMiColumnObj.textresponses,
        siteId: learningModel.siteid.toString(),
        sitrurl: learningModel.siteurl,
        isupdate: "true",
        noofattempts: jsonCMiColumnObj.noofattempts,

        /// injectIntoCMITable(cmiModel, "true");
      );
    }
  }

  Future<void> insertStudentResponsData(List<Studentresponse> jsonStudentAry,
      DummyMyCatelogResponseTable2 learningModel) async {
    for (Studentresponse j in jsonStudentAry) {
      String studentresponses = j.studentresponses;
      if (studentresponses.isNotEmpty) {
        // Replace "@" with "#^#"
        if (studentresponses.contains("@")) {
          studentresponses = studentresponses.replaceAll("@", "#^#^");
        }

        // Replace "&&**&&" with "##^^##"
        if (studentresponses.contains("&&**&&")) {
          studentresponses =
              studentresponses.replaceAll("&&\\*\\*&&", "##^^##^^");
        }
      }

      StudentResponseModel studentResponseModel = StudentResponseModel(
        userId: j.userid,
        studentresponses: studentresponses,
        scoId: j.scoid,
        result: j.result,
        questionid: int.parse(j.questionid),
        questionattempt: j.questionattempt,
        optionalNotes: j.optionalnotes,
        rindex: j.index,
        capturedVidId: j.capturedvidid,
        capturedVidFileName: j.capturedvidfilename,
        capturedImgId: j.capturedimgid.toString(),
        capturedImgFileName: j.capturedimgfilename.toString(),
        attemptdate: j.attemptdate.toString(),
        siteId: learningModel.siteid.toString(),
        attachfileid: j.attachfileid,
        attachfilename: j.attachfilename,
        assessmentattempt: j.assessmentattempt,
      );

      ///injectIntoStudentResponseTable(studentResponseModel);

    }
  }

  Future<void> insertLearnerSession(List<Learnersession> jsonLearnerSessionAry,
      DummyMyCatelogResponseTable2 learningModel) async {
    for (Learnersession l in jsonLearnerSessionAry) {
      int attemptnumber = 0;
      attemptnumber = l.attemptnumber;

      if (attemptnumber == 1) {
        String startDate = "";
        startDate = l.sessiondatetime.toString();

        ///updateCMIStartDate(learnerSessionTable.getScoID(), startDate, learnerSessionTable.getUserID());
      }

      LearnerSessionModel learnerSessionModel = LearnerSessionModel(
        userID: l.userid.toString(),
        timeSpent: l.timespent,
        sessionID: l.sessionid.toString(),
        sessionDateTime: l.sessiondatetime.toString(),
        scoID: l.scoid.toString(),
        attemptNumber: attemptnumber.toString(),

        /// injectIntoLearnerTable(learnerSessionTable);
      );
    }
  }
}
