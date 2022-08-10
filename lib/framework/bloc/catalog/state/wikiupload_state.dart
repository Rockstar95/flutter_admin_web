import 'package:flutter_admin_web/framework/common/api_state.dart';

class WikiUploadState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  WikiUploadState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  WikiUploadState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  WikiUploadState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class IntitialWikiUploadState extends WikiUploadState {
  IntitialWikiUploadState.completed(data) : super.completed(data);
}

class PostWikiUploadState extends WikiUploadState {
  String uploadRespose = "";

  PostWikiUploadState.loading(data) : super.loading(data);

  PostWikiUploadState.completed({this.uploadRespose = ""})
      : super.completed(uploadRespose);

  PostWikiUploadState.error(data) : super.error(data);
}

class OpenFileExplorerState extends WikiUploadState {
  String fileName = "";

  OpenFileExplorerState.loading(data) : super.loading(data);

  OpenFileExplorerState.completed({this.fileName = ""})
      : super.completed(fileName);

  OpenFileExplorerState.error(data) : super.error(data);
}

class GetWikiCategoriesState extends WikiUploadState {
  String fileName = "";

  GetWikiCategoriesState.loading(data) : super.loading(data);

  GetWikiCategoriesState.completed({this.fileName = ""})
      : super.completed(fileName);

  GetWikiCategoriesState.error(data) : super.error(data);
}
