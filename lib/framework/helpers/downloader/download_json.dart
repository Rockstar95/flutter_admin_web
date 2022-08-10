import 'dart:async';
import 'dart:io';

import 'package:flutter_admin_web/framework/helpers/utils.dart';

class DownloadJson {
  final String settingsFilename;

  factory DownloadJson(String settingsFilename) {
    return DownloadJson._internal(settingsFilename);
  }

  DownloadJson._internal(this.settingsFilename) {
    print(' ToPath : $settingsFilename');
  }

  // get local path of documents directory
  Future<String> get _localPath async {
    final directory = await AppDirectory.getDocumentsDirectory();
    return directory;
  }

  // get the settings file
  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/$settingsFilename');
  }

  // write user setting to file
  Future<File> writeJsonFile(String setting) async {
    final file = await _localFile;
    return file.writeAsString('$setting');
  }

  // read the file contents
  Future<String> readJsonFile() async {
    String contents = "";

    try {
      final file = await _localFile;

      // read the file
      contents = await file.readAsString();
    } catch (e) {
      print(e);
    }

    return contents;
  }

  Future<FileSystemEntity> removeUserSettingsFile() async {
    final file = await _localFile;
    return file.delete();
  }

  Future<bool> settingsFileExists() async {
    File settingsFile = await _localFile;

    if (await settingsFile.exists()) {
      return true;
    }

    return false;
  }
}
