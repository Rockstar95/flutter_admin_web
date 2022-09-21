import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/database/database_handler.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:flutter_admin_web/models/my_learning/download_feature/mylearning_download_model.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';

import '../configs/constants.dart';
import '../framework/common/constants.dart';
import '../framework/helpers/database/hivedb_handler.dart';
import '../providers/my_learning_download_provider.dart';

class MyLearningDownloadController {
  static MyLearningDownloadController? _instance;

  String webApiUrl = "";
  String pathSeparator = "";
  late GeneralRepository generalRepository;

  factory MyLearningDownloadController() {
    return _instance ??= MyLearningDownloadController._();
  }

  MyLearningDownloadController._() {
    if (pathSeparator.trim().isEmpty) {
      if(!kIsWeb) {
        pathSeparator = Platform.pathSeparator;
      }
    }
    generalRepository = GeneralRepositoryBuilder.repository();
  }

  Future<bool> storeMyLearningContentOffline(
    BuildContext context,
    DummyMyCatelogResponseTable2 table2,
    String appUserId, {
    bool isTrackEvent = false,
    DummyMyCatelogResponseTable2? trackData,
  }) async {
    PermissionStatus storagePermission = await Permission.storage.request();

    if (!storagePermission.isGranted) {
      return false;
    }

    AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: false);
    print("Object Type Id:${table2.objecttypeid}");
    //return false;

    if ([8, 9, 10, 26, 52, 102].contains(table2.objecttypeid) || (table2.objecttypeid == 11) || (table2.objecttypeid == 21 && table2.mediatypeid.toString() == '41')) {
      String tempUrl = ApiEndpoints.strSiteUrl;
      String objecttypeid = table2.objecttypeid.toString();
      String siteurl = table2.siteurl;
      // String scoid = table2.scoid.toString();
      String contentid = table2.contentid.toString();
      // String userid = table2.userid.toString();
      String folderpath = table2.folderpath.toString();
      String startpage = table2.startpage.toString();
      // String courseName = table2.name.toString();
      String jwvideokey =
          (table2.jwvideokey != null) ? table2.jwvideokey.toString() : '';
      String siteid = table2.siteid.toString();
      // String activityid = table2.activityid.toString();
      // String folderid = table2.folderid.toString();
      String cloudmediaplayerkey = (table2.cloudmediaplayerkey != null)
          ? table2.cloudmediaplayerkey.toString()
          : '';
      webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

      if (appBloc.uiSettingModel.isCloudStorageEnabled == "true") {
        tempUrl = appBloc.uiSettingModel.azureRootPath;
      }

      String strdownloadSourcePath = "";
      bool isZipFile = false;

      // https://instancylivesites.blob.core.windows.net/upgradedenterprise/content/publishfiles/1d588e92-29a0-4e7e-8cc5-39548cd44275/en-us/e84e5403-c94a-4431-ae06-6b5fd01a722f.pdf?fromNativeapp=true

      if (objecttypeid == "52") {
        try {
          strdownloadSourcePath = siteurl +
              "content/sitefiles/$siteid/UserCertificates/${table2.userid}/" +
              contentid +
              "/${table2.startpage.substring(0, table2.startpage.lastIndexOf("."))}" +
              ".pdf";
        }
        catch (e, s) {
          print(s);
        }
        isZipFile = false;
      }
      else if (['11', '14', '36'].contains(objecttypeid) || (objecttypeid == '21' && table2.mediatypeid.toString() == '41')) {
        if (jwvideokey.length > 0 && cloudmediaplayerkey.length > 0) {
          //JW Standalone video content in offline mode.
          strdownloadSourcePath =
              "https://content.jwplatform.com/videos/" + jwvideokey + ".mp4";
        }
        else {
          strdownloadSourcePath = tempUrl +
              "content/publishfiles/" +
              folderpath.toLowerCase() +
              "/" +
              startpage;
        }
        isZipFile = false;
      }
      else {
        strdownloadSourcePath = tempUrl +
            "content/publishfiles/" +
            folderpath.toLowerCase() +
            "/" +
            contentid +
            ".zip";
        isZipFile = true;
      }
      print("strdownloadSourcePath:$strdownloadSourcePath");
      print("IsZip:$isZipFile");

      /*if (isZipFile) {
        ApiResponse? apiResponse = await generalRepository.checkFileFoundOrNot(strdownloadSourcePath);

        print("checkFileFoundOrNot Response:${apiResponse?.status}");

        if (apiResponse?.status == 404) {
          showErrorDialog(context);
          if (checkFileOnServerCallback != null) {
            checkFileOnServerCallback();
          }
          return false;
        }
        else {
          if (apiResponse?.status != 200) {
            strdownloadSourcePath = tempUrl + "/content/downloadfiles/" + contentid + ".zip";
          }
          else {
            strdownloadSourcePath = tempUrl +
                "content/publishfiles/" +
                folderpath +
                "/" +
                contentid +
                ".zip";
          }
        }
      }
      if (checkFileOnServerCallback != null) {
        checkFileOnServerCallback();
      }*/

      downloadFileFromUrlAndExtract(
        context,
        strdownloadSourcePath,
        table2,
        isZipFile,
        appUserId,
        isTrackEvent: isTrackEvent,
        trackData: trackData,
      );
    }
    else if([70].contains(table2.objecttypeid)) {
      return false;
    }
    else {
      GotoCourseLaunch courseLaunch = GotoCourseLaunch(
        context,
        table2,
        false,
        appBloc.uiSettingModel,
        [],
      );
      await courseLaunch.getCourseUrl();
      String strdownloadSourcePath = courseLaunch.urlForView;
      print('ur: $strdownloadSourcePath');

      /*if (checkFileOnServerCallback != null) {
        checkFileOnServerCallback();
      }*/

      downloadFileFromUrlAndExtract(
        context,
        strdownloadSourcePath,
        table2,
        false,
        appUserId,
        isTrackEvent: isTrackEvent,
        trackData: trackData,
      );
    }
    return false;
  }

  Future<void> downloadFileFromUrlAndExtract(
    BuildContext context,
    String downloadFileUrl,
    DummyMyCatelogResponseTable2 learningModel,
    bool isZipFile,
    String appUserId, {
    bool isTrackEvent = false,
    DummyMyCatelogResponseTable2? trackData,
  }) async {
    print("downloadFileFromUrlAndExtract called");

    downloadFileUrl = downloadFileUrl.replaceAll(" ", "%20");
    String extensionStr = "";

    switch (learningModel.objecttypeid.toString()) {
      case "52":
        {
          extensionStr = learningModel.contentid + ".pdf";
          break;
        }
      case "11":
      case "14":
      case "36":
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
      case "26":
        extensionStr = learningModel.contentid + ".zip";
        break;
      case "20":
        extensionStr = "glossary_english.html";
        break;
      case "21":
        if (['40', '41'].contains(learningModel.mediatypeid.toString())) {
          List<String> startPage = [];
          if (learningModel.startpage.contains("/")) {
            startPage = learningModel.startpage.split("/");
            extensionStr = startPage[1];
          } else {
            extensionStr = learningModel.startpage;
          }
        } else {
          extensionStr = learningModel.contentid + ".zip";
        }
        break;
      default:
        extensionStr = learningModel.contentid + ".zip";
        break;
    }

    //https://instancylivesites.blob.core.windows.net/upgradedenterprise/content/publishfiles/1d588e92-29a0-4e7e-8cc5-39548cd44275/en-us/e84e5403-c94a-4431-ae06-6b5fd01a722f.pdf?fromNativeapp=true
    // https://upgradedenterprise.instancy.com/content/sitefiles/374/UserCertificates/363/a6ac2290-34ef-4521-a919-03431e7939d2/certificate.pdf?fromNativeapp=true

    String localizationFolder = "";
    List<String> startPage = [];

    if (learningModel.startpage.contains("/")) {
      startPage = learningModel.startpage.split("/");
      localizationFolder = "/" + startPage[0];
    } else {
      localizationFolder = "";
    }

    String downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() + "$pathSeparator.Mydownloads${pathSeparator}Contentdownloads$pathSeparator";
    if (isTrackEvent) {
      downloadDestFolderPath += '${trackData?.contentid}$pathSeparator${learningModel.contentid}-$appUserId';
    }
    else {
      downloadDestFolderPath += '${learningModel.contentid}-$appUserId';
    }

    if (!extensionStr.contains(".zip")) {
      downloadDestFolderPath += localizationFolder;
    }
    //https://instancylivesites.blob.core.windows.net/upgradedenterprise//content/sitefiles/http://upgradedenterprise.instancy.com//usercertificates/http://upgradedenterprise.instancy.com//aa3e7c2a-6c94-48fd-a221-3cd1971296f5.pdf
    // https://upgradedenterprise.instancy.com/content/sitefiles/374/UserCertificates/363/aa3e7c2a-6c94-48fd-a221-3cd1971296f5/Certificate.pdf

    /*if (extensionStr.contains(".zip")) {
      downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
          "${pathSeparator}.Mydownloads${pathSeparator}Contentdownloads" +
          pathSeparator +
          learningModel.contentid +
          '-' +
          appUserId;
    }
    else {
      downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
          "${pathSeparator}.Mydownloads${pathSeparator}Contentdownloads" +
          pathSeparator +
          learningModel.contentid +
          '-' +
          appUserId +
          localizationFolder;
    }*/

    //To Avoid error in Downloading
    downloadFileUrl = downloadFileUrl.replaceFirst("http://", "https://");

    Directory savedDir = Directory(downloadDestFolderPath);

    String destinationFilePath = "$downloadDestFolderPath$pathSeparator$extensionStr";
    /*String destinationFilePath = "/storage/emulated/0/Android/data/com.instancy.upgradedenterpriseapp/files/.Mydownloads"
          "/Contentdownloads/file.pdf";*/
    print("Download Url:'$downloadFileUrl'");
    print("destinationFilePath:$destinationFilePath");

    try {
      bool fileExist = await File(destinationFilePath).exists();
      MyPrint.printOnConsole("File Exist:$fileExist");
      if (fileExist) {
        await File(destinationFilePath).delete(recursive: true);
      }
    } catch (e, s) {
      MyPrint.printOnConsole(
          "Error in Deleting File at path we are downloading:$e");
      MyPrint.printOnConsole(s);
    }

    try {
      savedDir = await savedDir.create(recursive: true);
    } catch (e, s) {
      MyPrint.printOnConsole(
          "Error in Creating Directory at path we are downloading:$e");
      MyPrint.printOnConsole(s);
    }

    /*MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(
      NavigationController().mainNavigatorKey.currentContext!,
      listen: false,
    );
    List<MyLearningDownloadModel> existingDownloads = myLearningDownloadProvider
        .downloads
        .where((element) => element.table2.contentid == learningModel.contentid)
        .toList();
    if (existingDownloads.isNotEmpty) {
      existingDownloads.forEach((element) {
        myLearningDownloadProvider.downloads.remove(element);
      });
    }*/

    await downloadTask(
      context: context,
      downloadFileUrl: downloadFileUrl,
      downloadDestFolderPath: downloadDestFolderPath,
      destinationFilePath: destinationFilePath,
      fileName: extensionStr,
      isZipFile: isZipFile,
      learningModel: learningModel,
      trackData: trackData,
      isTrackEvent: isTrackEvent,
    );
  }


  Future<File?> downloadFromUrl(Map<String, String> args) async {
    try {
      final Response response = await get(Uri.parse(args['url']!));

      // print("Response:" + response.bodyBytes.toString());
      // print("Response Body:" + response.body);

      if (response.contentLength == 0) {
        //ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text("Dowload Failed: File Doesn't contains data")));
        return null;
      }
      else {
        File file = File(args['filePath']!);
        if (!file.existsSync()) file.createSync(recursive: true);
        file = await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      MyPrint.printOnConsole(e);
      return null;
    }
  }

  // destinationFilePath:                /storage/emulated/0/Android/data/com.instancy.enterpriseapp/files/.Mydownloads/Contentdownloads/673f4b9a-331b-4a02-95e7-6959fd2d847f-363/673f4b9a-331b-4a02-95e7-6959fd2d847f.zip
  // Extract File Called For Destination:/storage/emulated/0/Android/data/com.instancy.enterpriseapp/files/.Mydownloads/Contentdownloads/673f4b9a-331b-4a02-95e7-6959fd2d847f-363

  //region Download actions
  Future<void> downloadTask({
    required BuildContext context,
    required String downloadFileUrl,
    required String destinationFilePath,
    required String downloadDestFolderPath,
    required String fileName,
    required DummyMyCatelogResponseTable2 learningModel,
    required bool isZipFile,
    DummyMyCatelogResponseTable2? trackData,
    bool isTrackEvent = false,
  }) async {
    MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(
            NavigationController().mainNavigatorKey.currentContext!,
            listen: false);
    List<MyLearningDownloadModel> existingDownloads = myLearningDownloadProvider
        .downloads
        .where((element) => element.contentId == learningModel.contentid)
        .toList();
    if (existingDownloads.isNotEmpty) {
      existingDownloads.forEach((element) {
        myLearningDownloadProvider.downloads.remove(element);
      });
    }

    try {
      print("Started Downloading...");

      String? taskId = await FlutterDownloader.enqueue(
        url: downloadFileUrl,
        savedDir: downloadDestFolderPath,
        fileName: fileName,
        requiresStorageNotLow: true,
        showNotification: false,
        openFileFromNotification: false,
      );
      print("Task Id:$taskId");

      if (taskId?.isNotEmpty ?? false) {
        String contentId = learningModel.contentid;
        if(isTrackEvent && (trackData?.contentid.isNotEmpty ?? false)) {
          contentId = "${trackData!.contentid}_${learningModel.contentid}";
        }
        print("contentId added for download:$contentId");

        MyLearningDownloadModel myLearningDownloadModel = MyLearningDownloadModel(
          contentId: contentId,
          table2: learningModel,
          trackModel: trackData,
          downloadFileUrl: downloadFileUrl,
          downloadFilePath: destinationFilePath,
          trackContentId: trackData?.contentid ?? "",
          trackContentName: trackData?.name ?? "",
          isZip: isZipFile,
          isFileDownloading: true,
          isFileDownloaded: false,
          taskId: taskId!,
          isTrackContent: isTrackEvent,
        );
        myLearningDownloadProvider.downloads.add(myLearningDownloadModel);
        myLearningDownloadProvider.notifyListeners();

        AppBloc appBloc = BlocProvider.of<AppBloc>(
          NavigationController().mainNavigatorKey.currentContext!,
          listen: false,
        );
        String hiveMyDownloadsTable = "$MY_DOWNLOADS_HIVE_COLLECTION_NAME-${appBloc.userid}";

        HiveDbHandler().createData(
          hiveMyDownloadsTable,
          contentId,
          myLearningDownloadModel.toJson(),
        );
      }
      else {
        MyToast.showToast(context, "Could Not Start Download");
      }
    }
    catch (e, s) {
      print("Error in Starting Download:$e");
      print(s);
      MyToast.showToast(context, "Could Not Start Download:$e");
    }
  }

  Future<bool> extractZipFile(
      {required String destinationFolderPath,
      required File zipFile,
      Function(int totalOperationsCount)? onFileOperation}) async {
    print("Extract File Called For Destination:$destinationFolderPath");

    final Directory destinationDir = Directory(destinationFolderPath);
    await destinationDir.create(recursive: true);
    try {
      List<String> jwvideos = [];
      // Read the Zip newFile from disk.
      final Uint8List bytes = zipFile.readAsBytesSync();

      // Decode the Zip newFile
      final Archive archive = ZipDecoder().decodeBytes(bytes);

      //String lastFolderPath = "";

      int totalOperations = 1 + archive.length;

      // Extract the contents of the Zip archive to disk.
      for (final file in archive) {
        final filename = file.name;
        print("IsFile:${file.isFile}, Path:${file.name}");
        if (file.isFile) {
          final data = file.content as List<int>;
          File newFile = File(destinationFolderPath + "/" + filename);
          try {
            newFile = await newFile.create(recursive: true);
          } catch (e, s) {
            print(
                "Error in Creating File in MyLearningDownloadController().extractZipFile():$e");
            print(s);
          }
          try {
            newFile = await newFile.writeAsBytes(data);
          } catch (e, s) {
            print(
                "Error in Writing in File in MyLearningDownloadController().extractZipFile():$e");
            print(s);
          }

          /// For content with embedded videos, we get the list of videos in a separate XML file
          /// This needs to be downloaded and stored in a folder withing the destination path
          if (filename == 'jwvideoslist.xml') {
            print('Hello');
            String fileData = await newFile.readAsString();
            final document = XmlDocument.parse(fileData);
            List<XmlElement> elements =
                document.findAllElements('jwvideo').toList();
            for (final element in elements) {
              String content = element.innerText;
              Uri? uri = Uri.tryParse(content);
              if (uri != null) {
                jwvideos.add(content);
              }
            }
          }
        } else {
          //lastFolderPath = file.name;
          try {
            await Directory(destinationFolderPath + "/" + filename)
                .create(recursive: true);
          } catch (e, s) {
            print(
                "Error in Creating Directory in MyLearningDownloadController().extractZipFile():$e");
            print(s);
          }
        }
        if (onFileOperation != null) {
          onFileOperation(totalOperations);
        }
      }

      /// If the course contains videos, start a new process to download those videos
      /// These videos are saved in the same destination folder path under a `jwvideos` sub-folder
      if (jwvideos.isNotEmpty) {
        Directory videoDirectory =
            await Directory(destinationFolderPath + "${pathSeparator}jwvideos")
                .create(recursive: true);
        for(String url in jwvideos) {
          List<String> splitUrl = url.split('/');
          String fileName = splitUrl.last;
          String filePath = '${videoDirectory.path}$pathSeparator$fileName';
          await compute(downloadFromUrl, {'url': url, 'filePath': filePath});
          print('Hello');
        }
      }

      try {
        await zipFile.delete(recursive: true);
      } catch (e, s) {
        print(
            "Error in Deleting Zip File in MyLearningDownloadController().extractZipFile():$e");
        print(s);
      }
      if (onFileOperation != null) {
        onFileOperation(totalOperations);
      }

      return true;
    } catch (e, s) {
      print("Error in Extracting File:$e");
      print(s);
      return false;
    }
  }

  Future<bool> extractContentZipFile() async {
    try {
      String downloadDestFolderPath =
          await AppDirectory.getDocumentsDirectory() +
              "$pathSeparator.Mydownloads${pathSeparator}Contentdownloads";

      Directory directory =
          Directory('$downloadDestFolderPath${pathSeparator}Content');
      bool dirExists = await directory.exists();
      if (dirExists && !kDebugMode) return true;

      ByteData data = await rootBundle.load('assets/Content.zip');
      Uint8List bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      InputStream ifs = InputStream(bytes);

      final archive = ZipDecoder().decodeBuffer(ifs);
      for (final file in archive) {
        final filename = file.name;
        if (filename.contains('MACOSX')) continue;
        if (file.isFile) {
          final data = file.content as List<int>;
          File newFile = File('$downloadDestFolderPath$pathSeparator$filename');
          newFile = await newFile.create(recursive: true);
          newFile = await newFile.writeAsBytes(data);
        } else {
          await Directory('$downloadDestFolderPath$pathSeparator$filename')
              .create(recursive: true);
        }
      }
      return true;
    } catch (err) {
      MyPrint.printOnConsole(err);
      return false;
    }
  }

  Future<void> pauseDownload(MyLearningDownloadModel downloadModel) async {
    await FlutterDownloader.pause(taskId: downloadModel.taskId);
  }

  Future<void> resumeDownload(MyLearningDownloadModel downloadModel) async {
    String? newTaskId = await FlutterDownloader.resume(taskId: downloadModel.taskId);
    downloadModel.taskId = newTaskId ?? "";
  }

  Future<void> cancelDownload(MyLearningDownloadModel downloadModel) async {
    MyPrint.printOnConsole(
        "MyLearningDownloadController.cancelDownload():${downloadModel.taskId}");

    try {
      FlutterDownloader.remove(taskId: downloadModel.taskId, shouldDeleteContent: true).then((value) {
        MyPrint.printOnConsole("FlutterDownloader.cancel successful");
      }).catchError((e) {
        MyPrint.printOnConsole("FlutterDownloader.cancel failed:$e");
      });
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in Removing Download Task from FlutterDownloader in CancelDownload:$e");
      MyPrint.printOnConsole(s);
    }

    MyLearningBloc myLearningBloc = BlocProvider.of<MyLearningBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
    if (myLearningBloc.list.isNotEmpty) {
      List<DummyMyCatelogResponseTable2> list = myLearningBloc.list.where((element) => element.contentid == downloadModel.table2.contentid).toList();
      if (list.isNotEmpty) {
        list.forEach((element) {
          element.isDownloading = false;
          element.isdownloaded = false;

          AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
          String mylearningHiveCollectionName = "$myLearningCollection-${appBloc.userid}";
          HiveDbHandler().createData(
            mylearningHiveCollectionName,
            element.contentid,
            element.toJson(),
          );
        });
      }
    }
    if (myLearningBloc.listArchive.isNotEmpty) {
      List<DummyMyCatelogResponseTable2> list = myLearningBloc.listArchive.where((element) => element.contentid == downloadModel.table2.contentid).toList();
      if (list.isNotEmpty) {
        list.forEach((element) {
          element.isDownloading = false;
          element.isdownloaded = false;

          AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
          String archiveHiveCollectionName = "$archiveList-${appBloc.userid}";
          HiveDbHandler().createData(
            archiveHiveCollectionName,
            element.contentid,
            element.toJson(),
          );
        });
      }
    }

    AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
    String hiveMyDownloadsTable = "$MY_DOWNLOADS_HIVE_COLLECTION_NAME-${appBloc.userid}";

    HiveDbHandler().deleteData(hiveMyDownloadsTable, keys: [downloadModel.contentId]);

    MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
    myLearningDownloadProvider.downloads.remove(downloadModel);
    myLearningDownloadProvider.notifyListeners();
  }

  Future<void> removeFromDownload(MyLearningDownloadModel downloadModel) async {
    MyPrint.printOnConsole("MyLearningDownloadController.removeFromDownload():${downloadModel.taskId}");

    MyLearningDownloadController().changeDownloadStatusOfContent(learningModel: downloadModel.table2, isDownloaded: false);
    setRemoveFromDownloadsForContent(contentid: downloadModel.contentId, isRemoved: true);
    cancelDownload(downloadModel);

    /*MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(
      NavigationController().mainNavigatorKey.currentContext!,
      listen: false,
    );

    downloadModel.table2.isDownloading = false;
    downloadModel.table2.isdownloaded = false;

    MyLearningDownloadController().changeDownloadStatusOfContent(learningModel: downloadModel.table2, isDownloaded: false);

    MyLearningBloc myLearningBloc = BlocProvider.of<MyLearningBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
    if (myLearningBloc.list.isNotEmpty) {
      List<DummyMyCatelogResponseTable2> list = myLearningBloc.list.where((element) => element.contentid == downloadModel.table2.contentid).toList();
      if (list.isNotEmpty) {
        list.forEach((element) {
          element.isDownloading = false;
          element.isdownloaded = false;

          AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
          String mylearningHiveCollectionName = "$myLearningCollection-${appBloc.userid}";
          HiveDbHandler().createData(
            mylearningHiveCollectionName,
            element.contentid,
            element.toJson(),
          );
        });
      }
    }
    if (myLearningBloc.listArchive.isNotEmpty) {
      List<DummyMyCatelogResponseTable2> list = myLearningBloc.listArchive.where((element) => element.contentid == downloadModel.table2.contentid).toList();
      if (list.isNotEmpty) {
        list.forEach((element) {
          element.isDownloading = false;
          element.isdownloaded = false;

          AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
          String archiveHiveCollectionName = "$archiveList-${appBloc.userid}";
          HiveDbHandler().createData(
            archiveHiveCollectionName,
            element.contentid,
            element.toJson(),
          );
        });
      }
    }

    *//*String hiveMyDownloadsTable = "${MY_DOWNLOADS_HIVE_COLLECTION_NAME}-${appBloc.userid}";
    HiveDbHandler().deleteData(hiveMyDownloadsTable, keys: [downloadModel.contentId]);*//*

    setRemoveFromDownloadsForContent(contentid: downloadModel.contentId, isRemoved: true);

    myLearningDownloadProvider.downloads.remove(downloadModel);
    myLearningDownloadProvider.notifyListeners();*/
  }

  //endregion

  Future<bool> changeDownloadStatusOfContent({required DummyMyCatelogResponseTable2 learningModel, bool isDownloaded = true}) async {
    MyPrint.printOnConsole("changeDownloadStatusOfContent called with isDownloaded:$isDownloaded");

    var language = await sharePrefGetString(sharedPref_AppLocale);

    String paramsString, methodUrl;
    if (isDownloaded) {
      paramsString = "SiteURL=" +
          learningModel.siteurl +
          "&ContentID=" +
          learningModel.contentid +
          "&userid=" +
          learningModel.userid.toString() +
          "&DelivoryMode=1&IsDownload=1&localeId=" +
          language;

      methodUrl = "MobileGetMobileContentMetaData";
    } else {
      paramsString = "SiteID=" +
          learningModel.siteid.toString() +
          "&DeleteIDs=" +
          learningModel.contentid +
          "&UserID=" +
          learningModel.userid.toString();

      methodUrl = "MobileDeleteContent";
    }

    if (webApiUrl.isEmpty) {
      webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);
    }

    String url = webApiUrl + "/MobileLMS/$methodUrl?" + paramsString;

    MyPrint.printOnConsole("changeDownloadStatusOfContent:$url");

    try {
      Response? response = await RestClient.getPostData(url);
      MyPrint.printOnConsole(
          "changeDownloadStatusOfContent response status:${response?.statusCode}");
      MyPrint.printOnConsole(
          "changeDownloadStatusOfContent response body:${response?.body}");

      if (response != null) {
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e, s) {
      MyPrint.printOnConsole(s);
    }

    return true;
  }

  Future<void> setRemoveFromDownloadsForContent({required String contentid, required bool isRemoved}) async {
    MyPrint.printOnConsole("setRemoveFromDownloadsForContent called for contentid:$contentid, isRemoved:$isRemoved");

    AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
    String hiveRemovedFromMyDownloadsTable = "$MY_REMOVE_FROM_DOWNLOADS_HIVE_COLLECTION_NAME-${appBloc.userid}";
    if (isRemoved) {
      HiveDbHandler().createData(hiveRemovedFromMyDownloadsTable, contentid, {contentid: true});
    }
    else {
      HiveDbHandler().deleteData(hiveRemovedFromMyDownloadsTable, keys: [contentid]);
    }
  }

  Future<Map<String, bool>> getRemovedFromDownloadMap() async {
    Map<String, bool> removedFromDownload = {};

    AppBloc appBloc = BlocProvider.of<AppBloc>(
        NavigationController().mainNavigatorKey.currentContext!,
        listen: false);
    String removedFromDownloadsHiveCollectionName = "$MY_REMOVE_FROM_DOWNLOADS_HIVE_COLLECTION_NAME-${appBloc.userid}";

    List<Map<String, dynamic>> list = await HiveDbHandler().readData(removedFromDownloadsHiveCollectionName);
    MyPrint.printOnConsole("RemovedFromDownload List:$list");
    list.forEach((Map<String, dynamic> map) {
      map.forEach((String key, dynamic value) {
        if (value is bool) {
          removedFromDownload[key] = value;
        }
      });
    });

    return removedFromDownload;
  }

  showErrorDialog(BuildContext context) {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: false);
    Color textColor = Color(int.parse(
        '0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}'));
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
          title: Text(
            "Error",
            style: TextStyle(
              color: textColor,
            ),
          ),
          content: Text(
            "Unfortunately we could not find this file on our server.\nPlease try again later.",
            style: TextStyle(
              color: textColor,
            ),
          ),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }

  //region online-to-offline sync
  Future<void> checkDownloadedContentSubscribed() async {
    AppBloc appBloc = BlocProvider.of<AppBloc>(
      NavigationController().mainNavigatorKey.currentContext!,
      listen: false,
    );

    Map<String, bool> removedFromDownload = await MyLearningDownloadController().getRemovedFromDownloadMap();

    String hiveCollectionName = "$myLearningCollection-${appBloc.userid}";
    String archieveHiveCollectionName = "$archiveList-${appBloc.userid}";
    String hiveMyDownloadsTable = "$MY_DOWNLOADS_HIVE_COLLECTION_NAME-${appBloc.userid}";
    List<Map<String, dynamic>> mydownloadsHiveData = await HiveDbHandler().readData(hiveMyDownloadsTable);
    MyPrint.logOnConsole("MyDownloadsHiveData:$mydownloadsHiveData");

    List<Future> futures = [];

    List<String> contentIdsToCheck = [];

    Map<String, List<MyLearningDownloadModel>> parentChildsMapForTrackContents = {};

    mydownloadsHiveData.forEach((Map<String, dynamic> map) {
      MyLearningDownloadModel myLearningDownloadModel = MyLearningDownloadModel.fromJson(map);

      bool isRemovedFromDownloads = removedFromDownload[myLearningDownloadModel.contentId] == true;
      if (isRemovedFromDownloads) {
        myLearningDownloadModel.table2.isdownloaded = false;
        myLearningDownloadModel.table2.isDownloading = false;
        setRemoveFromDownloadsForContent(contentid: myLearningDownloadModel.contentId, isRemoved: true);
      }
      else {
        if (myLearningDownloadModel.isTrackContent) {
          if(myLearningDownloadModel.trackContentId.isNotEmpty) {
            if(parentChildsMapForTrackContents[myLearningDownloadModel.trackContentId] is List) {
              parentChildsMapForTrackContents[myLearningDownloadModel.trackContentId]!.add(myLearningDownloadModel);
            }
            else {
              parentChildsMapForTrackContents[myLearningDownloadModel.trackContentId] = [myLearningDownloadModel];
            }
            if(!contentIdsToCheck.contains(myLearningDownloadModel.trackContentId)) {
              contentIdsToCheck.add(myLearningDownloadModel.trackContentId);
            }
          }
        }
        else {
          contentIdsToCheck.add(myLearningDownloadModel.table2.contentid);
        }
      }
    });

    MyPrint.printOnConsole("contentIdsToCheck:$contentIdsToCheck");

    List<String> myLearningIdsList = await callGetDownloadedMyLearningdata(contentIdsToCheck);
    if (myLearningIdsList.isEmpty) return;

    MyPrint.printOnConsole("myLearningIdsList:$myLearningIdsList");

    contentIdsToCheck.forEach((element) {
      if (!myLearningIdsList.contains(element.toUpperCase())) {
        List<MyLearningDownloadModel> childDownloads = parentChildsMapForTrackContents[element] ?? [];

        if(childDownloads.isNotEmpty) {
          childDownloads.forEach((MyLearningDownloadModel childModel) {
            MyPrint.printOnConsole("Removing Content:${childModel.contentId}");
            futures.addAll([
              /*HiveDbHandler().deleteData(hiveCollectionName, keys: [childModel.contentId]),
              HiveDbHandler().deleteData(archieveHiveCollectionName, keys: [childModel.contentId]),*/
              //HiveDbHandler().deleteData(hiveMyDownloadsTable, keys: [childModel.contentId]),
              setRemoveFromDownloadsForContent(contentid: childModel.contentId, isRemoved: true),
            ]);
          });
        }
        else {
          MyPrint.printOnConsole("Removing Content:$element");
          futures.addAll([
            HiveDbHandler().deleteData(hiveCollectionName, keys: [element]),
            HiveDbHandler().deleteData(archieveHiveCollectionName, keys: [element]),
            //HiveDbHandler().deleteData(hiveMyDownloadsTable, keys: [element]),
            setRemoveFromDownloadsForContent(contentid: element, isRemoved: true),
          ]);
        }
      }
    });

    MyPrint.printOnConsole("futures:$futures");

    await Future.wait(futures);
  }

  Future<List<String>> callGetDownloadedMyLearningdata(
      List<String> contentIds) async {
    List<String> ids = [];

    try {
      String appLocale = await sharePrefGetString(sharedPref_AppLocale);
      String userId = await sharePrefGetString(sharedPref_userid);
      String siteId = await sharePrefGetString(sharedPref_siteid);

      String appWebApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

      String requestURL =
          "${appWebApiUrl}MobileLMS/GetDownloadedMyLearningdata?" +
              "userId=$userId" +
              "&contentIds=${contentIds.join(",")}" +
              "&siteId=$siteId" +
              "&localeId=$appLocale";

      var response =
          await RestClient.getDataToken(requestURL, "", userId: userId);
      MyPrint.printOnConsole(
          "Response Status for callGetDownloadedMyLearningdata:${response?.statusCode}");
      MyPrint.printOnConsole(
          "Response Body for callGetDownloadedMyLearningdata:${response?.body}");

      if (response != null) {
        try {
          dynamic value = jsonDecode(response.body);
          if (value is List) {
            List<String> list = List.castFrom<dynamic, String>(value);
            ids.addAll(list);
          }
          if (ids.isEmpty) {
            ids.add("");
          }
        } catch (e, s) {
          MyPrint.printOnConsole(
              "Error in MyLearningDownloadController().callGetDownloadedMyLearningdata():$e");
          MyPrint.printOnConsole(s);
        }
      }
    } catch (err) {
      print(err);
    }

    return ids;
  }

  Future<void> syncDownloadedData(DummyMyCatelogResponseTable2 learningModel) async {
    /*Future callMobileGetContentTrackedDataFuture = callMobileGetContentTrackedData(learningModel).then((Response? response) async {
      if (response != null) {
        var body = jsonDecode(response.body);
        await SqlDatabaseHandler().injectCMIDataInto(body ?? {}, learningModel);
        MyPrint.logOnConsole('Stef! callMobileGetContentTrackedData body for content:${learningModel.contentid}: ${response.body}');
      }
    });

    Future callMobileGetMobileContentMetaDataFuture = callMobileGetMobileContentMetaData(learningModel).then((Response? response) async {
      if (response != null) {
        var body = jsonDecode(response.body);
        await SqlDatabaseHandler().insertTrackObjects(body ?? {}, learningModel);
        MyPrint.logOnConsole('Stef! callMobileGetMobileContentMetaDataFuture body for content:${learningModel.contentid}: ${response.body}');

      }
    });*/

    List<Future> futures = [];

    if (learningModel.objecttypeid.toString() == "10") {
      if (!(learningModel.actualstatus == "Not Started")) {
        futures.addAll([
          callMobileGetContentTrackedData(learningModel).then((Response? response) async {
            if (response != null) {
              var body = jsonDecode(response.body);
              await SqlDatabaseHandler().injectCMIDataInto(body ?? {}, learningModel);
              MyPrint.logOnConsole('Stef! callMobileGetContentTrackedData body for content:${learningModel.contentid}: ${response.body}');
            }
          }),
          callMobileGetMobileContentMetaData(learningModel).then((Response? response) async {
            if (response != null) {
              var body = jsonDecode(response.body);
              await SqlDatabaseHandler().insertTrackObjects(body ?? {}, learningModel);
              MyPrint.logOnConsole('Stef! callMobileGetMobileContentMetaDataFuture body for content:${learningModel.contentid}: ${response.body}');

            }
          }),
        ]);
      }
      else {
        futures.addAll([
          callMobileGetMobileContentMetaData(learningModel).then((Response? response) async {
            if (response != null) {
              var body = jsonDecode(response.body);
              await SqlDatabaseHandler().insertTrackObjects(body ?? {}, learningModel);
              MyPrint.logOnConsole('Stef! callMobileGetMobileContentMetaDataFuture body for content:${learningModel.contentid}: ${response.body}');

            }
          })
        ]);
      }
    }
    else {
      if (!(learningModel.actualstatus == "Not Started")) {
        futures.addAll([
          callMobileGetContentTrackedData(learningModel).then((Response? response) async {
            if (response != null) {
              var body = jsonDecode(response.body);
              await SqlDatabaseHandler().injectCMIDataInto(body ?? {}, learningModel);
              MyPrint.logOnConsole('Stef! callMobileGetContentTrackedData body for content:${learningModel.contentid}: ${response.body}');
            }
          })
        ]);
      }
    }

    await Future.wait(futures);
  }

  Future<Response?> callMobileGetContentTrackedData(
      DummyMyCatelogResponseTable2 learningModel) async {
    try {
      String userId = await sharePrefGetString(sharedPref_userid);
      String appWebApiUrl = await sharePrefGetString(sharedPref_webApiUrl);
      String requestURL =
          "${appWebApiUrl}MobileLMS/MobileGetContentTrackedData?" +
              "_studid=" +
              learningModel.userid.toString() +
              "&_scoid=" +
              learningModel.scoid.toString() +
              "&_SiteURL=" +
              learningModel.siteurl +
              "&_contentId=" +
              learningModel.contentid +
              "&_trackId=";

      var response =
          await RestClient.getDataToken(requestURL, '', userId: userId);
      return response;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<Response?> callMobileGetMobileContentMetaData(
      DummyMyCatelogResponseTable2 learningModel) async {
    try {
      String appLocale = await sharePrefGetString(sharedPref_AppLocale);
      String userId = await sharePrefGetString(sharedPref_userid);

      String appWebApiUrl = await sharePrefGetString(sharedPref_webApiUrl);
      String requestURL =
          "${appWebApiUrl}MobileLMS/MobileGetMobileContentMetaData?" +
              "SiteURL=${learningModel.siteurl}" +
              "&ContentID=${learningModel.contentid}" +
              "&userid=${learningModel.userid}" +
              "&DelivoryMode=1&IsDownload=1&localeId=$appLocale";

      var response =
          await RestClient.getDataToken(requestURL, "", userId: userId);
      return response;
    } catch (err) {
      print(err);
      return null;
    }
  }
//endregion
}
