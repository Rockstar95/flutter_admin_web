import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/helpers/database/hivedb_handler.dart';
import 'package:flutter_admin_web/framework/repository/general/model/CMIModel.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:intl/intl.dart';

import '../../../framework/helpers/utils.dart';
import '../repository/general/model/LearnerSessionModel.dart';
import 'database/database_handler.dart';

class OfflineContentLauncherInAppWebview extends StatefulWidget {
  final DummyMyCatelogResponseTable2 table2;
  final DummyMyCatelogResponseTable2? eventTrackModel;
  final bool isTrackListItem;

  const OfflineContentLauncherInAppWebview({
    Key? key,
    required this.table2,
    this.eventTrackModel,
    this.isTrackListItem = false,
  }) : super(key: key);

  @override
  State<OfflineContentLauncherInAppWebview> createState() =>
      _OfflineContentLauncherInAppWebviewState();
}

class _OfflineContentLauncherInAppWebviewState extends State<OfflineContentLauncherInAppWebview> {
  late DummyMyCatelogResponseTable2 table2;
  MyLearningModel model = MyLearningModel();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      javaScriptEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      hardwareAcceleration: true,
      allowFileAccess: true,
      allowContentAccess: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late Future<bool> futureGetData;
  String queryParams = '';
  LearnerSessionModel? learnersessionTb;
  File? file;
  String offlineScormPath = '';
  bool isCourseCloseCalled = false;
  bool isReloadedOnce = false;
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  Future<String> generateDownloadFolderPath() async {

    String downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
        '/.Mydownloads/Contentdownloads' +
        '/';

    if(widget.isTrackListItem) {
      downloadDestFolderPath += widget.eventTrackModel!.contentid + '/';
    }

    downloadDestFolderPath += widget.table2.contentid +
        "-${appBloc.userid}";
    return downloadDestFolderPath;
  }

  Future<bool> getData() async {
    print("Content Id:${widget.table2.contentid}");

    String downloadDestFolderPath = await generateDownloadFolderPath();
    print("Checking Folder Exist:'$downloadDestFolderPath'");
    Directory directory = Directory(downloadDestFolderPath);
    print('Directory Exist:${directory.existsSync()}');

    String filePath = downloadDestFolderPath + Platform.pathSeparator + table2.startpage;
    print("Checking File Exist:'$filePath'");

    File file = File(filePath);

    bool isExist = await file.exists();
    print('file Exist:$isExist');
    if (isExist) {
      this.file = file;
      this.offlineScormPath = await AppDirectory.getDocumentsDirectory() + '/.Mydownloads/Contentdownloads/Content/LaunchCourse.html';
      Map<String, dynamic> map = await SqlDatabaseHandler().generateOfflinePathForCourseView(model);
      queryParams = map['requestString'] is String ? map['requestString'] : "";
      learnersessionTb = map['learnersessionTb'] is LearnerSessionModel ? map['learnersessionTb'] : null;
      MyPrint.printOnConsole("queryParams:${queryParams}");
    }

    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }

    await SqlDatabaseHandler.init();

    return isExist;
  }

  //Online
  //InApp Webview On Load Start:file:///storage/emulated/0/Android/data/com.instancy.enterpriseapp/files/.Mydownloads/Contentdownloads/
  // 0f222fc5-e2a2-4ce6-a295-e07810822096-88/blank.html?IOSCourseClose=true&cid=14582&stid=88&lloc=2&lstatus=completed&
  // susdata=#pgvs_start%231;2;3;4;5;6;%23pgvs_end%23&timespent=00:00:25.75&quesdata=

  //Offline
  //InApp Webview On Load Start:file:///storage/emulated/0/Android/data/com.instancy.enterpriseapp/files/.Mydownloads/Contentdownloads/
  // 0f222fc5-e2a2-4ce6-a295-e07810822096-88/blank.html?IOSCourseClose=true&cid=14582&stid=88&lloc=2&lstatus=completed&
  // susdata=#pgvs_start%231;2;3;4;5;6;%23pgvs_end%23&timespent=00:00:14.05&quesdata=

  // Executing Query:UPDATE CMI SET location = '2', isupdate= 'false' WHERE scoid=14582 AND siteid=374 AND userid=88
  // Executing Query:UPDATE CMI SET location = '4', isupdate= 'false' WHERE scoid=14582 AND siteid=374 AND userid=88

  //queryParams:cid=14582&stid=88&lloc=2&lstatus=completed&susdata=%23pgvs_start%231;2;3;4;5;6;%23pgvs_end%23&
  // quesdata=6@1@correct@$5@1@correct@$4@1@correct@&sname=&IsInstancyContent=true&nativeappURL=true

  void onLoadStartHandler(InAppWebViewController controller, Uri? url) async {
    print("InApp Webview On Load Start:$url");
    await controller.injectJavascriptFileFromAsset(assetFilePath: 'assets/js/main.js');
    String path = url?.toString().toLowerCase() ?? '';

    if (path.contains("coursetracking/savecontenttrackeddata1") ||
        path.contains("blank.html?ioscourseclose=true")) {
      path = path.replaceAll('#', '%23');
      Uri uri2 = Uri.parse(path);
      Map<String, String> queryParams = uri2.queryParameters;
      MyPrint.printOnConsole("queryParams in onLoadStartHandler:${queryParams}");

      String timespent = queryParams['timespent']?.toString() ?? "00:00:00";
      String score = queryParams['score']?.toString() ?? "0";

      List<Future> futures = [
        SqlDatabaseHandler().insertCMI(model, {
          "suspenddata" : queryParams['susdata']!,
          "score" : score,
          //"timespent" : timespent,
        }),
      ];

      if(learnersessionTb != null) {
        learnersessionTb!.timeSpent = timespent;
        futures.add(SqlDatabaseHandler().insertUserSession(learnersessionTb!));
      }
      // incomplete
      // passed
      // failed
      futures.add(updateCourseProgress(queryParams));

      await Future.wait(futures);

      print('path $path');
      if (!isCourseCloseCalled) {
        isCourseCloseCalled = true;
        Navigator.pop(context);
      }
    }
  }

  void onLoadStopHandler(InAppWebViewController controller, Uri? url) async {
    try {
      print("InApp Webview On Load Stop:${url?.path}");
      await controller.injectJavascriptFileFromAsset(
          assetFilePath: 'assets/js/main.js');
      addJSHandlers(controller);
      if(!isReloadedOnce) {
        isReloadedOnce = true;
        controller.reload();
      }
    } catch (err) {
      print(err);
    }
  }

  void addJSHandlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: 'hideNativeContentLoader',
      callback: (args) {
        print('hideNativeContentLoader called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'OnLineCourseClose',
      callback: (args) async {
        print('OnLineCourseClose called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'LMSSetRandomQuestionNosWithRandomqusseq',
      callback: (args) {
        print(
            'LMSSetRandomQuestionNosWithRandomqusseq called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'AddOfflineAttachementWithQuesid',
      callback: (args) {
        print('AddOfflineAttachementWithQuesid called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'LMSGetRandomQuestionNos',
      callback: (args) {
        print('LMSGetRandomQuestionNos called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'PlayAudioWithSrcStatus',
      callback: (args) {
        print('PlayAudioWithSrcStatus called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName:
      'saveUserPageNotesWithContentIDPageIDSequenceIDUserNotesTextNoteCountIsType',
      callback: (args) {
        print(
            'saveUserPageNotesWithContentIDPageIDSequenceIDUserNotesTextNoteCountIsType called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'DeletePageNoteWithContentIDPageIDNoteCount',
      callback: (args) {
        print(
            'DeletePageNoteWithContentIDPageIDNoteCount called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'GetUserPageNotesWithContentIDPageID',
      callback: (args) {
        print('GetUserPageNotesWithContentIDPageID called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'GetUserTextResponsesWithSeqIDUserID',
      callback: (args) {
        print('GetUserTextResponsesWithSeqIDUserID called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'getPercentCompleted',
      callback: (args) {
        print('getPercentCompleted called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'SaveLocationWithLocation',
      callback: (args) async {
        await SqlDatabaseHandler().saveResponseCMI(model, 'location', args[0].toString());
        print('SaveLocationWithLocation called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'SaveQuestionDataWithQuestionData',
      callback: (args) async {
        await SqlDatabaseHandler().saveQuestionDataWithQuestionDataMethod(model, args[0].toString(), '');
        print('SaveQuestionDataWithQuestionData called with args: ${args[0]}');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'RetakeCourseWithIsRetake',
      callback: (args) {
        print('RetakeCourseWithIsRetake called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'updatePercentCompletedWithProgressValue',
      callback: (args) async {
        await SqlDatabaseHandler()
            .updateContentStatusFromLRSInterface(model, args[0].toString());

        await SqlDatabaseHandler().updateContentStatusInTrackListLRS(
            model, args[0].toString(), false);

        await SqlDatabaseHandler()
            .savePercentCompletedInCMI(model, args[0].toString());
        print(
            'updatePercentCompletedWithProgressValue called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'UpdateUserTextResponsesWithSeqIDUserIDTextResponses',
      callback: (args) {
        print(
            'UpdateUserTextResponsesWithSeqIDUserIDTextResponses called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'LMSGetPooledQuestionNos',
      callback: (args) {
        print('LMSGetPooledQuestionNos called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'LMSSetPooledQuestionNosWithStr',
      callback: (args) {
        print('LMSSetPooledQuestionNosWithStr called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'XHR_requestWithLrsUrlMethodDataAuthCallbackIgnore404',
      callback: (args) {
        print(
            'XHR_requestWithLrsUrlMethodDataAuthCallbackIgnore404 called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'XHR_GetStateWithStateKey',
      callback: (args) {
        print('XHR_GetStateWithStateKey called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'widgetVideoRecordingWithFromSource',
      callback: (args) {
        print('widgetVideoRecordingWithFromSource called with args: $args');
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'widgetVideoRecordingFromSource',
      callback: (args) {
        print('widgetVideoRecordingFromSource called with args: $args');
      },
    );

    //region Workflow Rules Related Scripts
    controller.addJavaScriptHandler(
      handlerName: 'LMSGetTrackWorkflowResultsWithTrackID',
      callback: (args) async {
        print('LMSGetTrackWorkflowResultsWithTrackID called with args: $args');

        String trackId = "";
        if(args.isNotEmpty && args.first is String) {
          trackId = args[0].toString();
        }

        String returnTrack = await SqlDatabaseHandler().getTrackTemplateWorkflowResults(trackId, model);
        MyPrint.printOnConsole("LMSGetTracWithTrackID:${returnTrack}");
        return returnTrack;
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'UpdateTrackWorkflowResultsWithTrackIDTrackItemIDTrackItemStateWmessageRuleIDStepID',
      callback: (args) async {
        print('UpdateTrackWorkflowResultsWithTrackIDTrackItemIDTrackItemStateWmessageRuleIDStepID called with args: $args');

        String trackID = args.length > 0 ? (args[0]?.toString() ?? "") : "";
        String trackItemId = args.length > 1 ? (args[1]?.toString() ?? "") : "";
        String trackIstate = args.length > 2 ? (args[2]?.toString() ?? "") : "";
        String wMessage = args.length > 3 ? (args[3]?.toString() ?? "") : "";
        String ruleId = args.length > 4 ? (args[4]?.toString() ?? "") : "";
        String cStepId = args.length > 5 ? (args[5]?.toString() ?? "") : "";

        SqlDatabaseHandler().updateWorkFlowRulesInDBForTrackTemplate(trackID, trackItemId, trackIstate, wMessage, ruleId, cStepId, model.siteID, model.userID);
      },
    );
    //endregion

    controller.addJavaScriptHandler(
      handlerName: 'SCORM_LMSInitialize',
      callback: (args) {
        print('SCORM_LMSInitialize called with args: $args');
        return "true";
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'SCORM_LMSGetValueWithGetValue',
      callback: (args) async {
        print('SCORM_LMSGetValueWithGetValue called with args: $args');
        String returntring = "";
        String queryElement = "";

        if (args[0].contains("core.lesson_mode")) {
          queryElement = "coursemode";
        } else if (args[0].contains("lesson_status")) {
          queryElement = "status";
        } else if (args[0].contains("lesson_location")) {
          queryElement = "location";
        } else if (args[0].contains("suspend_data")) {
          queryElement = "suspenddata";
        } else if (args[0].contains("score.min")) {
          queryElement = "scoremin";
        } else if (args[0].contains("score.max")) {
          queryElement = "scoremax";
        }

        if(queryElement.isNotEmpty) {
          returntring = await SqlDatabaseHandler().checkCMIWithGivenQueryElement(queryElement, widget.table2);
        }

        return returntring;
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'SCORM_LMSSetValueWithTotalValue',
      callback: (args) async {
        print('SCORM_LMSSetValueWithTotalValue called with args: $args');
        String getname = "";
        String getvalue = "";

        args[0] = args[0].toString().replaceAll("#\$&", "=");

        List<String> array = args[0].toString().split("=");

        int sizeAry = array.length;
        if (array.isNotEmpty) {
          getname = array[0];
          getvalue = array[1];
        }

        String saveValue = "";
        String queryElement = "";
        String scormExit = "true";
        if (getname.contains("cmi.core.session_time")) {
          queryElement = "timespent";
          saveValue = getvalue;

        } else if (getname.contains("cmi.core.lesson_status")) {
          queryElement = "status";
          saveValue = getvalue;

        } else if (getname.contains("cmi.suspend_data")) {
          queryElement = "suspenddata";
          saveValue = getvalue;

        } else if (getname.contains("cmi.core.lesson_location")) {
          queryElement = "location";
          saveValue = getvalue;

        } else if (getname.contains("cmi.core.score.raw")) {
          queryElement = "score";
          saveValue = getvalue;

        } else if (getname.contains("cmi.core.score.max")) {
          queryElement = "scoreMax";
          saveValue = getvalue;

        } else if (getname.contains("cmi.core.score.min")) {
          queryElement = "scoreMin";
          saveValue = getvalue;

        } else if (getname.contains("cmi.core.exit")) {
          if (getvalue.toLowerCase() == "") {
            scormExit = "true";
          }
        } else {
          return "true";
        }

        if (!(queryElement.toLowerCase() == "")) {
          CMIModel cmiDetails = CMIModel();

          cmiDetails.siteId = widget.table2.siteid.toString();
          cmiDetails.userId = int.parse(widget.table2.userid.toString());
          cmiDetails.scoId = widget.table2.scoid;
          await SqlDatabaseHandler().UpdateScormCMI(cmiDetails, queryElement, saveValue);
          scormExit = "true";
        }

        return scormExit;
      },
    );

  }

  Future<void> updateCourseProgress(Map<String, String> queryParams) async {
    String collectionName = '';
    if(widget.isTrackListItem) {
      collectionName = "$tracklistCollection-${widget.eventTrackModel?.contentid}-${appBloc.userid}";
    }
    else {
      collectionName = "$myLearningCollection-${appBloc.userid}";
    }

    var data = await HiveDbHandler().readData(collectionName);

    if(data.isEmpty) return;

    List<DummyMyCatelogResponseTable2> list = [];
    for(Map<String, dynamic> item in data) {
      if(item.containsKey('data')) {
        continue;
      }
      DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
      table2.fromJson(item);
      list.add(table2);
    }
    int index = list.indexWhere((element) {
      return element.siteid == table2.siteid &&
          element.scoid == table2.scoid &&
          element.userid == table2.userid;
    });
    if (index != -1) {
      String startDate = list[index].startdate;
      String formattedDate = DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now());
      switch (queryParams['lstatus']) {
        case 'completed':
          list[index].corelessonstatus =
          'Completed';
          list[index].progress = '100';
          list[index].datecompleted = formattedDate;

          SqlDatabaseHandler().updateCMIstatus(list[index], 'completed', 100);
          break;
        case 'passed':
          list[index].corelessonstatus =
          'Completed(Passed)';
          list[index].progress = '100';
          list[index].datecompleted = formattedDate;
          SqlDatabaseHandler().updateCMIstatus(list[index], 'passed', 100);
          break;
        case 'failed':
          list[index].corelessonstatus =
          'Completed(Failed)';
          list[index].progress = '100';
          list[index].datecompleted = formattedDate;
          SqlDatabaseHandler().updateCMIstatus(list[index], 'failed', 100);
          break;
        case 'in progress':
        case 'incomplete':
        default:
          if(list[index].progress != '100') {
            list[index].corelessonstatus = 'In Progress';
            list[index].progress = '50';
          }
          break;
      }
      await HiveDbHandler().createData(
        collectionName,
        list[index].contentid,
        list[index].toJson(),
      );
    }

    if(widget.isTrackListItem) {
      bool trackIsCompleted = false;
      int courseCount = list.length;
      int completeCount = 0;
      for(DummyMyCatelogResponseTable2 item in list) {
        if (item.progress == '100') {
          completeCount++;
        }
      }
      if(completeCount == courseCount) {
        trackIsCompleted = true;
      }

      /// Update progress for Learning Track
      var myLearningData = await HiveDbHandler().readData("$myLearningCollection-${appBloc.userid}");
      if(myLearningData.isEmpty) return;

      List<DummyMyCatelogResponseTable2> myLearningDataList = [];
      for(Map<String, dynamic> item in myLearningData) {
        DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
        table2.fromJson(item);
        myLearningDataList.add(table2);
      }
      int idx = myLearningDataList.indexWhere((element) {
        return element.siteid == widget.eventTrackModel?.siteid &&
            element.scoid == widget.eventTrackModel?.scoid &&
            element.userid == widget.eventTrackModel?.userid;
      });
      if (idx != -1) {
        myLearningDataList[idx].corelessonstatus = trackIsCompleted ? 'Completed' : 'In Progress';
        myLearningDataList[idx].progress = trackIsCompleted ? '100' : '50';
        await HiveDbHandler().createData(
          "$myLearningCollection-${appBloc.userid}",
          myLearningDataList[idx].contentid,
          myLearningDataList[idx].toJson(),
        );
      }
    }
  }

  bool isFullScreen(DummyMyCatelogResponseTable2 myLearningModel) {
    if (myLearningModel.objecttypeid == 8 ||
        myLearningModel.objecttypeid == 9 ||
        myLearningModel.objecttypeid == 10) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    MyPrint.printOnConsole("Object Type Id:${widget.table2.objecttypeid}");
    table2 = widget.table2;
    model.scoId = table2.scoid.toString();
    model.siteID = table2.siteid.toString();
    model.userID = table2.userid.toString();
    model.objecttypeId = table2.objecttypeid.toString();
    model.startDate = table2.startdate;
    model.siteURL = table2.siteurl;
    model.offlinepath = table2.folderpath;
    futureGetData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return isFullScreen(widget.table2) ? false : true;
        //return true;
      },
      child: SafeArea(
        child: FutureBuilder<bool>(
          future: futureGetData,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true && file != null) {
                return getWebView(file!);
                // return getWebView(file!);
              }
              else {
                return Center(
                  child: Text("Could't Load File"),
                );
              }
            }
            else {
              return SpinKitFadingCircle(
                color: Colors.black,
              );
            }
          },
        ),
      ),
    );
  }

  Widget getWebView(File file) {
    Uri uri = Uri.file(file.path);
    Uri uri2 = Uri(
      path: uri.path,
      scheme: uri.scheme,
      query: queryParams,
    );
    if(widget.table2.objecttypeid.toString() == '26') {
      Uri uri = Uri.file(offlineScormPath);
      uri2 = Uri(
        path: uri.path,
        scheme: uri.scheme,
        query: 'contentpath=file://${file.path}',
      );
    }

    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: uri2,
      ),
      initialOptions: options,
      onWebViewCreated: (controller) async {
        await controller.clearCache();
        // webViewController = controller;
        await controller.injectJavascriptFileFromAsset(
            assetFilePath: 'assets/js/main.js');

        // ?nativeappURL=true&cid=${table2?.ciid}
      },
      onLoadError: (InAppWebViewController controller, Uri? url, int code,
          String message) {
        print("InApp Webview On Load Error:$message");
      },
      onConsoleMessage:
          (InAppWebViewController controller, ConsoleMessage consoleMessage) {
        print("InApp Webview On Console Message:${consoleMessage.message}");
      },
      onLoadResource:
          (InAppWebViewController controller, LoadedResource resource) {
        print("InApp Webview On Load Resource:${resource.url?.path}");

        // if ((resource.url?.path
        //             .toLowerCase()
        //             .contains("coursetracking/savecontenttrackeddata1") ??
        //         false) ||
        //     (resource.url?.path
        //             .toLowerCase()
        //             .contains("blank.html?ioscourseclose=true") ??
        //         false)) {
        //   Navigator.of(context).pop(true);
        // }
      },
      onLoadStart: onLoadStartHandler,
      onLoadStop: onLoadStopHandler,
    );
  }
}
