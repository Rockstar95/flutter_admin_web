import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_topic_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_topic_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/like_dislike_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/topic_comment_reply_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_topic_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_repository.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DiscussionTopicBloc extends Bloc<DiscussionTopicEvent, DiscussionTopicState> {
  DiscussionTopicRepository discussionTopicRepositry;
  List<TopicList> list = [];
  List<TopicList> pinTopicList = [];
  List<Table> replyList = [];
  List<LikeDislikeListResponse> likeDislikeList = [];
  List<LikeDislikeListResponse> likeCountList = [];

  bool isLike = false;
  bool isFirstLoading = true;
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
  final formatter = DateFormat('MM/dd/yyyy HH:mm:ss');

  DiscussionTopicBloc({
    required this.discussionTopicRepositry,
  }) : super(DiscussionTopicState.completed(null)) {
    on<GetDiscussionTopicDetails>(onEventHandler);
    on<AddTopicEvent>(onEventHandler);
    on<UploadAttachmentEvent>(onEventHandler);
    on<EditTopicEvent>(onEventHandler);
    on<OpenFileExplorerTopicEvent>(onEventHandler);
    on<DeleteForumTopicEvent>(onEventHandler);
    on<TopicReplyEvent>(onEventHandler);
    on<DeleteReplyEvent>(onEventHandler);
    on<PinTopicEvent>(onEventHandler);
    on<LikeDisLikeEvent>(onEventHandler);
    on<LikeCountEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(
      DiscussionTopicEvent event, Emitter emit) async {
    print("DiscussionTopicBloc onEventHandler called for ${event.runtimeType}");
    Stream<DiscussionTopicState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (DiscussionTopicState authState) {
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
  DiscussionTopicState get initialState =>
      IntitialDetailsState.completed("Intitalized");

  @override
  Stream<DiscussionTopicState> mapEventToState(
      DiscussionTopicEvent event) async* {
    // TODO: implement mapEventToState
    try {
      strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);
      var language = await sharePrefGetString(sharedPref_AppLocale);

      if (event is GetDiscussionTopicDetails) {
        yield GetDiscussionTopicState.loading('Please wait');

        Response? apiResponse =
            await discussionTopicRepositry.getDiscussionTopicData(
                int.parse(strUserID),
                event.forumId,
                int.parse(strSiteID),
                language);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          DiscussionTopicResponse response =
              discussionTopicResponseFromJson(apiResponse?.body ?? "{}");

          list = response.topicList;
          list.sort((a, b) {
            return a.createdDate.compareTo(b.createdDate);
          });

          yield GetDiscussionTopicState.completed(data: response);
        } else if (apiResponse?.statusCode == 401) {
          yield GetDiscussionTopicState.error('401');
        } else {
          yield GetDiscussionTopicState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      } else if (event is AddTopicEvent) {
        yield AddTopicState.loading('Please wait');
        isFirstLoading = true;
        Response? apiResponse = await discussionTopicRepositry.addTopicData(
          strAttachFile: event.strAttachFile,
          userID: int.parse(strUserID),
          orgID: event.orgID,
          forumID: event.forumID,
          strContentID: event.strContentID,
          description: event.description,
          localeID: language,
          siteID: int.parse(strSiteID),
          title: event.title,
          forumName: event.forumName,
        );
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          yield AddTopicState.completed(data: apiResponse?.body ?? "{}");
        } else if (apiResponse?.statusCode == 401) {
          yield AddTopicState.error('401');
        } else {
          yield AddTopicState.error('Something went wrong');
        }
        print('AddTopicEvent apiresposne ${apiResponse?.body}');
      } else if (event is EditTopicEvent) {
        yield EditTopicState.loading('Please wait');
        isFirstLoading = true;
        Response? apiResponse = await discussionTopicRepositry.editTopicData(
          strAttachFile: event.strAttachFile,
          userID: int.parse(strUserID),
          orgID: event.orgID,
          forumID: event.forumID,
          strContentID: event.strContentID,
          description: event.description,
          localeID: language,
          siteID: int.parse(strSiteID),
          title: event.title,
          forumName: event.forumName,
        );
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          yield EditTopicState.completed(data: apiResponse?.body ?? "{}");
        } else if (apiResponse?.statusCode == 401) {
          yield EditTopicState.error('401');
        } else {
          yield EditTopicState.error('Something went wrong');
        }
        print('EditTopicEvent apiresposne ${apiResponse?.body}');
      }
      if (event is OpenFileExplorerTopicEvent) {
        yield GetDiscussionTopicState.loading('Please wait');
        fileName = await openFileExplorer(event.pickingType);

        yield OpenFileExplorerState.completed(fileName: fileName);
        print('file name here $fileName $fileBytes');
      } else if (event is DeleteForumTopicEvent) {
        yield DeleteForumTopicState.loading('Please wait');
        Response? apiResponse =
            await discussionTopicRepositry.deleteDiscussionTopicUserData(
                topicID: event.topicID,
                forumID: event.forumID,
                forumName: event.forumName,
                userID: int.parse(strUserID),
                siteID: int.parse(strSiteID),
                localeID: language);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          print("size : ${apiResponse?.body}");
          yield DeleteForumTopicState.completed(
              data: apiResponse?.body ?? "{}");
        } else if (apiResponse?.statusCode == 401) {
          yield DeleteForumTopicState.error('401');
        } else {
          yield DeleteForumTopicState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      } else if (event is TopicReplyEvent) {
        yield TopicReplyState.loading('Please wait');
        Response? apiResponse =
            await discussionTopicRepositry.getTopicReplyData(
                strCommentID: event.commentId,
                userID: int.parse(strUserID),
                siteID: int.parse(strSiteID),
                localeID: language);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          TopicCommentReplyResponse response =
              topicCommentReplyResponseFromJson(apiResponse?.body ?? "{}");
          replyList = response.table;
          yield TopicReplyState.completed(data: response);
        } else if (apiResponse?.statusCode == 401) {
          yield TopicReplyState.error('401');
        } else {
          yield TopicReplyState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      } else if (event is DeleteReplyEvent) {
        yield DeleteReplyState.loading('Please wait');
        Response? apiResponse = await discussionTopicRepositry.deleteReplyData(
            replyID: event.replyID);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          yield DeleteReplyState.completed(data: apiResponse?.body ?? "{}");
        } else if (apiResponse?.statusCode == 401) {
          yield DeleteReplyState.error('401');
        } else {
          yield DeleteReplyState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is PinTopicEvent) {
        yield PinTopicState.loading('Please wait');
        Response? apiResponse = await discussionTopicRepositry.pinTopicData(
            forumID: event.forumID,
            strContentID: event.strContentID,
            isPin: event.isPin,
            userID: int.parse(strUserID));
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          //print("IsPinned In Bloc:${event.isPin}");
          yield PinTopicState.completed(data: apiResponse?.body ?? "{}", isPinned: event.isPin);
        }
        else if (apiResponse?.statusCode == 204) {
          yield PinTopicState.completed(data: apiResponse.toString(), isPinned: event.isPin);
        }
        else if (apiResponse?.statusCode == 401) {
          yield PinTopicState.error('401');
        } else {
          yield PinTopicState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      } else if (event is LikeDisLikeEvent) {
        yield LikeDislikeState.loading('Please wait');
        Response? apiResponse = await discussionTopicRepositry.likeDisLikeData(
            intUserID: int.parse(strUserID),
            strObjectID: event.strObjectID,
            intTypeID: event.intTypeID,
            blnIsLiked: event.blnIsLiked,
            intSiteID: int.parse(strSiteID),
            strLocale: language);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          List<LikeDislikeListResponse> response =
              likeDislikeListResponseFromJson(apiResponse?.body ?? "[]");
          likeDislikeList = response;
          yield LikeDislikeState.completed(data: response);
        } else if (apiResponse?.statusCode == 401) {
          yield LikeDislikeState.error('401');
        } else {
          yield LikeDislikeState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      } else if (event is LikeCountEvent) {
        yield LikeCountState.loading('Please wait');
        Response? apiResponse = await discussionTopicRepositry.likeCount(
          strObjectID: event.strObjectID,
          intTypeID: event.intTypeID,
        );
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          List<LikeDislikeListResponse> response =
              likeDislikeListResponseFromJson(
                  json.encode(apiResponse?.body ?? "[]"));
          likeCountList = response;
          isLike = likeCountList
              .any((element) => element.userID == int.parse(strUserID));
          print("**** : " + isLike.toString());

          yield LikeDislikeState.completed(data: response);
        } else if (apiResponse?.statusCode == 401) {
          yield LikeDislikeState.error('401');
        } else {
          yield LikeDislikeState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is UploadAttachmentEvent) {
        yield UploadAttachmentState.loading('Please wait');
        Response? apiResponse = await discussionTopicRepositry.uploadAttachment(
            topicID: event.topicID,
            replyID: event.replyID,
            isTopic: event.isTopic,
            fileName: event.fileName,
            fileBytes: event.fileBytes);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          yield UploadAttachmentState.completed();
        }
        else if (apiResponse?.statusCode == 401) {
          yield UploadAttachmentState.error('401');
        }
        else {
          yield UploadAttachmentState.error('Something went wrong');
        }
        print('uploadAttachment apiresposne ${apiResponse?.body}');
      }
    }
    catch (e, s) {
      isFirstLoading = false;
      print("Error in DiscussionTopicBloc.mapEventToState():$e");
      print(s);
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
      fileBytes = file.bytes;
      fileName = fileName.trim();
      fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));
    }
    return fileName;
  }
}
