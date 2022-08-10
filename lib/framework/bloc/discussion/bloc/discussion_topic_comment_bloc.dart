import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_topic_comment_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discusiion_comment_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_topic_comment_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_comment_repository.dart';
import 'package:uuid/uuid.dart';

class DiscussionTopicCommentBloc extends Bloc<DiscussionTopicCommentEvent, DiscussionTopicCommentState> {
  DiscussionTopicCommentRepository discussionTopicCommentRepositry;

  List<DiscussionCommentListResponse> list = [];

  // final formatter = DateFormat('MM/dd/yyyy HH:mm:ss');
  bool isFirstLoading = true;
  bool isSwitched = false;
  String filePath = '';
  String fileName = "";
  List<PlatformFile> _paths = [];
  String _directoryPath = "";
  String _extension = "";
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  DiscussionTopicCommentBloc({
    required this.discussionTopicCommentRepositry,
  }) : super(DiscussionTopicCommentState.completed(null)) {
    on<SetDiscussionTopicCommentDetails>(onEventHandler);
    on<GetDiscussionTopicCommentDetails>(onEventHandler);
    on<GetDiscussionTopicCommentListDetails>(onEventHandler);
    on<GetDiscussionTopicCommentReplyEvent>(onEventHandler);
    on<OpenFileExplorerEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(
      DiscussionTopicCommentEvent event, Emitter emit) async {
    print(
        "DiscussionTopicCommentBloc onEventHandler called for ${event.runtimeType}");
    Stream<DiscussionTopicCommentState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (DiscussionTopicCommentState authState) {
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
  DiscussionTopicCommentState get initialState =>
      IntitialDetailsState.completed("Intitalized");

  @override
  Stream<DiscussionTopicCommentState> mapEventToState(
      DiscussionTopicCommentEvent event) async* {
    // TODO: implement mapEventToState
    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var language = await sharePrefGetString(sharedPref_AppLocale);

    try {
      if (event is GetDiscussionTopicCommentDetails) {
        yield GetDiscussionTopicCommentDetailsState.loading('Please wait');

        Response? apiResponse =
            await discussionTopicCommentRepositry.getDiscussionTopicCommentData(
                topicID: event.topicID,
                topicName: event.topicName,
                forumId: event.forumID,
                forumTitle: event.forumTitle,
                message: event.message,
                strAttachFil: event.strAttachFil,
                strReplyID: event.strReplyID);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          yield GetDiscussionTopicCommentDetailsState.completed(
              data: apiResponse?.body ?? "{}");
        } else if (apiResponse?.statusCode == 401) {
          yield GetDiscussionTopicCommentDetailsState.error('401');
        } else {
          yield GetDiscussionTopicCommentDetailsState.error(
              'Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      } else if (event is GetDiscussionTopicCommentListDetails) {
        yield GetDiscussionTopicCommentListDetailsState.loading('Please wait');
        Response? apiResponse = await discussionTopicCommentRepositry
            .getDiscussionTopicCommentListData(
                int.parse(strSiteID),
                language,
                event.forumID,
                int.parse(strSiteID),
                int.parse(strUserID),
                event.topicID);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          List<DiscussionCommentListResponse> response =
              discussionCommentListResponseFromJson(apiResponse?.body ?? "[]");
          //setDetailsData(response);
          print("Res : " + response.toString());
          list = response;
          yield GetDiscussionTopicCommentListDetailsState.completed(
              data: response);
        } else if (apiResponse?.statusCode == 401) {
          yield GetDiscussionTopicCommentListDetailsState.error('401');
        } else {
          yield GetDiscussionTopicCommentListDetailsState.error(
              'Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      if (event is OpenFileExplorerEvent) {
        yield DiscussionTopicCommentState.loading('Please wait');
        fileName = await openFileExplorer(event.pickingType);

        yield OpenFileExplorerState.completed(fileName: fileName);
        print('file name here $fileName $filePath');
      } else if (event is GetDiscussionTopicCommentReplyEvent) {
        yield GetDiscussionTopicReplyDetailsState.loading('Please wait');
        Response? apiResponse =
            await discussionTopicCommentRepositry.getDiscussionTopicReplyData(
                strCommentID: event.strCommentID,
                topicID: event.topicID,
                topicName: event.topicName,
                forumID: event.forumID,
                message: event.message,
                localeID: language,
                strReplyID: event.strReplyID,
                userID: int.parse(strUserID),
                siteID: int.parse(strSiteID),
                forumTitle: event.forumTitle,
                strCommentTxt: event.strCommentTxt);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          yield GetDiscussionTopicReplyDetailsState.completed(
              data: apiResponse?.body ?? "{}");
        } else if (apiResponse?.statusCode == 401) {
          yield GetDiscussionTopicReplyDetailsState.error('401');
        } else {
          yield GetDiscussionTopicReplyDetailsState.error(
              'Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
    } catch (e, s) {
      isFirstLoading = false;
      print("Error in DiscussionTopicCommentBloc.mapEventToState():$e");
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
          ))
              ?.files ??
          [];
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
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
      filePath = file != null
          ? (file.path ?? "")
          : '';
      fileName = fileName.trim();
      fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));
      filePath = filePath.trim();
    }
    return fileName;
  }
}
