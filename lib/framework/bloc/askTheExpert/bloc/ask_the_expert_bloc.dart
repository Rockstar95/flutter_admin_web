import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/event/ask_the_expert_event.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/add_answer_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/add_question_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/answers_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/skill_category_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/user_questions_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/view_comment_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/state/ask_the_expert_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/ask_the_expert_repositry_builder.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AskTheExpertBloc extends Bloc<AskTheExpertEvent, AskTheExpertState> {
  bool isFirstLoading = false;
  List<QuestionList> questionList = [];
  List<QuestionList> myQuestionList = [];
  final formatter = DateFormat('MM/dd/yyyy');
  AnswersResponse answersResponse = AnswersResponse(upVotesUsers: [], table2: [], table1: [], table: []);
  Map<String, String> filterMenus = {};
  SkillCategoryResponse skillCategoryResponse = SkillCategoryResponse(table: [], table1: []);
  ViewCommentResponse viewCommentResponse = ViewCommentResponse(table: []);
  List<CommentList> commentList = [];
  bool isAddAnswer = false;

  String filePath = '';
  String fileName = "";
  List<PlatformFile> _paths = [];
  String _directoryPath = "";
  String _extension = "";
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  bool isQuestionFirstLoading = true;
  bool isQuestionSearch = false;
  String searchQuestionString = "";

  bool isFilterMenu = true;
  var strUserID, strUserName;

  AskTheExpertRepository askTheExpertRepository;

  AskTheExpertBloc({required this.askTheExpertRepository})
      : super(AskTheExpertState.completed({})) {
    on<GetUserQuestionsListEvent>(onEventHandler);
    on<AddQuestionEvent>(onEventHandler);
    on<OpenFileExplorerTopicEvent>(onEventHandler);
    on<AnswersListEvent>(onEventHandler);
    on<UpAndDownVoteEvent>(onEventHandler);
    on<AddAnswerCommentEvent>(onEventHandler);
    on<GetFilterMenus>(onEventHandler);
    on<GetSkillCategoryEvent>(onEventHandler);
    on<SelectCategoriesEvent>(onEventHandler);
    on<ViewCommentEvent>(onEventHandler);
    on<LikeDisLikeEvent>(onEventHandler);
    on<DeleteCommentEvent>(onEventHandler);
    on<DeleteQuestionEvent>(onEventHandler);
    on<ViewQuestionEvent>(onEventHandler);
    on<AddAnswerEvent>(onEventHandler);
    on<DeleteUserResponseEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(AskTheExpertEvent event, Emitter emit) async {
    print("AskTheExpertBloc onEventHandler called for ${event.runtimeType}");
    Stream<AskTheExpertState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (AskTheExpertState authState) {
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
  AskTheExpertState get initialState => AskTheExpertState.completed('data');

  @override
  Stream<AskTheExpertState> mapEventToState(AskTheExpertEvent event) async* {
    try {
      strUserName = await sharePrefGetString(sharedPref_LoginUserName);
      strUserID = await sharePrefGetString(sharedPref_userid);

      if (event is GetUserQuestionsListEvent) {
        yield UserQuestiondsListState.loading('Please wait',
            userQuestiondsListResponse:
                UserQuestiondsListResponse(questionList: []));
        Response? apiResponse =
            await askTheExpertRepository.userQuestionsListData(
          componentInsID: event.componentInsID,
          componentID: event.componentID,
          sortBy: event.sortBy,
          intSkillID: event.intSkillID,
          pageIndex: event.pageIndex,
          pageSize: event.pageSize,
          searchText: event.searchText,
        );

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          UserQuestiondsListResponse response =
              userQuestiondsListResponseFromJson(apiResponse?.body ?? "{}");
          questionList = response.questionList;
          myQuestionList.clear();
          for (int i = 0; i < questionList.length; i++) {
            if (questionList[i].userID == int.parse(strUserID)) {
              myQuestionList.add(questionList[i]);
            }
          }
          yield UserQuestiondsListState.completed(
              userQuestiondsListResponse:
                  UserQuestiondsListResponse(questionList: []));
        } else if (apiResponse?.statusCode == 401) {
          yield UserQuestiondsListState.error('401',
              userQuestiondsListResponse:
                  UserQuestiondsListResponse(questionList: []));
        } else {
          yield UserQuestiondsListState.error('Something went wrong',
              userQuestiondsListResponse:
                  UserQuestiondsListResponse(questionList: []));
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is AddQuestionEvent) {
        isFirstLoading = true;
        yield AddQuestionState.loading('Please wait',
            addQuestionResponse: AddQuestionResponse(table: []));
        Response? apiResponse = await askTheExpertRepository.addQuestion(
            userEmail: event.userEmail,
            userName: event.userName,
            questionTypeID: event.questionTypeID,
            userQuestion: event.userQuestion,
            userQuestionDesc: event.userQuestionDesc,
            userUploadedImageName: event.useruploadedImageName,
            filePath: event.filePath,
            fileName: event.fileName,
            skills: event.skills,
            selectedSkillIds: event.seletedSkillIds,
            editQueID: event.editQueID,
            isRemoveEditImage: event.isRemoveEditimage);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          yield AddQuestionState.completed(
              addQuestionResponse: AddQuestionResponse(table: []));
        } else if (apiResponse?.statusCode == 401) {
          yield AddQuestionState.error('401',
              addQuestionResponse: AddQuestionResponse(table: []));
        } else {
          yield AddQuestionState.error('Something went wrong',
              addQuestionResponse: AddQuestionResponse(table: []));
        }

        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is OpenFileExplorerTopicEvent) {
        isFirstLoading = false;
        yield AskTheExpertState.loading('Please wait');
        fileName = await openFileExplorer(event.pickingType);

        yield OpenFileExplorerState.completed(fileName: fileName);
        print('file name here $fileName $filePath');
      }
      else if (event is AnswersListEvent) {
        isFirstLoading = true;
        yield AnswersListState.loading('Please wait',
            answersResponse: AnswersResponse(
                table: [], table1: [], table2: [], upVotesUsers: []));
        Response? apiResponse = await askTheExpertRepository.viewAnswers(
            componentInsID: event.componentInsID,
            componentID: event.componentID,
            intQuestionID: event.intQuestionID);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          AnswersResponse response =
              answersResponseFromJson(apiResponse?.body ?? "{}");
          answersResponse = response;
          yield AnswersListState.completed(answersResponse: answersResponse);
        } else if (apiResponse?.statusCode == 401) {
          yield AnswersListState.error('401',
              answersResponse: AnswersResponse(
                  table: [], table1: [], table2: [], upVotesUsers: []));
        } else {
          yield AnswersListState.error('Something went wrong',
              answersResponse: AnswersResponse(
                  table: [], table1: [], table2: [], upVotesUsers: []));
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is UpAndDownVoteEvent) {
        isFirstLoading = false;
        yield UpAndDownVoteState.loading(data: 'Please wait');
        Response? apiResponse = await askTheExpertRepository.upDownVote(
            strObjectID: event.strObjectID,
            intTypeID: event.intTypeID,
            blnIsLiked: event.blnIsLiked);

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          yield UpAndDownVoteState.completed();
        } else if (apiResponse?.statusCode == 401) {
          isFirstLoading = false;
          yield UpAndDownVoteState.error(data: '401');
        } else {
          isFirstLoading = false;
          yield AnswersListState.error('Something went wrong',
              answersResponse: AnswersResponse(
                  table: [], table1: [], table2: [], upVotesUsers: []));
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is AddAnswerCommentEvent) {
        yield AddAnswerCommentState.loading(data: 'Please wait');
        Response? apiResponse = await askTheExpertRepository.addAnswerComment(
            questionID: event.questionID,
            responseID: event.responseID,
            commentID: event.commentID,
            comment: event.comment,
            userCommentImage: event.userCommentImage,
            commentStatus: event.commentStatus,
            isRemoveCommentImage: event.isRemoveCommentImage,
            filePath: event.filePath,
            fileName: event.fileName);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          yield AddAnswerCommentState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield AddAnswerCommentState.error(data: '401');
        } else {
          yield AddAnswerCommentState.error(data: 'Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is GetFilterMenus) {
        String strConditions = "";
        // print("listNativeModel ${event.listNativeModel.removeLast()}");
        event.listNativeModel.forEach((element) {
          print("element  ####### moduleName ${element.displayname}");
          print("element  ####### componentId ${element.componentId}");
          print("element  ####### landingpageType ${element.landingpageType}");
          if (element.displayname == event.moduleName) {
            strConditions = element.conditions;
          }
        });
        print("strConditions   $strConditions");
        filterMenus = new Map();

        if (strConditions != null && strConditions != "") {
          if (strConditions.contains("#@#")) {
            var conditionsArray = strConditions.split("#@#");
            int conditionCount = conditionsArray.length;
            if (conditionCount > 0) {
              filterMenus = generateHashMap(conditionsArray);
            }
          }
        }
        yield GetFilterMenusState.completed(filterMenus: filterMenus);
      }
      else if (event is GetSkillCategoryEvent) {
        isFirstLoading = true;
        yield GetSkillCategoryState.loading('Please wait',
            skillCategoryResponse:
                SkillCategoryResponse(table: [], table1: []));
        Response? apiResponse = await askTheExpertRepository.getSkillCategory();

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          skillCategoryResponse =
              skillCategoryResponseFromJson(apiResponse?.body ?? "{}");
          yield GetSkillCategoryState.completed(
              skillCategoryResponse:
                  SkillCategoryResponse(table: [], table1: []));
        } else if (apiResponse?.statusCode == 401) {
          yield GetSkillCategoryState.error('401',
              skillCategoryResponse:
                  SkillCategoryResponse(table: [], table1: []));
        } else {
          yield GetSkillCategoryState.error('Something went wrong',
              skillCategoryResponse:
                  SkillCategoryResponse(table: [], table1: []));
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is ViewCommentEvent) {
        yield GetCommentsState.loading('Please wait',
            viewCommentResponse: ViewCommentResponse(
              table: [],
            ));
        Response? apiResponse = await askTheExpertRepository.getComments(
            commentID: event.commentID);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          viewCommentResponse =
              viewCommentResponseFromJson(apiResponse?.body ?? "{}");
          commentList = viewCommentResponse.table
              .where((element) => element.commentResponseID == event.responseID)
              .toList();

          yield GetCommentsState.completed(
              viewCommentResponse: ViewCommentResponse(
            table: [],
          ));
        } else if (apiResponse?.statusCode == 401) {
          yield GetCommentsState.error('401',
              viewCommentResponse: ViewCommentResponse(
                table: [],
              ));
        } else {
          yield GetCommentsState.error('Something went wrong',
              viewCommentResponse: ViewCommentResponse(
                table: [],
              ));
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is LikeDisLikeEvent) {
        yield LikeDislikeState.loading(data: 'Please wait');
        Response? apiResponse = await askTheExpertRepository.likeDisLikeData(
            intUserID: int.parse(strUserID),
            strObjectID: event.strObjectID,
            intTypeID: event.intTypeID,
            blnIsLiked: event.blnIsLiked);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          yield LikeDislikeState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield LikeDislikeState.error(data: '401');
        } else {
          yield LikeDislikeState.error(data: 'Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is DeleteCommentEvent) {
        yield DeleteCommentState.loading(data: 'Please wait');
        Response? apiResponse = await askTheExpertRepository.deleteComment(
          commentId: event.commentId,
          commentedImage: '',
        );
        if (apiResponse?.statusCode == 200) {
          yield DeleteCommentState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield DeleteCommentState.error(data: '401');
        } else {
          yield DeleteCommentState.error(data: 'Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is DeleteQuestionEvent) {
        yield DeleteQuestionState.loading(data: 'Please Wait');
        Response? apiResponse = await askTheExpertRepository.deleteQuestion(
            questionID: event.questionID,
            userUploadImage: event.userUploadImage);
        if (apiResponse?.statusCode == 200) {
          yield DeleteQuestionState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield DeleteQuestionState.error(data: '401');
        } else {
          yield DeleteQuestionState.error(data: 'Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is ViewQuestionEvent) {
        yield ViewQuestionState.loading(data: 'Please wait');
        Response? apiResponse = await askTheExpertRepository.viewQuestion(
            intQuestionID: event.questionID);
        if (apiResponse?.statusCode == 200) {
          yield ViewQuestionState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield ViewQuestionState.error(data: '401');
        } else {
          yield ViewQuestionState.error(data: 'Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is AddAnswerEvent) {
        isFirstLoading = true;
        yield AddAnswerState.loading(data: AddAnswerResponse(table: []));
        Response? apiResponse = await askTheExpertRepository.addAnswer(
            userEmail: event.userEmail,
            userName: event.userName,
            response1: event.response,
            userResponseImageName: event.userResponseImageName,
            responseID: event.responseID,
            questionID: event.questionID,
            isRemoveEditImage: event.isRemoveEditImage,
            filePath: event.filePath,
            fileName: event.fileName);
        if (apiResponse?.statusCode == 200) {
          yield AddAnswerState.completed(data: AddAnswerResponse(table: []));
        } else if (apiResponse?.statusCode == 401) {
          yield AddAnswerState.error(
              data: AddAnswerResponse(
            table: [],
          ));
        } else {
          yield AddAnswerState.error(
              data: AddAnswerResponse(
            table: [],
          ));
        }
        print('apiResponse ${apiResponse?.body}');
      }
      else if (event is DeleteUserResponseEvent) {
        isFirstLoading = true;
        yield DeleteUserResponseState.loading(data: 'Please wait...');
        Response? apiResponse = await askTheExpertRepository.deleteUserResponse(
            responseId: event.responseId,
            userResponseImage: event.userResponseImage);
        if (apiResponse?.statusCode == 200) {
          yield DeleteUserResponseState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield DeleteUserResponseState.error(data: '401');
        } else {
          yield DeleteUserResponseState.error(data: 'Something went wrong');
        }
        print('apiResponse ${apiResponse?.body}');
      }
    } catch (e, s) {
      print("Error in AskTheExpertBloc.mapEventToState():$e");
      print(s);

      isFirstLoading = false;
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

  Map<String, String> generateHashMap(List<String> conditionsArray) {
    Map<String, String> map = new Map();
    if (conditionsArray.length != 0) {
      for (int i = 0; i < conditionsArray.length; i++) {
        var filterArray = conditionsArray[i].split("=");
        print(" forvalue   $filterArray");
        if (filterArray.length > 1) {
          map[filterArray[0]] = filterArray[1];
        }
      }
    } else {}
    return map;
  }
}
