import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/controllers/my_learning_download_controller.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/helpers/database/hivedb_handler.dart';
import 'package:flutter_admin_web/framework/repository/general/model/content_status_response.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_public.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/models/my_learning/download_feature/mylearning_download_model.dart';
import 'package:flutter_admin_web/providers/my_learning_download_provider.dart';
import 'package:flutter_admin_web/ui/MyLearning/Assignmentcontentweb.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/advanced_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunchContenisolation.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/inapp_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../configs/constants.dart';
import '../framework/common/api_response.dart';
import '../framework/common/constants.dart';
import '../framework/common/pref_manger.dart';
import '../framework/helpers/ApiEndpoints.dart';
import '../framework/helpers/utils.dart';
import '../framework/repository/general/contract/general_repository.dart';
import '../framework/repository/general/provider/general_repository_builder.dart';

class MyLearningController {
  static MyLearningController? _instance;

  String webApiUrl = "";
  String pathSeparator = "";
  late GeneralRepository generalRepository;

  factory MyLearningController() {
    return _instance ??= MyLearningController._();
  }

  MyLearningController._() {
    if (pathSeparator.trim().isEmpty) {
      if(!kIsWeb) {
        pathSeparator = Platform.pathSeparator;
      }
    }
    generalRepository = GeneralRepositoryBuilder.repository();
  }

  Future<void> getMyDownloads({bool isRefresh = true, bool withoutNotify = false, bool isSyncWithOfflineData = true}) async {
    if(kIsWeb) return;

    String uuid = Uuid().v1().replaceAll("-", "");
    MyPrint.printOnConsole("$uuid:getMyDownloads called");

    AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
    if(appBloc.userid.isEmpty) {
      MyPrint.printOnConsole("$uuid:User Id is empty");
      return;
    }

    MyLearningBloc myLearningBloc = BlocProvider.of<MyLearningBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
    MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false);

    if(isRefresh) {
      myLearningDownloadProvider.isLoadingMyDownloads = false;
      myLearningDownloadProvider.downloads.clear();
    }

    myLearningDownloadProvider.isLoadingMyDownloads = true;
    if(!withoutNotify) myLearningDownloadProvider.notifyListeners();

    try {
      String hiveCollectionName = "$myLearningCollection-${appBloc.userid}";
      List<Map<String, dynamic>> data = await HiveDbHandler().readData(hiveCollectionName);

      String archieveHiveCollectionName = "$archiveList-${appBloc.userid}";
      List<Map<String, dynamic>> archievedata = await HiveDbHandler().readData(archieveHiveCollectionName);

      Map<String, bool> removedFromDownload = await MyLearningDownloadController().getRemovedFromDownloadMap();

      MyPrint.printOnConsole("$uuid:MyLearning Data Length in MyLearning Hive Colletion in getMyDownloads:${data.length}");
      MyPrint.printOnConsole("$uuid:MyLearning Data Length in MyLearning Archieve Hive Colletion in getMyDownloads:${archievedata.length}");

      /// by default, hive will return an empty object.
      /// If there is cached data, it will be returned data.
      /// If there is nothing, then it will yeild an error
      if (data.isNotEmpty || archievedata.isNotEmpty) {
    //     /*DummyMyCatelogResponseEntity myCatelogResponseEntity = DummyMyCatelogResponseEntity();
    //     Map<String, dynamic> mappedData = {
    //       'table': data[0]['Table'],
    //       'table2': data[0]['Table2'],
    //     };
    //     myCatelogResponseEntity = myCatelogResponseEntity.fromJson(mappedData);*/
    //
    //     Map<String, dynamic> map = data[0];
        List<DummyMyCatelogResponseTable2> allList = [], list = [];
        for(Map<String, dynamic> item in data) {
          DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
          table2.fromJson(item);
          allList.add(table2);
          // setImageData(list);
        }
        for(Map<String, dynamic> item in archievedata) {
          DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
          table2.fromJson(item);
          allList.add(table2);
          // setImageData(list);
        }
        allList.sort((a, b) => a.name.compareTo(b.name));

    //     map.forEach((key, value) {
    //       //MyPrint.printOnConsole("Content Key:${key}");
    //
    //       Map<String, dynamic> map = {};
    //
    //       try {
    //         map = Map.castFrom<dynamic, dynamic, String, dynamic>((value ?? {}) as Map);
    //
    //         DummyMyCatelogResponseTable2 dummyMyCatelogResponseTable2 = DummyMyCatelogResponseTable2().fromJson(Map.castFrom<dynamic, dynamic, String, dynamic>(map));
    //         allList.add(dummyMyCatelogResponseTable2);
    //       }
    //       catch(e, s) {
    //
    //       }
    //     });
    //
        await myLearningBloc.checkifFileExist(allList);

        List<Future> syncFuturesList = [];

        allList.forEach((element) {
          if(element.isdownloaded && removedFromDownload[element.contentid] != true) {
            MyPrint.printOnConsole("$uuid:In Offline, Content ID:${element.contentid}, Content Name:${element.name}, UserId:${element.userid}");
            list.add(element);
            if(isSyncWithOfflineData) {
              syncFuturesList.add(MyLearningDownloadController().syncDownloadedData(element).then((value) {
                MyPrint.printOnConsole("$uuid:${element.contentid} offline sync completed in GetMyDownloads");
              })
              .catchError((e, s) {
                MyPrint.printOnConsole("$uuid:Error in Syncing offline Content in GetMyDownloads:${element.contentid}:$e");
                MyPrint.printOnConsole(s);
              }));
            }
          }
        });

        myLearningBloc.setImageData(list);
        MyPrint.printOnConsole("$uuid:My Downloads List Length:${list.length}");

        MyPrint.printOnConsole("$uuid:Sync With Offline Response Started");
        await Future.wait(syncFuturesList);
        MyPrint.printOnConsole("$uuid:Sync With Offline Response Finished");

        String hiveMyDownloadsTable = "$MY_DOWNLOADS_HIVE_COLLECTION_NAME-${appBloc.userid}";
        List<Map<String, dynamic>> mydownloadsHiveData = await HiveDbHandler().readData(hiveMyDownloadsTable);
        Map<String, MyLearningDownloadModel> existingDownloads = {};
        mydownloadsHiveData.forEach((Map<String, dynamic> map) {
          MyLearningDownloadModel myLearningDownloadModel = MyLearningDownloadModel.fromJson(map);

          bool isRemovedFromDownloads = removedFromDownload[myLearningDownloadModel.contentId] == true;
          if(isRemovedFromDownloads) {
            myLearningDownloadModel.table2.isdownloaded = false;
            myLearningDownloadModel.table2.isDownloading = false;
            HiveDbHandler().deleteData(hiveMyDownloadsTable, keys: [myLearningDownloadModel.contentId]);
          }
          else {
            if(myLearningDownloadModel.isTrackContent) {
              existingDownloads[myLearningDownloadModel.contentId] = myLearningDownloadModel;
            }
            else {
              List<DummyMyCatelogResponseTable2> datalist = allList.where((element) => element.contentid == myLearningDownloadModel.table2.contentid).toList();
              if(datalist.isNotEmpty) {
                DummyMyCatelogResponseTable2 table2 = datalist.first;

                table2.isdownloaded = myLearningDownloadModel.table2.isdownloaded;
                table2.isDownloading = myLearningDownloadModel.table2.isDownloading;

                myLearningDownloadModel.table2 = table2;

                HiveDbHandler().createData(hiveMyDownloadsTable, myLearningDownloadModel.table2.contentid, myLearningDownloadModel.toJson());

                existingDownloads[myLearningDownloadModel.table2.contentid] = myLearningDownloadModel;
                list.remove(table2);
              }
              else {
                existingDownloads[myLearningDownloadModel.table2.contentid] = myLearningDownloadModel;
              }
            }
          }
        });

        List<MyLearningDownloadModel> myDownloads = [];
        list.forEach((element) {
          MyLearningDownloadModel myLearningDownloadModel;
          if(existingDownloads[element.contentid] != null) {
            myLearningDownloadModel = existingDownloads[element.contentid]!;
          }
          else {
            myLearningDownloadModel = MyLearningDownloadModel(
              table2: element,
              downloadPercentage: 100,
              downloadStatus: 3,
              isFileDownloaded: true,
              isFileExtracted: true,
            );
          }
          myDownloads.add(myLearningDownloadModel);
        });
        MyPrint.printOnConsole("$uuid:Contents In MyDownloads:${myDownloads.map((e) => e.table2.contentid).toList()}");

        existingDownloads.forEach((String contentId, MyLearningDownloadModel myLearningDownloadModel) {
          if(myDownloads.where((element) => element.contentId == contentId).toList().isEmpty) {
            myDownloads.add(myLearningDownloadModel);
          }
        });
        MyPrint.printOnConsole("$uuid:Contents In MyDownloads:${myDownloads.map((e) => e.table2.contentid).toList()}");

        if(isRefresh) {
          myLearningDownloadProvider.downloads.clear();
        }
        myLearningDownloadProvider.downloads.addAll(myDownloads);
      }
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in MyLeadrningDownloadController().getMyDownloads():$e");
      MyPrint.printOnConsole(s);
    }

    myLearningDownloadProvider.isLoadingMyDownloads = false;
    myLearningDownloadProvider.notifyListeners();
  }


  Future<bool> storeMyLearningContentOffline(
      BuildContext context,
      DummyMyCatelogResponseTable2 dummyMyCatelogResponseTable2,
      String appUserId) async {
    PermissionStatus storagePermission = await Permission.storage.request();

    if (!storagePermission.isGranted) {
      return false;
    }

    print("Object Type Id:${dummyMyCatelogResponseTable2.objecttypeid}");

    if ([8, 9, 10, 26, 52, 102].contains(dummyMyCatelogResponseTable2.objecttypeid) || (dummyMyCatelogResponseTable2.objecttypeid == 11)) {
      String tempUrl = ApiEndpoints.strSiteUrl;
      String objecttypeid = dummyMyCatelogResponseTable2.objecttypeid.toString();
      String siteurl = dummyMyCatelogResponseTable2.siteurl;
      // String scoid = dummyMyCatelogResponseTable2.scoid.toString();
      String contentid = dummyMyCatelogResponseTable2.contentid.toString();
      // String userid = dummyMyCatelogResponseTable2.userid.toString();
      String folderpath = dummyMyCatelogResponseTable2.folderpath.toString();
      String startpage = dummyMyCatelogResponseTable2.startpage.toString();
      // String courseName = dummyMyCatelogResponseTable2.name.toString();
      String jwvideokey = dummyMyCatelogResponseTable2.jwvideokey.toString();
      // String siteid = dummyMyCatelogResponseTable2.siteid.toString();
      // String activityid = dummyMyCatelogResponseTable2.activityid.toString();
      // String folderid = dummyMyCatelogResponseTable2.folderid.toString();
      String cloudmediaplayerkey = dummyMyCatelogResponseTable2.cloudmediaplayerkey.toString();
      webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

      AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: false);
      if (appBloc.uiSettingModel.isCloudStorageEnabled == "true") {
        tempUrl = appBloc.uiSettingModel.azureRootPath;
      }

      String strdownloadSourcePath = "";
      bool isZipFile = false;

      if (objecttypeid == "52") {
        strdownloadSourcePath = tempUrl +
            "/content/sitefiles/" +
            siteurl +
            "/usercertificates/" +
            siteurl +
            "/" +
            contentid +
            ".pdf";
        isZipFile = false;
      }
      else if (objecttypeid == "11") {
        if (jwvideokey.length > 0 && cloudmediaplayerkey.length > 0) {
          //JW Standalone video content in offline mode.
          strdownloadSourcePath =
              "https://content.jwplatform.com/videos/" + jwvideokey + ".mp4";
        }
        isZipFile = false;
      }
      else if (objecttypeid == "14") {
        strdownloadSourcePath =
            tempUrl + "content/publishfiles/" + folderpath + "/" + startpage;
        isZipFile = false;
      }
      else {
        strdownloadSourcePath = tempUrl +
            "content/publishfiles/" +
            folderpath +
            "/" +
            contentid +
            ".zip";
        isZipFile = true;
      }
      print("strdownloadSourcePath:$strdownloadSourcePath");
      print("IsZip:$isZipFile");

      if (isZipFile) {
        ApiResponse? apiResponse = await generalRepository.checkFileFoundOrNot(strdownloadSourcePath);

        print("checkFileFoundOrNot Response:${apiResponse?.status}");

        if (apiResponse?.status == 404) {
          showErrorDialog(context);
        }
        else {
          if (apiResponse?.status != 200) {
            strdownloadSourcePath = tempUrl + "/content/downloadfiles/" + contentid + ".zip";
            bool isStored = await downloadFileFromUrlAndExtract(
              strdownloadSourcePath,
              dummyMyCatelogResponseTable2,
              isZipFile,
              appUserId,
            );
            return isStored;
          }
          else {
            strdownloadSourcePath = tempUrl +
                "content/publishfiles/" +
                folderpath +
                "/" +
                contentid +
                ".zip";
            bool isStored = await downloadFileFromUrlAndExtract(
                strdownloadSourcePath,
                dummyMyCatelogResponseTable2,
                isZipFile,
                appUserId);
            return isStored;
          }
        }
      }
      else {
        bool isStored = await downloadFileFromUrlAndExtract(
            strdownloadSourcePath,
            dummyMyCatelogResponseTable2,
            isZipFile,
            appUserId);
        return isStored;
      }
    }

    return false;
  }

  Future<File?> downloadFromUrl(DummyMyCatelogResponseTable2 table2, String url, String filepath) async {
    final Response response = await get(Uri.parse(url));

    print("Response:" + response.bodyBytes.toString());
    print("Response Body:" + response.body);

    if (response.contentLength == 0) {
      //ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text("Dowload Failed: File Doesn't contains data")));
      return null;
    }
    else {
      try {
        File file = File(filepath);
        if (!file.existsSync()) file.createSync(recursive: true);
        file = await file.writeAsBytes(response.bodyBytes);
        return file;
      }
      catch (e) {
        print("Error in Saving File:$e");
        return null;
      }
    }
  }

  Future<bool> extractZipFile(String destinationFolderPath, File zipFile) async {
    print("Extract File Called For Destination:$destinationFolderPath");

    final Directory destinationDir = Directory(destinationFolderPath);
    await destinationDir.create(recursive: true);
    try {
      // Read the Zip newFile from disk.
      final Uint8List bytes = zipFile.readAsBytesSync();

      // Decode the Zip newFile
      final Archive archive = ZipDecoder().decodeBytes(bytes);

      // String lastFolderPath = "";

      // Extract the contents of the Zip archive to disk.
      for (final file in archive) {
        final filename = file.name;
        print("IsFile:${file.isFile}, Path:${file.name}");
        if (file.isFile) {
          final data = file.content as List<int>;
          File newFile = File(destinationFolderPath + "/" + filename);
          newFile = await newFile.create(recursive: true);
          newFile = await newFile.writeAsBytes(data);
        }
        else {
          // lastFolderPath = file.name;
          await Directory(destinationFolderPath + "/" + filename).create(recursive: true);
        }
      }

      return true;
    }
    catch (e, s) {
      print("Error in Extracting File:$e");
      print(s);
      return false;
    }
  }

  Future<bool> downloadFileFromUrlAndExtract(
      String downloadStruri,
      DummyMyCatelogResponseTable2 learningModel,
      bool isZipFile,
      String appUserId) async {
    print("downloadThin called");

    downloadStruri = downloadStruri.replaceAll(" ", "%20");
    String extensionStr = "";
    // Uri downloadUri = Uri.parse(downloadStruri);

    switch (learningModel.objecttypeid.toString()) {
      case "52":
      case "11":
      case "14":
      //String[] startPage = null;
        List<String> startPage = [];
        if (learningModel.startpage.contains("/")) {
          startPage = learningModel.startpage.split("/");
          extensionStr = startPage[1];
        }
        else {
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
    }
    else {
      localizationFolder = "";
    }
    String downloadDestFolderPath = "";
    if (extensionStr.contains(".zip")) {
      downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
          "/.Mydownloads/Contentdownloads" +
          pathSeparator +
          learningModel.contentid +
          '-' +
          appUserId;
    }
    else {
      downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
          "/.Mydownloads/Contentdownloads" +
          pathSeparator +
          learningModel.contentid +
          '-' +
          appUserId +
          localizationFolder;
    }

    Directory savedDir = Directory(downloadDestFolderPath);
    await savedDir.create(recursive: true);

    String destinationFilePath = "$downloadDestFolderPath$pathSeparator$extensionStr";
    print("Download Url:$downloadStruri");
    print("destinationFilePath:$destinationFilePath");

    //File? file = await downloadFromUrl("https://instancylivesites.blob.core.windows.net/enterprisedemocontent/content/publishfiles/9e84f496-30d1-4bd4-addb-a5deb178866d/6934048d-7acf-4ab7-9249-e14dfce7495f.zip", destinationFilePath);
    File? file = await downloadFromUrl(learningModel, downloadStruri, destinationFilePath);
    print("Downloaded File:$file");

    if (file != null) {
      print("isZipFile:$isZipFile");
      if (isZipFile) {
        //await extractZipFile("/storage/emulated/0/Contentdownloads/673f4b9a-331b-4a02-95e7-6959fd2d847f", file);
        bool isExtracted = await extractZipFile(downloadDestFolderPath, file);
        print("isExtracted:$isExtracted");

        await file.delete(recursive: true);
        print("Zip File Extracted Successfully");

        return isExtracted;
      }
      else {
        return true;
      }
    }

    return false;
  }

  showErrorDialog(BuildContext context) {
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

  Future<bool> fileExistCheck(DummyMyCatelogResponseTable2 table2, String appUserId) async {
    String downloadDestFolderPath = '';
    if(table2.objecttypeid.toString() == '20') {
      downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
          "$pathSeparator.Mydownloads${pathSeparator}Contentdownloads" +
          "$pathSeparator" +
          table2.contentid +
          '-' +
          "$appUserId${pathSeparator}glossary_english.html";
    }
    else if(table2.objecttypeid.toString() == '52') {
      downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() + "$pathSeparator.Mydownloads${pathSeparator}Contentdownloads$pathSeparator";

      /*if(table2.) {
        downloadDestFolderPath += '${trackData?.contentid}$pathSeparator${learningModel.contentid}-$appUserId';
      } else {
        downloadDestFolderPath += '${learningModel.contentid}-$appUserId';
      }*/
      downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
          "$pathSeparator.Mydownloads${pathSeparator}Contentdownloads" +
          "$pathSeparator" +
          table2.contentid +
          '-' +
          "$appUserId$pathSeparator${table2.contentid}.pdf";
    }
    else {
      downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
          "$pathSeparator.Mydownloads${pathSeparator}Contentdownloads" +
          "$pathSeparator" +
          table2.contentid +
          '-' +
          "$appUserId$pathSeparator${table2.startpage}";
    }
    File file = File(downloadDestFolderPath);
    bool exists = await file.exists();
    print("Checking Path:$downloadDestFolderPath");
    return exists;
  }

  Future<bool> decideCourseLaunchMethod({
    required BuildContext context,
    required DummyMyCatelogResponseTable2 table2,
    bool isContentisolation = false
  }) async {
    bool networkAvailable = await AppDirectory.checkInternetConnectivity();
    bool isCourseDownloaded = await checkIfContentIsAvailableOffline(
      context: context,
      table2: table2,
    );
    MyPrint.printOnConsole("networkAvailable:$networkAvailable");
    MyPrint.printOnConsole("isCourseDownloaded:$isCourseDownloaded");

    if (networkAvailable && isCourseDownloaded) {
      // launch offline
      bool isLaunched = true;
      return isLaunched;
    }
    else if (!networkAvailable && isCourseDownloaded) {
      // launch offline
      return true;
    }
    else if (networkAvailable && !isCourseDownloaded) {
      // launch online
      await launchCourse(context: context, table2: table2, isContentisolation: isContentisolation);
      return true;
    }
    else {
      // error dialog
      AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: false);
      await _courseNotDownloadedDialog(context, appBloc);
      return false;
    }
  }

  Future<bool> checkIfContentIsAvailableOffline({
    required BuildContext context,
    required DummyMyCatelogResponseTable2 table2,
  }) async {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: false);
    Map<String, bool> removedFromDownload = await MyLearningDownloadController().getRemovedFromDownloadMap();
    if (table2.objecttypeid == 10 && table2.bit5) {
      print('Navigation to EventTrackList called');
      String tracklistCollectionName = '$tracklistCollection-${table2.contentid}-${appBloc.userid}';
      var courseData = await HiveDbHandler().readData(tracklistCollectionName);

      /// If `courseData` is not empty, that means that track data is available
      return courseData.isNotEmpty;
    }
    else if(table2.objecttypeid == 70) {
      return false;
    }
    else if (table2.objecttypeid == 694) {
      return false;
    }
    else if([8, 9, 21, 26, 28, 102].contains(table2.objecttypeid) || (table2.objecttypeid == 10 && !table2.bit5)) {
      bool fileCheck = await fileExistCheck(table2, appBloc.userid);
      print("checkIfContentIsAvailableOffline called with isDownloaded:$fileCheck");
      if(removedFromDownload[table2.contentid] == true) {
        return false;
      }

      return fileCheck;
    }
    else {
      bool fileCheck = await fileExistCheck(table2, appBloc.userid);
      print("launchCourseOffline called with isDownloaded:$fileCheck");
      if(removedFromDownload[table2.contentid] == true) {
        return false;
      }

      return fileCheck;
    }
  }

  //Region Content Launching
  Future<bool> launchCourse(
      {required BuildContext context,
      required DummyMyCatelogResponseTable2 table2,
      bool isContentisolation = false}) async {
    print('launchCourse called with isContentisolation:$isContentisolation');

    /*
    //TODO: This content for testing purpuse
    courseLaunch = GotoCourseLaunch(
        context, table2, false, appBloc.uiSettingModel, myLearningBloc.list);
    String url = await courseLaunch.getCourseUrl();

    print('urldataaaaa $url');
    if (url.isNotEmpty) {
      if (table2.objecttypeid == 26) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AdvancedWebCourseLaunch(url, table2.name)));
      } else {
        //await FlutterWebBrowser.openWebPage(url: url, androidToolbarColor: Colors.deepPurple);

        //await launch(url);
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InAppWebCourseLaunch(url, table2)));
      }

      logger.e('.....Refresh Me....$url');

      /// Refresh Content Of My Learning

    }
    return;
    */

    AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: false);

    /// content isolation only for 8,9,10,11,26,27

    /// Need Some value
    /*if (table2.objecttypeid == 102) {
      await executeXAPICourse(table2);
    }*/

    print('Table2 Objet Id:${table2.objecttypeid}');
    if (table2.objecttypeid == 10 && table2.bit5) {
      // Need to open EventTrackListTabsActivity
      print('Navigation to EventTrackList called');

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventTrackList(
            table2,
            true,
            [],
          ),
        ),
      );
      return false;
    }
    else if(table2.objecttypeid == 70) {
      print('Navigation to Classroom Events');

      /*await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventTrackList(
            table2,
            false,
            [],
          ),
        ),
      );
      return false;*/
    }
    else if (table2.objecttypeid == 694) {
      String assignmenturl = '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}/ismobilecontentview/true';
      print('assignmenturl is : $assignmenturl');

      dynamic value = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Assignmentcontentweb(
            url: assignmenturl,
            myLearningModel: table2,
          ),
        ),
      );
      return (value is bool) ? value : true;
    }
    else if([8, 9, 26, 28, 102].contains(table2.objecttypeid) || (table2.objecttypeid == 10 && !table2.bit5)) {
      bool isGetData = false;

      if (!isContentisolation) {
        GotoCourseLaunchContentisolation courseLaunch = GotoCourseLaunchContentisolation(
          context,
          table2,
          appBloc.uiSettingModel,
          [],
        );

        String courseUrl = await courseLaunch.getCourseUrl();
        MyPrint.printOnConsole("Course Url:'$courseUrl'");

        if(courseUrl.isNotEmpty) {
          String courseTrackingSessionId = await getCourseTrackingSessionId(courseUrl: courseUrl, table2: table2);
          MyPrint.printOnConsole("Course Tracking Session Id:'$courseTrackingSessionId'");

          if(courseTrackingSessionId.isNotEmpty) {
            String token = await getCourseLaunchToken(
              courseTrackingSessionId: courseTrackingSessionId,
              courseUrl: courseUrl,
              table2: table2,
            );
            MyPrint.printOnConsole("Course Tracking Token:'$token'");

            if (token.isNotEmpty) {
              String courseUrl;
              MyPrint.printOnConsole("Azure Path:'${appBloc.uiSettingModel.azureRootPath}'");
              if (isValidString(appBloc.uiSettingModel.azureRootPath)) {
                MyPrint.printOnConsole("Taking Azure Path");
                courseUrl = '${appBloc.uiSettingModel.azureRootPath}content/index.html?coursetoken=$token&TokenAPIURL=${ApiEndpoints.appAuthURL}';

                // assignmenturl = await '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}';
              }
              else {
                MyPrint.printOnConsole("Taking Site Url Path");

                String siteUrl = ApiEndpoints.strSiteUrl;
                MyPrint.printOnConsole("siteUrl:$siteUrl");
                courseUrl = '${siteUrl}content/index.html?coursetoken=$token&TokenAPIURL=${ApiEndpoints.appAuthURL}';

                //assignmenturl = await '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}';
              }

              if (table2.objecttypeid == 26) {
                // assignmenturl = await '$assignmenturl/ismobilecontentview/true';
                // print('assignmenturl is : $assignmenturl');
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AdvancedWebCourseLaunch(courseUrl, table2.name),
                  ),
                );
              }
              else {
                // assignmenturl = await '$assignmenturl/ismobilecontentview/true';
                print('Course Url:$courseUrl');
                dynamic value = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InAppWebCourseLaunch(courseUrl, table2),
                  ),);

                isGetData = (value is bool) ? value : true;
              }
            }
          }
        }
      }

      String courseUrl = await getContentStatusUrl(table2: table2);

      print('launchCourseUrl $courseUrl');

      Contentstatus? contentstatus = await getContentStatus(courseUrl);

      if(contentstatus != null) {
        print('getcontentstatusvl ${contentstatus.name} ${contentstatus.progress} ${contentstatus.contentStatus}');
        table2.actualstatus = contentstatus.name;
        table2.progress = contentstatus.progress;
        if (contentstatus.progress != '0') {
          table2.percentcompleted = contentstatus.progress;
        }
        table2.corelessonstatus = contentstatus.contentStatus;
      }

      return isGetData;
    }
    else {
      GotoCourseLaunch courseLaunch = GotoCourseLaunch(
        context,
        table2,
        false,
        appBloc.uiSettingModel,
        [],
      );
      String url = await courseLaunch.getCourseUrl();

      print('urldataaaaa $url');
      if (url.isNotEmpty) {
        if (table2.objecttypeid == 26) {
          print('Navigation to AdvancedWebCourseLaunch called');

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdvancedWebCourseLaunch(url, table2.name),
            ),
          );
          return false;
        }
        else {
          print('Navigation to InAppWebCourseLaunch called');
          dynamic value = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InAppWebCourseLaunch(
                url,
                table2,
              ),
            ),);
          return (value is bool) ? value : true;
        }
      }
    }

    return false;
  }

  Future<String> getCourseTrackingSessionId({required String courseUrl, required DummyMyCatelogResponseTable2 table2}) async {
    Response? courseApiResponse = await MyLearningRepositoryPublic().courseTrackingApiCall(
      courseUrl,
      table2.userid.toString(),
      table2.scoid.toString(),
      table2.objecttypeid.toString(),
      table2.contentid,
      table2.siteid.toString(),
    );

    print("MyLearningController().getCourseTrackingUrl() response status:${courseApiResponse?.statusCode}");
    print("MyLearningController().getCourseTrackingUrl() response body:${courseApiResponse?.body.toString()}");

    return courseApiResponse?.body.toString() ?? "";
  }

  Future<String> getCourseLaunchToken(
      {required String courseTrackingSessionId,
      required String courseUrl,
      required DummyMyCatelogResponseTable2 table2}) async {
    String token = "";

    Response? tokenApiResponse = await MyLearningRepositoryPublic().tokenFromSessionIdAiCall(
      courseUrl,
      '${table2.name}',
      table2.contentid,
      table2.objecttypeid.toString(),
      table2.scoid.toString(),
      courseTrackingSessionId,
      table2.objecttypeid.toString(),
    );

    print("MyLearningController().getCourseLaunchToken() response status:${tokenApiResponse?.statusCode}");
    print("MyLearningController().getCourseLaunchToken() response body:${tokenApiResponse?.body.toString()}");

    if (tokenApiResponse?.statusCode == 200) {
      try {
        token = jsonDecode(tokenApiResponse?.body ?? "{}").toString();
      }
      catch(e, s) {
        print("Error in JsonDecode in MyLearningController().getCourseLaunchToken():$e");
        print(s);
      }
    }

    return token;
  }

  Future<String> getContentStatusUrl({required DummyMyCatelogResponseTable2 table2}) async {
    String paramsString = '';
    if (table2.objecttypeid == 10 && table2.bit5) {
      paramsString = 'userID=${table2.userid.toString()}' +
          '&scoid=${table2.scoid.toString()}' +
          '&TrackObjectTypeID=${table2.objecttypeid.toString()}' +
          '&TrackContentID=${table2.contentid}' +
          '&TrackScoID=${table2.scoid.toString()}' +
          '&SiteID=${table2.siteid.toString()}' +
          '&OrgUnitID=${table2.siteid.toString()}' +
          '&isonexist=onexit';
    }
    else {
      paramsString = 'userID=${table2.userid.toString()}' + '&scoid=${table2.scoid.toString()}';
    }
    String webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

    return '$webApiUrl/MobileLMS/MobileGetContentStatus?$paramsString';
  }

  Future<Contentstatus?> getContentStatus(String courseUrl) async {
    Response? response = await MyLearningRepositoryPublic().getContentStatus(courseUrl);

    print('getcontentstatusres ${response?.body}');

    if (response?.statusCode == 200) {
      ContentstatusResponse contentResponse = contentstatusResponseFromJson(response?.body ?? "{}");
      return contentResponse.contentstatus.isNotEmpty ? contentResponse.contentstatus[0] : null;
    }
    return null;
  }

  Future<void> executeXAPICourse(DummyMyCatelogResponseTable2 learningModel) async {
    print("executeXAPICourse called");

    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

    String paramsString = 'strContentID=${learningModel.contentid}' +
        '&UserID=$strUserID' +
        '&SiteID=$strSiteID' +
        '&SCOID=${learningModel.scoid.toString()}' +
        '&CanTrack=true';

    String url = webApiUrl + 'CourseTracking/TrackLRSStatement?' + paramsString;

    ApiResponse? apiResponse = await generalRepository.executeXAPICourse(url);
    print("XApi Response:${apiResponse?.data}");
  }
  //End Region

  Future<void> _courseNotDownloadedDialog(BuildContext context, AppBloc appBloc) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Error',
          style: TextStyle(
              color: Color(
                int.parse(
                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
              ),
              fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This course has not been downloaded. Please download in order to view it.',
          style: TextStyle(
            color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
            ),
          ),
        ),
        backgroundColor: InsColor(appBloc).appBGColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        actions: <Widget>[
          TextButton(
            child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
            style: TextButton.styleFrom(
              primary: Colors.blue,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  bool isValidString(String val) {
    return val.isNotEmpty && val != 'null';
  }
}
