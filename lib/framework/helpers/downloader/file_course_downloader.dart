import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class FileCourseDownloader {
  static var backgroundIsolateName = "zipCoursedownloader";

  var _localContentPath;

  static String _taskId = "";
  String _url;

  _TaskInfo? _task;

  ReceivePort _port = ReceivePort();
  Isolate? _extractIsolate;
  bool _running = false;
  ReceivePort? _receivePort;
  Function _callback;
  String pathSeparator = "";
  String downloadFileName = "";

  factory FileCourseDownloader(String url, Function callback,
      String localContentPath, String pathSeparator, String downloadFileName) {
    return FileCourseDownloader._internal(
        url, callback, localContentPath, pathSeparator, downloadFileName);
  }

  FileCourseDownloader._internal(this._url, this._callback,
      this._localContentPath, this.pathSeparator, this.downloadFileName) {
    print('URL : $_url , ToPath : $_localContentPath');
  }

  /* Future<void> initialize() async {
    await FlutterDownloader.initialize();
  }

*/

  void startDownload() async {
    _task = _TaskInfo(name: "Course Download", link: _url);
    _bindBackgroundIsolate();
    //_registerCallback(_downloadCallback);
    await _requestDownload(_task!);
  }

  Future<void> stopDownload() async {
    if (_task != null) await _cancelDownload(_task!);
    unbindBackgroundIsolate();
  }

  /*void _registerCallback(DownloadCallback callback) {
    FlutterDownloader.registerCallback(callback);
  }*/

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, backgroundIsolateName);
    if (!isSuccess) {
      unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      DownloadTaskStatus? status;int progress = 0;
      print('UI Isolate Callback: $data');
      String id = data[0];
      if(data[1] != DownloadTaskStatus(4))
      status = data[1];
      if(data[2] != -1)
      progress = data[2];
      // DownloadTaskStatus status = data[1];
      // int progress = data[2];

      print('Local download service status: $status && progress: $progress');

      _callback(CallbackParam(id, status!, progress, false));
    });
  }

  static void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(backgroundIsolateName);
  }

  static void _downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');

    final SendPort? send =
        IsolateNameServer.lookupPortByName(backgroundIsolateName);
    send?.send([id, status, progress]);
  }

  Future<void> _requestDownload(_TaskInfo task) async {
    task.taskId = (await FlutterDownloader.enqueue(
            url: task.link,
            fileName: downloadFileName,
            savedDir: _localContentPath,
            showNotification: false,
            openFileFromNotification: false)) ??
        "";
    _taskId = task.taskId;
  }

  Future<void> _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _configExtractionIsolate(String id) async {
    if (_running) {
      return;
    }
    try {
      _running = true;
      _receivePort = ReceivePort();
      ThreadParams threadParams = ThreadParams(2000, _receivePort!.sendPort,
          _localContentPath, pathSeparator, downloadFileName);
      _extractIsolate = await Isolate.spawn(
        _extractZippedFile,
        threadParams,
      );
      _receivePort!.listen(_handleMessage, onDone: () {});
    } catch (exception) {
      print('extraction exception: $exception');
    }
  }

  void _handleMessage(dynamic data) {
    if (data is String &&
        (data != null && data.trim().isNotEmpty) &&
        data == 'EXTRACTION_COMPLETED') {
      _stopExtractionIsolate();
      _callback(CallbackParam(_taskId, DownloadTaskStatus.complete, 100, true));
    }
  }

  void _stopExtractionIsolate() {
    if (null != _extractIsolate) {
      _running = false;
      _receivePort?.close();
      _extractIsolate?.kill(priority: Isolate.immediate);
      _extractIsolate = null;
    }
  }

  static void _extractZippedFile(ThreadParams threadParams) async {
    String path =
        '${threadParams.localPath}${threadParams.pathSeparator}${threadParams.txtFileName}';
    // '${threadParams.rootDirectory}${threadParams.pathSeparator}local_content.zip';
    final file = File(path);

    if (await file.exists()) {
      // Read the Zip file from disk.
      final bytes = file.readAsBytesSync();

      // Decode the Zip file
      final archive = ZipDecoder().decodeBytes(bytes);

      // Extract the contents of the Zip archive to disk.
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          String filePath =
              //'${threadParams.rootDirectory}${threadParams.pathSeparator}${filename}';
              '${threadParams.localPath}${threadParams.pathSeparator}$filename';
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          String directoryPath =
              //'${threadParams.rootDirectory}${threadParams.pathSeparator}${filename}';
              '${threadParams.localPath}${threadParams.pathSeparator}$filename';
          Directory(directoryPath)..create(recursive: true);
        }
      }
      //Delete the file
      await file.delete();
    }
    threadParams.sendPort.send('EXTRACTION_COMPLETED');
  }

  Future<List<FileSystemEntity>> getOnBoardingImages() async {
    String localPath = _localContentPath;
    List<FileSystemEntity> imageList = [];

    Directory savedDir = Directory(localPath);
    if (await savedDir.exists()) {
      imageList = savedDir.listSync();
      print("...imageListDemo....: ${imageList.length}");
      print("...image details....: ${imageList[0].path}");
      /*setState(() {
        this.fileList=imageListDemo;
      });*/
    }
    return imageList;
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId = "";
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name = "", this.link = ""});
}

class ThreadParams {
  ThreadParams(this.val, this.sendPort, this.localPath, this.pathSeparator,
      this.txtFileName);

  int val;
  SendPort sendPort;
  String localPath;
  String pathSeparator;
  String txtFileName;
}

class CallbackParam {
  final String id;
  final DownloadTaskStatus status;
  final int progress;
  final bool isFileExtracted;

  CallbackParam(this.id, this.status, this.progress, this.isFileExtracted);
}
