import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/create_discussion_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discusiion_topic_user_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/create_discussion_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/createDiscussion/create_discussion_repository.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CreateDiscussionBloc extends Bloc<CreateDiscussionEvent, CreateDiscussionState> {
  CreateDiscussionRepositry createDiscussionRepositry;
  List<DiscussionTopicUserListResponse> topicUserList = [];
  List<bool> userChecked = [];

  List<DiscussionTopicUserListResponse> filterTopicList = [];

  final formatter = DateFormat('dd/MM/yyyy');
  bool isFirstLoading = true;
  bool isCreateLoading = false;
  bool isSwitched = false;

  Uint8List? fileBytes;
  String fileName = "";

  List<PlatformFile> _paths = [];
  String _directoryPath = "";
  String _extension = "";
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  var strUserID;

  CreateDiscussionBloc({required this.createDiscussionRepositry})
      : super(CreateDiscussionState.completed(null)) {
    on<SetDiscussionMainHomeDetails>(onEventHandler);
    on<OpenFileExplorerEvent>(onEventHandler);
    on<CreateDiscussionForumEvent>(onEventHandler);
    on<GetDiscussionTopicUserListDetails>(onEventHandler);
    on<AddTopicEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(
      CreateDiscussionEvent event, Emitter emit) async {
    print(
        "CreateDiscussionBloc onEventHandler called for ${event.runtimeType}");
    Stream<CreateDiscussionState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (CreateDiscussionState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  @override
  CreateDiscussionState get initialState =>
      CreateDiscussionState.completed('data');

  @override
  Stream<CreateDiscussionState> mapEventToState(CreateDiscussionEvent event) async* {
    try {
      strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      if (event is OpenFileExplorerEvent) {
        yield CreateDiscussionState.loading('Please wait');
        fileName = await openFileExplorer(event.pickingType);

        yield OpenFileExplorerState.completed(fileName: fileName);
        print('file name here $fileName $fileBytes');
      }
      else if (event is GetDiscussionTopicUserListDetails) {
        yield GetDiscussionTopicUserListDetailsState.loading('Please wait');

        Response? apiResponse =
            await createDiscussionRepositry.getDiscussionTopicUserData(
                int.parse(strUserID), int.parse(strSiteID), language);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          isCreateLoading = false;
          //Response response = await RestClient.getPostData(paramsString);

          List<DiscussionTopicUserListResponse> response =
              discussionTopicUserListResponseFromJson(
                  apiResponse?.body ?? "[]");

          topicUserList = response;

          userChecked = List.filled(topicUserList.length, false);

          print("size : $response");
          yield GetDiscussionTopicUserListDetailsState.completed(
              data: response);
        } else if (apiResponse?.statusCode == 401) {
          isCreateLoading = false;
          yield GetDiscussionTopicUserListDetailsState.error('401');
        } else {
          isCreateLoading = false;
          yield GetDiscussionTopicUserListDetailsState.error(
              'Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is CreateDiscussionForumEvent) {
        yield CreateDiscussionDetailsState.loading('Please wait');
        Response? apiResponse =
            await createDiscussionRepositry.createDiscussionData(
                event.likePosts,
                event.description,
                event.moderation,
                event.updatedDate,
                event.forumID,
                event.forumThumbnailName,
                event.categoryIDs,
                event.sendEmail,
                event.parentForumID,
                event.name,
                event.createNewTopic,
                event.attachFile,
                event.requiresSubscription,
                event.moderatorID,
                event.createdDate,
                event.allowShare,
                event.isPrivate,
                event.allowPinTopic,
                event.fileBytes,
                event.fileName);
        print('apiresposne ${apiResponse?.body}');
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          print("size : ${apiResponse?.body}");
          yield CreateDiscussionDetailsState.completed(
              data: apiResponse?.body ?? "");
        } else if (apiResponse?.statusCode == 401) {
          yield CreateDiscussionDetailsState.error('401');
        } else {
          yield CreateDiscussionDetailsState.error('Something went wrong');
        }
      }
    } catch (e, s) {
      print("Error in CreateDiscussionBloc.mapEventToState():$e");
      print(s);

      //yield GetListState.error("Error  $e");
    }
  }

  Future<String> openFileExplorer(FileType _pickingType) async {
    if (_pickingType == FileType.custom) {
      _extension = 'xlsx,pptx,docx,txt,doc,pdf';
    }
    _loadingPath = true;
    try {
      _paths = (await FilePicker.platform.pickFiles(
            type: _pickingType,
            allowMultiple: _multiPick,
            allowedExtensions: (_extension.isNotEmpty)
                ? _extension.replaceAll(' ', '').split(',')
                : null,
          ))?.files ?? [];
    } on PlatformException catch (e) {
      print("Unsupported operation$e");
    } catch (ex) {
      print(ex);
    }
    // if (!mounted) return;
    _loadingPath = false;

    PlatformFile? file = _paths.isNotEmpty ? _paths.first : null;

    if(file != null) {
      fileName = file != null
          ? file.name.replaceAll('(', ' ').replaceAll(')', '')
          : '';
      fileBytes = file.bytes;
      fileName = fileName.trim();
      fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));
    }
    return fileName;
  }

  String selectedUserId() {
    String selectedUserID = '';
    for (int i = 0; i < topicUserList.length; i++) {
      if (topicUserList[i].check == true) {
        if (i == 0) {
          selectedUserID = topicUserList[i].userID.toString();
        } else {
          selectedUserID += ',${topicUserList[i].userID}';
        }
      }
    }
    return selectedUserID;
  }

  String selectedEditUserId() {
    String selectedUserID = '';
    for (int i = 0; i < userChecked.length; i++) {
      if (userChecked[i] == true) {
        if (i == 0) {
          selectedUserID = filterTopicList[i].userID.toString();
        } else {
          selectedUserID += ',${filterTopicList[i].userID}';
        }
      }
    }
    return selectedUserID;
  }
}
