import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';

class LocalDownloadService {
  static var backgroundIsolateName = "downloader";

  //var _localContentPath = "SplashImages";
  var _localContentPath;

  static String _taskId = "";
  String _url;

  _TaskInfo? _task;
  static String _rootDirectory = "";
  static String pathSeparator =
      ""; // The file will be downloaded to root directory
  ReceivePort _port = ReceivePort();
  Isolate? _extractIsolate;
  bool _running = false;
  ReceivePort? _receivePort;
  Function _callback;

  factory LocalDownloadService(
      String url, Function callback, String localContentPath) {
    return LocalDownloadService._internal(url, callback, localContentPath);
  }

  LocalDownloadService._internal(
      this._url, this._callback, this._localContentPath) {
    print('URL : $_url , ToPath : $_localContentPath');
  }

  Future<void> initialize() async {
    await _getRootDirectory();
    // await FlutterDownloader.initialize();
  }

  ///have code for file exist
  /*Future<int> localModelsVersion() async {
    await _getRootDirectory();
    var _localPath = _rootDirectory + pathSeparator + _localContentPath;
    final versionFile = await File(_localPath + pathSeparator + _versionJson);
    if (!await versionFile.exists()) {
      return -1;
    }
    String content = await versionFile.readAsString();
    Map<String, dynamic> versionInfo = jsonDecode(content);
    return versionInfo['versionCode'];
  }*/

  static Future _getRootDirectory() async {
    if (_rootDirectory == null || _rootDirectory.trim().isEmpty) {
      _rootDirectory = await AppDirectory.getDocumentsDirectory();
    }

    if (pathSeparator == null || pathSeparator.trim().isEmpty) {
      pathSeparator = Platform.pathSeparator;
    }
  }

  // delete Dir
  Future<bool> deleteLocalModels() async {
    await _getRootDirectory();
    var _localPath = _rootDirectory + pathSeparator + _localContentPath;

    print("....path....$_localPath");

    final savedDir = Directory(_localPath);
    if (await savedDir.exists()) {
      await savedDir.delete(recursive: true);
      return true;
    }
    return false;
  }

  Future<bool> isModelsAvailable() async {
    await _getRootDirectory();
    var _localPath = _rootDirectory + pathSeparator + _localContentPath;

    print("local path......$_localPath");

    final Directory savedDir = Directory(_localPath);
    if (!await savedDir.exists()) {
      await savedDir.create();

      print(savedDir.path);

      print("i am not avaible ................$_localPath");
      return false;
    }
    else {
      await savedDir.delete(recursive: true);
      await savedDir.create();

      print(savedDir.path);

      print("i am not avaible ......$_localPath");
      return false;
    }
  }

  void startDownload() async {
    await _getRootDirectory();
    _task = _TaskInfo(name: "Models Download", link: _url);
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
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, backgroundIsolateName);
    if (!isSuccess) {
      unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_task != null && _task!.taskId == id) {
        if (status == DownloadTaskStatus.complete) {
          unbindBackgroundIsolate();
          _configExtractionIsolate(id);
          progress = 95;
          _task!.status = DownloadTaskStatus.running;
        } else if (status == DownloadTaskStatus.failed) {
          //_retryDownload(_task);
        } else if (status == DownloadTaskStatus.running) {
          if (progress == 100) {
            progress = 95;
          }
        }
        _task!.status = status;
        _task!.progress = progress;
      }
      print('Local download service status: $status && progress: $progress');

      _callback(CallbackParam(id, status, progress, false));
    });
  }

  static void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(backgroundIsolateName);
  }

  static void _downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print('Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');

    final SendPort? send =
        IsolateNameServer.lookupPortByName(backgroundIsolateName);
    send?.send([id, status, progress]);
  }

  Future<void> _requestDownload(_TaskInfo task) async {
    task.taskId = (await FlutterDownloader.enqueue(
            url: task.link,
            savedDir: _rootDirectory + pathSeparator + _localContentPath,
            showNotification: false,
            openFileFromNotification: false)) ??
        "";
    _taskId = task.taskId;
  }

  Future<void> _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  /*void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }*/

//  Future<String> _findLocalPath() async {
//    final directory = Platform.isAndroid
//        ? await getExternalStorageDirectory()
//        : await getApplicationDocumentsDirectory();
//    return directory.path;
//  }

  void _configExtractionIsolate(String id) async {
    if (_running) {
      return;
    }
    try {
      _running = true;
      _receivePort = ReceivePort();
      ThreadParams threadParams = ThreadParams(2000, _receivePort!.sendPort,
          _rootDirectory, pathSeparator, _localContentPath);
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
        '${threadParams.rootDirectory}${threadParams.pathSeparator}${threadParams.localPath}${threadParams.pathSeparator}SplashImages.zip';
    // '${threadParams.rootDirectory}${threadParams.pathSeparator}local_content.zip';
    final file = File(path);

    if (await file.exists()) {
      // Read the Zip file from disk.
      final bytes = file.readAsBytesSync();

      // Decode the Zip file
      try {
        final archive = ZipDecoder().decodeBytes(bytes);

        // Extract the contents of the Zip archive to disk.
        for (final file in archive) {
          final filename = file.name;
          if (file.isFile) {
            final data = file.content as List<int>;
            String filePath =
                //'${threadParams.rootDirectory}${threadParams.pathSeparator}${filename}';
                '${threadParams.rootDirectory}${threadParams.pathSeparator}${threadParams.localPath}${threadParams.pathSeparator}$filename';
            File(filePath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          }
          else {
            String directoryPath =
                //'${threadParams.rootDirectory}${threadParams.pathSeparator}${filename}';
                '${threadParams.rootDirectory}${threadParams.pathSeparator}${threadParams.localPath}${threadParams.pathSeparator}$filename';
            Directory(directoryPath)..create(recursive: true);
          }
        }
      }
      catch (exception) {
        print("ZIP $exception");
        threadParams.sendPort.send('EXTRACTION_FAILED');
      }
      //Delete the file
      await file.delete();
    }
    threadParams.sendPort.send('EXTRACTION_COMPLETED');
  }

  Future<List<FileSystemEntity>> getOnBoardingImages() async {
    String localPath = _rootDirectory + pathSeparator + _localContentPath;
    List<FileSystemEntity> imageList = [];

    Directory savedDir = Directory(localPath);
    if (await savedDir.exists()) {
      imageList = savedDir.listSync();
      // print("...imageListDemo....: ${imageList.length}");
      // print("...image details....: ${imageList[0].path}");
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
  ThreadParams(this.val, this.sendPort, this.rootDirectory, this.pathSeparator,
      this.localPath);

  int val;
  SendPort sendPort;
  String rootDirectory;
  String pathSeparator;
  String localPath;
}

class CallbackParam {
  final String id;
  final DownloadTaskStatus status;
  final int progress;
  final bool isFileExtracted;

  CallbackParam(this.id, this.status, this.progress, this.isFileExtracted);
}
