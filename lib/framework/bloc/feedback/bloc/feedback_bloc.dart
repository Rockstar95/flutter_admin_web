import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/feedback/event/feedback_event.dart';
import 'package:flutter_admin_web/framework/bloc/feedback/model/feedbackresponse.dart';
import 'package:flutter_admin_web/framework/bloc/feedback/state/feedback_state.dart';
import 'package:flutter_admin_web/framework/repository/feedback/feedback_repositry_builder.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  bool isFirstLoading = true;
  List<FeedbackModel> feedbackList = [];

  String fileName = '';
  List<PlatformFile> _paths = [];
  String _extension = "";
  bool _multiPick = false;
  Uint8List? fileBytes;

  FeedbackRepository feedbackRepository;

  FeedbackBloc({required this.feedbackRepository})
      : super(FeedbackState.completed(null)) {
    on<FeedbackSubmitEvent>(onEventHandler);
    on<OpenFileExplorerEvent>(onEventHandler);
    on<GetFeedbackResponseEvent>(onEventHandler);
    on<DeleteFeedbackEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(FeedbackEvent event, Emitter emit) async {
    print("FeedbackBloc onEventHandler called for ${event.runtimeType}");
    Stream<FeedbackState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (FeedbackState authState) {
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
  FeedbackState get initialState =>
      IntitialFeedbackUploadState.completed('data');

  @override
  Stream<FeedbackState> mapEventToState(FeedbackEvent event) async* {
    try {
      if (event is FeedbackSubmitEvent) {
        yield PostFeedbackState.loading('Please wait');
        Response? apiResponse = await feedbackRepository.feedbackSubmit(
            isUrl: event.isUrl,
            currentSiteId: event.currentUserId,
            currentUrl: event.currentUrl,
            currentUserId: event.currentUserId,
            date2: event.date2,
            feedbackDesc: event.feedbackDesc,
            feedbackTitle: event.feedbackTitle,
            image: event.image,
            imageFileName: event.imageFileName);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          yield PostFeedbackState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield PostFeedbackState.error('401');
        } else {
          yield PostFeedbackState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      if (event is OpenFileExplorerEvent) {
        yield OpenFileExplorerState.loading('Please wait');
        fileName = await openFileExplorer(event.pickingType);
        yield OpenFileExplorerState.completed(fileName: fileName);
        print('file name here $fileName $fileBytes');
      }
      if (event is GetFeedbackResponseEvent) {
        yield GetFeedbackResponseState.loading('Please wait ');
        Response? apiResponse =
            await feedbackRepository.getFeedbackResponseEvent(event.isAdmin);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          //List<FeedbackModel> feedbackList = [];
          if (apiResponse?.body.isNotEmpty ?? false) {
            var jsonArray =
                new List<dynamic>.from(jsonDecode(apiResponse?.body ?? "[]"));
            feedbackList =
                jsonArray.map((e) => new FeedbackModel.fromJson(e)).toList();
          }
          print("feedbackList" + feedbackList.toString());
          yield GetFeedbackResponseState.completed(feedbackList: feedbackList);
        } else if (apiResponse?.statusCode == 401) {
          yield GetFeedbackResponseState.error('401');
        } else {
          yield GetFeedbackResponseState.error('Something went wrong');
        }
      }
      if (event is DeleteFeedbackEvent) {
        yield DeleteFeedbackState.loading('Please wait');
        Response? apiResponse =
            await feedbackRepository.deleteFeedbackEvent(id: event.id);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          feedbackList.removeWhere((item) => item.iD == event.id);
          yield DeleteFeedbackState.completed(
              response: apiResponse?.body.toString() ?? "");
        } else if (apiResponse?.statusCode == 401) {
          yield DeleteFeedbackState.error('401');
        } else {
          yield DeleteFeedbackState.error('Something went wrong');
        }
        print('apiresposne $apiResponse');
      }
    } catch (e) {
      print("Error in FeedbackBloc.mapEventToState():$e");
      isFirstLoading = false;
      //yield GetListState.error("Error  $e");
    }
  }

  Future<String> openFileExplorer(FileType _pickingType) async {
    if (_pickingType == FileType.custom) {
      _extension = 'xlsx,pptx,docx,txt,doc,pdf';
    }
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
    PlatformFile? file = _paths.isNotEmpty ? _paths.first : null;

    if(file != null) {
      fileName = file != null
          ? file.name.replaceAll('(', ' ').replaceAll(')', '')
          : '';
      fileBytes = file.bytes;
    }
    return fileName;
  }
}
