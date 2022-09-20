
import '../../../framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import '../../../utils/my_print.dart';

/*Download Status Values Mapping
undefined = 0;
enqueued = 1;
running = 2;
complete = 3;
failed = 4;
canceled = 5;
paused = 6;*/

class MyLearningDownloadModel {
  double downloadPercentage = 0;
  DummyMyCatelogResponseTable2 table2;
  DummyMyCatelogResponseTable2? trackModel;
  String taskId = "", contentId = "", downloadFileUrl = "", downloadFilePath = "", trackContentId = "", trackContentName = "";
  int downloadStatus = 0;
  bool isZip = false, isFileDownloading = false, isFileDownloadingPaused = false, isFileDownloaded = false, isFileExtracted = false,
      isTrackContent = false;

  MyLearningDownloadModel({
    this.downloadPercentage = 0,
    required this.table2,
    this.trackModel,
    this.taskId = "",
    this.contentId = "",
    this.downloadFileUrl = "",
    this.downloadFilePath = "",
    this.trackContentId = "",
    this.trackContentName = "",
    this.downloadStatus = 0,
    this.isZip = false,
    this.isFileDownloading = false,
    this.isFileDownloadingPaused = false,
    this.isFileDownloaded = false,
    this.isFileExtracted = false,
    this.isTrackContent = false,
  });

  /*MyLearningDownloadModel.fromJson2(Map<String, dynamic> map) {
    downloadPercentage = map['downloadPercentage']?.toDouble() ?? 0;
    // table2 = DummyMyCatelogResponseTable2().fromJson(map['table2'] ?? {});

    table2 = DummyMyCatelogResponseTable2();
  }*/

  static MyLearningDownloadModel fromJson(Map<String, dynamic> map) {
    Map<String, dynamic> table2 = {};
    if(map['table2'] is Map) {
      try {
        table2 = Map.castFrom<dynamic, dynamic, String, dynamic>(map['table2']);
      }
      catch(e, s) {
        MyPrint.printOnConsole(s);
      }
    }

    Map<String, dynamic> trackMap = {};
    if(map['trackModel'] is Map) {
      try {
        trackMap = Map.castFrom<dynamic, dynamic, String, dynamic>(map['trackModel']);
      }
      catch(e, s) {
        MyPrint.printOnConsole(s);
      }
    }

    MyLearningDownloadModel myLearningDownloadModel = MyLearningDownloadModel(
      downloadPercentage: map['downloadPercentage']?.toDouble() ?? 0,
      table2: DummyMyCatelogResponseTable2().fromJson(table2),
      trackModel: trackMap.isNotEmpty ? DummyMyCatelogResponseTable2().fromJson(trackMap) : null,
      taskId: map['taskId']?.toString() ?? "",
      contentId: map['contentId']?.toString() ?? "",
      downloadFileUrl: map['downloadFileUrl']?.toString() ?? "",
      downloadFilePath: map['downloadFilePath']?.toString() ?? "",
      trackContentId: map['trackContentId']?.toString() ?? "",
      trackContentName: map['trackContentName']?.toString() ?? "",
      downloadStatus: map['downloadStatus']?.toInt() ?? 0,
      isZip: map['isZip'] ?? false,
      isFileDownloading: map['isFileDownloading'] ?? false,
      isFileDownloadingPaused: map['isFileDownloadingPaused'] ?? false,
      isFileDownloaded: map['isFileDownloaded'] ?? false,
      isFileExtracted: map['isFileExtracted'] ?? false,
      isTrackContent: map['isTrackContent'] ?? false,
    );

    /*downloadPercentage = map['downloadPercentage']?.toDouble() ?? 0;
    // table2 = DummyMyCatelogResponseTable2().fromJson(map['table2'] ?? {});

    table2 = DummyMyCatelogResponseTable2();*/

    return myLearningDownloadModel;
  }

  Map<String, dynamic> toJson() {
    return {
      "downloadPercentage" : downloadPercentage,
      "table2" : table2.toJson(),
      "trackModel" : trackModel?.toJson(),
      "taskId" : taskId,
      "contentId" : contentId,
      "downloadFileUrl" : downloadFileUrl,
      "downloadFilePath" : downloadFilePath,
      "trackContentId" : trackContentId,
      "trackContentName" : trackContentName,
      "downloadStatus" : downloadStatus,
      "isZip" : isZip,
      "isFileDownloading" : isFileDownloading,
      "isFileDownloadingPaused" : isFileDownloadingPaused,
      "isFileDownloaded" : isFileDownloaded,
      "isFileExtracted" : isFileExtracted,
      "isTrackContent" : isTrackContent,
    };
  }
}