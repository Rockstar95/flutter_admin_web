import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/helpers/database/hivedb_handler.dart';
import 'package:flutter_admin_web/framework/helpers/offline_course_launcher.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:open_file/open_file.dart';

import 'my_learning_download_controller.dart';

class EventTrackController {
  static EventTrackController? _instance;
  String pathSeparator = "";
  late GeneralRepository generalRepository;

  factory EventTrackController() {
    return _instance ??= EventTrackController._();
  }

  EventTrackController._() {
    if (pathSeparator.trim().isEmpty) {
      pathSeparator = Platform.pathSeparator;
    }
    generalRepository = GeneralRepositoryBuilder.repository();
  }

  Future<bool> fileExistCheck(DummyMyCatelogResponseTable2 myLearningModel,
      DummyMyCatelogResponseTable2 table2, String appUserId) async {
    String downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
        "$pathSeparator.Mydownloads${pathSeparator}Contentdownloads" +
        "$pathSeparator" +
        myLearningModel.contentid.toString() +
        "$pathSeparator" +
        table2.contentid +
        '-' +
        "$appUserId$pathSeparator${table2.startpage}";
    File file = File(downloadDestFolderPath);
    print("Checking Path:$downloadDestFolderPath");
    return (await file.exists());
  }

  Future<bool> checkIfContentIsAvailableOffline({
    required BuildContext context,
    required DummyMyCatelogResponseTable2 parentMyLearningModel,
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
      bool fileCheck = await fileExistCheck(parentMyLearningModel, table2, appBloc.userid);
      print("checkIfContentIsAvailableOffline called with isDownloaded:$fileCheck");
      if(removedFromDownload['${parentMyLearningModel.contentid}_${table2.contentid}'] == true) {
        return false;
      }

      return fileCheck;
    }
    else {
      bool fileCheck = await fileExistCheck(parentMyLearningModel, table2, appBloc.userid);
      print("launchCourseOffline called with isDownloaded:$fileCheck");
      if(removedFromDownload['${parentMyLearningModel.contentid}_${table2.contentid}'] == true) {
        return false;
      }

      return fileCheck;
    }
  }

  Future<bool> launchCourseOffline({
    required BuildContext context,
    required DummyMyCatelogResponseTable2 parentMyLearningModel,
    required DummyMyCatelogResponseTable2 table2,
  }) async {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: false);

    Map<String, bool> removedFromDownload = await MyLearningDownloadController().getRemovedFromDownloadMap();

    if(removedFromDownload["${parentMyLearningModel.contentid}_${table2.contentid}"] == true) {
      courseNotDownloadedDialog(context, appBloc);
      return false;
    }

    if (table2.objecttypeid == 10 && table2.bit5) {
      // Need to open EventTrackListTabsActivity
      print('Navigation to EventTrackList called');
      MyLearningBloc myLearningBloc =
      BlocProvider.of<MyLearningBloc>(context, listen: false);

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventTrackList(
            table2,
            true,
            myLearningBloc.list,
          ),
        ),
      );
      return true;
    }
    else if(table2.objecttypeid == 70){
      /// No download for this file type
    }
    else if (table2.objecttypeid == 694) {
      // TODO: Phase 2
    }
    else if ([8, 9, 21, 26, 28, 102].contains(table2.objecttypeid) ||
        (table2.objecttypeid == 10 && !table2.bit5)) {
      bool fileCheck =
          await fileExistCheck(parentMyLearningModel, table2, appBloc.userid);
      print("launchCourseOffline called with isDownloaded:$fileCheck");

      if(!fileCheck) {
        courseNotDownloadedDialog(context, appBloc);
        return false;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => OfflineContentLauncherInAppWebview(
            table2: table2,
            isTrackListItem: true,
            eventTrackModel: parentMyLearningModel,
          ),
        ),
      );
      return true;
    }
    else {
      bool fileCheck =
      await fileExistCheck(parentMyLearningModel, table2, appBloc.userid);
      print("launchCourseOffline called with isDownloaded:$fileCheck");

      if(!fileCheck) {
        courseNotDownloadedDialog(context, appBloc);
        return false;
      }
      try {
        String downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() +
            "$pathSeparator.Mydownloads${pathSeparator}Contentdownloads" +
            "$pathSeparator" +
            parentMyLearningModel.contentid.toString() +
            "$pathSeparator" +
            table2.contentid +
            '-' +
            "${appBloc.userid}$pathSeparator${table2.startpage}";
        File file = File(downloadDestFolderPath);
        // downloadDestFolderPath = downloadDestFolderPath.replaceFirst('/', '');
        OpenResult result = await OpenFile.open(file.path);
        if(result.type != ResultType.done) {
          SnackBar snackBar = SnackBar(content: Text(result.message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        }
        return true;
      } catch (err) {
        return false;
      }
    }
    return false;
  }

  void courseNotDownloadedDialog(BuildContext context, AppBloc appBloc) {
    showDialog(
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
}
