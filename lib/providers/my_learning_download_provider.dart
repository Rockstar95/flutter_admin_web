import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_admin_web/controllers/my_learning_download_controller.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/models/my_learning/download_feature/mylearning_download_model.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_admin_web/utils/my_utils.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';

import '../configs/constants.dart';
import '../controllers/navigation_controller.dart';
import '../framework/bloc/app/bloc/app_bloc.dart';
import '../framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import '../framework/common/constants.dart';
import '../framework/helpers/database/hivedb_handler.dart';

class MyLearningDownloadProvider extends ChangeNotifier {
  bool isLoadingMyDownloads = false;
  List<MyLearningDownloadModel> downloads = [];

  Future<void> updateDownloadProgress({required String taskid, required DownloadTaskStatus status, required int progress}) async {
    print("updateDownloadProgress called for TaskId:$taskid, DownloadStatus:$status, Progress:$progress");

    List<MyLearningDownloadModel> downList = downloads.where((element) => element.taskId == taskid).toList();
    MyPrint.printOnConsole("downList in MyLearningDownloadProvider.updateDownloadProgress():${downList.length}");
    if(downList.isNotEmpty) {
      MyLearningDownloadModel myLearningDownloadModel = downList.first;

      AppBloc appBloc = BlocProvider.of<AppBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
      String hiveMyDownloadsTable = "$MY_DOWNLOADS_HIVE_COLLECTION_NAME-${appBloc.userid}";

      //Checking Cancel or failed Operation
      if([4, 5].contains(status.value)) {
        if(status.value == 4 && NavigationController().actbaseScaffoldKey.currentContext != null) {
          MyToast.showToastWithIcon(
            context: NavigationController().actbaseScaffoldKey.currentContext!,
            text: "Download Failed",
            iconData: Icons.info,
          );
        }
        downList.forEach((element) {
          String path = element.downloadFilePath;
          path = path.substring(0, path.lastIndexOf(MyLearningDownloadController().pathSeparator));
          try {
            Directory(path).delete();
          }
          catch(e) {}

          downloads.remove(element);
          HiveDbHandler().deleteData(hiveMyDownloadsTable, keys: [element.contentId]);
        });
        MyPrint.printOnConsole("New Downloads Length:${downloads.length}");

        MyLearningBloc myLearningBloc = BlocProvider.of<MyLearningBloc>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
        myLearningBloc.list.where((element) => element.contentid == myLearningDownloadModel.table2.contentid).forEach((element) {
          element.isdownloaded = false;
          element.isDownloading = false;
        });
        myLearningBloc.listArchive.where((element) => element.contentid == myLearningDownloadModel.table2.contentid).forEach((element) {
          element.isdownloaded = false;
          element.isDownloading = false;
        });

        MyLearningDownloadController().setRemoveFromDownloadsForContent(contentid: myLearningDownloadModel.contentId, isRemoved: false);

        String hiveCollectionName = "$myLearningCollection-${appBloc.userid}";
        String archieveHiveCollectionName = "$archiveList-${appBloc.userid}";

        Future myLearningOfflineDataOperation = HiveDbHandler().readData(hiveCollectionName, keys: [myLearningDownloadModel.table2.contentid]).then((List<Map<String, dynamic>> data) {
          MyPrint.printOnConsole("MyLearning List Length when Download Completed:${data.length}");
          if (data.isNotEmpty) {
            for(Map<String, dynamic> item in data) {
              DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
              table2.fromJson(item);

              if(table2.contentid == myLearningDownloadModel.table2.contentid) {
                table2.isdownloaded = false;
                table2.isDownloading = false;
              }

              HiveDbHandler().createData(
                hiveCollectionName,
                table2.contentid,
                table2.toJson(),
              );
            }
          }
        })
            .catchError((e, s) {
          MyPrint.printOnConsole("Error in Getting Non-Archieved Contents From Hive when Download Completed:$e");
          MyPrint.printOnConsole(s);
        });

        Future myLearningArchieveOfflineDataOperation = HiveDbHandler().readData(archieveHiveCollectionName, keys: [myLearningDownloadModel.table2.contentid]).then((List<Map<String, dynamic>> archievedata) {
          MyPrint.printOnConsole("Archieve List Length when Download Completed:${archievedata.length}");
          if (archievedata.isNotEmpty) {
            for(Map<String, dynamic> item in archievedata) {
              DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
              table2.fromJson(item);

              if(table2.contentid == myLearningDownloadModel.table2.contentid) {
                table2.isdownloaded = false;
                table2.isDownloading = false;
              }

              HiveDbHandler().createData(
                archieveHiveCollectionName,
                table2.contentid,
                table2.toJson(),
              );
            }
          }
        })
            .catchError((e, s) {
          MyPrint.printOnConsole("Error in Getting Archieved Contents From Hive when Download Completed:$e");
          MyPrint.printOnConsole(s);
        });

        await Future.wait([
          myLearningOfflineDataOperation,
          myLearningArchieveOfflineDataOperation
        ]);
      }
      else {
        myLearningDownloadModel.downloadStatus = status.value;
        myLearningDownloadModel.isFileDownloadingPaused = status.value == 6;
        myLearningDownloadModel.downloadPercentage = MyUtils.roundTo(progress.toDouble() * (myLearningDownloadModel.isZip ? 0.8 : 1), 100);

        myLearningDownloadModel.table2.isdownloaded = myLearningDownloadModel.downloadStatus == 3 && myLearningDownloadModel.downloadPercentage == (myLearningDownloadModel.isZip ? 80 : 100);
        myLearningDownloadModel.table2.isDownloading = [1, 2].contains(myLearningDownloadModel.downloadStatus);

        HiveDbHandler().createData(hiveMyDownloadsTable, myLearningDownloadModel.contentId, myLearningDownloadModel.toJson());

        if(myLearningDownloadModel.table2.isdownloaded) {
          print("Destination File Path:${myLearningDownloadModel.downloadFilePath}");
          File file = File(myLearningDownloadModel.downloadFilePath);
          bool isExist = await file.exists();
          print("Destination File Path:${myLearningDownloadModel.downloadFilePath} Exist:$isExist");

          if(isExist && myLearningDownloadModel.isZip) {
            myLearningDownloadModel.isFileExtracted = false;

            double remainingDownloadPercentage = 100 - myLearningDownloadModel.downloadPercentage;
            String folderPath = myLearningDownloadModel.downloadFilePath;
            folderPath = folderPath.substring(0, folderPath.lastIndexOf(MyLearningDownloadController().pathSeparator));

            HiveDbHandler().createData(hiveMyDownloadsTable, myLearningDownloadModel.contentId, myLearningDownloadModel.toJson());

            await MyLearningDownloadController().extractZipFile(
              destinationFolderPath: folderPath,
              zipFile: file,
              onFileOperation: remainingDownloadPercentage > 0 ? (int totalOperations) {
                myLearningDownloadModel.downloadPercentage += (remainingDownloadPercentage / totalOperations);
                notifyListeners();
              } : null,
            );
            myLearningDownloadModel.isFileExtracted = true;

            HiveDbHandler().createData(hiveMyDownloadsTable, myLearningDownloadModel.contentId, myLearningDownloadModel.toJson());
          }
          MyLearningDownloadController().setRemoveFromDownloadsForContent(contentid: myLearningDownloadModel.contentId, isRemoved: false);

          String hiveCollectionName = "$myLearningCollection-${appBloc.userid}";
          String archieveHiveCollectionName = "$archiveList-${appBloc.userid}";

          Future syncDownloadedDataOperation = MyLearningDownloadController().syncDownloadedData(myLearningDownloadModel.table2).then((value) {
            MyPrint.printOnConsole("Sync Downloaded Data Successfull when Content Downloaded");
          })
          .catchError((e, s) {
            MyPrint.printOnConsole("Error in Syncing Downloaded Data when Content Downloaded:$e");
            MyPrint.printOnConsole(s);
          });

          Future myLearningOfflineDataOperation = HiveDbHandler().readData(hiveCollectionName, keys: [myLearningDownloadModel.table2.contentid]).then((List<Map<String, dynamic>> data) {
            MyPrint.printOnConsole("MyLearning List Length when Download Completed:${data.length}");
            if (data.isNotEmpty) {
              for(Map<String, dynamic> item in data) {
                DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
                table2.fromJson(item);

                if(table2.contentid == myLearningDownloadModel.table2.contentid) {
                  table2.isdownloaded = true;
                  table2.isDownloading = false;
                }

                HiveDbHandler().createData(
                  hiveCollectionName,
                  table2.contentid,
                  table2.toJson(),
                );
              }
            }
          })
          .catchError((e, s) {
            MyPrint.printOnConsole("Error in Getting Non-Archieved Contents From Hive when Download Completed:$e");
            MyPrint.printOnConsole(s);
          });

          Future myLearningArchieveOfflineDataOperation = HiveDbHandler().readData(archieveHiveCollectionName, keys: [myLearningDownloadModel.table2.contentid]).then((List<Map<String, dynamic>> archievedata) {
            MyPrint.printOnConsole("Archieve List Length when Download Completed:${archievedata.length}");
            if (archievedata.isNotEmpty) {
              for(Map<String, dynamic> item in archievedata) {
                DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
                table2.fromJson(item);

                if(table2.contentid == myLearningDownloadModel.table2.contentid) {
                  table2.isdownloaded = true;
                  table2.isDownloading = false;
                }

                HiveDbHandler().createData(
                  archieveHiveCollectionName,
                  table2.contentid,
                  table2.toJson(),
                );
              }
            }
          })
          .catchError((e, s) {
            MyPrint.printOnConsole("Error in Getting Archieved Contents From Hive when Download Completed:$e");
            MyPrint.printOnConsole(s);
          });

          await Future.wait([
            syncDownloadedDataOperation,
            myLearningOfflineDataOperation,
            myLearningArchieveOfflineDataOperation
          ]);

          MyLearningDownloadController().changeDownloadStatusOfContent(learningModel: myLearningDownloadModel.table2, isDownloaded: true);

          myLearningDownloadModel.isFileDownloaded = true;
          myLearningDownloadModel.isFileDownloading = false;

          HiveDbHandler().createData(hiveMyDownloadsTable, myLearningDownloadModel.contentId, myLearningDownloadModel.toJson());
        }
      }

      notifyListeners();
    }
  }
}